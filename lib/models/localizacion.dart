import 'package:flutter/material.dart';
import 'package:geo_explorer/models/pregunta.dart';

class Localizaciones extends ChangeNotifier {
  List<Localizacion> items = new List();

  set localizaciones(Localizacion localizacion) {
    items.add(localizacion);
  }

  Localizaciones({this.items});
}

class Localizacion extends ChangeNotifier {
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
