import 'dart:convert';

import 'package:flutter/material.dart';

class Pregunta extends StatefulWidget {
  final pregunta;

  Pregunta({Key key, @required this.pregunta}) : super(key: key);

  @override
  _PreguntaState createState() => _PreguntaState(pregunta);
}

class _PreguntaState extends State<Pregunta> {
  var pregunta;
  var valor = "1";

  _PreguntaState(var pregunta) {
    this.pregunta = pregunta;
  }

  @override
  Widget build(BuildContext context) {
    //COMPRUEBA SI HAY UNA IMAGEN VALIDA SI NO PONE UN PLACEHOLDER
    var imagenValida;
    if (pregunta['imagen'] == "" || pregunta['imagen'] == null) {
      imagenValida = AssetImage("images/explorer.png");
    } else {
      imagenValida = Image.memory(
        base64.decode(pregunta['imagen']),
        width: 100.0,
        height: 200.0,
      );
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //PREGUNTA
                Align(
                    child: Text(pregunta['pregunta'],
                        style: TextStyle(fontFamily: 'Arcade', fontSize: 20))),
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 200,
                  width: 200,
                  child: Image(image: imagenValida),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  child: Column(
                    children: [
                      //RESPUESTA UNO
                      ListTile(
                        title: Text(
                          pregunta['respuesta1'],
                          style: TextStyle(fontFamily: 'Arcade', fontSize: 14),
                        ),
                        leading: Radio(
                          value: "1",
                          groupValue: valor,
                          onChanged: (String value) {
                            setState(() {
                              valor = value;
                            });
                          },
                        ),
                      ),
                      //RESPUESTA DOS
                      ListTile(
                          title: Text(
                            pregunta['respuesta2'],
                            style:
                                TextStyle(fontFamily: 'Arcade', fontSize: 14),
                          ),
                          leading: Radio(
                            value: "2",
                            groupValue: valor,
                            onChanged: (String value) {
                              setState(() {
                                valor = value;
                              });
                            },
                          )),
                      //RESPUESTA TRES
                      ListTile(
                          title: Text(
                            pregunta['respuesta3'],
                            style:
                                TextStyle(fontFamily: 'Arcade', fontSize: 14),
                          ),
                          leading: Radio(
                            value: "3",
                            groupValue: valor,
                            onChanged: (String value) {
                              setState(() {
                                valor = value;
                              });
                            },
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                //DEVUELVE EL RESUTADO DE LA PREGUNTA SI ES CORRECTO O NO Y VUELVE A MOSTRAR EL MAPA
                FloatingActionButton.extended(
                    onPressed: () {
                      //print(pregunta['correcta']);
                      print("$valor dialog");
                      if (valor == pregunta['correcta']) {
                        print('has acertado');
                      }
                      Navigator.pop(
                          context, int.parse(valor) == pregunta['correcta']);
                    },
                    label: Icon(Icons.check))
              ],
            ))
          ],
        ),
      ),
    );
  }
}
