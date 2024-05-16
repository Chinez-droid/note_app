import 'package:flutter/material.dart';
import 'package:note_app/data/database_helper.dart';
import 'package:note_app/models/note.dart';
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
  List<Note> _notes = [];
  List<Note> _deletedNotes = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    _refreshNotes(); // Load initial notes
  }

  Future<void> _initializeDatabase() async {
    _databaseHelper = DatabaseHelper.instance;
  }

  Future<void> _refreshNotes() async {
    final notes = await _databaseHelper.readAllNotes();
    setState(() {
      _notes = notes;
    });
  }

  void _addNote(String title, String content) async {
    final note = Note(
        title: title,
        content: content,
        createdAt: DateTime.now().millisecondsSinceEpoch);
    await _databaseHelper.createNote(note);
    _refreshNotes();
  }

  void _editNote(int id, String newTitle, String newContent) async {
    final note = await _databaseHelper.readNote(id);
    final updatedNote = note.copy(title: newTitle, content: newContent);
    await _databaseHelper.updateNote(updatedNote);
    _refreshNotes();
  }

  void _deleteNote(int index, Note note) async {
    await _databaseHelper.deleteNote(note.id!);
    _deletedNotes.add(note);
    setState(() {
      _notes.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_deletedNotes.length} note(s) deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: _undoDeletion,
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _undoDeletion() {
    setState(() {
      _notes.insertAll(0, _deletedNotes.reversed.toList());
      _deletedNotes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chinez Note'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => InputScreen(addNote: _addNote),
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
              key: ValueKey(note.id),
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
              ),
            ),
          );
        },
      ),
    );
  }
}
