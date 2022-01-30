import 'package:flutter/material.dart';

class ChatRoom with ChangeNotifier{
  List<Room> rooms = [];

  int get count => rooms.length;

  Room getRoom(int pos) => rooms[pos];

  void newMessage(MessageData data){
    var roomPosition = findRoom(rooms, data);
    var message = Message(type: data.type, message: data.message, sender: User(username: data.sender,userId: data.sender), time: data.time);
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

  void clearAll(){
    rooms.clear();
    notifyListeners();
  }

}

int? findRoom(List<Room> rooms,MessageData data){
  for (int i = 0 ; i < rooms.length ; i++) {
      if(data.room == rooms[i].id){
        return i;
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
    room.name = data.room!.split("user/")[1];
    room.id = data.room!;
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
  String? message;
  String? time;
  Message({required this.type,required this.message,required this.sender,required this.time});
}

class User{
  String? username;
  String? userId;
  User({this.username, this.userId});
}

class MessageData{
  String? type;
  String? room;
  String? sender;
  String? message;
  String? time;
  MessageData({this.type,this.message,this.room,this.sender,this.time});
  MessageData.fromJson(Map<String, dynamic> json){
    message = json['message'];
    time = json['time'];
    type = json['type'];
    sender = json['from'];
    room = json['to'];
  }
// {"event":"chat","payload":{"message":"hello all","from":"junu","to":"group/India","type":"text","time":"2022-01-31T00:53:58+04:00"}}
}
class MessageParser{
  String? event;
  Map<String, dynamic>? payload;

}

String getEventType(Map<String, dynamic> json){
  return json['event'];
}