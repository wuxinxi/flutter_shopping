import 'package:flutter/material.dart';

class PersonScaffold extends Scaffold {
  final String title;
  final BuildContext context;
  final Widget body;
  final GestureTapCallback onSettingTap;
  final GestureTapCallback onMessageTap;

  PersonScaffold(
      {Key key,
      @required this.context,
      @required this.title,
      this.body,
      this.onSettingTap,
      this.onMessageTap})
      : super(key: key, body: body);

  @override
  PreferredSizeWidget get appBar => AppBar(
    backgroundColor: Colors.transparent,
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings, size: 23.0), onPressed: onSettingTap),
          IconButton(
              icon: Icon(Icons.message, size: 23.0), onPressed: onMessageTap)
        ],
      );
}
