import 'package:flutter_app_sale_06072022/data/model/product.dart';

class Cart {
  late String id;
  late List<Product> products;
  late String idUser;
  late num price;

  Cart([String? id, List<Product>? products, String? idUser, num? price]) {
    this.id = id ?? "";
    this.products = products ?? [];
    this.idUser = idUser ?? "";
    this.price = price ?? 0;
  }
}