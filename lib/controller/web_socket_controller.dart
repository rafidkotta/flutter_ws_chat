import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ws_chat/providers/chat_room_provider.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../config.dart';
import '../utils.dart';

class SocketController {
  static WebSocketChannel? _channel;
  static BuildContext? context;
  static String? username;

  static bool init({required String usernameVal,required BuildContext contextVal}){
    username = usernameVal;
    context = contextVal;
    return _connect();
  }
  static dispose(){
    _channel!.sink.close();
  }

  static handleEvents(Map<String,dynamic> event){
    var type = _getEventType(event);
    switch (type){
      case "chat":{
        Provider.of<ChatRoom>(context!,listen: false).newMessage(MessageData.fromJson(event['payload']));
      }
      break;
      case "alert":{
        showSnackBar(context: context!,color: Colors.amber,message: event['payload']['message']);
      }
      break;
      case "welcome":{
        Provider.of<ChatRoom>(context!,listen: false).welcome(WelcomeData.fromJSON(event['payload']));
      }
      break;
      default :{
        debugPrint(event.toString());
      }
    }
  }

  static sendMessage(Map<String,dynamic> data){
    _channel!.sink.add(json.encode(data));
  }

  static bool _connect(){
    try{
      _channel = WebSocketChannel.connect(Uri.parse(urlWebSocket+'/chat/'+username!));
      _channel!.stream.listen((event) {
        handleEvents(json.decode(event));
      },
      onError: (error){
        debugPrint(error);
      },
      cancelOnError: false
      );
      return true;
    }catch(ex){
      showSnackBar(context: context!, message: ex.toString(), color: Colors.red);
      return false;
    }
  }
  static String _getEventType(Map<String, dynamic> json){
    return json['event'];
  }
}