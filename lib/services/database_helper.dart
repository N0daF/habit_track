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
    return await openDatabase(
      path,
      version: 3, // เพิ่มเวอร์ชันเป็น 3 เพื่อให้ onUpgrade ทำงาน
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color INTEGER NOT NULL,
        goal REAL NOT NULL,
        detail TEXT NOT NULL,
        unit TEXT NOT NULL,
        icon TEXT NOT NULL
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

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // การอัปเกรดจากเวอร์ชัน 1 (ลบคอลัมน์ progress)
      await db.execute('''
        CREATE TABLE habits_new (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          color INTEGER NOT NULL,
          goal REAL NOT NULL,
          detail TEXT NOT NULL,
          unit TEXT NOT NULL
        )
      ''');

      await db.execute('''
        INSERT INTO habits_new (id, name, color, goal, detail, unit)
        SELECT id, name, color, goal, detail, unit FROM habits
      ''');

      await db.execute('DROP TABLE habits');
      await db.execute('ALTER TABLE habits_new RENAME TO habits');
    }

    if (oldVersion < 3) {
      // การอัปเกรดจากเวอร์ชัน 2 (เพิ่มคอลัมน์ icon)
      await db.execute('ALTER TABLE habits ADD COLUMN icon TEXT NOT NULL DEFAULT "check_circle"');
    }
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