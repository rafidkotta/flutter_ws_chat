import 'package:flutter/material.dart';
import 'package:flutter_ws_chat/providers/chat_room_provider.dart';
import 'package:provider/provider.dart';

class PersonalChatRoom extends StatelessWidget{
  final int position;
  const PersonalChatRoom({Key? key,required this.position}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   var room = context.watch<ChatRoom>().rooms[position];
   return Scaffold(
     appBar: AppBar(
       title: Text('${context.watch<ChatRoom>().rooms[position].name} (${context.watch<ChatRoom>().rooms[position].messages!.length})'),
     ),
     floatingActionButton: FloatingActionButton(
       onPressed: (){
         Provider.of<ChatRoom>(context,listen: false).newMessage(MessageData(message: "Hello "+(room.messages!.length+1).toString(),room: "user/UAE",sender: "test",time: DateTime.now().toString(),type: "text"));
       },
       child: const Icon(Icons.add),
       backgroundColor: Colors.green,
     ),
     body: ListView(
       reverse: false,
       children: List.generate(room.messages!.length, (index) {
         return ListTile(
           title: Text(room.messages![index].message!),
         );
       }),
    )
   );
  }

}