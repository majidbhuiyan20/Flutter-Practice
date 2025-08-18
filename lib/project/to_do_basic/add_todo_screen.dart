import 'package:flutter/material.dart';

class AddTodoScreen extends StatelessWidget {
  const AddTodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: BackButton(color: Colors.white),
        title: const Text('Add Todo', style: TextStyle(color: Colors.white),),
      ),
      body: Center(child: Text("Add To Do Screen")),
    );
  }
}
