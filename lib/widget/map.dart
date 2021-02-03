import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:geo_explorer/api/conexionApi.dart';
import 'package:geo_explorer/global/globals.dart';
import 'package:geo_explorer/widget/dialog.dart';
import 'package:geo_explorer/widget/ranking.dart';
import 'package:geo_explorer/widget/swiper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapa extends StatefulWidget {
  final List localizaciones;

  Mapa({Key key, @required this.localizaciones}) : super(key: key);

  @override
  _MapaState createState() => _MapaState(localizaciones);
}

class _MapaState extends State<Mapa> {
  var localizaciones = [];
  MapType _defaultMapType = MapType.normal;
  bool _isVisible = false;
  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor pinAnswered;
  bool seguir = false;
  var imagenValida;

  _MapaState(List localizaciones) {
    this.localizaciones = localizaciones;
  }

  CameraPosition _initialPosition = CameraPosition(
      target: LatLng(43.3141039075075, -1.883062156365791), zoom: 11);
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = HashSet<Marker>();
  Set<Circle> _circles = HashSet<Circle>();
  Set<Polyline> _polylines = HashSet<Polyline>();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Position _currentPosition;

  @override
  void initState() {
    super.initState();
    /*_getRutasUsuario();*/
    _setCircles();
    _goToTheUser();
    _distanceFromCircle();
    _updatePosition();
    _updatePositions();
    //AVATAR SI TIENE UNA IMAGEN VALIDA

    if (usuario[0]["avatar"] == "" || usuario[0]["avatar"] == null) {
      imagenValida = Image(
        image: AssetImage("images/explorer.png"),
        width: 100.0,
        height: 200.0,
      );
    } else {
      imagenValida = Image.memory(
        base64.decode(usuario[0]["avatar"]),
        width: 100.0,
        height: 200.0,
      );
    }
  }

  //OBTENER TODAS LA PARTIDAS

  /*Future<List> _getRutasUsuario() async {
    return 
  }*/

  //OBTENER POSICION ACTUAL

  Future<Position> _getCurrentLocation() async {
    return Future(() {
      return Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    });
  }

  //CAMARA VA A EL USUARIO

  Future<void> _goToTheUser() async {
    _currentPosition = await _getCurrentLocation();

    LatLng latLngPosition =
        LatLng(_currentPosition.latitude, _currentPosition.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 14);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  //CAMARA SIGUE A EL USUARIO

  Future<void> _followUser() async {
    while (seguir) {
      _currentPosition = await _getCurrentLocation();
      LatLng latLngPosition =
          LatLng(_currentPosition.latitude, _currentPosition.longitude);

      CameraPosition cameraPosition =
          new CameraPosition(target: latLngPosition, zoom: 16);
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }
  }

//ACTUALIZA LA POSCION DEL USUARIO
  Future<void> _updatePosition() async {
    _currentPosition = await _getCurrentLocation();
    API.updatePosicion(rutaUsuario["id"], _currentPosition.latitude,
        _currentPosition.longitude);
    Future.delayed(Duration(seconds: 10), _updatePosition);
  }

  //ACTUALIZA LAS POSCIONES DE LOS OTROS USUARIOS
  Future<void> _updatePositions() async {
    await API.getRutasUsuarios().then((response) {
      rutasUsuario = response;
    });

    _markers.removeWhere((item) => item.icon == pinLocationIcon);

    rutasUsuario
        .retainWhere((element) => element["rutaId"] == rutaUsuario["rutaId"]);

    rutasUsuario.retainWhere((element) => element["activo"] == true);

    var cont = 0;

    for (var ruta in rutasUsuario) {
      var userAhora = listaUsuarios.firstWhere((element) {
        return ruta["usuarioId"] == element["id"];
      });
      var pinUser;

      if (userAhora["avatar"] == null || userAhora["avatar"] == "") {
        pinUser = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 100),
            'images/usuarioMarker.png');
      } else {
        pinUser = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(
              devicePixelRatio: 100,
            ),
            'images/usuarioMarker.png');
      }

