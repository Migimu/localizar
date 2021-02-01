import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:geo_explorer/global/globals.dart';
import 'package:geo_explorer/models/ruta.dart';
import 'package:geo_explorer/pages/pageView.dart';
import 'package:geo_explorer/api/conexionApi.dart';
import 'package:geo_explorer/widget/ranking.dart';
import 'package:provider/provider.dart';

class SwiperRutas extends StatefulWidget {
  SwiperRutas({Key key}) : super(key: key);

  @override
  _SwiperRutasState createState() => _SwiperRutasState();
}

class _SwiperRutasState extends State<SwiperRutas> {
  List listaRutas = [];
  int longitudSwiper = 0;

  @override
  void initState() {
    super.initState();
    getUsuario();
  }

  //LLAMDA A API PARA CONSEGUIR LAS RUTAS

  Future<List> getData() async {
    return await API.getRutas().then((response) {
      return response;
    });
  }

  //LLAMDA A API PARA CONSEGUIR PARITDA

  Future<Map> getRutausuario(var id) async {
    return await API.getRutaUsuario(id).then((response) {
      print(response);
      return response;
    });
  }

  //LLAMDA A API PARA CONSEGUIR EL USUARIO POR NOMBRE DE USUARIO

  Future<List> getGetUser(var nombre) async {
    return await API.getUser(nombre).then((response) {
      return response;
    });
  }

  Future<void> getUsuario() async {
    usuario = await getGetUser(usuarioNombre);
  }

  //VALORES DEL BOTON DROPDOWN

