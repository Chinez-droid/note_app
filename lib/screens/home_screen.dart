import 'package:flutter/material.dart';
import 'package:note_app/data/database_helper.dart';
import 'package:note_app/models/note.dart' as model;
import 'package:note_app/screens/input_screen.dart';
import 'package:note_app/widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late DatabaseHelper _databaseHelper;
  List<model.Note> _notes = [];
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    _refreshNotes();
  }

  Future<void> _initializeDatabase() async {
    _databaseHelper = DatabaseHelper.instance;
  }

  Future<void> _refreshNotes() async {
    final notes = await _databaseHelper.readAllNotes();
    setState(() {
      _notes = notes.map((note) => model.Note.fromJson(note.toJson())).toList();
    });
  }

  void _addNote(String title, String content) async {
    final note = model.Note(
      title: title,
      content: content,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _databaseHelper.createNote(note);
    _refreshNotes();
  }

  void _editNote(int id, String newTitle, String newContent) async {
    final note = await _databaseHelper.readNote(id);
    final updatedNote = model.Note.fromJson(note.toJson())
        .copy(title: newTitle, content: newContent);
    await _databaseHelper.updateNote(updatedNote);
    _refreshNotes();
  }

  void _deleteNote(int index, model.Note note) async {
    await _databaseHelper.deleteNote(note.id!);
    setState(() {
      _notes.removeAt(index);
    });
  }

  void _toggleThemeMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? _darkTheme : _lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Chinez Note'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => InputScreen(
                      addNote: _addNote,
                      isDarkMode: _isDarkMode,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _notes.length,
          itemBuilder: (context, index) {
            final note = _notes[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Dismissible(
                key: UniqueKey(),
                background: Container(
                  color: Colors.red,
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                ),
                onDismissed: (direction) {
                  _deleteNote(index, note);
                },
                child: NoteCard(
                  note: note,
                  index: note.id!,
                  editNote: _editNote,
                  isDarkMode: _isDarkMode,
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _toggleThemeMode,
          child: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
        ),
      ),
    );
  }
}

// Light theme colors
var _lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(13, 91, 13, 159),
  ),
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: Colors.purple.shade200,
    foregroundColor: Colors.white,
  ),
);

// Dark theme colors
var _darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(),
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: Colors.blueGrey.shade900,
    foregroundColor: Colors.white,
  ),
);
