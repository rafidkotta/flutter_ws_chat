import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ws_chat/controller/web_socket_controller.dart';
import 'package:flutter_ws_chat/pages/welcome.dart';
import 'package:flutter_ws_chat/providers/chat_room_provider.dart';
import 'package:flutter_ws_chat/utils.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'chat_rooms.dart';
class Home extends StatefulWidget{
  final String username;
  final Logout onLogout;
  const Home({Key? key,required this.username,required this.onLogout}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    initWebSocket();
  }

  @override
  void dispose() {
    SocketController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Go Websocket Chat'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: () {
          widget.onLogout();
          Navigator.of(context).pop();
        }, icon: const RotatedBox(quarterTurns: 2,child: Icon(Icons.logout))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          SocketController.sendMessage({
            "event":"join_group",
            "payload":{
              "name":"India"
            }
          });
          // Provider.of<ChatRoom>(context,listen: false).newMessage(MessageData(message: "Hello",room: "user/UAE",sender: "test",time: DateTime.now().toString(),type: "text"));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      body: const ChatRoomsView(),
    );
  }

  initWebSocket(){
    SocketController.init(usernameVal: widget.username, contextVal: context);
  }

}