      setState(() {
        _markers.add(Marker(
            markerId: MarkerId("User$cont"),
            position: LatLng(ruta["lat"], ruta["lng"]),
            consumeTapEvents: false,
            zIndex: 0,
            visible: true,
            icon: pinUser));
      });
      cont++;
    }
    if (jugando) {
      Future.delayed(Duration(seconds: 10), _updatePositions);
    }
  }

  //CALCULA LAS DISTANCIAS DESDE LOS PUNTOS MAS CARCANOS

  Future<void> _distanceFromCircle() async {
    _currentPosition = await _getCurrentLocation();

    var cont = 0;

    for (var circulo in Set.from(_circles)) {
      var distancia = Geolocator.distanceBetween(
          _currentPosition.latitude,
          _currentPosition.longitude,
          circulo.center.latitude,
          circulo.center.longitude);

      pinLocationIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 50, size: Size(50, 50)),
          'images/pregunta.png');

      pinAnswered = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 50, size: Size(50, 50)),
          'images/comprobar.png');

      if (distancia < 50) {
        setState(() {
          _isVisible = true;
          //SI ESTA DENTRO DEL CICULO SE MUSTRA EL ICONO

          _markers.add(Marker(
              markerId: MarkerId("Ori$cont"),
              position: circulo.center,
              consumeTapEvents: false,
              icon: pinLocationIcon,
              zIndex: 1,
              onTap: () async {
                for (var localizacion in localizaciones) {
                  if (localizacion['latitud'] == circulo.center.latitude ||
                      localizacion['longitud'] == circulo.center.longitude) {
                    var chatMsg = Map();

                    chatMsg["action"] = "msg";
                    chatMsg["from"] = "server";
                    chatMsg["route"] = rutaName;
                    chatMsg["value"] =
                        "El usuario ${usuario[0]["usuario"]} a encontrado la localizacion:${localizacion['nombre']}";

                    socketChat?.write('${jsonEncode(chatMsg)}\n');

                    // MUESTRA LA PESTAÑA CON LA PREGUNTA
                    var respuesta = await showDialog(
                        barrierColor: Colors.green,
                        barrierDismissible: false,
                        child: Dialog(
                            child: Pregunta(
                          pregunta: localizacion['pregunta'],
                        )),
                        context: context);

                    //AÑADE NUEVO MARKER INDICANDO QUE SE HA RESPONDIDIO A LA RESPUESTA
                    _markers.add(Marker(
                        markerId: MarkerId("Bien$cont"),
                        position: circulo.center,
                        consumeTapEvents: false,
                        icon: pinAnswered,
                        zIndex: 5,
                        onTap: () {}));

                    //BORRA EL PRIMER MARKER
                    _markers.retainWhere((element) =>
                        element.markerId.value.contains("Bien") ||
                        element.markerId.value.contains("User"));
                    if (respuesta) {
                      puntuacion = puntuacion + 10;
                    }
                    //CONTADOR PREGUNTAS RESPONDIDADAS
                    contRespondido++;
                    //SI EL CONTADOR PREGUNTAS RESPONDIDADAS ES IGUAL AL NUMERO DE LOCALIZACIONES EL JUEGO TERMINA
                    if (contRespondido == _circles.length) {
                      //FINALIZAR JUEGO
                      //PESTAÑA FIN DE JUEGO
                      showDialog(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return WillPopScope(
                            onWillPop: () async => false,
                            child: AlertDialog(
                              title: Row(children: [
                                Text('Enhorabuena'),
                                Icon(Icons.celebration)
                              ]),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Has finalizado la ruta'),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('Tu puntuacion ha sido: $puntuacion'),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        'Si quieres ver tu puesto en el raking selecciona el icono de la derecha si no volveras a la pestaña de rutas'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                //BOTON IZQUIERDA
                                TextButton(
                                  child: Icon(Icons.list_alt),
                                  onPressed: () {
                                    //VACIA CHAT
                                    mensajes = [];
                                    //DEJA DE JUGAR
                                    jugando = false;
                                    //ACTUALIZA LA PUTUACION DEL JUGADOR Y MUSTRA EL RANKING
                                    API.updatePuntuacion(
                                        rutaUsuario["id"], puntuacion);
                                    print(idRuta);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Ranking(
                                                id: idRuta,
                                              )),
                                    );
                                  },
                                ),
                                //BOTON DERECHA
                                TextButton(
                                  child: Icon(Icons.clear),
                                  onPressed: () {
                                    //VACIA CHAT
                                    mensajes = [];
                                    //DEJA DE JUGAR
                                    jugando = false;
                                    //ACTUALIZA LA PUTUACION DEL JUGADOR Y MUSTRA LAS RUTAS
                                    API.updatePuntuacion(
                                        rutaUsuario["id"], puntuacion);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SwiperRutas()),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                      print("has terminado");
                    }
                  }
                  cont++;
                }
              }));
        });

        break;
      } else {
        //SI TE ALEJAS DEL CICULO SE OCULTA EL ICONO A NO SER QUE SE HALLA RESPONDIDIO
        setState(() {
          _isVisible = false;
          _markers.retainWhere((element) =>
              element.markerId.value.contains("Bien") ||
              element.markerId.value.contains("User"));
        });
      }
    }
//SI SE DEJA DE JUGAR DEJA DE BUSCAR LA LOCALIZACION MAS CERCANA
    if (jugando) {
      _distanceFromCircle();
    }
  }

