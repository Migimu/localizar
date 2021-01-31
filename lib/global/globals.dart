library geo_explorer.globals;

import 'dart:io';

import 'package:dash_chat/dash_chat.dart';

//LA PUNTUACION DEL JUAGADOR

int puntuacion = 0;

//EL NOMBRE DE USUARIO DEL USUARIO

String usuarioNombre;

//LA PARTIDA ACTUAL

var rutaUsuario;

//EL USUARIO ACTUAL

var usuario;

//EL NOMBRE DE LA RUTA ACTUAL

String rutaName;

//LISTA DE MENSAJES

List<ChatMessage> mensajes = [];

//SOCKET DEL CHAT

Socket socketChat;

//LISTA DE USUARIOS

List listaUsuarios;

//ID DE LA RUTA ACUTAL

var idRuta;

//NUMERO DE LOCALIZACIONES RESPONDIDAS

int contRespondido = 0;

//SI EL JUGADOR SIGUE JUGANDO

bool jugando = true;
