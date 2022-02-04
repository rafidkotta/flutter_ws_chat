import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

showSnackBar({required BuildContext context,required String message,required MaterialColor color}){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: color,
  ),);
}

String localTime(String time){
  var date = DateTime.parse(time);
  final format = DateFormat('E, d MMM y HH:mm a');
  return format.format(date.toLocal());
}