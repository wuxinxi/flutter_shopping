import 'package:flutter/material.dart';

class MyScaffold extends Scaffold {
  final String title;
  final BuildContext context;
  final Widget body;
  final bool leading;

  MyScaffold(
      {Key key,
      @required this.context,
      @required this.title,
      this.body,
      this.leading = false})
      : super(key: key, body: body);

  @override
  PreferredSizeWidget get appBar => AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
        centerTitle: true,
        leading: leading
            ? BackButton(onPressed: () => Navigator.pop(context))
            : null,
      );
}
