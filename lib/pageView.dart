import 'package:flutter/material.dart';

import 'package:geo_explorer/widget/map.dart';
import 'package:geo_explorer/widget/chat.dart';

class Pages extends StatefulWidget {
  Pages({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PagesState createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  var _currentLocation;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: <Widget>[
        Container(
          color: Colors.deepPurple,
        ),
        map(
          posicion: _currentLocation,
        ),
        Chat(),
      ],
    );
  }
}
