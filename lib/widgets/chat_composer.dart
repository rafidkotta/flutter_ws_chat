import 'package:flutter/material.dart';

typedef OnMessage = Function(String message);
Container buildChatComposer(OnMessage onMessage) {
  TextEditingController editingController = TextEditingController();
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    color: Colors.white,
    height: 80,
    child: Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    onTap: () => onMessage(""),
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type your message ...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                    controller: editingController,
                    onSubmitted: (msg){
                      if(msg!=""){
                        onMessage(msg);
                        editingController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        InkWell(
          onTap: (){
            onMessage(editingController.text);
            editingController.clear();
          },
          child: const CircleAvatar(
            radius: 25,
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        )
      ],
    ),
  );
}