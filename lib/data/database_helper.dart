import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:note_app/models/note.dart' as model;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    await db.execute('''
      CREATE TABLE $tableNotes (
        ${NoteFields.id} $idType,
        ${NoteFields.title} $textType,
        ${NoteFields.content} $textType,
        ${NoteFields.createdAt} $intType
      )
    ''');
  }

  Future<model.Note> createNote(model.Note note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<model.Note> readNote(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return model.Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<model.Note>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = '${NoteFields.createdAt} ASC';
    final result = await db.query(tableNotes, orderBy: orderBy);
    return result.map((json) => model.Note.fromJson(json)).toList();
  }

  Future<int> updateNote(model.Note note) async {
    final db = await instance.database;
    return db.update(
      tableNotes,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

const String tableNotes = 'notes';

class NoteFields {
  static final List<String> values = [
    id,
    title,
    content,
    createdAt,
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String content = 'content';
  static const String createdAt = 'createdAt';
}
