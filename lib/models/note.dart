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

class Note {
  final int? id;
  final String title;
  final String content;
  final int createdAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Note copy({
    int? id,
    String? title,
    String? content,
    int? createdAt,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
      );

  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,
        title: json[NoteFields.title] as String,
        content: json[NoteFields.content] as String,
        createdAt: json[NoteFields.createdAt] as int,
      );

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.content: content,
        NoteFields.createdAt: createdAt,
      };
}
