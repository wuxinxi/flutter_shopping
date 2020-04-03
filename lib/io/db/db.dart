import 'dart:io';

import 'package:flutter_shopping/common/contant.dart';
import 'package:flutter_shopping/model/cart_model.dart';
import 'package:sqflite/sqflite.dart';

class DBManager {
  static const int _version = 1;
  static const String _db_name = 'flutter_shopping.db';
  static const tableName = 'cart';
  Database _database;

  factory DBManager() => _getInstance();

  static DBManager get instance => _getInstance();

  static DBManager _instance;

  DBManager.internal() {}

  initDB() async {
    var databasePath = await getDatabasesPath();
    String path = databasePath + _db_name;
    if (Platform.isIOS) {
      path = databasePath + '/' + _db_name;
    }
    _database =
        await openDatabase(path, version: _version, onCreate: (db, version) {
      db.execute(
          "create table $tableName (id INTEGER primary key , goodsId TEXT not null , goodsName TEXT not null , count INTEGER default 0 , price REAL  default 0.0 , images TEXT not null , isCheck BLOB  default false) ");
    });
  }

  //表是否存在
  isTableExits(String tableName) async {
    String sql =
        "select * from Sqlite master where type = 'table' and name = $tableName ";
    var res = await _database.rawQuery(sql);
    return res != null && res.length > 0;
  }

  //加入或者修改购物车
  Future<int> insert(CartModel model) async {
    List<Map<String, dynamic>> list = await _database.query(tableName,
        where: " goodsId= '${model.goodsId}' ", limit: 1);
    if (list == null || list.length == 0) {
      //如果不存在goodsId
      return await _database.insert(tableName, model.toJson());
    } else {
      CartModel newModel = CartModel.fromJson(list[0]);
      newModel.count += 1;
      return _database.update(tableName, newModel.toJson(),
          where: " goodsId= '${model.goodsId}' ");
    }
  }

  //删除指定商品
  Future<int> deleteByGoodsId(String goodsId) {
    print('删除$goodsId');
    return _database.delete(tableName, where: " goodsId= '$goodsId' ");
  }

  //删除所有
  Future<int> deleteAll() async {
    print('清空购物车');
    return _database.delete(tableName);
  }

  //更改选中状态
  //增减数量
  Future<int> update(CartModel cartModel) {
    return _database.update(tableName, cartModel.toJson(),
        where: " goodsId= '${cartModel.goodsId}' ");
  }

  //强制更改选中状态
  Future<int> forceChangeCheckState(String goodsId) {
    final sql =
        "UPDATE $tableName SET isCheck = $check WHERE  goodsId= '$goodsId' ";
    return _database.rawUpdate(sql);
  }

  //全选/不选
  Future<int> changeAllCheckState(bool isAllCheck) {
    final isCheck = isAllCheck ? check : unCheck;
    final sql = 'UPDATE $tableName SET isCheck = $isCheck ';
    return _database.rawUpdate(sql);
  }

  //查询出所有购物车信息
  query() async {
    List<Map<String, dynamic>> list = await _database.query(tableName);
    return List.generate(list.length, (i) {
      return CartModel.fromJson(list[i]);
    });
  }

  //查询出所有购物车信息
  Future<List<CartModel>> query2() async {
    List<Map<String, dynamic>> list = await _database.query(tableName);
    return List.generate(list.length, (i) {
      return CartModel.fromJson(list[i]);
    });
  }

  static DBManager _getInstance() {
    if (_instance == null) {
      _instance = DBManager.internal();
    }
    return _instance;
  }
}
