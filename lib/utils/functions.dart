import 'dart:math';

import 'package:notes_app/model/task.dart';
import 'package:table_calendar/table_calendar.dart';

String randId(int length) {
  const characters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()-_=+[]{}|;:",.<>?/~`';
  final random = Random();
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => characters.codeUnitAt(
        random.nextInt(characters.length),
      ),
    ),
  );
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

bool timeElapsed(DateTime date) {
  return date.isBefore(DateTime.now());
}
