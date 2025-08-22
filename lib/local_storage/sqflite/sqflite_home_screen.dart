import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class StudentDatabasePage extends StatefulWidget {
  @override
  _StudentDatabasePageState createState() => _StudentDatabasePageState();
}

class _StudentDatabasePageState extends State<StudentDatabasePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Student> _students = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  // Load students from the database
  void _loadStudents() async {
    List<Student> students = await _dbHelper.getAllStudents();
    setState(() {
      _students = students;
    });
  }

  // Add a new student
  void _showAddStudentDialog(BuildContext context) {
    _nameController.clear();
    _ageController.clear();
    _gradeController.clear();

    showDialog(
      context: context,  // Pass the parent context here
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Student'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an age';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid age';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _gradeController,
                  decoration: InputDecoration(labelText: 'Grade'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a grade';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Student newStudent = Student(
                    name: _nameController.text,
                    age: int.parse(_ageController.text),
                    grade: _gradeController.text,
                  );
                  await _dbHelper.insertStudent(newStudent);
                  _loadStudents(); // Reload the student list after adding
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }


  // Update a student
  void _updateStudent(Student student) async {
    Student updatedStudent = Student(
      id: student.id,
      name: student.name,
      age: student.age + 1,  // Example: increment age by 1
      grade: student.grade,
    );
    await _dbHelper.updateStudent(updatedStudent);
    _loadStudents();  // Reload after updating
  }

  // Delete a student
  void _deleteStudent(int id) async {
    await _dbHelper.deleteStudent(id);
    _loadStudents();  // Reload after deleting
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Database'),
      ),
      body: ListView.builder(
        itemCount: _students.length,
        itemBuilder: (context, index) {
          final student = _students[index];
          return ListTile(
            title: Text(student.name),
            subtitle: Text('Age: ${student.age}, Grade: ${student.grade}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteStudent(student.id!);  // Delete student
              },
            ),
            onTap: () {
              _updateStudent(student);  // Update student on tap
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddStudentDialog(context); // Show dialog to add a new student
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
class Student {
  int? id;
  final String name;
  final int age;
  final String grade;

  Student({
    this.id,
    required this.name,
    required this.age,
    required this.grade,
  });

  // Convert a Student into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'grade': grade,
    };
  }

  // Convert a Map into a Student object.
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      grade: map['grade'],
    );
  }
}



class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  // Open the database
  Future<Database> get database async {
    if (_database != null) return _database!;

    // If the database is not created yet, then create it.
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    return await openDatabase(
      join(path, 'students.db'),
      onCreate: (db, version) async {
        // Create a table for storing student data
        await db.execute(
          '''
          CREATE TABLE students(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            age INTEGER,
            grade TEXT
          )
          ''',
        );
      },
      version: 1,
    );
  }

  // Insert a student into the database
  Future<int> insertStudent(Student student) async {
    final db = await database;
    return await db.insert('students', student.toMap());
  }

  // Get all students from the database
  Future<List<Student>> getAllStudents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('students');

    return List.generate(maps.length, (i) {
      return Student.fromMap(maps[i]);
    });
  }

  // Get a student by id
  Future<Student?> getStudentById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Student.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Update a student's data
  Future<int> updateStudent(Student student) async {
    final db = await database;
    return await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  // Delete a student
  Future<int> deleteStudent(int id) async {
    final db = await database;
    return await db.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

