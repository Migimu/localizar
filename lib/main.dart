import 'package:flutter/material.dart';

import 'package:geo_explorer/map.dart';
import 'package:geo_explorer/chat.dart';
import 'package:geolocator/geolocator.dart';
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
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
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
  var _currentLocation;
  @override
  void initState() {
    super.initState();
    _getLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: <Widget>[
        Container(
          color: Colors.deepPurple,
        ),
        map(
          posicion: _currentLocation,
        ),
        Chat(),
      ],
    );
  }

  Future<Position> _getCurrentLocation() async {
    return Future(() {
      return Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    });
  }

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
      _currentLocation = _getCurrentLocation();
    }
  }
}
