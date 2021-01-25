import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  Chat({Key key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<ChatMessage> mensajes = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Chat"),
        ),
        body: DashChat(
          user: ChatUser(
            name: "Jhon Doe",
            uid: "xxxxxxxxx",
            avatar:
                "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
          ),
          messages: mensajes,
          onSend: (ChatMessage) {
            mensajes.add(ChatMessage);
          },
        ));
  }
}
