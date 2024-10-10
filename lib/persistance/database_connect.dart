import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnect {
  static final DatabaseConnect _instance = DatabaseConnect._internal();
  static Database? _database;

  factory DatabaseConnect() {
    return _instance;
  }

  DatabaseConnect._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'sport60.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE types_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
    ''');
    await db.insert('types_sessions', {'name': 'AMRAP'});
    await db.insert('types_sessions', {'name': 'HIIT'});
    await db.insert('types_sessions', {'name': 'EMOM'});

    await db.execute('''
      CREATE TABLE sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        total_duration INTEGER,
        pause_duration INTEGER,
        type_id INTEGER,
        FOREIGN KEY (type_id) REFERENCES types_sessions(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER,
        name TEXT,
        repetitions INTEGER,
        duration INTEGER,
        FOREIGN KEY (session_id) REFERENCES sessions(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE comments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER,
        exercise_id INTEGER,
        comment TEXT,
        is_global BOOLEAN,
        FOREIGN KEY (session_id) REFERENCES sessions(id),
        FOREIGN KEY (exercise_id) REFERENCES exercises(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE planning (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER,
        date TEXT,
        time TEXT,
        FOREIGN KEY (session_id) REFERENCES sessions(id)
      );
    ''');
  }
}
