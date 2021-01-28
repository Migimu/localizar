import 'package:flutter/material.dart';
import 'package:geo_explorer/api/conexionApi.dart';

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

  Future<List> getData(var id) async {
    return await API.getPuntuacion(id).then((response) {
      return response;
    });
  }

  List<Widget> usuarios = [];

  @override
  Widget build(BuildContext context) {
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
      child: Column(children: [
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
        //width: 200,
        //height: 100,
        FutureBuilder<List>(
            future: getData(id),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              print(id);
              if (snapshot.hasData) {
                var pos;
                var i = 1;
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
                  usuarios.add(Text('$pos AAAAA 1000',
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
                return Center(child: CircularProgressIndicator());
              }
            }),
      ]),
    );
  }
}
