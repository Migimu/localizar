import 'package:flutter/material.dart';

class Pregunta extends ChangeNotifier {
  String pregunta;
  String respuesta1;
  String respuesta2;
  String respuesta3;
  String correcta;
  String imagen;
  String localizacionId;

  Pregunta(
      {this.pregunta,
      this.respuesta1,
      this.respuesta2,
      this.respuesta3,
      this.correcta,
      this.imagen,
      this.localizacionId});
}
