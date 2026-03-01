import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async{

    if(_database != null){

      return _database!;

    }

    _database = await _initDB();

    return _database!;

  }

  Future<Database> _initDB() async{

    final path = join(

      await getDatabasesPath(),

      "students.db",

    );

    return openDatabase(

      path,

      version:1,

      onCreate:_createDB,

    );

  }

  Future<void> _createDB(Database db,int version) async{

    await db.execute('''

    CREATE TABLE students(

      id INTEGER PRIMARY KEY AUTOINCREMENT,

      name TEXT,

      age INTEGER,

      grade TEXT

    )

    ''');

  }

}