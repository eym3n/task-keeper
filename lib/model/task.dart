import 'dart:math';

import 'package:flutter/cupertino.dart';

Color generatePastelColor() {
  final random = Random();
  final hue = random.nextInt(360);
  final saturation =
      0.5 + random.nextDouble() * 0.3; // Adjusted saturation range
  final lightness = 0.8 + random.nextDouble() * 0.1; // Adjusted lightness range
  return HSLColor.fromAHSL(1.0, hue.toDouble(), saturation, lightness)
      .toColor();
}

final cardColors = List<Color>.generate(30, (index) => generatePastelColor());

class Task {
  String id;
  String title;
  String description;
  DateTime date;
  bool completed;
  bool important = false;
  Color color = cardColors[Random().nextInt(cardColors.length)];

  Task(
      {required this.id,
      required this.title,
      required this.description,
      required this.completed,
      required this.date,
      this.important = false});

  Task.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['description'],
        completed = map['completed'] == 1,
        date = DateTime.parse(map['date']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed ? 1 : 0,
      'date': date.toIso8601String()
    };
  }
}
