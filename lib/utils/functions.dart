import 'dart:convert';
import 'dart:math';

import 'package:notes_app/model/note.dart';
import 'package:notes_app/model/task.dart';
import 'package:notes_app/service/notification_service.dart';
import 'package:table_calendar/table_calendar.dart';

String randId(int length) {
  return '${Random().nextInt(100000)}';
}

bool deadlineApproaching(DateTime deadline) {
  final now = DateTime.now();
  final diff = deadline.difference(now);
  return isSameDay(DateTime.now(), deadline) && diff.inHours < 2;
}

List<Task> sortByRelevance(List<Task> tasks) {
  tasks.sort((a, b) {
    if (a.completed && !b.completed) {
      return 1;
    } else if (!a.completed && b.completed) {
      return -1;
    } else {
      return a.date.compareTo(b.date);
    }
  });
  return tasks;
}

List<Note> sortNotesByRelevance(List<Note> notes) {
  notes.sort((a, b) {
    return -1 * (a.lastModified.compareTo(b.lastModified));
  });
  return notes;
}

bool timeElapsed(DateTime date) {
  return date.isBefore(DateTime.now());
}

String extractTextFromJson(String jsonString) {
  try {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    final document = jsonMap['document'];
    if (document == null) return '';

    final children = document['children'];
    if (children == null || children is! List) return '';

    StringBuffer extractedText = StringBuffer();

    for (final child in children) {
      final data = child['data'];
      if (data == null) continue;

      final delta = data['delta'];
      if (delta == null || delta is! List) continue;

      for (final item in delta) {
        if (item['insert'] != null) {
          extractedText.write(item['insert']);
        }
      }
      extractedText.write('\n'); // Adding line break after each node's text
    }

    return extractedText.toString().trim();
  } catch (e) {
    return 'Error decoding JSON: $e';
  }
}

bool nameValid(String name) {
  return name.trim().isNotEmpty;
}

void updateNotification(Task task) {
  if (!task.completed) {
    NotificationService().scheduleNotification(
        id: int.parse(task.id),
        title: task.title,
        body: task.description,
        scheduledNotificationDateTime: task.date);
  } else {
    NotificationService().deleteNotification(int.parse(task.id));
  }
}

void deleteNotification(String id) {
  NotificationService().deleteNotification(int.parse(id));
}

void addNotification(Task task) {
  NotificationService().scheduleNotification(
      id: int.parse(task.id),
      title: task.title,
      body: task.description,
      scheduledNotificationDateTime: task.date);
}
