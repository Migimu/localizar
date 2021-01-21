import 'package:flutter/material.dart';
import 'package:geo_explorer/widget/swiper.dart';
import 'package:geo_explorer/widget/loginCorrect.dart';
import 'package:geo_explorer/widget/registerScreen.dart';
import 'package:geo_explorer/api/conexionApi.dart';

//TUTORIAL DE YOUTUBE
//https://www.youtube.com/watch?v=6kaEbTfb444&ab_channel=MarcusNg

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var lista;

  @override
  void initState() {
    API.getUsers().then((response) {
      lista = response;
    });
  }

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
  bool recordarme = false;
  bool _obscureText = true;
  Object _iconoContrasena = Icons.visibility;

  bool esVisible = false;

  TextEditingController controllerUsuario = TextEditingController();
  TextEditingController controllerContrasena = TextEditingController();
  TextEditingController controllerErrores =
      TextEditingController(text: "Errores");

  /* FRAGMENTOS DEL CODIGO*/

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
            obscureText: _obscureText,
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
                  icon: Icon(_iconoContrasena, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                      if (_iconoContrasena == Icons.visibility) {
                        _iconoContrasena = Icons.visibility_off;
                      } else {
                        _iconoContrasena = Icons.visibility;
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

  Widget crearLSinContrasena() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
          onPressed: () => print("Se olvido la contraseña"),
          padding: EdgeInsets.only(right: 0.0),
          child: Text(
            "¿Has olvidado la contraseña?",
            style: kLabelStyle,
          )),
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

  Widget crearBLogin() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          if (controllerUsuario.text == "" || controllerContrasena.text == "") {
            controllerErrores.text = "Rellena todos los huecos";
            esVisible = true;
            actualizar();
          } else if (existeUsuario()) {
            esVisible = false;
            Navigator.of(context).push(_goLogueado());
          } else {
            esVisible = true;
            controllerErrores.text = "Usuario y contraseña no coinciden";
            actualizar();
          }
        },
        padding: EdgeInsets.all(15.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.white,
        child: Text('LOGIN',
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

  Widget crearLRegistro() {
    return GestureDetector(
      onTap: () => {Navigator.of(context).push(_goRegister())},
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: '¿No tienes cuenta?',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400)),
        TextSpan(
            text: ' Registrate',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold)),
      ])),
    );
  }

  Route _goRegister() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => RegisterScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  Route _goLogueado() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SwiperRutas(),
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
                    'Log In',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "OpenSans",
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  crearTFUsuario(),
                  SizedBox(
                    height: 30.0,
                  ),
                  crearTFContrasena(),
                  crearLSinContrasena(),
                  crearLError(),
                  crearBLogin(),
                  crearLRegistro(),
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
    setState(() {});
  }

  bool existeUsuario() {
    bool existe = false;
    for (var user in lista) {
      if (controllerUsuario.text == user['usuario'] &&
          controllerContrasena.text == user['contrasena']) {
        existe = true;
        break;
      }
    }
    return existe;
  }
}
