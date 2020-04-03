import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

class DioFactory {
  factory DioFactory() => _getInstance();

  static DioFactory get instance => _getInstance();
  static DioFactory _instance;

  Dio dio;

  DioFactory._internal() {
    dio = Dio();
    dio.options.contentType = 'application/x-www-form-urlencoded';
    dio.interceptors.add(DioCacheManager(CacheConfig()).interceptor);
  }

  static DioFactory _getInstance() {
    if (_instance == null) {
      _instance = DioFactory._internal();
    }
    return _instance;
  }

  Future request(url, {method = 'POST', formData}) async {
    Dio dio = DioFactory.instance.dio;
    Response response;

    try {
      if (method == 'POST') {
        response = await dio.post(url,
            data: formData, options: buildCacheOptions(Duration(days: 7)));
      } else {
        response =
            await dio.get(url, options: buildCacheOptions(Duration(days: 7)));
      }
      if (response.statusCode == 200) {
        return response;
      }
      throw Exception('请求错误[${response.statusCode}]');
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }
}
