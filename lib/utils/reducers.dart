import 'package:notes_app/db/sqflite.dart';
import 'package:notes_app/utils/functions.dart';
import 'package:notes_app/utils/redux.dart';

AppState tasksReducer(AppState state, dynamic action) {
  if (action is AddTaskAction) {
    Db.insertTask(action.task.toMap());
    return AppState(
        tasks: sortByRelevance(List.from(state.tasks)..add(action.task)));
  } else if (action is UpdateTaskAction) {
    return AppState(
        tasks: sortByRelevance(state.tasks.map((task) {
      Db.updateTask(task.toMap());
      return task.id == action.id ? action.updatedTask : task;
    }).toList()));
  } else if (action is DeleteTaskAction) {
    Db.deleteTask(action.id);
    return AppState(
        tasks: sortByRelevance(
            state.tasks.where((task) => task.id != action.id).toList()));
  } else if (action is InitializeTasksAction) {
    return AppState(tasks: action.tasks);
  }

  return state;
}
