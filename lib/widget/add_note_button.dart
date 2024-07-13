import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:notes_app/model/note.dart';
import 'package:notes_app/pages/note_editor.dart';
import 'package:notes_app/utils/functions.dart';
import 'package:notes_app/utils/redux.dart';
import 'package:redux/redux.dart';

class AddNoteButton extends StatefulWidget {
  const AddNoteButton({super.key});

  @override
  State<AddNoteButton> createState() => _AddNoteButtonState();
}

class _AddNoteButtonState extends State<AddNoteButton> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, void Function(Note)>(
      converter: (Store<AppState> store) {
        return (note) => store.dispatch(AddNoteAction(note));
      },
      builder: (context, addNote) {
        return IconButton(
          icon: Icon(
            CupertinoIcons.add,
            color: Colors.black.withOpacity(0.7),
            size: 25,
          ),
          onPressed: () {
            final note = Note(
                id: randId(16),
                content:
                    '{"document":{"type":"page","children":[{"type":"paragraph","data":{"delta":[]}}]}}',
                date: DateTime.now(),
                lastModified: DateTime.now());
            addNote(note);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NoteEditor(note: note)));
          },
        );
      },
    );
  }
}
