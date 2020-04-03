import 'package:flutter/material.dart';
import 'package:flutter_shopping/model/home_model.dart';

class CategoryGoodsListProvider extends ChangeNotifier {
  List<Recommend> goodsList = [];

  getGoodsList(List<Recommend> list) {
    goodsList = list;
    notifyListeners();
  }

  addGoodsList(List<Recommend> list) {
    goodsList.addAll(list);
    notifyListeners();
  }
}
