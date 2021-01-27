import 'package:flutter/material.dart';
import 'package:geo_explorer/widget/map.dart';
import 'package:provider/provider.dart';

class Pregunta extends StatefulWidget {
  final pregunta;

  Pregunta({Key key, @required this.pregunta}) : super(key: key);

  @override
  _PreguntaState createState() => _PreguntaState(pregunta);
}

class _PreguntaState extends State<Pregunta> {
  var pregunta;
  var valor = "A";

  _PreguntaState(var pregunta) {
    this.pregunta = pregunta;
  }

  @override
  Widget build(BuildContext context) {
    var preguntaP = Provider.of<Pregunta>(context);

    return Container(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                  child: Text(pregunta['pregunta'],
                      style: TextStyle(fontFamily: 'Arcade'))),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 200,
                width: 200,
                child: Image(
                    image: NetworkImage(
                        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg')),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
              ),
              ListTile(
                title: Text(pregunta['respuesta1']),
                leading: Radio(
                  value: "A",
                  groupValue: valor,
                  onChanged: (String value) {
                    setState(() {
                      valor = value;
                    });
                  },
                ),
              ),
              ListTile(
                  title: Text(pregunta['respuesta2']),
                  leading: Radio(
                    value: "B",
                    groupValue: valor,
                    onChanged: (String value) {
                      setState(() {
                        valor = value;
                      });
                    },
                  )),
              ListTile(
                  title: Text(pregunta['respuesta3']),
                  leading: Radio(
                    value: "C",
                    groupValue: valor,
                    onChanged: (String value) {
                      setState(() {
                        valor = value;
                      });
                    },
                  )),
              FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.pop(context);
                    print(pregunta['correcta']);
                    print(valor);
                    if (valor == pregunta['correcta']) {
                      print('has acertado');
                    }
                  },
                  label: Icon(Icons.check))
            ],
          )
        ],
      ),
    );
  }
}
