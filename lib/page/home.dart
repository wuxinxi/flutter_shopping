import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping/common/contant.dart';
import 'package:flutter_shopping/common/url.dart';
import 'package:flutter_shopping/io/dao/dao.dart';
import 'package:flutter_shopping/model/home_model.dart';
import 'package:flutter_shopping/provider/category_provider.dart';
import 'package:flutter_shopping/provider/jump_by_index.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import '../common/common_widget.dart';
import 'details/shopping_details.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  Future _future;

  @override
  void initState() {
    _future = loadHomeData(homeUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MyScaffold(
      context: context,
      title: '首页',
      body: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: FutureBuilder<HomeModel>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (!snapshot.hasError) {
                    HomeModel model = snapshot.data;
                    Data data = model.data;
                    if (data != null) {
                      return ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            switch (index) {
                              case 0:
                                return _banner(data.slides);
                              case 1:
                                return _category(data.category);
                              case 2:
                                return _textDivider(
                                    '推荐专区', _recommendContent(data.recommend));
                              case 3:
                                return _positionContent(
                                    data.floor1Pic, data.floor1);
                              default:
                                return _textDivider(
                                    '火爆专区', _hotContent(data.recommend));
                            }
                          });
                    }
                  }
                  return Container(
                    alignment: Alignment.center,
                    child: FlatButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.refresh),
                        label: Text('重试')),
                  );
                }
                return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              })),
    );
  }

  //轮播图
  _banner(List<Slides> slides) {
    if (slides == null && slides.length == 0) return null;
    return Container(
      height: 250.0,
      child: Swiper(
        itemCount: slides.length,
        autoplay: true,
        pagination: SwiperPagination(
            builder: FractionPaginationBuilder(),
            alignment: Alignment.bottomRight),
        itemBuilder: (context, index) {
          return InkWell(
            child: CachedNetworkImage(
              imageUrl: slides[index].image,
              fit: BoxFit.cover,
            ),
            onTap: () {},
          );
        },
      ),
    );
  }

  //分类
  _category(List<Category> category) {
    if (category == null && category.length == 0) return null;
    //仅仅只显示10个
    if (category.length > 10) {
      category = category.sublist(0, 10);
    }
    return Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.white,
        child: GridView.builder(
            shrinkWrap: true,
            itemCount: category.length,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
            itemBuilder: (context, index) {
              return InkWell(
                child: Column(
                  children: <Widget>[
                    CachedNetworkImage(
                        imageUrl: category[index].image,
                        width: 45.0,
                        height: 45.0),
                    Container(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text('${category[index].firstCategoryName}'))
                  ],
                ),
                onTap: () {
                  var of =
                      Provider.of<CategoryProvider>(context, listen: false);
                  of.changeDefaultFirstIndex(index);
                  of.changeFirstCategory(
                      category[index].firstCategoryId, index);
                  of.getSecondCategory(category[index].secondCategoryVO,
                      category[index].firstCategoryId);
                  Provider.of<JumpByIndexProvider>(context, listen: false)
                      .changeIndex(1, isForceJump: true);
                },
              );
            }));
  }

  //推荐内容
  _recommendContent(List<Recommend> recommend) {
    int len = recommend.length;
    return Container(
      height: 220.0,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: recommend.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(
                  top: 5.0, left: 15.0, right: index != len - 1 ? 0.0 : 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Material(
                    child: InkWell(
                      child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Hero(
                              tag: '${recommend[index].image}$tagRecommend',
                              child: CachedNetworkImage(
                                  imageUrl: recommend[index].image,
                                  width: 150.0,
                                  height: 150.0,
                                  fit: BoxFit.cover))),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ShoppingDetails(
                            goodId: recommend[index].goodsId,
                            tag: '$tagRecommend',
                          );
                        }));
                      },
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(
                          '￥ ${recommend[index].presentPrice.toString()}',
                          style: TextStyle(color: Colors.red))),
                  Text('￥ ${recommend[index].oriPrice.toString()}',
                      style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.combine(
                              [TextDecoration.lineThrough])))
                ],
              ),
            );
          }),
    );
  }

  //固定位置的内容
  _positionContent(Floor1Pic floor1Pic, List<Floor1> floor1) {
    return Column(
      children: <Widget>[
        CachedNetworkImage(
            imageUrl: floor1Pic.pICTUREADDRESS, fit: BoxFit.fill),
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
                child: Container(
                    child: CachedNetworkImage(
                        imageUrl: floor1[0].image,
                        height: 250.0,
                        fit: BoxFit.fill))),
            Expanded(
                child: Container(
              height: 250.0,
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  Expanded(
                      child: Container(
                    child: CachedNetworkImage(
                        imageUrl: floor1[2].image, fit: BoxFit.fill),
                  )),
                  Expanded(
                      child: Container(
                          child: CachedNetworkImage(
                              imageUrl: floor1[3].image, fit: BoxFit.fill))),
                ],
              ),
            )),
          ],
        ),
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
                child: Container(
                    child: CachedNetworkImage(
                        imageUrl: floor1[1].image, fit: BoxFit.fill))),
            Expanded(
                child: Container(
                    child: CachedNetworkImage(
                        imageUrl: floor1[4].image, fit: BoxFit.fill))),
          ],
        ),
      ],
    );
  }

  //火爆专区
  _hotContent(List<Recommend> recommend) {
    return GridView.builder(
        itemCount: recommend.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              child: Hero(
                  tag: '${recommend[index].image}$tagHot',
                  child: CachedNetworkImage(
                      imageUrl: '${recommend[index].image}', fit: BoxFit.cover)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ShoppingDetails(
                    goodId: recommend[index].goodsId,
                    tag: '$tagHot',
                  );
                }));
              },
            ),
          );
        });
  }

  _textDivider(String title, Widget widget) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0),
            child: Text(title,
                style: TextStyle(
                    fontSize: 14.0, color: Theme.of(context).primaryColor)),
          ),
          Divider(thickness: 1.0),
          widget,
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
