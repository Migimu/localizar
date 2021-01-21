import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:geo_explorer/models/localizacion.dart';
import 'package:geo_explorer/models/ruta.dart';
import 'package:geo_explorer/pageView.dart';
import 'package:geo_explorer/api/conexionApi.dart';

class SwiperRutas extends StatefulWidget {
  SwiperRutas({Key key}) : super(key: key);

  @override
  _SwiperRutasState createState() => _SwiperRutasState();
}

class _SwiperRutasState extends State<SwiperRutas> {
  List<Ruta> listaRutas = [];

  @override
  void initState() {
    super.initState();
    API.getRutas().then((response) {
      Ruta ruta = new Ruta("", "", "", "", 0, "", "", "", 0, []);
      for (var json in response) {
        print(json["id"]);

        ruta.setId(json["id"]);

        ruta.setNombre(json["nombre"]);

        ruta.setCiudad(json["ciudad"]);

        ruta.setTamatica(json["tematica"]);

        ruta.setDuracion(json["duracion"]);

        ruta.setDescripcion(json["descripcion"]);

        ruta.setTransporte(json["transporte"]);

        ruta.setImagen(json["imagen"]);

        ruta.setDificultad(json["dificultad"]);

        listaRutas.add(ruta);
      }
    });
  }

  final imageList = [
    'https://cdn.pixabay.com/photo/2016/03/05/19/02/hamburger-1238246__480.jpg',
    'https://cdn.pixabay.com/photo/2016/11/20/09/06/bowl-1842294__480.jpg',
    'https://cdn.pixabay.com/photo/2017/01/03/11/33/pizza-1949183__480.jpg',
    'https://cdn.pixabay.com/photo/2017/02/03/03/54/burger-2034433__480.jpg',
  ];
  var dropdownValue = "One";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          body: Column(children: <Widget>[
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
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: <String>['One', 'Two', 'Free', 'Four']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        Swiper(
          layout: SwiperLayout.TINDER,
          itemCount: listaRutas.length,
          itemBuilder: (context, index) {
            return Container(
              child: Column(children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Image.network(
                  imageList[index],
                  fit: BoxFit.cover,
                  height: 200,
                  width: 300,
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(),
                    Flexible(
                        child: Text(listaRutas[index].getNombre(),
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
                Text(listaRutas[index].getDescripcion()),
                Row(
                  children: [
                    FlatButton(
                      color: Colors.blue[300],
                      onPressed: () {
                        /*****************INICIAR RUTA****************** */
                        print("object");
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Pages()),
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
          height: 30,
        ),
        FloatingActionButton.extended(
          onPressed: () {},
          label: Text("RANKING"),
        )
      ])),
    );
  }
}
