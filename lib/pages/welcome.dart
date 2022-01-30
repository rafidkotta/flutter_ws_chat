import 'package:flutter/material.dart';
import 'package:flutter_ws_chat/home.dart';

typedef Logout = Function();
class Welcome extends StatelessWidget{
  final Logout onLogout;
  const Welcome({Key? key,required this.onLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController(text: "urumi");
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.forum,size: 200,color: Colors.green[600]),
              const Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: Text("Go Websocket Chat",style: TextStyle(fontSize: 24),),
              ),
              TextFormField(
                controller: _searchController,
                validator: (value){
                  if(value!.isEmpty){
                    return 'Enter a valid username';
                  } else {
                    return null;
                  }
                },
                textAlign: TextAlign.center,
                decoration:const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(3.0)
                      )
                  ),
                  hintStyle: TextStyle(fontSize: 14,letterSpacing: 1),
                  labelStyle: TextStyle(fontSize: 12,letterSpacing: 1),
                  contentPadding: EdgeInsets.only(left: 20,top: 8,bottom: 8,right: 8),
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.account_circle),
                  suffixStyle: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.redAccent),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: TextButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home(username: _searchController.text,onLogout: onLogout,)));
                    }
                  },
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColorDark)),
                  child: const Text('Enter',style: TextStyle(color: Colors.white),)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}