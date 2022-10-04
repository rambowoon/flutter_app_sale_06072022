import 'package:flutter_app_sale_06072022/data/model/product.dart';

class Order {
  late String id;
  late List<Product> products;
  late String idUser;
  late num price;
  late bool status;
  late String dateCreated;

  Order([String? id, List<Product>? products, String? idUser, num? price, bool? status, String? dateCreated]) {
    this.id = id ?? "";
    this.products = products ?? [];
    this.idUser = idUser ?? "";
    this.price = price ?? 0;
    this.status = status ?? false;
    this.dateCreated = dateCreated ?? "";
  }
}