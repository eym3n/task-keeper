import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/model/note.dart';
import 'package:notes_app/pages/note_editor.dart';
import 'package:notes_app/utils/functions.dart';
// import 'package:notes_app/pages/note_editor.dart';
import 'package:notes_app/utils/redux.dart';
import 'package:redux/redux.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toastification/toastification.dart';
// import 'package:toastification/toastification.dart';
import 'package:tuple/tuple.dart';

class NoteWidget extends StatefulWidget {
  final Note note;

  const NoteWidget({super.key, required this.note});

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  final noteColor = Color.fromARGB(255, 255, 246, 200);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState,
        Tuple2<void Function(String), void Function(String, Note)>>(
      converter: (Store<AppState> store) {
        return Tuple2(
          (noteId) => store.dispatch(DeleteNoteAction(noteId)),
          (noteId, updatedNote) =>
              store.dispatch(UpdateNoteAction(noteId, updatedNote)),
        );
      },
      builder: (context, actions) {
        final deleteNote = actions.item1;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: InkWell(
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onLongPress: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  height: 80,
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          deleteNote(widget.note.id);
                          toastification.show(
                            context:
                                context, // optional if you use ToastificationWrapper
                            title: const Text('Note deleted'),
                            primaryColor: Colors.red,
                            showProgressBar: false,
                            animationDuration:
                                const Duration(milliseconds: 200),
                            autoCloseDuration: const Duration(seconds: 2),
                          );
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 50),
                          height: 70,
                          width: double.infinity,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delete note',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600),
                              ),
                              Icon(
                                CupertinoIcons.delete,
                                size: 20,
                                color: Colors.red,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteEditor(
                    note: widget.note,
                  ),
                ),
              );
            },
            child: Container(
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: noteColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: noteColor.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 5,
                      offset: const Offset(0, 0),
                    )
                  ]),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 125,
                        width: double.infinity,
                        child: ListView(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 8.0),
                            Text(
                              extractTextFromJson(widget.note.content),
                              style: const TextStyle(
                                  fontSize: 16, overflow: TextOverflow.clip),
                            ),
                            const SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: noteColor,
                              blurRadius: 5,
                              spreadRadius: 10,
                              offset: const Offset(0, -5))
                        ]),
                        child: Text(
                          (!isSameDay(DateTime.now(), widget.note.lastModified)
                              ? DateFormat.yMMMMd()
                                  .format(widget.note.lastModified)
                              : DateFormat.jm()
                                  .format(widget.note.lastModified)),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: -0,
                    bottom: 15,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              CupertinoIcons.pencil,
                              color: Colors.white,
                              size: 16,
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
