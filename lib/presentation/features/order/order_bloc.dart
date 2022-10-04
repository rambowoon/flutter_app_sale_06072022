import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_app_sale_06072022/common/bases/base_bloc.dart';
import 'package:flutter_app_sale_06072022/common/bases/base_event.dart';
import 'package:flutter_app_sale_06072022/data/model/cart.dart';
import 'package:flutter_app_sale_06072022/data/model/product.dart';
import 'package:flutter_app_sale_06072022/data/repositories/product_repository.dart';
import 'package:flutter_app_sale_06072022/presentation/features/order/order_event.dart';

import '../../../data/datasources/remote/app_response.dart';
import '../../../data/datasources/remote/dto/order_dto.dart';
import '../../../data/model/order.dart';

class OrderBloc extends BaseBloc{
  StreamController<List<Order>> listOrderController = StreamController();
  late ProductRepository _repository;

  void updateProductRepository(ProductRepository productRepository) {
    _repository = productRepository;
  }

  @override
  void dispatch(BaseEvent event) {
    switch(event.runtimeType) {
      case GetListOrderEvent:
        _getListOrder();
        break;
    }
  }

  void _getListOrder() async{
    loadingSink.add(true);
    try {
      Response response = await _repository.getListOrders();
      AppResponse<List<OrderDto>> listOrderResponse = AppResponse.fromJson(response.data, OrderDto.convertJson);
      List<Order>? listOrder = listOrderResponse.data?.map((dto){

        return Order(dto.id, dto.products, dto.idUser, dto.price, dto.status, dto.dateCreated);
      }).toList();
      listOrderController.add(listOrder ?? []);
    } on DioError catch (e) {
      messageSink.add(e.response?.data["message"]);
    } catch (e) {
      messageSink.add(e.toString());
    }
    loadingSink.add(false);
  }
}