import 'package:notes_app/model/task.dart';
import 'package:notes_app/model/note.dart';

class AddNoteAction {
  final Note note;

  AddNoteAction(this.note);
}

class UpdateNoteAction {
  final String id;
  final Note updatedNote;

  UpdateNoteAction(this.id, this.updatedNote);
}

class DeleteNoteAction {
  final String id;

  DeleteNoteAction(this.id);
}

class InitializeNotesAction {
  final List<Note> notes;
  InitializeNotesAction(this.notes);
}

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
  List<Note> notes;
  VisibilityFilter visibilityFilter;

  // The AppState constructor can contain default values. No need to define these in another
  // place, like the Reducer.
  AppState({
    this.tasks = const [],
    this.notes = const [],
    this.visibilityFilter = VisibilityFilter.showAll,
  });
}
