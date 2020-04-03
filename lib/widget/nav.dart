import 'package:flutter/material.dart';
import 'package:flutter_shopping/provider/category_provider.dart';
import 'package:flutter_shopping/provider/jump_by_index.dart';
import 'package:provider/provider.dart';
import '../page/index.dart';

class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _pageView = [
    HomePage(),
    CategoryPage(),
    ShoppingCartPage(),
    PersonPage()
  ];

  final _bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
    BottomNavigationBarItem(icon: Icon(Icons.category), title: Text('分类')),
    BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart), title: Text('购物车')),
    BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('会员中心')),
  ];

  @override
  Widget build(BuildContext context) {
    print('重构 Nav build');
    var of = Provider.of<JumpByIndexProvider>(context);
    int currentIndex = of.currentIndex;
    bool isForceJump = of.isForceJump;
    if (isForceJump) {
      //这里之所以加延迟是因为此时组件还未构建完成，而且jumpToPage还会导致再一次build组件
      //暂时未找到好的解决办法GG
      Future.delayed(Duration(milliseconds: 1)).then((_) {
        _controller.jumpToPage(currentIndex);
      });
    }

    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          if (currentIndex != index) {
            Provider.of<JumpByIndexProvider>(context, listen: false)
                .changeIndex(index);
          }
        },
        children: _pageView,
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) {
            if (currentIndex != index) {
              Provider.of<JumpByIndexProvider>(context, listen: false)
                  .changeIndex(index);
              _controller.jumpToPage(index);
            }
          },
          items: _bottomItems),
    );
  }
}
