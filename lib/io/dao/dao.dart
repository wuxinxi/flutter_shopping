//主页刷新dao
import 'dart:convert';

import 'package:flutter_shopping/io/http/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter_shopping/model/detail_model.dart';
import 'package:flutter_shopping/model/home_model.dart';

//主页
Future<HomeModel> loadHomeData(String url) async {
  Response res = await DioFactory.instance.request(url);
  HomeModel homeModel = HomeModel.fromJson(json.decode(res.toString()));
  return homeModel;
}

//详情
Future<GoodInfo> loadDetails(String url, String goodId) async {
  var formData = {'goodId': goodId};
  Response res =
      await DioFactory.instance.request(url, formData: formData);
  DetailModel model = DetailModel.fromJson(json.decode(res.toString()));
  return model.data.goodInfo;
}

//分类
Future<List<Category>> loadCategory(String url) async {
  Response res = await DioFactory.instance.request(url);
  CategoryData categoryData =
      CategoryData.fromJson(json.decode(res.toString()));
  return categoryData.data;
}

//推荐
Future<List<Recommend>> loadRecommend(String url) async {
  Response res = await DioFactory.instance.request(url);
  RecommendData recommendData =
      RecommendData.fromJson(json.decode(res.toString()));
  return recommendData.data;
}
