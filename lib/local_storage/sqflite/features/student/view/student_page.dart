import 'package:flutter/material.dart';
import '../model/student.dart';
import '../repository/student_repository.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final repo = StudentRepository();

  List<Student> students = [];
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final gradeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    load();
  }

  Future load() async {
    students = await repo.getAll();
    setState(() {});
  }

  void addStudent() async {
    await repo.insert(
      Student(
        name: nameController.text,
        age: int.parse(ageController.text),
        grade: gradeController.text,
      ),
    );
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Students")),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,

            builder: (context) {
              return AlertDialog(
                title: Text("Add Student"),

                content: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    TextField(controller: nameController),
                    TextField(controller: ageController),
                    TextField(controller: gradeController),
                  ],
                ),

                actions: [
                  TextButton(
                    onPressed: () {
                      addStudent();

                      Navigator.pop(context);
                    },

                    child: Text("Save"),
                  ),
                ],
              );
            },
          );
        },

        child: Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: students.length,

        itemBuilder: (context, index) {
          final s = students[index];

          return ListTile(
            title: Text(s.name),

            subtitle: Text("Age ${s.age} | Grade ${s.grade}"),

            trailing: IconButton(
              icon: Icon(Icons.delete),

              onPressed: () async {
                await repo.delete(s.id!);

                load();
              },
            ),
          );
        },
      ),
    );
  }
}
