import 'package:geo_explorer/models/localizacion.dart';

class Ruta {
  String _id;
  String _nombre;
  String _ciudad;
  String _tematica;
  double _duracion;
  String _descripcion;
  String _transporte;
  String _imagen;
  int _dificultad;
  List<Localizacion> _listaLocalizaciones;

  Ruta.empty();

  Ruta(
      String id,
      String nombre,
      String ciudad,
      String tematica,
      double duracion,
      String descripcion,
      String transporte,
      String imagen,
      int dificultad,
      List<Localizacion> listaLocalizaciones) {
    this._id = id;
    this._nombre = nombre;
    this._ciudad = ciudad;
    this._tematica = tematica;
    this._duracion = duracion;
    this._descripcion = descripcion;
    this._transporte = transporte;
    this._imagen = imagen;
    this._dificultad = dificultad;
    this._listaLocalizaciones = listaLocalizaciones;
  }

//GETTERS

  String getId() {
    return this._id;
  }

  String getNombre() {
    return this._nombre;
  }

  String getCiudad() {
    return this._ciudad;
  }

  String getTamatica() {
    return this._tematica;
  }

  double getDuracion() {
    return this._duracion;
  }

  String getDescripcion() {
    return this._descripcion;
  }

  String getTransporte() {
    return this._transporte;
  }

  String getImagen() {
    return this._imagen;
  }

  int getDificultad() {
    return this._dificultad;
  }

  List<Localizacion> getListaLocalizaciones() {
    return this._listaLocalizaciones;
  }

  //SETTERS

  void setId(String id) {
    this._id = id;
  }

  void setNombre(String nombre) {
    this._nombre = nombre;
  }

  void setCiudad(String ciudad) {
    this._ciudad = ciudad;
  }

  void setTamatica(String tematica) {
    this._tematica = tematica;
  }

  void setDuracion(double duracion) {
    this._duracion = duracion;
  }

  void setDescripcion(String descripcion) {
    this._descripcion = descripcion;
  }

  void setTransporte(String transporte) {
    this._transporte = transporte;
  }

  void setImagen(String imagen) {
    this._imagen = imagen;
  }

  void setDificultad(int dificultad) {
    this._dificultad = dificultad;
  }

  void setListaLocalizaciones(List localizaciones) {
    this._listaLocalizaciones = localizaciones;
  }
}
