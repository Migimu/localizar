import 'package:flutter/material.dart';

import 'package:geo_explorer/widget/chat.dart';
import 'package:geo_explorer/widget/informacion.dart';
import 'package:geo_explorer/widget/map.dart';

class Pages extends StatefulWidget {
  Pages({Key key, @required this.localizacionesList, @required this.rutaList})
      : super(key: key);

  final List localizacionesList;
  final rutaList;

  @override
  _PagesState createState() => _PagesState(localizacionesList, rutaList);
}

class _PagesState extends State<Pages> {
  var localizacionesList = [];
  var rutaList;

  _PagesState(List localizaciones, var rutaList) {
    this.localizacionesList = localizaciones;
    this.rutaList = rutaList;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: <Widget>[
        InfoPage(
          rutaList: rutaList,
        ),
        Mapa(
          localizaciones: localizacionesList,
        ),
        Chat(),
      ],
    );
  }
}
