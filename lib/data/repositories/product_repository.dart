import 'package:flutter_app_sale_06072022/common/bases/base_repository.dart';

class ProductRepository extends BaseRepository{

  Future getListProducts() {
    return apiRequest.getProducts();
  }

  Future getCart() {
    return apiRequest.getCart();
  }

  Future addToCart(String id) {
    return apiRequest.addToCart(id);
  }

  Future updateCart(String idCart, num quantity, String idProduct) {
    return apiRequest.updateCart(idCart, quantity, idProduct);
  }
}