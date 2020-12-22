import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CameraPosition _initialPosition =
      CameraPosition(target: LatLng(26.8206, 30.8025), zoom: 6);
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = HashSet<Marker>();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _getLocationPermission();
  }

  @override
  void main(List<String> args) {}

  _getLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isUndetermined) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
      ].request();
      print(statuses[Permission.location]);
    }
    // You can can also directly ask the permission about its status.
    if (await Permission.location.isRestricted) {
      //_getLocationPermission();
      // The OS restricts access, for example because of parental controls.
    }
    if (await Permission.location.request().isGranted) {
      print("@@@@@@@@@@@@@@@@@@@object################");

      _goToTheUser();
    }

    // You can request multiple permissions at once.
  }

  Future<Position> _getCurrentLocation() async {
    return Future.delayed(Duration(seconds: 3), () {
      return Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    });
  }

  Future<void> _goToTheUser() async {
    print(await _getCurrentLocation());
    _currentPosition = await _getCurrentLocation();
    print(_currentPosition);

    LatLng latLngPosition =
        LatLng(_currentPosition.latitude, _currentPosition.longitude);

    setState(() {
      _markers.clear();
      _markers.add(Marker(markerId: MarkerId("1"), position: latLngPosition));
    });

    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 14);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: _initialPosition,
            markers: _markers,
          ),
        ],
      ),
    );
  }
}
