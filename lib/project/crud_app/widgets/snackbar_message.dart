import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showSnackBarMessage(BuildContext context, String title){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
}