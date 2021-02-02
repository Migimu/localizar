import 'dart:convert';
import 'dart:io';

import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:geo_explorer/global/globals.dart';

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

  //String localIP = "10.10.12.183";
  //String localIP = "13.95.106.247";
  String localIP = "192.168.56.1";

  int port = 1234;
  //int port = 443;

  String nick = usuario[0]["nombre"];

  _PagesState(List localizaciones, var rutaList) {
    this.localizacionesList = localizaciones;
    this.rutaList = rutaList;
  }

  /*######RUTAS########*/
  //CONECTARSE A EL SERVIDOR
  void connectToServer() async {
    print('conectando ...');
    Socket.connect(localIP, port, timeout: Duration(seconds: 5))
        .then((misocket) {
      socketChat = misocket;
      print(
          "connected to ${socketChat.remoteAddress.address}:${socketChat.remotePort}");
      sendLoginMsg("login");

      socketChat.listen(
        (data) => escucharServer(utf8.decode(data)),
      );
      setState(() {});
    });
  }

  //ENVIAR MENSAJE

  void sendLoginMsg(String action) {
    var loginMsg = Map();

    loginMsg["action"] = action;
    loginMsg["user"] = usuario[0]["nombre"];
    loginMsg["route"] = rutaName;

    socketChat?.write('${jsonEncode(loginMsg)}\n');
  }

//AÑADIR MENSAJE A EL CHAT SI LO RECIVE DEL SERVER
  void escucharServer(json) {
    var data = jsonDecode(json);
    setState(() {
      if (data['from'] == "server") {
        mensajes.add(ChatMessage(
            customProperties: {
              "color": Colors.amber
            },
            buttons: [
              Text(
                "Mensaje del server",
                style: TextStyle(color: Colors.green[900]),
              )
            ],
            text: data['value'],
            user: ChatUser(name: data['from'], uid: data['from'])));
      } else {
        mensajes.add(ChatMessage(
            buttons: [
              Text(
                data['from'],
                style: TextStyle(color: Colors.blue[900]),
              )
            ],
            text: data['value'],
            user: ChatUser(name: data['from'], uid: data['from'])));
      }
    });
  }

  /*###################*/

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

//VISTA PAGINADA
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: PageView(
        children: <Widget>[
          //PAGINA INFORMACION
          InfoPage(
            rutaList: rutaList,
          ),
          //MAPA
          Mapa(
            localizaciones: localizacionesList,
          ),
          //CHAT
          Chat(),
        ],
      ),
    );
  }
}
