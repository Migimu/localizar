import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class map extends StatefulWidget {
  final LatLng posicion;

  map({Key key, @required this.posicion}) : super(key: key);

  @override
  _mapState createState() => _mapState(posicion);
}

class _mapState extends State<map> {
  var posicion = LatLng(26.8206, 30.8025);
  MapType _defaultMapType = MapType.normal;

  _mapState(LatLng posicion) {
    this.posicion = posicion;
  }

  CameraPosition _initialPosition =
      CameraPosition(target: LatLng(26.8206, 30.8025), zoom: 15);
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = HashSet<Marker>();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _goToTheUser();
  }

  @override
  void main(List<String> args) {}

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

    /*setState(() {
      _markers.clear();
      _markers.add(Marker(markerId: MarkerId("1"), position: latLngPosition));
    });*/

    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 14);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    //_moveMarker();
  }

  Future<void> _moveMarker() async {
    print(await _getCurrentLocation());
    _currentPosition = await _getCurrentLocation();
    print(_currentPosition);

    LatLng latLngPosition =
        LatLng(_currentPosition.latitude, _currentPosition.longitude);

    setState(() {
      _markers.clear();
      _markers.add(Marker(
          markerId: MarkerId("1"),
          position: latLngPosition,
          consumeTapEvents: false));
    });
    _moveMarker();
  }

  void _changeMapType() {
    setState(() {
      _defaultMapType = _defaultMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: GoogleMap(
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: _initialPosition,
              markers: _markers,
              mapToolbarEnabled: false,
              mapType: _defaultMapType,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 80, right: 10),
            alignment: Alignment.topRight,
            child: Column(children: <Widget>[
              FloatingActionButton(
                  child: Icon(Icons.layers),
                  elevation: 5,
                  backgroundColor: Colors.teal[200],
                  onPressed: () {
                    _changeMapType();
                    print('Changing the Map Type');
                  }),
            ]),
          )
        ],
      ),
    );
  }
}
