import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PersonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('个人中心'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          _topHeader(context),
          _orderTitle(),
          _orderType(context),
          _actionList(),
        ],
      ),
    );
  }

  //头像区域
  Widget _topHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Theme.of(context).primaryColor,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 23.0),
            child: ClipOval(
                child: ClipOval(
                    child: CachedNetworkImage(
              imageUrl: 'http://www.xxstudy.cn/static/images/avatar_15.png',
              height: 80.0,
              width: 80.0,
            ))),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              '唐人',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //我的订单标题
  Widget _orderTitle() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      color: Colors.white,
      child: ListTile(
        leading: Icon(Icons.list),
        title: Text('我的订单'),
        trailing: Icon(Icons.arrow_right),
      ),
    );
  }

  //我的订单类型
  Widget _orderType(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.only(bottom: 5.0,top: 5.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.payment,
                  size: 23.0,
                ),
                Text('待付款'),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.send,
                  size: 23.0,
                ),
                Text('待发货'),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.call_received,
                  size: 23.0,
                ),
                Text('待收货'),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.message,
                  size: 23.0,
                ),
                Text('待评价'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _myListTile(String title,IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      child: ListTile(
        leading: Icon(iconData),
        title: Text(title),
        trailing: Icon(Icons.arrow_right),
      ),
    );
  }

  //其它操作列表
  Widget _actionList() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _myListTile('领取优惠券',Icons.get_app),
          _myListTile('已领取优惠券',Icons.confirmation_number),
          _myListTile('地址管理',Icons.not_listed_location),
          _myListTile('客服电话',Icons.phone),
          _myListTile('关于我们',Icons.account_box),
        ],
      ),
    );
  }
}
