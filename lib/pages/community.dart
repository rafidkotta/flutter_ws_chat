import 'package:flutter/material.dart';
import 'package:flutter_ws_chat/pages/groups.dart';
import 'package:flutter_ws_chat/pages/people.dart';

class Community extends StatelessWidget{
  const Community({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Community'),
          centerTitle: true,
          bottom: const TabBar(tabs:[Tab(text: "People",icon: Icon(Icons.person),),Tab(text: "Groups",icon: Icon(Icons.people))]),
        ),
        body: const TabBarView(children: [
          PeopleView(),
          GroupsView()
        ]),
      ),
    );
  }

}