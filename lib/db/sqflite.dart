import "package:sqflite/sqflite.dart";
import 'package:path/path.dart';

class Db {
  static late final Database db;
  static bool initialized = false;

  static Future<void> init() async {
    if (initialized) return;
    db = (await openDB())!;
    initialized = true;
  }

  static Database get() {
    if (!initialized) throw Exception('Database not initialized');
    return db;
  }

  static Future<Database?> openDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'local.db');
    var db = await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
      CREATE TABLE tasks(
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        completed INTEGER,
        date TEXT,
        important INTEGER,
        color INTEGER
      )
      CREATE TABLE notes(
        id TEXT PRIMARY KEY,
        content TEXT,
        date TEXT,
        lastModified TEXT
      )
    ''');
    });
    return db;
  }

  static Future<void> insertTask(Map<String, dynamic> task) async {
    if (!initialized) await init();
    await db.insert('tasks', task);
  }

  static Future<void> updateTask(Map<String, dynamic> task) async {
    if (!initialized) await init();
    await db.update('tasks', task, where: 'id = ?', whereArgs: [task['id']]);
  }

  static Future<void> deleteTask(String taskId) async {
    if (!initialized) await init();
    await db.delete('tasks', where: 'id = ?', whereArgs: [taskId]);
  }

  static Future<void> insertNote(Map<String, dynamic> note) async {
    if (!initialized) await init();
    await db.insert('notes', note);
  }

  static Future<void> updateNote(Map<String, dynamic> note) async {
    if (!initialized) await init();
    await db.update('notes', note, where: 'id = ?', whereArgs: [note['id']]);
  }

  static Future<void> deleteNote(String noteId) async {
    if (!initialized) await init();
    await db.delete('notes', where: 'id = ?', whereArgs: [noteId]);
  }

  static Future<List<Map<String, dynamic>>> getTasks() async {
    if (!initialized) await init();
    return await db.query('tasks');
  }

  static Future<List<Map<String, dynamic>>> getNotes() async {
    if (!initialized) await init();
    return await db.query('notes');
  }
}
