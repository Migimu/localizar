import 'dart:async';
import 'package:geo_explorer/global/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const baseUrl =
    "http://10.0.2.2:8080"; //10.0.2.2 porque estas en un emulador de android

class API {
  static Future getRutas() async {
    var url = baseUrl + "/rutas/leer";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return responseJson;
    } else {
      return null;
    }
  }

  static Future getLocalizacion(var id) async {
    var url = baseUrl + "/localizaciones/porId/$id";

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return responseJson;
    } else {
      return null;
    }
  }

  static Future getUsers() async {
    var url = baseUrl + "/usuarios/all";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return responseJson;
    } else {
      return null;
    }
  }

  static Future createUser(var data) async {
    var url = baseUrl + "/usuarios/new";

    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    print("${response.statusCode}");
    print("${response.body}");

    print("Funcion de crear usuario");
  }

  static Future getUser(var user) async {
    var url = baseUrl + "/usuarios/getByUsuario/$user";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return responseJson;
    } else {
      return null;
    }
  }

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

  static Future createRutaUsuario(var data) async {
    var url = baseUrl + "/rutaUsuario/new";
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    rutaUsuario = jsonDecode(response.body);
  }

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

  /*static Future updateRutaUsuario(var id) async {
    var url = baseUrl + "/rutaUsuario/rutaUsuarioActivar/$id";

    await http.put(url);
  }*/

  static Future updateRutaUsuarioDes(var id) async {
    var url = baseUrl + "/rutaUsuario/rutaUsuarioDesactivar/$id";

    await http.put(url);
  }
}
