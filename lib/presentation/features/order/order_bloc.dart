import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_app_sale_06072022/common/bases/base_bloc.dart';
import 'package:flutter_app_sale_06072022/common/bases/base_event.dart';
import 'package:flutter_app_sale_06072022/data/model/product.dart';
import 'package:flutter_app_sale_06072022/data/repositories/product_repository.dart';
import 'package:flutter_app_sale_06072022/presentation/features/order/order_event.dart';

import '../../../data/datasources/remote/app_response.dart';
import '../../../data/datasources/remote/dto/order_dto.dart';
import '../../../data/model/order.dart';

class OrderBloc extends BaseBloc{
  StreamController<List<Order>> listOrderController = StreamController();
  late ProductRepository _repository;

  void updateOrderRepository(ProductRepository productRepository) {
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

      List<Order> orders = [];
      listOrderResponse.data?.forEach((item) {
        Order order = Order(
          item.id,
          item.products?.map((dto){
            return Product(dto.id, dto.name, dto.address, dto.price, dto.img, dto.quantity, dto.gallery);
          }).toList(),
          item.idUser,
          item.price,
          item.status,
          item.dateCreated,
        );
        orders.add(order);
      });

      listOrderController.add(orders);
    } on DioError catch (e) {
      messageSink.add(e.response?.data["message"]);
    } catch (e) {
      messageSink.add(e.toString());
    }
    loadingSink.add(false);
  }
}