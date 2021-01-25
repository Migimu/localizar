import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geo_explorer/widget/dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:permission_handler/permission_handler.dart';

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
  bool seguir = false;

  _MapaState(List localizaciones) {
    this.localizaciones = localizaciones;
  }

  CameraPosition _initialPosition = CameraPosition(
      target: LatLng(43.3141039075075, -1.883062156365791), zoom: 11);
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = HashSet<Marker>();
  Set<Circle> _circles = HashSet<Circle>();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _setCircles();
    _goToTheUser();
    _distanceFromCircle();
  }

  Future<Position> _getCurrentLocation() async {
    return Future(() {
      return Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    });
  }

  Future<void> _goToTheUser() async {
    print(await _getCurrentLocation());
    _currentPosition = await _getCurrentLocation();
    print(_currentPosition);

    LatLng latLngPosition =
        LatLng(_currentPosition.latitude, _currentPosition.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 14);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

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

  Future<void> _distanceFromCircle() async {
    _currentPosition = await _getCurrentLocation();
    print(_currentPosition);

    var cont = 0;

    for (var circulo in Set.from(_circles)) {
      var distancia = Geolocator.distanceBetween(
          _currentPosition.latitude,
          _currentPosition.longitude,
          circulo.center.latitude,
          circulo.center.longitude);

      pinLocationIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 2.5), 'images/pregunta.png');
      if (distancia < 200) {
        setState(() {
          _isVisible = true;

          _markers.add(Marker(
              markerId: MarkerId("$cont"),
              position: circulo.center,
              consumeTapEvents: false,
              icon: pinLocationIcon,
              onTap: () {
                for (var localizacion in localizaciones) {
                  var json = jsonDecode(localizacion);
                  if (json['latitud'] == circulo.center.latitude &&
                      json['longitud'] == circulo.center.longitude) ;

                  showDialog(
                      child: Dialog(
                        child: Pregunta(
                          pregunta: json['pregunta'],
                        ),
                      ),
                      context: context);
                  break;
                }
              }));
        });
        cont++;
        break;
      } else {
        setState(() {
          _isVisible = false;
        });
      }
    }

    _distanceFromCircle();
  }

  void _changeMapType() {
    setState(() {
      _defaultMapType = _defaultMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _setCircles() {
    var cont = 0;
    print(localizaciones);
    for (var localizacion in localizaciones) {
      var json = jsonDecode(localizacion);
      print(json["latitud"]);
      setState(() {
        _circles.add(Circle(
            circleId: CircleId("$cont"),
            center: LatLng(json["latitud"], json["longitud"]),
            radius: 200,
            visible: true));
      });
      cont++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Icon(
            Icons.perm_identity,
          ),
          SizedBox(
            width: 20,
          )
        ],
        title: Text("NOMBRE DE RUTA"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: GoogleMap(
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: _initialPosition,
              markers: _markers,
              circles: _circles,
              mapToolbarEnabled: false,
              mapType: _defaultMapType,
              myLocationButtonEnabled: false,
            ),
          ),

          /*PODER DESPLAZAR CON DOS DEDOS*/

          //MultiDragGestureRecognizer(debugOwner: null),
          Container(
            margin: EdgeInsets.only(top: 20, right: 10),
            alignment: Alignment.topRight,
            child: Column(children: <Widget>[
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
          Visibility(
              visible: _isVisible,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    child: Center(
                        child: Text(
                      "Lo has logrado!",
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
