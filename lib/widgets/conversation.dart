import 'package:flutter/material.dart';
import 'package:flutter_ws_chat/controller/web_socket_controller.dart';
import 'package:flutter_ws_chat/utils.dart';
import 'package:provider/src/provider.dart';
import '../providers/chat_room_provider.dart';

import '../app_theme.dart';

class Conversation extends StatefulWidget {
  const Conversation({Key? key,required this.position}) : super(key: key);

  final int position;

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var room = context.watch<ChatRoom>().rooms[widget.position];
    _scrollDown();
    return ListView.builder(
        reverse: false,
        controller: _controller,
        itemCount: room.messages!.length,
        itemBuilder: (context, int index) {
          final message = room.messages![index];
          bool isMe = message.sender!.username == SocketController.username;
          Widget _chat = Column(
            children: [
              Row(
                mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!isMe && room.type != "personal")
                    CircleAvatar(
                      radius: 15,
                      child: Text(room.messages![index].sender!.username!.split("")[0].toUpperCase()),
                    ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    decoration: BoxDecoration(
                        color: isMe ? Colors.green[300] : Colors.grey[200],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isMe ? 12 : 0),
                          bottomRight: Radius.circular(isMe ? 0 : 12),
                        )),
                    child: Text(
                      room.messages![index].message!,
                      style: MyTheme.bodyTextMessage.copyWith(
                          color: isMe ? Colors.white : Colors.grey[800]),
                    ),
                  ),

                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    if (!isMe)
                      const SizedBox(
                        width: 40,
                      ),
                    if (isMe) Icon(
                      Icons.done_all,
                      size: 20,
                      color: MyTheme.bodyTextTime.color,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      localTime(message.time!),
                      style: MyTheme.bodyTextTime,
                    )
                  ],
                ),
              )
            ],
          );
          return Container(
            margin: const EdgeInsets.only(top: 10),
            child: _chat,
          );
        });
  }

  void _scrollDown() async {
    await Future.delayed(const Duration(microseconds: 1000));
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.linearToEaseOut,
    );
  }
}