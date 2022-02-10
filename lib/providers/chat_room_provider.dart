import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ws_chat/config.dart';
import 'package:flutter_ws_chat/controller/web_socket_controller.dart';

class ChatRoom with ChangeNotifier{
  List<Room> rooms = [];
  List<User> people = [];
  List<Group> groups = [];

  int get count => rooms.length;

  Room getRoom(int pos) => rooms[pos];

  void newMessage(MessageData data){
    if(data.receiver == SocketController.username){
      AudioCache().play(assetMsgReceived);
    }else{
      AudioCache().play(assetMsgSent);
    }
    var roomPosition = findRoom(rooms, data);
    var message = Message(type: data.type,room: data.room, message: data.message,receiver: User(userId: data.receiver,username: data.receiver), sender: User(username: data.sender,userId: data.sender), time: data.time);
    if(roomPosition != null){
      // Room already exits
      rooms[roomPosition].messages!.add(message);
      notifyListeners();
      return;
    }else{
      // Create new room
      Room room = createRoom(data);
      room.participants = addParticipant(room.participants!,data.sender);
      room.messages!.add(message);
      rooms.add(room);
      notifyListeners();
    }
  }

  int createNewRoom(Room room){
    rooms.add(room);
    return rooms.length-1;
  }

  int findPersonalRoom(User user){
    for(int i = 0 ; i < rooms.length ; i++){
      if(rooms[i].type == "personal" && user.userId == rooms[i].id){
        return i;
      }
    }
    return -1;
  }
  int findGroupRoom(Group group){
    for(int i = 0 ; i < rooms.length ; i++){
      if(rooms[i].type != "personal" && group.id == rooms[i].id){
        return i;
      }
    }
    return -1;
  }

  void welcome(WelcomeData welcome){
    people.addAll(welcome.users);
    groups.addAll(welcome.groups);
    notifyListeners();
  }

  void clearAll(){
    rooms.clear();
    notifyListeners();
  }

}

int? findRoom(List<Room> rooms,MessageData data){
  for (int i = 0 ; i < rooms.length ; i++) {
    bool personal = rooms[i].type == "personal";
    if(!personal){
      if(data.room == rooms[i].id){
        return i;
      }
    }else{
      if(data.receiver == rooms[i].id || data.sender == rooms[i].id){
        return i;
      }
    }

  }
  return null;
}

Room createRoom(MessageData data){
  var room = Room(id: data.room!, name: data.room!, type: data.type, messages: [], participants: []);
  if(data.room!.contains("group/")){
    room.type = "group";
    room.name = data.room!.split("group/")[1];
    room.id = data.room!;
  }else{
    room.type = "personal";
    room.name = data.sender!;
    room.id = data.sender!;
  }
  return room;
}

List<User> addParticipant(List<User> participants,String? user){
  for(int i = 0 ; i < participants.length; i ++){
    if(participants[i].username == user){
      return participants;
    }
  }
  participants.add(User(userId: user,username: user));
  return participants;
}

class Room{
  String? id;
  String? name;
  String? type;
  List<User>? participants;
  List<Message>? messages;
  Room({required this.id,required this.name,required this.type,required this.messages,required this.participants});
}

class Message{
  String? type;
  User? sender;
  User? receiver;
  String? message;
  String? time;
  String? room;
  Message({required this.type,required this.message,required this.sender,required this.time,required this.receiver,required this.room});
}

class User{
  String? username;
  String? userId;
  User({this.username, this.userId});
  User.fromJSON(Map<String, dynamic> json){
    username = json['username'];
    userId = json['id'];
  }
}

class MessageData{
  String? type;
  String? room;
  String? sender;
  String? message;
  String? time;
  String? receiver;
  MessageData({this.type,this.message,this.room,this.sender,this.time,this.receiver});
  MessageData.fromJson(Map<String, dynamic> json){
    message = json['message'];
    time = json['time'];
    type = json['type'];
    sender = json['from'].toString().split("user/")[1];
    room = json['to'];
    receiver = SocketController.username;
  }
}
class MessageParser{
  String? event;
  Map<String, dynamic>? payload;

}

String getEventType(Map<String, dynamic> json){
  return json['event'];
}

class Group{
  String? id;
  String? name;
  String? logo;
  Group({this.id,this.name,this.logo});
  Group.fromJSON(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    logo = "";
  }
}

class WelcomeData{
  List<User> users = [];
  List<Group> groups = [];
  WelcomeData.fromJSON(Map<String, dynamic> json){
    if (json['groups'] != null) {
      json['groups'].forEach((v) {
        groups.add(Group.fromJSON(v));
      });
    }
    if (json['people'] != null) {
      json['people'].forEach((v) {
        users.add(User.fromJSON(v));
      });
    }
  }
}