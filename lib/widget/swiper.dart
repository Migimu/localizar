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
  var idRuta;

  @override
  void initState() {
    super.initState();
    getUsuario();
  }

  Future<List> getData() async {
    return await API.getRutas().then((response) {
      return response;
    });
  }

  Future<Map> getRutausuario(var id) async {
    return await API.getRutaUsuario(id).then((response) {
      print(response);
      return response;
    });
  }

  Future<List> getGetUser(var nombre) async {
    return await API.getUser(nombre).then((response) {
      return response;
    });
  }

  Future<void> getUsuario() async {
    usuario = await getGetUser(usuarioNombre);
  }

  List<String> ciudades = ["TODOS"];
  var dropdownValue = "TODOS";
  @override
  Widget build(BuildContext context) {
    final ruta = Provider.of<Ruta>(context);

    final rutas = Provider.of<Rutas>(context);

    return Container(
        child: Scaffold(
      body: FutureBuilder<List>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
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

              var itemLista =
                  ciudades.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList();
              return Column(children: <Widget>[
                SizedBox(
                  height: 10,
                ),
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
                Swiper(
                  onIndexChanged: (value) {
                    idRuta = snapshot.data[value]["id"];
                  },
                  layout: SwiperLayout.TINDER,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
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
                      var imagen64 = base64.decode(imagen);

                      imagenValida = Image.memory(
                        imagen64,
                        width: 100.0,
                        height: 200.0,
                      );
                    }
                    return Container(
                      child: Column(children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          child: imagenValida,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(),
                            Flexible(
                                child: Text(snapshot.data[index]['nombre'],
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(fontSizeFactor: 2.0))),
                            Row(
                              children: [Icon(Icons.person), Text("0")],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.60,
                            height: MediaQuery.of(context).size.width * 0.40,
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                        snapshot.data[index]['descripcion']),
                                  ),
                                  Row(
                                    children: [
                                      FlatButton(
                                        color: Colors.blue[300],
                                        onPressed: () async {
                                          puntuacion = 0;

                                          /*****************INICIAR RUTA****************** */

                                          Map data = {
                                            "usuarioId": usuario[0]["id"],
                                            "rutaId": idRuta,
                                            "puntuacion": puntuacion,
                                            "activo": true,
                                          };

                                          API.createRutaUsuario(data);

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Pages(
                                                      localizacionesList: snapshot
                                                              .data[index][
                                                          'listaLocalizaciones'],
                                                      rutaList:
                                                          snapshot.data[index],
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
                FloatingActionButton.extended(
                  label: Text("RANKING"),
                  onPressed: () {
                    /*****************ABRIR RANKING****************** */

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Ranking(
                                  id: idRuta,
                                )));
                  },
                ),
              ]);
            } else if (snapshot.hasError) {
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
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Center(child: CircularProgressIndicator())]);
            }
          }),
    ));
  }
}
