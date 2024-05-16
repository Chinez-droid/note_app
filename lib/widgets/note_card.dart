import 'package:flutter/material.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/screens/edit_screen.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final int index;
  final Function(int, String, String) editNote;

  const NoteCard({
    super.key,
    required this.note,
    required this.index,
    required this.editNote,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('M/d/yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(note.createdAt));

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => EditScreen(
              note: note,
              index: index,
              editNote: editNote,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.purple.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(note.content),
                  const SizedBox(height: 8),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
