import 'package:dio/dio.dart';
import 'package:flutter_app_sale_06072022/common/constants/api_constant.dart';
import 'package:flutter_app_sale_06072022/data/datasources/remote/dio_client.dart';

class ApiRequest {
  late Dio _dio;
  
  ApiRequest(){
    _dio = DioClient.instance.dio;
  }
  
  Future signIn(String email, String password) {
    return _dio.post(ApiConstant.SIGN_IN_URL, data: {
      "email": email,
      "password": password
    });
  }

  Future signUp(String email, String name, String phone, String password, String address) {
    return _dio.post(ApiConstant.SIGN_UP_URL, data: {
      "email": email,
      "password": password,
      "phone": phone,
      "name": name,
      "address": address
    });
  }

  Future getProducts() {
    return _dio.get(ApiConstant.LIST_PRODUCT_URL);
  }

  Future getCart() {
    return _dio.get(ApiConstant.CART_URL);
  }
}