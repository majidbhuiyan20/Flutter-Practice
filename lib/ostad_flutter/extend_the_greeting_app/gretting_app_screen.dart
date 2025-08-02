import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GrettingAppScreen extends StatelessWidget {
  const GrettingAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Greeting App"),
        ),
        body: Center(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Hello, World!", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
              SizedBox(height: 20,),
              Text("Welcome To Flutter!"),
              SizedBox(height: 20,),
              Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Google-flutter-logo.svg/2560px-Google-flutter-logo.svg.png',
                width: 200,
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: (){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Button Pressed!",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }, child: Text("Press Me", style: TextStyle(color: Colors.white),)),
            ],
          ),
        ),
      ),
    );
  }
}
