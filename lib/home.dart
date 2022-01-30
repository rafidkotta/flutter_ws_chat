import 'dart:convert';

import 'package:flutter/material.dart';
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
  WebSocketChannel? _channel;

  @override
  void initState() {
    connect();
    super.initState();
  }

  @override
  void dispose() {
    _channel!.sink.close();
    // TODO: implement dispose
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
          _channel!.sink.add(json.encode({
            "event":"join_group",
            "payload":{
              "name":"India"
            }
          }));
          // Provider.of<ChatRoom>(context,listen: false).newMessage(MessageData(message: "Hello",room: "user/UAE",sender: "test",time: DateTime.now().toString(),type: "text"));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      body: const ChatRoomsView(),
    );
  }

  connect(){
    try{
      _channel = WebSocketChannel.connect(Uri.parse('ws://192.168.0.110:3000/chat/'+widget.username));
      _channel!.stream.listen((event) {
        handleEvents(json.decode(event));
      },
      onError: (error){
        debugPrint(error);
      },
      cancelOnError: false
      );
      _channel!.sink.add(json.encode({
        "event":"join_group",
        "payload":{
          "name":"India"
        }
      }));
      // listen();
      // join();
    }catch(ex){
      debugPrint(ex.toString());
    }
  }

  join(){
    _channel!.sink.add({
      "event":"join_group",
      "payload":{
        "name":"India"
      }
    });
  }

  handleEvents(Map<String,dynamic> event){
    var type = getEventType(event);
    switch (type){
      case "chat" :{
        Provider.of<ChatRoom>(context,listen: false).newMessage(MessageData.fromJson(event['payload']));
      }
      break;
      case "alert":{
        showSnackBar(context: context,color: Colors.amber,message: event['payload']['message']);
      }
      break;
      default :{
        debugPrint(event.toString());
      }
    }
  }

  listen(){
    _channel!.stream.listen((event) {
      print(event);
    });
  }
}