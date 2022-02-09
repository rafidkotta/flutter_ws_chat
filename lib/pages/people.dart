import 'package:flutter/material.dart';
import 'package:flutter_ws_chat/providers/chat_room_provider.dart';
import 'package:provider/provider.dart';

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
              ) ;
            }),
          );
        }
    );
  }
}