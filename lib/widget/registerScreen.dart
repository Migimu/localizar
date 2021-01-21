import 'package:flutter/material.dart';
import 'package:geo_explorer/widget/loginScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:geo_explorer/api/conexionApi.dart';

import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  /* CONSTANTES */
  final kHintTextStyle = TextStyle(
    color: Colors.white54,
    fontFamily: 'OpenSans',
  );

  final kLabelStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
  );

  final kBoxDecorationStyle = BoxDecoration(
    color: Colors.black,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  /* VARIABLES */
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  Object _iconoContrasena1 = Icons.visibility;
  Object _iconoContrasena2 = Icons.visibility;

  var imagen = AssetImage('images/usuario.png');
  File imagenCamara;
  var foto64;
  final imagePicker = ImagePicker();

  bool esVisible = false;
  bool usuarioVisible = true;
  bool imagenVisible = false;

  TextEditingController controllerUsuario = TextEditingController();
  TextEditingController controllerNombre = TextEditingController();
  TextEditingController controllerApellidos = TextEditingController();
  TextEditingController controllerContrasena = TextEditingController();
  TextEditingController controllerContrasenaRepetida = TextEditingController();

  TextEditingController controllerErrores =
      TextEditingController(text: "Errores");

  /* FRAGMENTOS DEL CODIGO*/

  Widget crearIUsuario() {
    return Visibility(
        visible: usuarioVisible,
        child: GestureDetector(
            onTap: () {
              return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            GestureDetector(
                              child: Text('Camara'),
                              onTap: _openCamera,
                            ),
                            Padding(
                              padding: EdgeInsets.all(20.0),
                            ),
                            GestureDetector(
                              child: new Text('Galería'),
                              onTap: _openGallery,
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: Image(
              image: imagen,
              width: 80.0,
              height: 80.0,
            )));
  }

  Widget crearIImagen() {
    if (imagenCamara != null) {
      return Visibility(
          visible: imagenVisible,
          child: GestureDetector(
            onTap: () {
              return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            GestureDetector(
                              child: Text('Camara'),
                              onTap: _openCamera,
                            ),
                            Padding(
                              padding: EdgeInsets.all(20.0),
                            ),
                            GestureDetector(
                              child: new Text('Galería'),
                              onTap: _openGallery,
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: InkWell(
              child: Image.file(
                imagenCamara,
                width: 80.0,
                height: 80.0,
              ),
            ),
          ));
    } else {
      return Container();
    }
  }

  void _openCamera() async {
    if (await Permission.camera.status.isUndetermined) {
      Permission.camera.request();
    }
    if (await Permission.camera.status.isPermanentlyDenied) {
      openAppSettings();
    } else {
      PickedFile picture = await imagePicker.getImage(
        source: ImageSource.camera,
      );
      Navigator.pop(context);
      setState(() {
        if (picture != null) {
          imagenCamara = File(picture.path);
          imagenVisible = true;
          usuarioVisible = false;
          base64();
        }
      });
    }
  }

  void _openGallery() async {
    if (await Permission.storage.status.isUndetermined) {
      Permission.storage.request();
    }
    if (await Permission.storage.isPermanentlyDenied) {
      openAppSettings();
    } else {
      PickedFile picture = await imagePicker.getImage(
        source: ImageSource.gallery,
      );
      Navigator.pop(context);
      setState(() {
        if (picture != null) {
          imagenCamara = File(picture.path);
          imagenVisible = true;
          usuarioVisible = false;
          base64();
        }
      });
    }
  }

  Widget crearTFUsuario() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Usuario',
          style: kLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: controllerUsuario,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
              border: InputBorder.none, //quita la barra que aparece al clickar
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.supervised_user_circle,
                color: Colors.white,
              ),
              hintText: 'Inserta tu nombre de usuario',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget crearTFNombre() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Nombre',
          style: kLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: controllerNombre,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
              border: InputBorder.none, //quita la barra que aparece al clickar
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.supervised_user_circle,
                color: Colors.white,
              ),
              hintText: 'Inserta tu nombre',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget crearTFApellidos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Apellidos',
          style: kLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: controllerApellidos,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
              border: InputBorder.none, //quita la barra que aparece al clickar
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.supervised_user_circle,
                color: Colors.white,
              ),
              hintText: 'Inserta tus apellidos',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget crearTFContrasena() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Contraseña',
          style: kLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: controllerContrasena,
            obscureText: _obscureText1,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
              border: InputBorder.none, //quita la barra que aparece al clickar
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              suffixIcon: IconButton(
                  icon: Icon(_iconoContrasena1, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _obscureText1 = !_obscureText1;
                      if (_iconoContrasena1 == Icons.visibility) {
                        _iconoContrasena1 = Icons.visibility_off;
                      } else {
                        _iconoContrasena1 = Icons.visibility;
                      }
                    });
                  }),
              hintText: 'Inserta tu contraseña',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget crearTFRepetirContrasena() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Repetir contraseña',
          style: kLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: controllerContrasenaRepetida,
            obscureText: _obscureText2,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
              border: InputBorder.none, //quita la barra que aparece al clickar
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              suffixIcon: IconButton(
                  icon: Icon(_iconoContrasena2, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _obscureText2 = !_obscureText2;
                      if (_iconoContrasena2 == Icons.visibility) {
                        _iconoContrasena2 = Icons.visibility_off;
                      } else {
                        _iconoContrasena2 = Icons.visibility;
                      }
                    });
                  }),
              hintText: 'Inserta tu contraseña',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget crearBRegistro() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          if (controllerUsuario.text == "" ||
              controllerContrasena.text == "" ||
              controllerContrasenaRepetida.text == "" ||
              controllerNombre.text == "" ||
              controllerApellidos.text == "") {
            controllerErrores.text = "Rellena todos los huecos";
            esVisible = true;
          } else if (controllerContrasena.text !=
              controllerContrasenaRepetida.text) {
            controllerErrores.text = "Las contraseñas no coinciden";
            esVisible = true;
          } else {
            esVisible = false;
            print(
                "Nombre ${controllerUsuario.text}, Contraseña ${controllerContrasena.text}, Contraseña ${controllerContrasenaRepetida.text}");

            print(foto64);
            Map data = {
              "usuario": "${controllerUsuario.text}",
              "contrasena": "${controllerContrasena.text}",
              "nombre": "${controllerNombre.text}",
              "apellidos": "${controllerApellidos.text}",
              "rol": "usuario",
              "avatar": "$foto64",
              "conectado": false
            };

            API.createUser(data);
            Navigator.of(context).push(_goLogin());
          }
          actualizar();
        },
        padding: EdgeInsets.all(15.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.white,
        child: Text('REGISTRAR',
            style: TextStyle(
              color: Colors.black,
              letterSpacing: 1.5,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            )),
      ),
    );
  }

  Widget crearLError() {
    return Visibility(
        visible: esVisible,
        child: Container(
          child: Text(
            controllerErrores.text,
            style: TextStyle(color: Colors.red, fontSize: 20.0),
          ),
        ));
  }

  Widget crearLLogin() {
    return GestureDetector(
      onTap: () => {Navigator.of(context).push(_goLogin())},
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: '¿Ya tienes cuenta?',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400)),
        TextSpan(
            text: ' Inicia Sesion',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold)),
      ])),
    );
  }

  Route _goLogin() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                //OBVIAMENTE HABLAR DE LOS COLORES, EL ARCOIRIS ES HORRIBLE
                //MINIMO TIENE QUE HABER 2 COLORES
                //Colors.red,
                //Colors.pink,
                Colors.purple,
                //Colors.deepPurple,
                //Colors.deepPurple,
                Colors.indigo,
                //Colors.blue,
                //Colors.lightBlue,
                //Colors.cyan,
                //Colors.teal,
                //Colors.green,
                //Colors.lightGreen,
                //Colors.lime,
                //Colors.yellow,
                //Colors.amber,
                //Colors.orange,
                //Colors.deepOrange,
              ],
              //stops: [0.1, 0.4, 0.7, 0.9]
            )),
          ),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 60.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image(
                      image: AssetImage('images/explorer.png'),
                      width: 100.0,
                      height: 100.0,
                    ),
                  ),
                  Text(
                    'Register',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "OpenSans",
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  crearIUsuario(),
                  crearIImagen(),
                  SizedBox(
                    height: 5.0,
                  ),
                  crearTFUsuario(),
                  SizedBox(
                    height: 10.0,
                  ),
                  crearTFContrasena(),
                  SizedBox(
                    height: 10.0,
                  ),
                  crearTFRepetirContrasena(),
                  SizedBox(
                    height: 10.0,
                  ),
                  crearTFNombre(),
                  SizedBox(
                    height: 10.0,
                  ),
                  crearTFApellidos(),
                  SizedBox(
                    height: 20.0,
                  ),
                  crearLError(),
                  crearBRegistro(),
                  crearLLogin(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  actualizar() {
    controllerContrasena.text = "";
    controllerContrasenaRepetida.text = "";
    setState(() {});
  }

  Future base64() async {
    final bytes = await imagenCamara.readAsBytes();
    var imagen = base64Encode(bytes);
    foto64 = imagen;
  }
}
