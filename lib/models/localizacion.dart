import 'package:flutter/material.dart';
import 'package:geo_explorer/models/pregunta.dart';

class Localiazaciones extends ChangeNotifier {
  List<Localizacion> items = new List();

  Localiazaciones({this.items});
}

class Localizacion {
  String nombre;
  double latitud;
  double longitud;
  bool oculta;
  String pista;
  Pregunta pregunta;
  String rutaId;

  Localizacion(
      {this.nombre,
      this.latitud,
      this.longitud,
      this.oculta,
      this.pista,
      this.pregunta,
      this.rutaId});
}
