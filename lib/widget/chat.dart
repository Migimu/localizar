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
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var imagen64 = base64.decode(usuario[0]["avatar"]);

    var avatar = Image.memory(
      imagen64,
      width: 100.0,
      height: 200.0,
    );
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Chat"),
        ),
        body: DashChat(
          user: ChatUser(
            name: usuario[0]["usuario"],
            uid: usuario[0]["usuario"],
          ),
          messages: mensajes,
          onSend: (ChatMessage) {
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
