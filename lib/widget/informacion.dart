import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_explorer/widget/swiper.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 75, 95, 1),
      body: Stack(children: [
        // Positioned(
        //   top: 5,
        //   left: 5,
        //   child: Container(
        //     child: Ink(
        //       decoration: const ShapeDecoration(
        //         color: Colors.grey,
        //         shape: CircleBorder(),
        //       ),
        //       child: IconButton(
        //         icon: Icon(Icons.arrow_back_ios),
        //         color: Colors.white,
        //         onPressed: () {
        //           Navigator.pop(context);
        //         },
        //       ),
        //     ),
        //   ),
        // ),
        Positioned.fill(
          top: 50,
          child: Align(
            child: SingleChildScrollView(
                child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly, // mainAxisAlignment
                    children: [
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.80, //80% de la pantalla
                    //height: 100,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(243, 233, 210, 1),
                        border: Border.all(
                          color: Color.fromRGBO(224, 214, 191, 1),
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "RUTA AAA",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                              "Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó una galería de textos y los mezcló de tal manera que logró hacer un libro de textos especimen. No sólo sobrevivió 500 años, sino que tambien ingresó como texto de relleno en documentos electrónicos, quedando esencialmente igual al original. Fue popularizado en los 60s con la creación de las hojas , las cuales contenian pasajes de Lorem Ipsum, y más recientemente con software de autoedición, como por ejemplo Aldus PageMaker, el cual incluye versiones de Lorem Ipsum."),
                        ]),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.80, //80% de la pantalla
                    height: 500,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(198, 218, 191, 1),
                        border: Border.all(
                          color: Color.fromRGBO(136, 212, 152, 1),
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "LOCALIZACIONES",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Stepper(steps: [
                            Step(
                                isActive: false,
                                title: Text("Localizacion 1"),
                                content: Icon(Icons.gps_fixed)),
                            Step(
                                isActive: true,
                                title: Text("Localizacion 2"),
                                content: Icon(Icons.gps_fixed)),
                            Step(
                                title: Text("Localizacion 3"),
                                content: Icon(Icons.gps_fixed)),
                            Step(
                                title: Text("Localizacion 4"),
                                content: Icon(Icons.gps_fixed))
                          ])
                        ]),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.80, //80% de la pantalla
                    //height: 100,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(243, 233, 210, 1),
                        border: Border.all(
                          color: Color.fromRGBO(224, 214, 191, 1),
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              decoration: new BoxDecoration(
                                color: Color.fromRGBO(136, 212, 152, 0.51),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              //width: 200,
                              //height: 100,
                              child: Center(
                                child: Text('RANKING',
                                    style: TextStyle(fontFamily: 'Arcade')),
                              )),
                          SizedBox(height: 10),
                          Text('1ST AAAAA 1000',
                              style: TextStyle(fontFamily: 'Arcade')),
                          SizedBox(height: 10),
                          Text('2ST BBBBB 900',
                              style: TextStyle(fontFamily: 'Arcade')),
                          SizedBox(height: 10),
                          Text('3ST CCCC 700',
                              style: TextStyle(fontFamily: 'Arcade')),
                          SizedBox(height: 10),
                          Text('4ST DDD 450',
                              style: TextStyle(fontFamily: 'Arcade')),
                          SizedBox(height: 10),
                          Text('5ST EEE 250',
                              style: TextStyle(fontFamily: 'Arcade')),
                        ]),
                  ),
                  SizedBox(height: 10),
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SwiperRutas()),
                      );
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(26, 147, 111, 1),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Text('FINALIZAR PARTIDA',
                          style: TextStyle(fontFamily: 'Arcade')),
                    ),
                  )
                ])),
          ),
        ),
      ]),
    );
  }
}
