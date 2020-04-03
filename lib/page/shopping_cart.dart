import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping/common/common_widget.dart';
import 'package:flutter_shopping/common/contant.dart';
import 'package:flutter_shopping/model/cart_model.dart';
import 'package:flutter_shopping/page/details/shopping_details.dart';
import 'package:flutter_shopping/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  @override
  void initState() {
    super.initState();
    _loadCartList();
  }

  _loadCartList() async {
    Future.delayed(Duration(milliseconds: 100)).then((_) {
      Provider.of<CartProvider>(context, listen: false).getCardModels();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('重构');
    return MyScaffold(
        title: '购物车',
        context: context,
        body: Consumer<CartProvider>(builder: (context, provider, child) {
          return Stack(
            children: <Widget>[
              ListView.builder(
                  itemCount: provider.cartList.length,
                  itemBuilder: (context, index) {
                    return _item(provider.cartList[index]);
                  }),
              Positioned(
                left: 0,
                bottom: 0,
                child: _bottom(provider.isAllCheck, provider.totalPrice,
                    provider.totalGoods),
              )
            ],
          );
        }));
  }

  _item(CartModel cartModel) {
    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Checkbox(
              onChanged: (bool value) {
                cartModel.isCheck = value ? check : unCheck;
                Provider.of<CartProvider>(context, listen: false)
                    .changeCartInfo(cartModel);
              },
              value: cartModel.isCheck == check,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ShoppingDetails(
                    goodId: cartModel.goodsId,
                    tag: '$tagCart',
                  );
                }));
              },
              child: Hero(
                  tag: '${cartModel.images}$tagCart',
                  child: CachedNetworkImage(
                      imageUrl: cartModel.images,
                      height: 90.0,
                      width: 90.0,
                      fit: BoxFit.cover)),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 2.0, bottom: 7.0),
                    child: Text('${cartModel.goodsName}',
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                  ),
                  //商品增减
                  _itemCount(cartModel),
                ],
              ),
            )),
            Expanded(
                flex: 0,
                child: Container(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Column(
                    children: <Widget>[
                      Text('￥ ${cartModel.price}',
                          style: TextStyle(fontSize: 15.0, color: Colors.red)),
                      IconButton(
                          icon: Icon(Icons.delete_forever),
                          onPressed: () {
                            Provider.of<CartProvider>(context, listen: false)
                                .deleteCart(cartModel.goodsId);
                          })
                    ],
                  ),
                ))
          ],
        ));
  }

  _itemCount(CartModel cartModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _actionBtn(cartModel, false),
        _count(cartModel.count),
        _actionBtn(cartModel, true),
      ],
    );
  }

  _actionBtn(CartModel cartModel, bool isAdd) {
    return InkWell(
      onTap: () {
        //如果是增减或者总数大于1
        if (isAdd || cartModel.count > 1) {
          cartModel.count = isAdd ? cartModel.count + 1 : cartModel.count - 1;
          Provider.of<CartProvider>(context, listen: false)
              .changeCartInfo(cartModel);
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isAdd
                ? Colors.white
                : cartModel.count <= 1 ? Colors.grey : Colors.white,
            border: Border.all(color: Colors.grey, width: 1.0)),
        width: 40.0,
        height: 30.0,
        child: Text(
          isAdd ? '+' : '-',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  _count(int count) {
    return Container(
      height: 30.0,
      width: 50.0,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: Colors.grey, width: 1.0),
              bottom: BorderSide(color: Colors.grey, width: 1.0))),
      child: Text('$count'),
    );
  }

  //底部
  _bottom(bool isAllCheck, double totalPrice, int totalGoods) {
    return Container(
      height: 55.0,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.only(left: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Checkbox(
              value: isAllCheck,
              onChanged: (check) {
                Provider.of<CartProvider>(context, listen: false)
                    .changeAllCheckState(check);
              }),
          Column(
            children: <Widget>[
              Text.rich(TextSpan(children: [
                TextSpan(text: '合计：', style: TextStyle(fontSize: 18.0)),
                TextSpan(
                    text: '￥$totalPrice',
                    style: TextStyle(fontSize: 18.0, color: Colors.red))
              ])),
              Text('满10元免费配送,预约免费配送')
            ],
          ),
          Container(
            padding: EdgeInsets.only(right: 5.0),
            child: FlatButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {},
                child: Text(
                  '结算($totalGoods)',
                  style: TextStyle(color: Colors.white),
                )),
          )
        ],
      ),
    );
  }
}
