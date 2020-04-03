import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class GoodsDetailInfo extends StatefulWidget {
  final String goodsDetail;

  GoodsDetailInfo({Key key, @required this.goodsDetail}) : super(key: key);

  @override
  _GoodsDetailInfoState createState() => _GoodsDetailInfoState();
}

class _GoodsDetailInfoState extends State<GoodsDetailInfo>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 5.0,bottom: 5.0),
            child: Text('商品详情'),
          ),
          Html(
            data: widget.goodsDetail,
          ),
        ],
      )
    );
  }
}
