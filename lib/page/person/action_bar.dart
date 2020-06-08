import 'package:flutter/material.dart';

class ActionBar extends StatelessWidget {
  //透明度
  final int alpha;
  final GestureTapCallback onSettingTap;
  final GestureTapCallback onMessageTap;

  ActionBar({this.alpha = 255, this.onSettingTap, this.onMessageTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top:40.0),
      height: 40.0,
      color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 10.0),
              child: Icon(Icons.local_mall, size: 23.0)),
          Container(padding: EdgeInsets.only(left: 10.0), child: Text('我的',style: TextStyle(color: Colors.black))),
          Container(
            child: Row(
              children: <Widget>[
                Icon(Icons.settings, size: 23.0),
                Icon(Icons.message, size: 23.0),
              ],
            ),
          )
        ],
      ),
    );
  }
}
