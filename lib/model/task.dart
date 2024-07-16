import 'dart:math';

import 'package:flutter/cupertino.dart';

/// Generates a pastel color using random values for hue, saturation, and lightness.
///
/// The hue is a random integer between 0 and 360.
/// The saturation is a random double between 0.5 and 0.8.
/// The lightness is a random double between 0.8 and 0.9.
///
/// Returns a [Color] object representing the generated pastel color.
Color generatePastelColor() {
  final random = Random();
  final hue = random.nextInt(360);
  final saturation =
      0.5 + random.nextDouble() * 0.3; // Adjusted saturation range
  final lightness = 0.8 + random.nextDouble() * 0.1; // Adjusted lightness range
  return HSLColor.fromAHSL(1.0, hue.toDouble(), saturation, lightness)
      .toColor();
}

/// A list of 30 randomly generated pastel colors.
final cardColors = List<Color>.generate(30, (index) => generatePastelColor());

/// A class representing a task with various attributes.
class Task {
  String id;
  String title;
  String description;
  DateTime date;
  bool completed;
  bool important = false;
  Color color = cardColors[Random().nextInt(cardColors.length)];

  /// Creates a new [Task] instance.
  ///
  /// The [id], [title], [description], [completed], and [date] parameters are required.
  /// The [important] parameter is optional and defaults to false.
  Task(
      {required this.id,
      required this.title,
      required this.description,
      required this.completed,
      required this.date,
      this.important = false});

  /// Creates a new [Task] instance from a map.
  ///
  /// The map should contain the following keys: 'id', 'title', 'description', 'completed', 'date', 'important', and 'color'.
  Task.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['description'],
        completed = map['completed'] == 1,
        date = DateTime.parse(map['date']),
        important = map['important'] == 1,
        color = Color(map['color']);

  /// Converts the [Task] instance to a map.
  ///
  /// The returned map contains the following keys: 'id', 'title', 'description', 'completed', 'date', 'important', and 'color'.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed ? 1 : 0,
      'date': date.toIso8601String(),
      'important': important ? 1 : 0,
      'color': color.value
    };
  }

  /// Returns a string representation of the [Task] instance.
  ///
  /// The string contains the values of the [id], [title], [description], [completed], [date], [important], and [color] attributes.
  @override
  String toString() {
    return 'Task{id: $id, title: $title, description: $description, completed: $completed, date: $date, important: $important, color: $color}';
  }

  /// Checks if the task is due.
  ///
  /// A task is considered due if its [date] is before the current date and time.
  ///
  /// Returns `true` if the task is due, otherwise `false`.
  bool isDue() {
    return date.isBefore(DateTime.now());
  }

  /// Checks if the task is overdue.
  ///
  /// A task is considered overdue if its [date] is before the current date and time minus one day.
  ///
  /// Returns `true` if the task is overdue, otherwise `false`.
  bool isOverdue() {
    return date.isBefore(DateTime.now());
  }

  /// Checks if the task is empty.
  ///
  /// A task is considered empty if both its [title] and [description] are empty strings.
  ///
  /// Returns `true` if the task is empty, otherwise `false`.
  bool isEmpty() {
    return title.isEmpty && description.isEmpty;
  }
}
