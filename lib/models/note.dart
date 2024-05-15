class Note {
  final String title;
  final String content;
  final DateTime? createdAt; // Add the ? to make it nullable

  Note(this.title, this.content, this.createdAt);
}
