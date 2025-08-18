import 'package:flutter/material.dart';
import 'add_todo_screen.dart';

class BasicTodoApp extends StatefulWidget {
  const BasicTodoApp({super.key});

  @override
  State<BasicTodoApp> createState() => _BasicTodoAppState();
}

class _BasicTodoAppState extends State<BasicTodoApp> {

  List<ToDo> todoList = [];
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
      body: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (context, index){
          return ListTile(
            title: Text(todoList[index].title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(todoList[index].description),
                Text("Created Date: ${todoList[index].createdDate}"),
              ],
            ),
            trailing: Text(todoList[index].status),
          );
      }),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return AddTodoScreen();
                }));
          },
      backgroundColor: Colors.blue,
      child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}

class ToDo {
  final String title;
  final String description;
  final DateTime createdDate;
  final String status;

  ToDo({required this.title, required this.description, required this.createdDate, required this.status});


}

