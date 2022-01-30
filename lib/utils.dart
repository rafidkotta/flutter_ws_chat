import 'package:flutter/material.dart';

showSnackBar({required BuildContext context,required String message,required MaterialColor color}){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: color,
  ),);
}