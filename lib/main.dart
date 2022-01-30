import 'package:flutter/material.dart';
import 'package:flutter_ws_chat/pages/welcome.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'providers/chat_room_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key _appKey = UniqueKey();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatRoom>(
      key: _appKey,
      create: (context) => ChatRoom(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Go Websocket Chat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Welcome(onLogout: () {
          setState(() {
            _appKey = UniqueKey();
          });
        },),
      ),
    );
  }
}
