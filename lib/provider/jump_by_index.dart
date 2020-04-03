import 'package:flutter/material.dart';

//切换导航栏
class JumpByIndexProvider extends ChangeNotifier {
  int currentIndex = 0;
  bool isForceJump = false;

  changeIndex(int newIndex, {isForceJump = false}) {
    this.currentIndex = newIndex;
    this.isForceJump = isForceJump;
    notifyListeners();
  }
}
