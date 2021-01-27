import 'package:flutter/material.dart';
import 'package:geo_explorer/models/localizacion.dart';

class Rutas with ChangeNotifier {
  List<Ruta> items = new List();

  void setRutas(Ruta ruta) {
    items.add(ruta);
  }

  Rutas({this.items});
}

class Ruta with ChangeNotifier {
  String id = "";
  String nombre = "";
  String ciudad = "";
  String tematica = "";
  double duracion = 0;
  String descripcion = "";
  String transporte = "";
  String imagen = "";
  int dificultad = 0;
  List<Localizacion> listaLocalizaciones = [];

  //Ruta.empty();

  Ruta(
      {this.id,
      this.nombre,
      this.ciudad,
      this.tematica,
      this.duracion,
      this.descripcion,
      this.transporte,
      this.imagen,
      this.dificultad,
      this.listaLocalizaciones});
//GETTERS

  String getId() {
    return this.id;
  }

  String getNombre() {
    return this.nombre;
  }

  String getCiudad() {
    return this.ciudad;
  }

  String getTamatica() {
    return this.tematica;
  }

  double getDuracion() {
    return this.duracion;
  }

  String getDescripcion() {
    return this.descripcion;
  }

  String getTransporte() {
    return this.transporte;
  }

  String getImagen() {
    return this.imagen;
  }

  int getDificultad() {
    return this.dificultad;
  }

  List<Localizacion> getListaLocalizaciones() {
    return this.listaLocalizaciones;
  }

  //SETTERS

  set idR(String id) {
    this.id = id;
    notifyListeners();
  }

  void setNombre(String nombre) {
    this.nombre = nombre;
    notifyListeners();
  }

  void setCiudad(String ciudad) {
    this.ciudad = ciudad;
    notifyListeners();
  }

  void setTamatica(String tematica) {
    this.tematica = tematica;
    notifyListeners();
  }

  void setDuracion(double duracion) {
    this.duracion = duracion;
    notifyListeners();
  }

  void setDescripcion(String descripcion) {
    this.descripcion = descripcion;
    notifyListeners();
  }

  void setTransporte(String transporte) {
    this.transporte = transporte;
    notifyListeners();
  }

  void setImagen(String imagen) {
    this.imagen = imagen;
    notifyListeners();
  }

  void setDificultad(int dificultad) {
    this.dificultad = dificultad;
    notifyListeners();
  }

  void setListaLocalizaciones(List localizaciones) {
    this.listaLocalizaciones = localizaciones;
    notifyListeners();
  }
}
