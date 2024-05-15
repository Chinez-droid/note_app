import 'package:flutter/material.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key, required this.addNote});

  // passing a function parameter to receive the addNote callback
  final Function(String, String) addNote;

  @override
  State<StatefulWidget> createState() {
    return _InputScreenState();
  }
}

class _InputScreenState extends State<InputScreen> {
  // storing the user's input (for the title & note)
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // disposing the user's input when it's removed from the user
  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Title',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  controller: _titleController,
                  maxLength: 50,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Note',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  controller: _noteController,
                  maxLines: null, // allow multiline input
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final title = _titleController.text;
                        final content = _noteController.text;
                        if (title.isNotEmpty && content.isNotEmpty) {
                          widget.addNote(title, content);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
