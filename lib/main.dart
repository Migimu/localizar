import 'package:flutter/material.dart';
import 'package:geo_explorer/models/localizacion.dart';
import 'package:geo_explorer/models/pregunta.dart';
import 'package:geo_explorer/models/ruta.dart';
import 'package:geo_explorer/widget/loginScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Pregunta(),
        ),
        ChangeNotifierProvider(
          create: (context) => Ruta(),
        ),
        ChangeNotifierProvider(
          create: (context) => Localizacion(),
        ),
        ChangeNotifierProvider(
          create: (context) => Localizaciones(),
        ),
        ChangeNotifierProvider(
          create: (context) => Rutas(),
        )
      ],
      child: MaterialApp(
        title: 'Geo explorer',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
