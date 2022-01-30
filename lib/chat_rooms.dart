import 'package:flutter/material.dart';
import 'package:flutter_ws_chat/providers/chat_room_provider.dart';
import 'package:provider/provider.dart';

import 'pages/personal_chat_room.dart';

class ChatRoomsView extends StatelessWidget{
  const ChatRoomsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatRoom>(
        builder: (context,chat,child){
          return ListView(
            children: List.generate(chat.rooms.length, (index) {
              var room = chat.rooms[index];
              return InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => PersonalChatRoom(position: index,)));
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(child: Icon(room.type == "group" ? Icons.group : Icons.person)),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(room.name!,style: const TextStyle(fontSize: 24),),
                                Text(room.messages!.last.message!,style: const TextStyle(fontSize: 14),)
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(room.messages!.last.time!.split(" ")[0],maxLines: 1,overflow: TextOverflow.ellipsis,),
                              CircleAvatar(child: Center(child: Text(room.messages!.length.toString(),style: const TextStyle(fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,)),radius: 12,)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        }
    );
  }
}