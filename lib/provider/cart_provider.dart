import 'package:flutter/material.dart';
import 'package:flutter_shopping/io/db/db.dart';
import 'package:flutter_shopping/model/cart_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> cartList = [];

  //总价
  double totalPrice = 0.0;

  //商品总数
  int totalGoods = 0;

  //是否全选
  bool isAllCheck = false;

  //获取购物车信息
  getCardModels() async {
    List<CartModel> cardList = await DBManager.instance.query();
    this.cartList = [];
    if (cardList.length == 0) {
      this.cartList = [];
    } else {
      totalPrice = 0.0;
      totalGoods = 0;
      isAllCheck = true;
      this.cartList.addAll(cardList);
      this.cartList.forEach((cart) {
        if (cart.isCheck == 1) {
          totalPrice += cart.price * cart.count;
          totalGoods += cart.count;
        } else {
          isAllCheck = false;
        }
      });
    }
    //保留两位有效数字
    totalPrice = double.parse(totalPrice.toStringAsFixed(2));
    print(
        '获取成功:totalPrice=$totalPrice  totalGoods.count=$totalGoods cardList=${cardList.length}');
    notifyListeners();
  }

  //加入购物车
  addCart(CartModel model) async {
    await DBManager.instance.insert(model);
    await getCardModels();
  }

  //删除指定购物车
  deleteCart(String goodsId) async {
    await DBManager.instance.deleteByGoodsId(goodsId);
    await getCardModels();
  }

  //清空购物车
  deleteCartAll() async {
    await DBManager.instance.deleteAll();
    await getCardModels();
  }

  //更改选中状态
  changeCartInfo(CartModel model) async {
    await DBManager.instance.update(model);
    await getCardModels();
  }

  //强制更改选中状态
  forceChangeCheckState(String goodsId) async {
    await DBManager.instance.forceChangeCheckState(goodsId);
    await getCardModels();
  }

  //全选/不选
  changeAllCheckState(bool isAllCheck) async {
    await DBManager.instance.changeAllCheckState(isAllCheck);
    await getCardModels();
  }
}