//CAMBIA LA APARIENCIA DEL MAPA
  void _changeMapType() {
    setState(() {
      _defaultMapType = _defaultMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  //MUESTRA LOS CICULOS EN EL MAPA Y LAS LINEAS

  void _setCircles() {
    var cont = 0;
    List<LatLng> _puntos = [];
    for (var localizacion in localizaciones) {
      //var json = jsonDecode(localizacion);
      setState(() {
        _circles.add(Circle(
            circleId: CircleId("$cont"),
            center: LatLng(localizacion["latitud"], localizacion["longitud"]),
            radius: 50,
            zIndex: 0,
            visible: false));
        _puntos.add(LatLng(localizacion["latitud"], localizacion["longitud"]));
      });
      cont++;
    }
    setState(() {
      _polylines.add(Polyline(
          polylineId: PolylineId("$cont"),
          points: _puntos,
          width: 7,
          color: Colors.green));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          imagenValida,
          SizedBox(
            width: 20,
          )
        ],
        title: Text(
          rutaName,
          style: TextStyle(fontFamily: 'Arcade'),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            //WIDGET MAPA
            child: GoogleMap(
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: _initialPosition,
              markers: _markers,
              circles: _circles,
              polylines: _polylines,
              mapToolbarEnabled: false,
              mapType: _defaultMapType,
              myLocationButtonEnabled: false,
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 20, right: 10),
            alignment: Alignment.topRight,
            child: Column(children: <Widget>[
              //BOTON CAMBIAR APARIENCIA MAPA
              FloatingActionButton(
                  heroTag: 'map',
                  child: Icon(Icons.layers),
                  elevation: 5,
                  backgroundColor: Colors.teal[200],
                  onPressed: () {
                    _changeMapType();
                  }),
              SizedBox(
                height: 10,
              ),
              //BOTON PARA SEGUIR A EL USUARIO
              FloatingActionButton(
                  heroTag: 'follow',
                  child: Icon(Icons.my_location),
                  elevation: 5,
                  backgroundColor: Colors.teal[200],
                  onPressed: () {
                    if (seguir) {
                      seguir = false;
                    } else {
                      seguir = true;
                      _followUser();
                    }
                  }),
            ]),
          ),
          //TEXTO DE LO HAS ENCONTRADO
          Visibility(
              visible: _isVisible,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    child: Center(
                        child: Text(
                      "Lo has encontrado!",
                      style: TextStyle(fontFamily: 'Arcade'),
                    )),
                    height: 100,
                    width: 200,
                    color: Colors.amber,
                  )
                ]),
                SizedBox(
                  height: 20,
                )
              ]))
        ],
      ),
    );
  }
}
