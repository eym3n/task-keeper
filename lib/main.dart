import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/db/sqflite.dart';
import 'package:notes_app/model/note.dart';
import 'package:notes_app/model/task.dart';
import 'package:notes_app/pages/main_page.dart';
import 'package:notes_app/utils/functions.dart';
import 'package:notes_app/utils/reducers.dart';
import 'package:notes_app/utils/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Db.init();
  var tasks = sortByRelevance(await fetchTasksFromDb());
  var notes = sortNotesByRelevance(await fetchNotesFromDb());
  // var notes = <Note>[];

  final store = Store<AppState>(
    appReducer,
    initialState: AppState(),
  );

  store.dispatch(InitializeTasksAction(tasks));
  store.dispatch(InitializeNotesAction(notes));

  runApp(MyApp(store: store));
}

Future<List<Task>> fetchTasksFromDb() async {
  var taskMaps = await Db.getTasks();
  return taskMaps.map((e) => Task.fromMap(e)).toList();
}

Future<List<Note>> fetchNotesFromDb() async {
  var noteMaps = await Db.getNotes();
  return noteMaps.map((e) => Note.fromMap(e)).toList();
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({super.key, required this.store});
  // This widget is the root of your application

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: ToastificationWrapper(
        child: MaterialApp(
          localizationsDelegates: const [
            AppFlowyEditorLocalizations.delegate,
          ],
          title: 'Notes App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0x00ff896f)),
            useMaterial3: true,
            fontFamily: 'San Francisco',
          ),
          home: const MainPage(),
        ),
      ),
    );
  }
}
