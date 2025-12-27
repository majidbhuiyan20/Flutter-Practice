import 'package:flutter/cupertino.dart';
import 'package:practice/ostad_flutter/ostad_home.dart';

class NotificationNavigator{
  static void handleNotification(String path){
    if(path=='/ostad'){
      Navigator.pushNamed(OstadHome.navigator.currentContext!, '/');

    }
     }
}