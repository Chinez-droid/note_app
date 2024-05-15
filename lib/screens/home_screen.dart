import 'package:flutter/material.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/screens/input_screen.dart';
import 'package:note_app/widgets/NoteCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  // list for storing the saved notes
  List<Note> _notes = [];

  // method for adding new notes
  void _addNote(String title, String content) {
    setState(() {
      _notes.add(Note(title, content, DateTime.now()));
    });
  }

  // method for editing notes
  void _editNote(int index, String newTitle, String newContent) {
    setState(() {
      _notes[index] = Note(newTitle, newContent, _notes[index].createdAt);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chinez Note',
        ),
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
      body: // home_screen.dart
          ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return NoteCard(
            note: note,
            index: index, // Pass the index
            editNote: _editNote, // Pass the editNote method
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 16),
      ),
    );
  }
}
