import 'package:flutter/material.dart';
import 'package:flutter_ws_chat/providers/chat_room_provider.dart';
import 'package:provider/provider.dart';

import 'chat_room.dart';

class PeopleView extends StatelessWidget{
  const PeopleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatRoom>(
        builder: (context,chat,child){
          var people = chat.people;
          return ListView(
            children: List.generate(people.length, (index){
              return Card(
                child: InkWell(
                  onTap: (){
                    int pos = chat.findPersonalRoom(people[index]);
                    if(pos != -1){
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatRoomViewAll(position: pos,name: chat.rooms[pos].name!,)));
                    }
                    Room newRoom = Room(id: people[index].username, name: people[index].username, type: "personal", messages: [], participants: [people[index]]);
                    pos = chat.createNewRoom(newRoom);
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatRoomViewAll(position: pos,name: chat.rooms[pos].name!,)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          child: Text(people[index].username!.split("")[0].toUpperCase(),style: const TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(people[index].username!)
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