import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_app_sale_06072022/common/bases/base_bloc.dart';
import 'package:flutter_app_sale_06072022/common/bases/base_event.dart';
import 'package:flutter_app_sale_06072022/data/datasources/remote/dto/cart_dto.dart';
import 'package:flutter_app_sale_06072022/data/model/cart.dart';
import 'package:flutter_app_sale_06072022/data/model/product.dart';
import 'package:flutter_app_sale_06072022/data/repositories/product_repository.dart';
import '../../../data/datasources/remote/app_response.dart';
import 'cart_event.dart';

class CartBloc extends BaseBloc{
  StreamController<Cart> cartController = StreamController();
  late ProductRepository _repository;

  void updateProductRepository(ProductRepository productRepository) {
    _repository = productRepository;
  }

  @override
  void dispatch(BaseEvent event) {
    switch(event.runtimeType) {
      case GetCartEvent:
        _getCart();
        break;
    }
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
  void _updateCart(UpdateCartEvent event) async {
    loadingSink.add(true);
    try {
      Response response = await _repository.updateCart(event.idCart, event.quantity, event.idProduct);
      AppResponse<CartDto> cartResponse = AppResponse.fromJson(response.data, CartDto.convertJson);
      Cart cart = Cart(
          cartResponse.data?.id,
          cartResponse.data?.products?.map((dto){
            return Product(dto.id, dto.name, dto.address, dto.price, dto.img, dto.quantity, dto.gallery);
          }).toList(),
          cartResponse.data?.idUser,
          cartResponse.data?.price
      );
      print(cart);
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