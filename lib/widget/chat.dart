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
        ) /*Column(
        children: [
          Container(
            //height: MediaQuery.of(context).size.height * 0.9,
            //width: MediaQuery.of(context).size.width,
            height: 50,
            width: 50,
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 200,
                child: TextField(),
                decoration: BoxDecoration(border: Border.all()),
              ),
              FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.send),
              )
            ],
          )),
        ],
      ),*/
        );
  }
}
