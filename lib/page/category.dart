import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping/widget/common_widget.dart';
import 'package:flutter_shopping/common/url.dart';
import 'package:flutter_shopping/io/dao/dao.dart';
import 'package:flutter_shopping/model/home_model.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_shopping/provider/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_shopping/provider/category_goods_list_provider.dart';

import 'details/shopping_details.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with AutomaticKeepAliveClientMixin {
  List<Category> list;

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
    super.build(context);
    return MyScaffold(
      context: context,
      title: '商品分类',
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[
                TopCategoryNav(),
                CategoryGoodsList(),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

//左侧导航栏
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List<Category> list = [];
  var listIndex = 0;

  @override
  void initState() {
    super.initState();
    print('左侧初始化initState');
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        listIndex = provider.firstCategoryIndex;
        return Container(
          width: 100.0,
          decoration: BoxDecoration(
              border: Border(right: BorderSide(width: 1, color: Colors.grey))),
          child: ListView.builder(
              itemBuilder: (context, index) => _leftItem(index),
              itemCount: list.length),
        );
      },
    );
  }

  _loadData() async {
    Future future = loadCategory(categoryUrl);
    await future.then((list) {
      setState(() {
        this.list = list;
      });
    });

    int defaultIndex =
        Provider.of<CategoryProvider>(context, listen: false).defaultFirstIndex;
    //通知顶部导航（二级）
    Provider.of<CategoryProvider>(context, listen: false)
        .getSecondCategory(list[defaultIndex].secondCategoryVO, '1');

    //获取二级导航下面的列表
    _getGoodList(context, firstCategoryId: '1');
  }

  _leftItem(int index) {
    bool isClick = false;
    isClick = index == listIndex;
    return InkWell(
      onTap: () {
        var secondCategoryList = list[index].secondCategoryVO;
        var firstCategoryId = list[index].firstCategoryId;
        Provider.of<CategoryProvider>(context, listen: false)
            .changeFirstCategory(firstCategoryId, index);
        Provider.of<CategoryProvider>(context, listen: false)
            .getSecondCategory(secondCategoryList, firstCategoryId);
        _getGoodList(context, firstCategoryId: firstCategoryId);
      },
      child: Container(
          height: 45.0,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          decoration: BoxDecoration(
              color: isClick ? Theme.of(context).primaryColor : Colors.white,
              border: Border(
                  bottom: BorderSide(width: 1.5, color: Colors.grey),
                  left: BorderSide(
                      width: 5,
                      color: isClick ? Colors.pinkAccent : Colors.white))),
          child: Text(list[index].firstCategoryName,
              style: TextStyle(
                  color: isClick ? Colors.white : Colors.black,
                  fontSize: 16.0))),
    );
  }

  _getGoodList(BuildContext context, {String firstCategoryId}) async {
    Future future = loadRecommend(goodsListUrl);
    await future.then((list) {
      Provider.of<CategoryGoodsListProvider>(context, listen: false)
          .getGoodsList(list);
    });
  }
}

//顶侧导航栏
class TopCategoryNav extends StatefulWidget {
  @override
  _TopCategoryNavState createState() => _TopCategoryNavState();
}

class _TopCategoryNavState extends State<TopCategoryNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<CategoryProvider>(builder: (context, provider, child) {
        print('顶部导航len=${provider.secondCategoryList.length}');
        return Container(
          height: 45.0,
          width: MediaQuery.of(context).size.width - 100.0,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
          child: ListView.builder(
              itemCount: provider.secondCategoryList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return _topItem(index, provider.secondCategoryList[index]);
              }),
        );
      }),
    );
  }

  _topItem(int index, SecondCategoryVO vo) {
    bool isClick =
        index == Provider.of<CategoryProvider>(context).secondCategoryIndex;
    return InkWell(
      onTap: () {
        Provider.of<CategoryProvider>(context, listen: false)
            .changeSecondCategory(vo.secondCategoryId, index);
        _getGoodList(context, vo.secondCategoryId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          vo.secondCategoryName,
          style: TextStyle(
              fontSize: 16.0,
              color: isClick ? Theme.of(context).primaryColor : Colors.black),
        ),
      ),
    );
  }

  _getGoodList(BuildContext context, String firstCategoryId) async {
    Future future = loadRecommend(goodsListUrl);
    await future.then((list) {
      Provider.of<CategoryGoodsListProvider>(context, listen: false)
          .getGoodsList(list);
    });
  }
}

//商品列表
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  ScrollController _controller = ScrollController();
  double scrollDistance = 0.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryGoodsListProvider>(
      builder: (context, provider, child) {
        if (scrollDistance != 0.0) {
          if (Provider.of<CategoryProvider>(context).page == 1) {
            try {
              _controller.jumpTo(0.0);
            } catch (_) {}
          }
        }
        print('scrollDistance=$scrollDistance');
        final len = provider.goodsList.length;
        if (len > 0) {
          return Expanded(
              child: Container(
                  width: MediaQuery.of(context).size.width - 100.0,
                  child: NotificationListener(
                      onNotification: (scrollNotification) {
                        if (scrollNotification is ScrollUpdateNotification &&
                            scrollNotification.depth == 0) {
                          scrollDistance = scrollNotification.metrics.pixels;
                        }
                        return true;
                      },
                      child: EasyRefresh(
                          onRefresh: () async {
                            print('下拉刷新');
                          },
                          onLoad: () async {
                            print('上拉加载更多');
                          },
                          child: ListView.builder(
                              controller: _controller,
                              itemCount: len,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ShoppingDetails(
                                          goodId: provider
                                              .goodsList[index].goodsId, tag: 'category',);
                                    }));
                                  },
                                  child:
                                      _goodsListItem(provider.goodsList[index]),
                                );
                              })))));
        }
        return Text('暂时没有数据');
      },
    );
  }

  _goodsListItem(Recommend recommend) {
    return Container(
        padding: EdgeInsets.only(right: 5.0, bottom: 5.0, top: 5.0),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0))),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 0,
              child: CachedNetworkImage(
                  imageUrl: recommend.image,
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.cover),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text(recommend.name,
                          style: TextStyle(fontSize: 15.0),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis)),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 5.0, top: 10.0),
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: '价格 ￥${recommend.presentPrice}',
                          style: TextStyle(color: Colors.red)),
                      TextSpan(
                          text: '\b\b${recommend.oriPrice}',
                          style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.combine(
                                  [TextDecoration.lineThrough]))),
                    ])),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
