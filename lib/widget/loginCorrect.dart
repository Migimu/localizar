import 'package:flutter/material.dart';
import 'package:geo_explorer/api/conexionApi.dart';

import 'dart:convert';

class LoginCorrect extends StatefulWidget {
  LoginCorrect({Key key, this.usuario}) : super(key: key);
  final usuario;

  @override
  _LoginCorrectState createState() => _LoginCorrectState();
}

class _LoginCorrectState extends State<LoginCorrect> {
  var dbUser;

  @override
  void initState() {
    super.initState();
    obtenerUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("LOGUEADO")),
      body: Center(
        child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              if (dbUser == null) ...{
                CircularProgressIndicator()
              } else ...{
                Text("hola ${widget.usuario}"),
                mostrarImagen()
              }
              //mostrarImagen()
            ])),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        mostrarImagen();
      }),
    );
  }

  obtenerUsuario() {
    API.getUser(widget.usuario).then((response) {
      dbUser = response[0];
      setState(() {});
    });
  }

  mostrarImagen() {
    print(dbUser);
    if (dbUser["avatar"] != null) {
      print("hola");
      var imagen = base64.decode(dbUser['avatar']);
      return Image.memory(imagen, width: 80.0, height: 80.0);
    } else {
      return Image(
          image: AssetImage('images/explorer.png'), width: 80.0, height: 80.0);
    }
  }
}
