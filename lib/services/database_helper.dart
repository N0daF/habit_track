import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/habit.dart';
import '../models/habit_history.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('habits.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        progress REAL NOT NULL,
        color INTEGER NOT NULL,
        goal REAL NOT NULL,
        detail TEXT NOT NULL,
        unit TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE habit_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        habitId INTEGER NOT NULL,
        date TEXT NOT NULL,
        progressAdded REAL NOT NULL,
        FOREIGN KEY (habitId) REFERENCES habits(id)
      )
    ''');
  }

  Future<void> insertHabit(Habit habit) async {
    final db = await database;
    await db.insert('habits', habit.toMap());
  }

  Future<List<Habit>> getHabits() async {
    final db = await database;
    final result = await db.query('habits');
    return result.map((json) => Habit.fromMap(json)).toList();
  }

  Future<void> updateHabit(Habit habit) async {
    final db = await database;
    await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<void> deleteHabit(int id) async {
    final db = await database;
    await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
    await db.delete(
      'habit_history',
      where: 'habitId = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertHabitHistory(HabitHistory history) async {
    final db = await database;
    await db.insert('habit_history', history.toMap());
  }

  Future<List<HabitHistory>> getHabitHistory(int habitId) async {
    final db = await database;
    final result = await db.query(
      'habit_history',
      where: 'habitId = ?',
      whereArgs: [habitId],
    );
    return result.map((json) => HabitHistory.fromMap(json)).toList();
  }
}