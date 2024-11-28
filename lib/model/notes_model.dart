class Note {
  // Unique identifier for the note
  final int? id;

  // Note details
  final String title;
  final String content;
  final String color;
  final String dateTime;

  // Constructor
  Note({
    this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.dateTime,
  });

  // Convert Note to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'dateTime': dateTime,
    };
  }

  // Create Note from database Map
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      color: map['color'],
      dateTime: map['dateTime'],
    );
  }
}
