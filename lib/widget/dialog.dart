import 'package:flutter/material.dart';

class Pregunta extends StatefulWidget {
  Pregunta({Key key}) : super(key: key);

  @override
  _PreguntaState createState() => _PreguntaState();
}

class _PreguntaState extends State<Pregunta> {
  var valor = "A";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Align(child: Text("RESPONDE")),
          Image(
            image: NetworkImage(
                'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
          ),
          ListTile(
            title: const Text('Pregunta A'),
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
              title: const Text('Pregunta B'),
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
              title: const Text('Pregunta C'),
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
              onPressed: null, label: Icon(Icons.check))
        ],
      ),
    );
  }
}
