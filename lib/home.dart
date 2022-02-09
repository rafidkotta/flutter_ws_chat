import 'package:flutter/material.dart';
import 'package:flutter_ws_chat/controller/web_socket_controller.dart';
import 'package:flutter_ws_chat/pages/welcome.dart';

import 'chat_rooms.dart';
import 'pages/community.dart';
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
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Community()));
        },
        child: const Icon(Icons.chat),
        backgroundColor: Colors.green,
      ),
      body: const ChatRoomsView(),
    );
  }

  initWebSocket(){
    SocketController.init(usernameVal: widget.username, contextVal: context);
  }

}