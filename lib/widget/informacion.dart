import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_explorer/api/conexionApi.dart';
import 'package:geo_explorer/global/globals.dart';
import 'package:geo_explorer/widget/swiper.dart';

class InfoPage extends StatefulWidget {
  final rutaList;

  InfoPage({Key key, @required this.rutaList}) : super(key: key);
  @override
  _InfoPageState createState() => _InfoPageState(rutaList);
}

class _InfoPageState extends State<InfoPage> {
  var rutaList;
  _InfoPageState(var rutaList) {
    this.rutaList = rutaList;
  }

  List<Widget> _getLocalizaciones() {
    var localizaciones = [
      Text(
        "LOCALIZACIONES",
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 10)
    ];
    for (var localizacion in rutaList["listaLocalizaciones"]) {
      var json = jsonDecode(localizacion);
      localizaciones.add(Text(json["nombre"]));
    }
    return localizaciones;
  }

  Future<List> _getUsuariosRanking() async {
    return await API.getPuntuacion(rutaList["id"]).then((response) {
      return response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(17, 75, 95, 1),
        body: Stack(
          children: [
            Positioned.fill(
              top: 50,
              child: Align(
                  child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // mainAxisAlignment
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width *
                            0.80, //80% de la pantalla
                        //height: 100,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(243, 233, 210, 1),
                            border: Border.all(
                              color: Color.fromRGBO(224, 214, 191, 1),
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                rutaList["nombre"],
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(rutaList["descripcion"]),
                              SizedBox(height: 10),
                            ]),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width *
                            0.80, //80% de la pantalla
                        height: MediaQuery.of(context).size.width * 0.50,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(198, 218, 191, 1),
                            border: Border.all(
                              color: Color.fromRGBO(136, 212, 152, 1),
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _getLocalizaciones()),
                      ),
                      SizedBox(height: 10),
                      Container(
                          width: MediaQuery.of(context).size.width *
                              0.80, //80% de la pantalla
                          //height: 100,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(243, 233, 210, 1),
                              border: Border.all(
                                color: Color.fromRGBO(224, 214, 191, 1),
                                width: 4,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: new BoxDecoration(
                                    color: Color.fromRGBO(136, 212, 152, 0.51),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 5,
                                        offset: Offset(
                                            0, 4), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  //width: 200,
                                  //height: 100,
                                  child: FutureBuilder<List>(
                                      future: _getUsuariosRanking(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        var listaColumn = <Widget>[
                                          Center(
                                            child: Text('RANKING',
                                                style: TextStyle(
                                                    fontFamily: 'Arcade')),
                                          )
                                        ];
                                        var i = 1;
                                        var pos;
                                        if (snapshot.hasData) {
                                          for (var usuario in snapshot.data) {
                                            if (i == 1) {
                                              pos = "1ST";
                                            } else if (i == 2) {
                                              pos = "2ND";
                                            } else if (i == 3) {
                                              pos = "3RD";
                                            } else {
                                              pos = "${i}TH";
                                            }
                                            listaColumn
                                                .add(SizedBox(height: 10));
                                            listaColumn.add(Text(
                                                '$pos ${usuario["usuario"]} ${usuario["puntuacion"]}',
                                                style: TextStyle(
                                                    fontFamily: 'Arcade',
                                                    fontSize: 20)));
                                            i++;
                                            if (i == 6) {
                                              break;
                                            }
                                          }
                                          return Column(children: listaColumn);
                                        } else if (snapshot.hasError) {
                                          return Column(children: [
                                            Icon(
                                              Icons.error_outline,
                                              color: Colors.red,
                                              size: 60,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 16),
                                              child: Text(
                                                  'Error: ${snapshot.error}'),
                                            )
                                          ]);
                                        } else {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      }),
                                ),
                                SizedBox(height: 10),
                                RaisedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible:
                                          false, // user must tap button!
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Row(children: [
                                            Text('Atencion'),
                                            Icon(Icons.warning)
                                          ]),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                Text(
                                                    'Estas seguro de que quieres salar de la partida?'),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                    'Perderas todo tu progreso.'),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                    'Selecciona una de las respuestas para continuar.'),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Icon(Icons.check),
                                              onPressed: () {
                                                mensajes = [];
                                                API.updateRutaUsuarioDes(
                                                    rutaUsuario["id"]);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SwiperRutas()),
                                                );
                                              },
                                            ),
                                            TextButton(
                                              child: Icon(Icons.clear),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  textColor: Colors.white,
                                  padding: const EdgeInsets.all(1.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(26, 147, 111, 1),
                                    ),
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text('FINALIZAR PARTIDA',
                                        style: TextStyle(fontFamily: 'Arcade')),
                                  ),
                                )
                              ])),
                    ]),
              )),
            )
          ],
        ));
  }
}
