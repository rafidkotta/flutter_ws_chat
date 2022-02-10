import 'package:flutter/material.dart';
import 'package:flutter_ws_chat/pages/chat_room.dart';
import 'package:flutter_ws_chat/providers/chat_room_provider.dart';
import 'package:provider/provider.dart';

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
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => PersonalChatRoom(position: index,)));
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatRoomViewAll(position: index,name: room.name!,)));
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
                                room.messages!.isNotEmpty ? Text(room.messages!.last.message!,style: const TextStyle(fontSize: 14),): const Text("")
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              room.messages!.isNotEmpty ? Text(room.messages!.last.time!.split(" ")[0],maxLines: 1,overflow: TextOverflow.ellipsis,): const Text(""),
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