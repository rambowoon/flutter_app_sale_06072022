import 'package:flutter_app_sale_06072022/data/datasources/remote/dto/product_dto.dart';

class OrderDto {
  OrderDto({
    this.id,
    this.products,
    this.idUser,
    this.price,
    this.status,
    this.dateCreated
  });

  OrderDto.fromJson(dynamic json) {
    id = json['_id'];
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(ProductDto.fromJson(v));
      });
    }
    idUser = json['id_user'];
    price = json['price'];
    status = json['status'];
    dateCreated = json['date_created'];
  }

  String? id;
  List<ProductDto>? products;
  String? idUser;
  num? price;
  bool? status;
  String? dateCreated;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    if (products != null) {
      map['products'] = products?.map((v) => v.toJson()).toList();
    }
    map['id_user'] = idUser;
    map['price'] = price;
    map['status'] = status;
    map['date_created'] = dateCreated;
    return map;
  }

  static List<OrderDto> convertJson(dynamic json) {
    return (json as List).map((e) => OrderDto.fromJson(e)).toList();
  }
}
