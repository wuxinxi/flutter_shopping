import 'package:flutter/material.dart';
import 'package:flutter_shopping/provider/category_goods_list_provider.dart';
import 'package:flutter_shopping/widget/nav.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'io/db/db.dart';
import 'provider/cart_provider.dart';
import 'provider/category_provider.dart';
import 'provider/jump_by_index.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DBManager.instance.initDB();
    return MultiProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.pink, primaryColorLight: Colors.pinkAccent),
        home: Nav(),
      ),
      providers: <SingleChildWidget>[
        ChangeNotifierProvider(create: (_) => JumpByIndexProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => CategoryGoodsListProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
    );
  }
}
