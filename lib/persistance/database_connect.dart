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
    // resetDatabase();
    // _database = await _initDatabase();
    // return _database!;
  }

  Future<void> resetDatabase() async {
    String path = join(await getDatabasesPath(), 'sport60.db');
    // Supprimer la base de données existante
    await deleteDatabase(path);
    // Recréer la base de données
    _database = await _initDatabase();
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
      CREATE TABLE session_type (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT
      );
    ''');
    await db.insert('session_type', {'name': 'AMRAP', 'description': 'As Many Rounds As Possible'});
    await db.insert('session_type', {'name': 'HIIT', 'description': 'High-Intensity Interval Training'});
    await db.insert('session_type', {'name': 'EMOM', 'description': 'Every Minute On the Minute'});

    await db.execute('''
      CREATE TABLE exercise (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE session (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        total_duration INTEGER,
        pause_duration INTEGER,
        session_type_id INTEGER NOT NULL,
        FOREIGN KEY (session_type_id) REFERENCES session_type(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE session_exercise (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL,
        exercise_id INTEGER NOT NULL,
        duration INTEGER,
        repetitions INTEGER,
        series INTEGER NOT NULL DEFAULT 1,
        exercise_pause_time INTEGER,
        serie_pause_time INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (session_id) REFERENCES session(id),
        FOREIGN KEY (exercise_id) REFERENCES exercise(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE comment (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER,
        exercise_id INTEGER,
        comment TEXT,
        is_global BOOLEAN,
        FOREIGN KEY (session_id) REFERENCES session(id),
        FOREIGN KEY (exercise_id) REFERENCES exercise(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE planning (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL,
        date TEXT,
        time TEXT,
        date_realized TEXT,
        time_realized TEXT,
        FOREIGN KEY (session_id) REFERENCES session(id)
      );
    ''');
  }
}
