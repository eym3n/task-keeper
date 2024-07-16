import 'package:notes_app/db/sqflite.dart';
import 'package:notes_app/utils/functions.dart';
import 'package:notes_app/utils/redux.dart';

AppState tasksReducer(AppState state, dynamic action) {
  if (action is AddTaskAction) {
    Db.insertTask(action.task.toMap());
    addNotification(action.task);
    return AppState(
        tasks: sortByRelevance(List.from(state.tasks)..add(action.task)));
  } else if (action is UpdateTaskAction) {
    return AppState(
        tasks: sortByRelevance(state.tasks.map((task) {
      Db.updateTask(task.toMap());
      updateNotification(action.updatedTask);
      return task.id == action.id ? action.updatedTask : task;
    }).toList()));
  } else if (action is DeleteTaskAction) {
    Db.deleteTask(action.id);
    deleteNotification(action.id);
    return AppState(
        tasks: sortByRelevance(
            state.tasks.where((task) => task.id != action.id).toList()));
  } else if (action is InitializeTasksAction) {
    return AppState(tasks: action.tasks);
  }

  return state;
}

AppState notesReducer(AppState state, dynamic action) {
  if (action is AddNoteAction) {
    Db.insertNote(action.note.toMap());
    return AppState(
        notes: sortNotesByRelevance(List.from(state.notes)..add(action.note)));
  } else if (action is UpdateNoteAction) {
    return AppState(
        notes: sortNotesByRelevance(state.notes.map((note) {
      Db.updateNote(note.toMap());
      return note.id == action.id ? action.updatedNote : note;
    }).toList()));
  } else if (action is DeleteNoteAction) {
    Db.deleteNote(action.id);
    return AppState(
        notes: sortNotesByRelevance(
            state.notes.where((note) => note.id != action.id).toList()));
  } else if (action is InitializeNotesAction) {
    return AppState(notes: action.notes);
  }

  return state;
}

AppState appReducer(AppState state, dynamic action) {
  AppState newTaskState = tasksReducer(state, action);
  AppState newNoteState = notesReducer(state, action);

  return AppState(
    tasks: newTaskState.tasks,
    notes: newNoteState.notes,
  );
}
