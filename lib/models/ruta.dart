import 'package:flutter/material.dart';
import 'package:geo_explorer/models/localizacion.dart';
import 'package:provider/provider.dart';

class Rutas with ChangeNotifier {
  List<Ruta> items = new List();

  Rutas({this.items});
}

class Ruta {
  String id;
  String nombre;
  String ciudad;
  String tematica;
  double duracion;
  String descripcion;
  String transporte;
  String imagen;
  int dificultad;
  List<Localizacion> listaLocalizaciones;

  Ruta.empty();

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

  void setId(String id) {
    this.id = id;
  }

  void setNombre(String nombre) {
    this.nombre = nombre;
  }

  void setCiudad(String ciudad) {
    this.ciudad = ciudad;
  }

  void setTamatica(String tematica) {
    this.tematica = tematica;
  }

  void setDuracion(double duracion) {
    this.duracion = duracion;
  }

  void setDescripcion(String descripcion) {
    this.descripcion = descripcion;
  }

  void setTransporte(String transporte) {
    this.transporte = transporte;
  }

  void setImagen(String imagen) {
    this.imagen = imagen;
  }

  void setDificultad(int dificultad) {
    this.dificultad = dificultad;
  }

  void setListaLocalizaciones(List localizaciones) {
    this.listaLocalizaciones = localizaciones;
  }
}
