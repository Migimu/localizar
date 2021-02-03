import 'dart:async';
import 'package:geo_explorer/global/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//LOCAL IP CLASE
//String localIP = "10.10.12.183";
//AZURE IP
const String localIP = "13.95.106.247";
//LOCAL IP CASA
//String localCasaIP = "192.168.56.1";

const baseUrl =
    "http://13.95.106.247:8080/apiMongo"; //10.0.2.2 porque estas en un emulador de android

//LLAMDA A API PARA CONSEGUIR LAS RUTAS

class API {
  static Future getRutas() async {
    var url = baseUrl + "/rutas/getAll";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);

      return responseJson;
    } else {
      return null;
    }
  }

//LLAMDA A API PARA CONSEGUIR LAS LOCALIZACIONES
  static Future getLocalizacion(var id) async {
    var url = baseUrl + "/localizaciones/getId/$id";

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return responseJson;
    } else {
      return null;
    }
  }

//LLAMDA A API PARA CONSEGUIR LOS USUARIOS
  static Future getUsers() async {
    var url = baseUrl + "/usuarios/getAll";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return responseJson;
    } else {
      return null;
    }
  }

//LLAMDA A API PARA CREAR USUARIO
  static Future createUser(var data) async {
    var url = baseUrl + "/usuarios/add";

    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    print("${response.statusCode}");
    print("${response.body}");

    print("Funcion de crear usuario");
  }

//LLAMDA A API PARA CONSEGUIR USUARIO POR NOMBRE DE USUARIO
  static Future getUser(var user) async {
    var url = baseUrl + "/usuarios/getUsuario/$user";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return responseJson;
    } else {
      return null;
    }
  }

//LLAMDA A API PARA CONSEGUIR LA PUNTUACION DE UNA RUTA
  static Future getPuntuacion(var id) async {
    var url = baseUrl + "/rutaUsuario/getAllByRutaId/$id";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return responseJson;
    } else {
      return null;
    }
  }

//LLAMDA A API PARA CREAR UNA NUEVA PARTIDA
  static Future createRutaUsuario(var data) async {
    var url = baseUrl + "/rutaUsuario/add";
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    rutaUsuario = jsonDecode(response.body);
  }

//LLAMDA A API PARA CONSEGUIR UNA PARTIDA EN CONCRETO
  static Future getRutaUsuario(var id) async {
    var url = baseUrl + "/rutaUsuario/getAllByUsuarioId/$id";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return responseJson;
    } else {
      return null;
    }
  }

//LLAMDA A API PARA MODIFICAR EL ESTADO DE LA PARTIDA
  static Future updateRutaUsuarioDes(var id) async {
    var url = baseUrl + "/rutaUsuario/editRutaUsuarioDesactivar/$id";

    await http.put(url);
  }

//LLAMDA A API PARA MODIFICAR LA PUNTUACION DE LA PARTIDA
  static Future updatePuntuacion(var id, var puntuacion) async {
    var url = baseUrl + "/rutaUsuario/editPuntuacion/$id/$puntuacion";

    await http.put(url);
  }

  //LLAMDA A API PARA MODIFICAR LA POSICION DEL USUARIO
  static Future updatePosicion(var id, var lat, var lng) async {
    var url = baseUrl + "/rutaUsuario/editRutaPosicion/$id/$lat/$lng";

    await http.put(url);
  }

  static Future getRutasUsuarios() async {
    var url = baseUrl + "/rutaUsuario/getAll";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return responseJson;
    } else {
      return null;
    }
  }
}
