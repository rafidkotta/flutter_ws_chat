import 'package:flutter/material.dart';
import 'package:flutter_ws_chat/providers/chat_room_provider.dart';
import 'package:provider/provider.dart';

import 'chat_room.dart';

class GroupsView extends StatelessWidget{
  const GroupsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Consumer<ChatRoom>(
       builder: (context,chat,child){
          var groups = chat.groups;
          return ListView(
            children: List.generate(groups.length, (index){
              return Card(
                child: InkWell(
                  onTap: (){
                    int pos = chat.findGroupRoom(groups[index]);
                    if(pos != -1){
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatRoomViewAll(position: pos,name: chat.rooms[pos].name!,)));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          child: Text(groups[index].name!.split("")[0].toUpperCase(),style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(groups[index].name!)
                      ],
                    ),
                  ),
                ),
              ) ;
            }),
          );
       }
   );
  }
}