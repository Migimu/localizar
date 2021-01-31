import 'dart:convert';

import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:geo_explorer/global/globals.dart';

class Chat extends StatefulWidget {
  Chat({Key key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Chat"),
        ),
        //WIDGET CHAT
        body: DashChat(
          //USUARIO DEL CHAT
          user: ChatUser(
            name: usuario[0]["usuario"],
            uid: usuario[0]["usuario"],
          ),
          messages: mensajes,
          onSend: (ChatMessage) {
            //AL ENVIAR MENSAJE SE ENVIA EL MENSAJE A EL CHAT
            mensajes.add(ChatMessage);
            var chatMsg = Map();

            chatMsg["action"] = "msg";
            chatMsg["from"] = ChatMessage.user.name;
            chatMsg["route"] = rutaName;
            chatMsg["value"] = ChatMessage.text;

            socketChat?.write('${jsonEncode(chatMsg)}\n');
          },
        ));
  }
}
