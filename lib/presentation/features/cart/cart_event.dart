import 'package:flutter_app_sale_06072022/common/bases/base_event.dart';

class GetCartEvent extends BaseEvent {
  @override
  List<Object?> get props => [];
}

class UpdateCartEvent extends BaseEvent {
  String idCart;
  num quantity;
  String idProduct;
  UpdateCartEvent({required this.idCart, required this.quantity, required this.idProduct});
  @override
  List<Object?> get props => [];
}

class CartConformEvent extends BaseEvent {
  String idCart;
  CartConformEvent({required this.idCart});
  @override
  List<Object?> get props => [];
}