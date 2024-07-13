class Note {
  String id;
  String content;
  DateTime date;
  DateTime lastModified;

  Note({
    required this.id,
    required this.content,
    required this.date,
    required this.lastModified,
  });

  Note.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        content = map['content'],
        date = DateTime.parse(map['date']),
        lastModified = DateTime.parse(map['lastModified']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'date': date.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
    };
  }
}
