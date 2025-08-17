import 'package:flutter/material.dart';

class BasicTodoApp extends StatefulWidget {
  const BasicTodoApp({super.key});

  @override
  State<BasicTodoApp> createState() => _BasicTodoAppState();
}

class _BasicTodoAppState extends State<BasicTodoApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Todo App",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}