import 'package:flutter/material.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/screens/edit_screen.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final int index;
  final Function(int, String, String) editNote;
  final bool isDarkMode;

  const NoteCard({
    super.key,
    required this.note,
    required this.index,
    required this.editNote,
    required this.isDarkMode,
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
              isDarkMode: isDarkMode,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.blueGrey.shade800 : Colors.purple.shade100,
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note.content,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: isDarkMode
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
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
