import 'package:flutter/material.dart';
import 'package:flutter_shopping/model/home_model.dart';

//分类
class CategoryProvider extends ChangeNotifier {
  List<SecondCategoryVO> secondCategoryList = [];

  //一级分类索引
  int firstCategoryIndex = 0;

  //一级ID
  String firstCategoryId = '1';

  //二级分类索引
  int secondCategoryIndex = 0;

  //二级ID
  String secondCategoryId = '0';

  //列表页数
  int page = 1;

  String noMoreText = '';

  bool isNewCategory = true;

  //默认左侧导航index，如果是从主页分类过来就不一定是0了
  var defaultFirstIndex=0;


  //首页点击类别到类别页
  changeFirstCategory(String id, int index) {
    firstCategoryId = id;
    firstCategoryIndex = index;
    secondCategoryId = '';
    notifyListeners();
  }

  //获取二级分类
  getSecondCategory(List<SecondCategoryVO> list, String id) {
    isNewCategory = true;
    firstCategoryId = id;
    secondCategoryIndex = 0;
    page = 1;
    //点击一级分类时二级清空
    secondCategoryId = '';
    noMoreText = '';
    SecondCategoryVO all = SecondCategoryVO(
        firstCategoryId: '00',
        secondCategoryName: '全部',
        comments: '',
        secondCategoryId: '');
    secondCategoryList = [all];
    secondCategoryList.addAll(list);
    notifyListeners();
  }

  //改变二级类别
  changeSecondCategory(String id, int index) {
    isNewCategory = true;
    secondCategoryId = id;
    secondCategoryIndex = index;
    page = 1;
    noMoreText = '';
    notifyListeners();
  }

  addPage() {
    page++;
  }

  changeNoMore(String text) {
    noMoreText = text;
    notifyListeners();
  }

  changeFalse() {
    isNewCategory = false;
  }

  changeDefaultFirstIndex(int index){
    this.defaultFirstIndex=index;
  }
}
