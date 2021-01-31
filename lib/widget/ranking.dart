import 'package:flutter/material.dart';
import 'package:geo_explorer/api/conexionApi.dart';
import 'package:geo_explorer/global/globals.dart';
import 'package:geo_explorer/widget/swiper.dart';

class Ranking extends StatefulWidget {
  final id;
  Ranking({Key key, @required this.id}) : super(key: key);

  @override
  _RankingState createState() => _RankingState(id);
}

class _RankingState extends State<Ranking> {
  var id;

  _RankingState(var id) {
    this.id = id;
  }
//LLAMADA A LA API PARA OBTENER LAS PUNTUACIONES
  Future<List> getData(var id) async {
    return await API.getPuntuacion(id).then((response) {
      return response;
    });
  }

  List<Widget> usuarios = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //CUERPO
    return Container(
      width: MediaQuery.of(context).size.width * 0.80, //80% de la pantalla
      //height: 100,
      height: MediaQuery.of(context).size.height * 0.80, //80% de la pantalla
      //height: 100,
      decoration: BoxDecoration(
          color: Color.fromRGBO(243, 233, 210, 1),
          border: Border.all(
            color: Color.fromRGBO(224, 214, 191, 1),
            width: 4,
          ),
          borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
          child: Column(children: [
        //TITULO
        Container(
          decoration: new BoxDecoration(
            color: Color.fromRGBO(136, 212, 152, 0.51),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 5,
                offset: Offset(0, 4), // changes position of shadow
              ),
            ],
          ),
          child: Center(
            child: Text('RANKING',
                style: TextStyle(fontFamily: 'Arcade', fontSize: 60)),
          ),
        ),

        //LLAMDA A API PARA GESTIONAR LOS DATOS
        FutureBuilder<List>(
            future: getData(id),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              print(id);
              //SI HAY DATOS
              if (snapshot.hasData) {
                var pos;
                var i = 1;
                var username = "Anonimo";
                //FUNCION PARA HACER LISTA DE POSCIONES
                for (var usuario in snapshot.data) {
                  for (var user in listaUsuarios) {
                    if (user["id"] == usuario["usuarioId"]) {
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
                  //ENTRADA RANKING
                  usuarios.add(Text('$pos $username ${usuario["puntuacion"]}',
                      style: TextStyle(fontFamily: 'Arcade', fontSize: 20)));
                  i++;
                  if (i == 11) {
                    break;
                  }
                }

                var columna = Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: usuarios)));
                return columna;
                //SI HAY ALGUN ERROR CON LA INFORMACION
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
                //MIENTRAS SE CARGA LA INFORMACION
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
        //BOTON DE VOLVER A RUTAS
        Container(
            decoration: new BoxDecoration(
              color: Color.fromRGBO(136, 212, 152, 0.51),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: Offset(0, 4), // changes position of shadow
                ),
              ],
            ),
            child: FlatButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SwiperRutas()),
                );
              },
              child: Text("Volver a rutas",
                  style: TextStyle(
                      fontFamily: 'Arcade', fontSize: 20, color: Colors.red)),
              height: 100,
            ))
      ])),
    );
  }
}
