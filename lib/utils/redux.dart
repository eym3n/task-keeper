import 'package:notes_app/model/task.dart';

class AddTaskAction {
  final Task task;

  AddTaskAction(this.task);
}

class UpdateTaskAction {
  final String id;
  final Task updatedTask;

  UpdateTaskAction(this.id, this.updatedTask);
}

class DeleteTaskAction {
  final String id;

  DeleteTaskAction(this.id);
}

class InitializeTasksAction {
  final List<Task> tasks;
  InitializeTasksAction(this.tasks);
}

enum VisibilityFilter { showAll, showActive, showCompleted, showToday }

class AppState {
  List<Task> tasks;
  VisibilityFilter visibilityFilter;

  // The AppState constructor can contain default values. No need to define these in another
  // place, like the Reducer.
  AppState({
    this.tasks = const [],
    this.visibilityFilter = VisibilityFilter.showAll,
  });
}
