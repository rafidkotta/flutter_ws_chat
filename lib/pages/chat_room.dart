import 'package:flutter/material.dart';
import 'package:flutter_ws_chat/controller/web_socket_controller.dart';
import 'package:flutter_ws_chat/providers/chat_room_provider.dart';
import 'package:flutter_ws_chat/widgets/chat_composer.dart';
import 'package:flutter_ws_chat/widgets/conversation.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';

class ChatRoomViewAll extends StatefulWidget {
  const ChatRoomViewAll({Key? key,required this.position,required this.name}) : super(key: key);

  @override
  _ChatRoomViewAllState createState() => _ChatRoomViewAllState();
  final int position;
  final String name;
}

class _ChatRoomViewAllState extends State<ChatRoomViewAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        centerTitle: false,
        leadingWidth: 30,
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: const Icon(Icons.chevron_left,size: 36,)),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              child: Text(widget.name.split("")[0].toUpperCase()),
              // backgroundImage: AssetImage(
              //   widget.user.avatar,
              // ),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: MyTheme.chatSenderName,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.circle,color: Colors.green,size: 12,),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text('online', style: MyTheme.bodyText1.copyWith(fontSize: 14,color: Colors.white),),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Conversation(position: widget.position,),
                ),
              ),
            ),
            buildChatComposer((onMessage){
              if(onMessage != ""){
                SocketController.sendMessage({
                  "event": "message",
                  "payload": {
                    "to":widget.name,
                    "message": onMessage
                  }
                });
                Provider.of<ChatRoom>(context,listen: false).newMessage(MessageData(room: "user/"+widget.name,receiver: widget.name,type:"text",message: onMessage,time: DateTime.now().toString(),sender: SocketController.username));
              }
            })
          ],
        ),
      ),
    );
  }
}