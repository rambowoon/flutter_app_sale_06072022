import 'package:flutter_app_sale_06072022/data/datasources/remote/api_request.dart';

abstract class BaseRepository {
  late ApiRequest apiRequest;

  void updateRequest(ApiRequest apiRequest) {
    this.apiRequest = apiRequest;
  }
}