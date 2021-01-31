import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_explorer/api/conexionApi.dart';
import 'package:geo_explorer/global/globals.dart';
import 'package:geo_explorer/widget/swiper.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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

// LOCALIZACIONES EN AL MAPA Y INDICADOR DE PROGRESO
  List<Widget> _getLocalizaciones() {
    var localizaciones = [
      LinearPercentIndicator(
        center:
            Text("$contRespondido/${rutaList["listaLocalizaciones"].length}"),
        lineHeight: 30,
        percent: contRespondido / rutaList["listaLocalizaciones"].length,
      ),
      SizedBox(
        height: 10,
      ),
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
      //var json = jsonDecode(localizacion);
      localizaciones.add(Text(localizacion["nombre"]));
    }
    return localizaciones;
  }
  //LLAMDA A LA API PARA OBTENER LAS PUNTUACIONES

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
                      //NOMBRE Y DESCRIPCION DE LA RUTA
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
                      // LOCALIZACIONES EN AL MAPA Y INDICADOR DE PROGRESO
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
                      //RANKING SIMPLIFICADO
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
                                        var username = "Anonimo";
                                        if (snapshot.hasData) {
                                          for (var usuario in snapshot.data) {
                                            for (var user in listaUsuarios) {
                                              if (user["id"] ==
                                                  usuario["usuarioId"]) {
                                                username = user["usuario"];
                                                break;
                                              }
                                            }
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
                                                '$pos $username ${usuario["puntuacion"]}',
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
                                //BOTON DE FINALIZAR PARTIDA
                                RaisedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible:
                                          false, // user must tap button!
                                      builder: (BuildContext context) {
                                        //PESTAÑA DE ADVERTENCIA PARA SALIR DE LA RUTA
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
                                          //BOTON IZQUIERDA PESTAÑA SALIR
                                          actions: <Widget>[
                                            TextButton(
                                              child: Icon(Icons.check),
                                              onPressed: () {
                                                //VACIAMOS CHAT
                                                mensajes = [];
                                                //DEJAMOS DE JUGAR
                                                jugando = false;
                                                //SALIMOS DE LA PARTIDA

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
                                            //BOTON DERECHA PESTAÑA SALIR
                                            TextButton(
                                              child: Icon(Icons.clear),
                                              onPressed: () {
                                                //CERRAMOS PESTAÑA
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