  List<String> ciudades = ["TODOS"];
  var dropdownValue = "TODOS";
  @override
  Widget build(BuildContext context) {
    final ruta = Provider.of<Ruta>(context);

    final rutas = Provider.of<Rutas>(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
          child: Scaffold(
        // SE PIDE LA INFORMACION A LA API Y MENDIATE EL FUTURE BUILDER SE GETIONA
        body: FutureBuilder<List>(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              //SI HAY DATOS
              if (snapshot.hasData) {
                if (dropdownValue == "TODOS") {
                  longitudSwiper = snapshot.data.length;
                } else {
                  snapshot.data.retainWhere(
                      (element) => element["ciudad"] == dropdownValue);
                  longitudSwiper = snapshot.data.length;
                }

                print(snapshot.data);
                //LISTA DE CIUDADES PARA EL BOTON DROPDOWN
                idRuta = snapshot.data[0]["id"];
                rutaName = snapshot.data[0]["nombre"];
                for (var ruta in snapshot.data) {
                  var esta = false;
                  for (var ciudad in ciudades) {
                    if (ciudad == ruta['ciudad']) {
                      esta = true;
                    }
                  }
                  if (!esta) {
                    ciudades.add(ruta['ciudad']);
                  }
                }
                //AQUI SE AÑADEN LA CIUDADES
                var itemLista =
                    ciudades.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList();

                //VISTA ELEGIR RUTAS
                return Column(children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  //BOTON DROPDOWN
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String newValue) {
                      print(newValue);
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: itemLista,
                  ),

                  //SWIPER

                  Swiper(
                    onIndexChanged: (value) {
                      //CUENDO SE CAMBIA DE CARTA SE CAMBIA EL VALOR DE LA VARIABLE PARA EL RANKING
                      idRuta = snapshot.data[value]["id"];
                    },
                    layout: SwiperLayout.TINDER,
                    itemCount: longitudSwiper,
                    itemBuilder: (context, index) {
                      //COMPRUEBA SI HAY UNA IMAGEN VALIDA SI NO LA SUSTITUYE POR UN PLACEHOLDER
                      var imagen = snapshot.data[index]['imagen'];
                      var imagenValida;

                      if (imagen == "" ||
                          imagen.substring(imagen.length - 4, imagen.length) ==
                              ".jpg") {
                        imagenValida = Image(
                          image: AssetImage("images/explorer.png"),
                          height: 200,
                          width: 300,
                        );
                      } else {
                        //EN LA BASE DE DATOS LAS IMAGENS SE GUARDAR COMO BASE64 ASI SE DECODIFICAN
                        var imagen64 = base64.decode(imagen);

                        imagenValida = Image.memory(
                          imagen64,
                          width: 100.0,
                          height: 200.0,
                        );
                      }

                      //SI EL VALOR DEL DROPDOWN COINCIDE CON EL DE LA RUTA SE MUESTRA LA CARTA
                      /*if (dropdownValue == snapshot.data[index]["ciudad"]) {*/
                      return Container(
                        child: Column(children: <Widget>[
                          SizedBox(
                            height: 15,
                          ),
                          //LA IMAGEN
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                  color: Color.fromRGBO(224, 214, 191, 1),
                                  width: 4,
                                ),
                                borderRadius: BorderRadius.circular(12)),
                            child: imagenValida,
                          ),
                          SizedBox(
                            height: 30,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(),
                              //EL NOMBRE DE LA RUTA
                              Flexible(
                                  child: Text(snapshot.data[index]['nombre'],
                                      style: TextStyle(
                                        fontFamily: 'Arcade',
                                        fontSize: 16,
                                      ))),
                              //EL NUMERO DE PERSONAS EN LA RUTA
                              Row(
                                children: [Icon(Icons.person), Text("0")],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          //DESCRIPCION Y BOTON DE INICIAR RUTA
                          Container(
                              width: MediaQuery.of(context).size.width * 0.60,
                              height: MediaQuery.of(context).size.width * 0.40,
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                        child: SingleChildScrollView(
                                      child: Text(
                                          snapshot.data[index]['descripcion'],
                                          style: TextStyle(
                                              fontFamily: 'Arcade',
                                              fontSize: 12)),
                                    )),
                                    Row(
                                      children: [
                                        FlatButton(
                                          color: Colors.blue[300],
                                          onPressed: () async {
                                            puntuacion = 0;
                                            contRespondido = 0;
                                            /*****************INICIAR RUTA****************** */
                                            //LLAMADA A LA API PARA CREAR NUEVA PARTIDA
                                            Map data = {
                                              "usuarioId": usuario[0]["id"],
                                              "rutaId": idRuta,
                                              "puntuacion": puntuacion,
                                              "activo": true,
                                            };

                                            API.createRutaUsuario(data);

                                            //MOUSTRA SIGUINTE PESTAÑA

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Pages(
                                                        //LISTA DE LOCALIZACIONES
                                                        localizacionesList: snapshot
                                                                .data[index][
                                                            'listaLocalizaciones'],
                                                        //RUTA ACTUAL
                                                        rutaList: snapshot
                                                            .data[index],
                                                      )),
                                            );
                                          },
                                          child: Icon(Icons.check),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        )
                                      ],
                                      mainAxisAlignment: MainAxisAlignment.end,
                                    )
                                  ]))
                        ]),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(width: 3.0),
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                      );
                    },
                    itemWidth: MediaQuery.of(context).size.width * 0.80,
                    itemHeight: MediaQuery.of(context).size.height * 0.80,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //BOTON RANKING
                  FloatingActionButton.extended(
                    label: Text("RANKING"),
                    onPressed: () {
                      /*****************ABRIR RANKING****************** */

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Ranking(
                                    //ID DE LA RUTA ACTUAL
                                    id: idRuta,
                                  )));
                    },
                  ),
                ]);
              } else if (snapshot.hasError) {
                //SI HAY UN ERROR CON LA INFORMACION LO QUE MUESTRA
                return Column(children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  )
                ]);
              } else {
                //LO QUE MUSTRA MIENTRAS SE CARGA LA INFORMACION
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Center(child: CircularProgressIndicator())]);
              }
            }),
      )),
    );
  }
}
