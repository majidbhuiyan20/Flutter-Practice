import '../../../database/database_helper.dart';
import '../model/student.dart';

class StudentRepository{

  Future insert(Student student) async{

    final db = await DatabaseHelper.instance.database;

    return db.insert(

      "students",

      student.toMap(),

    );

  }

  Future<List<Student>> getAll() async{

    final db = await DatabaseHelper.instance.database;

    final maps = await db.query("students");

    return maps.map((e)=>Student.fromMap(e)).toList();

  }

  Future delete(int id) async{

    final db = await DatabaseHelper.instance.database;

    return db.delete(

      "students",

      where:"id=?",

      whereArgs:[id],

    );

  }

  Future update(Student student) async{

    final db = await DatabaseHelper.instance.database;

    return db.update(

      "students",

      student.toMap(),

      where:"id=?",

      whereArgs:[student.id],

    );

  }

}