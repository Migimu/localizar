import 'package:flutter/material.dart';

import 'package:geo_explorer/widget/chat.dart';
import 'package:geo_explorer/widget/map.dart';

class Pages extends StatefulWidget {
  Pages({Key key, @required this.localizacionesList}) : super(key: key);

  final List localizacionesList;

  @override
  _PagesState createState() => _PagesState(localizacionesList);
}

class _PagesState extends State<Pages> {
  var localizacionesList = [];

  _PagesState(List localizaciones) {
    this.localizacionesList = localizaciones;
  }

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
        Mapa(
          localizaciones: localizacionesList,
        ),
        Chat(),
      ],
    );
  }
}
