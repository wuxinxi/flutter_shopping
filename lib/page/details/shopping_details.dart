import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping/common/common_widget.dart';
import 'package:flutter_shopping/common/url.dart';
import 'package:flutter_shopping/io/dao/dao.dart';
import 'package:flutter_shopping/model/cart_model.dart';
import 'package:flutter_shopping/model/detail_model.dart';
import 'package:flutter_shopping/provider/cart_provider.dart';
import 'package:flutter_shopping/provider/jump_by_index.dart';
import 'package:provider/provider.dart';

import 'goods_info.dart';

class ShoppingDetails extends StatefulWidget {
  final String goodId;
  final String tag;

  ShoppingDetails({Key key, @required this.goodId, @required this.tag})
      : super(key: key);

  @override
  _ShoppingDetailsState createState() => _ShoppingDetailsState();
}

class _ShoppingDetailsState extends State<ShoppingDetails>
    with SingleTickerProviderStateMixin {
  Future _future;

  @override
  void initState() {
    _future = loadDetails(detailsUrl, widget.goodId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('商品详情');
    return MyScaffold(
        title: '商品详情',
        context: context,
        leading: true,
        body: FutureBuilder<GoodInfo>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                GoodInfo goodInfo = snapshot.data;
                if (!snapshot.hasError && goodInfo != null) {
                  return Stack(
                    children: <Widget>[
                      _content(goodInfo),
                      _bottom(goodInfo),
                    ],
                  );
                }
                print('${snapshot.error.toString()}');
                return Container(
                  alignment: Alignment.center,
                  child: FlatButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.refresh),
                      label: Text('${snapshot.error.toString()}')),
                );
              }
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }));
  }

  _bottom(GoodInfo goodInfo) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
              flex: 0,
              child: Consumer<CartProvider>(
                builder: (BuildContext context, CartProvider provider,
                    Widget child) {
                  return Stack(
                    children: <Widget>[
                      Container(
                          child: IconButton(
                              icon: Icon(Icons.shopping_cart),
                              onPressed: () {})),
                      Positioned(
                        right: 0.0,
                        child: Container(
                            height: 25.0,
                            child: CircleAvatar(
                                child: Text('${provider.totalGoods}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13.0)),
                                backgroundColor: Colors.red)),
                      )
                    ],
                  );
                },
              )),
          Expanded(
              child: Container(
                  padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                  color: Colors.green,
                  child: FlatButton(
                      onPressed: () {
                        CartModel model = CartModel(
                            count: 1,
                            price: goodInfo.presentPrice,
                            images: goodInfo.image1,
                            goodsName: goodInfo.goodsName,
                            goodsId: goodInfo.goodsId);
                        Provider.of<CartProvider>(context, listen: false)
                            .addCart(model);
                      },
                      child: Text('加入购物车',
                          style: TextStyle(color: Colors.white))))),
          Expanded(
              child: Container(
                  padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                  color: Theme.of(context).primaryColor,
                  child: FlatButton(
                      onPressed: () {
                        Provider.of<JumpByIndexProvider>(context, listen: false)
                            .changeIndex(2, isForceJump: true);
                        //强制选中
                        Provider.of<CartProvider>(context, listen: false)
                            .forceChangeCheckState(widget.goodId);
                        Navigator.pop(context);
                      },
                      child: Text('立即购买',
                          style: TextStyle(color: Colors.white))))),
        ],
      ),
    );
  }

  _content(GoodInfo goodInfo) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        _firstContent(goodInfo),
        _secondContent(),
        GoodsDetailInfo(goodsDetail: goodInfo.goodsDetail),
      ],
    );
  }

  //第一部分
  _firstContent(GoodInfo goodInfo) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Hero(
              tag: '${goodInfo.image1}${widget.tag}',
              child: CachedNetworkImage(
                  imageUrl: goodInfo.image1,
                  height: 400.0,
                  width: double.infinity,
                  fit: BoxFit.cover)),
          Container(
            padding:
                EdgeInsets.only(top: 3.0, left: 5.0, right: 3.0, bottom: 5.0),
            child: Text(
              '${goodInfo.goodsName}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14.0),
            ),
          ),
          Container(
              padding: EdgeInsets.only(left: 5.0, bottom: 5.0),
              child: Text('编号 ${goodInfo.goodsSerialNumber}',
                  style: TextStyle(color: Colors.grey))),
          Container(
            padding: EdgeInsets.only(bottom: 5.0, left: 10.0),
            child: Text.rich(TextSpan(children: [
              TextSpan(
                  text: '￥ ${goodInfo.presentPrice}',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18.0)),
              TextSpan(
                  text: '\b\b市场价${goodInfo.oriPrice}',
                  style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.combine(
                          [TextDecoration.lineThrough]))),
            ])),
          ),
        ],
      ),
    );
  }

  _secondContent() {
    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 15.0),
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 3.0),
        child: Text('说明: > 急速送达 > 正品保证',
            style: TextStyle(color: Colors.red, fontSize: 16.0)));
  }
}
