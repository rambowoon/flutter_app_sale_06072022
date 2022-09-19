import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_app_sale_06072022/common/bases/base_bloc.dart';
import 'package:flutter_app_sale_06072022/common/bases/base_event.dart';
import 'package:flutter_app_sale_06072022/data/datasources/remote/dto/cart_dto.dart';
import 'package:flutter_app_sale_06072022/data/model/cart.dart';
import 'package:flutter_app_sale_06072022/data/model/product.dart';
import 'package:flutter_app_sale_06072022/data/repositories/product_repository.dart';
import 'package:flutter_app_sale_06072022/presentation/features/home/home_event.dart';

import '../../../data/datasources/remote/app_response.dart';
import '../../../data/datasources/remote/dto/product_dto.dart';

class HomeBloc extends BaseBloc{
  StreamController<Cart> cartController = StreamController();
  StreamController<List<Product>> listProductController = StreamController();
  late ProductRepository _repository;

  void updateProductRepository(ProductRepository productRepository) {
    _repository = productRepository;
  }

  @override
  void dispatch(BaseEvent event) {
    switch(event.runtimeType) {
      case GetListProductEvent:
        _getListProduct();
        break;
      case GetCartEvent:
        _getCart();
        break;
    }
  }

  void _getListProduct() async{
    loadingSink.add(true);
    try {
      Response response = await _repository.getListProducts();
      AppResponse<List<ProductDto>> listProductResponse = AppResponse.fromJson(response.data, ProductDto.convertJson);
      List<Product>? listProduct = listProductResponse.data?.map((dto){
        return Product(dto.id, dto.name, dto.address, dto.price, dto.img, dto.quantity, dto.gallery);
      }).toList();
      listProductController.add(listProduct ?? []);
    } on DioError catch (e) {
      messageSink.add(e.response?.data["message"]);
    } catch (e) {
      messageSink.add(e.toString());
    }
    loadingSink.add(false);
  }

  void _getCart() async {
    loadingSink.add(true);
    try {
      Response response = await _repository.getCart();
      AppResponse<CartDto> cartResponse = AppResponse.fromJson(response.data, CartDto.convertJson);
      Cart cart = Cart(
        cartResponse.data?.id,
        cartResponse.data?.products?.map((dto){
          return Product(dto.id, dto.name, dto.address, dto.price, dto.img, dto.quantity, dto.gallery);
        }).toList(),
        cartResponse.data?.idUser,
        cartResponse.data?.price
      );
      cartController.sink.add(cart);
    } on DioError catch (e) {
      cartController.sink.addError(e.response?.data["message"]);
      messageSink.add(e.response?.data["message"]);
    } catch (e) {
      messageSink.add(e.toString());
    }
    loadingSink.add(false);
  }
}