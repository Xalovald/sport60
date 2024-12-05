import 'package:flutter_test/flutter_test.dart';
import 'package:sport60/persistance/database_connect.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('DatabaseConnect Tests', () {
    late DatabaseConnect dbConnect;
    late Database db;

    setUp(() async {
      dbConnect = DatabaseConnect();
      db = await dbConnect.database;
      await dbConnect.resetDatabase();
      db = await dbConnect.database;
    });

    tearDown(() async {
      await db.close();
    });

    test('Database initialization', () async {
      expect(db, isNotNull);

      // Check if tables are created
      List<Map<String, dynamic>> tables = await db
          .rawQuery('SELECT name FROM sqlite_master WHERE type="table"');
      List<String> tableNames =
          tables.map((table) => table['name'] as String).toList();
      expect(
          tableNames,
          containsAll([
            'session_type',
            'exercise',
            'session',
            'session_exercise',
            'comment',
            'planning'
          ]));
    });

    test('Default session_type data insertion', () async {
      List<Map<String, dynamic>> sessionTypes = await db.query('session_type');
      expect(sessionTypes.length, 3);
      expect(sessionTypes.any((type) => type['name'] == 'AMRAP'), isTrue);
      expect(sessionTypes.any((type) => type['name'] == 'HIIT'), isTrue);
      expect(sessionTypes.any((type) => type['name'] == 'EMOM'), isTrue);
    });

    test('Reset database', () async {
      await db.insert('exercise',
          {'name': 'Test Exercise', 'description': 'Test Description'});

      List<Map<String, dynamic>> exercises = await db.query('exercise');
      expect(exercises.length, 1);

      await dbConnect.resetDatabase();
      db = await dbConnect.database; // Reopen the database after reset

      exercises = await db.query('exercise');
      expect(exercises.length, 0);
    });
  });
}
