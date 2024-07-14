import 'dart:convert';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:notes_app/model/note.dart';
import 'package:notes_app/utils/redux.dart';
import 'package:redux/redux.dart';
import 'package:toastification/toastification.dart';
import 'package:tuple/tuple.dart';

class NoteEditor extends StatefulWidget {
  final Note note;
  const NoteEditor({super.key, required this.note});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

const bgColor = Color.fromARGB(255, 20, 20, 26);
const textColor = Colors.white;

class _NoteEditorState extends State<NoteEditor> {
  late final EditorState editorState;

  @override
  void initState() {
    super.initState();

    editorState = EditorState(
      document: Document.fromJson(jsonDecode(widget.note.content)),
    );
  }

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
        final updateNote = actions.item2;

        return Scaffold(
          backgroundColor: bgColor,
          body: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          CupertinoIcons.back,
                          color: Colors.white,
                          size: 25,
                        )),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete Note'),
                                    content: const Text(
                                        'Are you sure you want to delete this note?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Delete'),
                                        onPressed: () {
                                          deleteNote(widget.note.id);
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          toastification.show(
                                            context:
                                                context, // optional if you use ToastificationWrapper
                                            title: const Text('Note deleted'),
                                            primaryColor: Colors.red,
                                            showProgressBar: false,
                                            animationDuration: const Duration(
                                                milliseconds: 200),
                                            autoCloseDuration:
                                                const Duration(seconds: 2),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              CupertinoIcons.delete,
                              size: 18,
                              color: Colors.white,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        TextButton(
                            onPressed: () {
                              widget.note.content =
                                  jsonEncode(editorState.document.toJson());
                              widget.note.lastModified = DateTime.now();

                              updateNote(widget.note.id, widget.note);
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Save',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Container(
                  color: bgColor,
                  child: AppFlowyEditor(
                    editorState: editorState,
                    editorStyle: customizeEditorStyle(),
                    blockComponentBuilders: customBuilder(editorState),
                  ),
                ),
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: bgColor,
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.shade300.withOpacity(0.3),
                      width: 1.0,
                    ),
                  ),
                ),
                width: MediaQuery.sizeOf(context).width,
                child: _FixedToolbar(
                  editorState: editorState,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// custom the block style
  Map<String, BlockComponentBuilder> customBuilder(
    EditorState editorState,
  ) {
    final configuration = BlockComponentConfiguration(
      padding: (node) {
        if (HeadingBlockKeys.type == node.type) {
          return const EdgeInsets.symmetric(vertical: 30);
        }
        return const EdgeInsets.symmetric(vertical: 5);
      },
      textStyle: (node) {
        if (HeadingBlockKeys.type == node.type) {
          return const TextStyle(color: Colors.white);
        }
        return const TextStyle();
      },
    );

    // customize heading block style
    return {
      ...standardBlockComponentBuilderMap,
      // heading block
      HeadingBlockKeys.type: HeadingBlockComponentBuilder(
        configuration: configuration,
      ),
      // todo-list block
      TodoListBlockKeys.type: TodoListBlockComponentBuilder(
        configuration: configuration,
        iconBuilder: (context, node, ___) {
          final checked = node.attributes[TodoListBlockKeys.checked] as bool;
          return GestureDetector(
            onTap: () {
              try {
                editorState.apply(
                  editorState.transaction
                    ..updateNode(node, {TodoListBlockKeys.checked: !checked}),
                );
              } catch (error) {
                print('Error updating node: $error');
              }
            },
            child: Icon(
              checked ? Icons.check_box : Icons.check_box_outline_blank,
              size: 20,
              color: Colors.white,
            ),
          );
        },
      ),
      // bulleted list block
      BulletedListBlockKeys.type: BulletedListBlockComponentBuilder(
        configuration: configuration,
        iconBuilder: (context, node) {
          return Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            child: const Icon(
              Icons.circle,
              size: 10,
              color: Colors.red,
            ),
          );
        },
      ),
      // quote block
    };
  }

  /// custom the text style
  EditorStyle customizeEditorStyle() {
    return EditorStyle(
      padding: PlatformExtension.isDesktopOrWeb
          ? const EdgeInsets.only(left: 200, right: 200)
          : const EdgeInsets.symmetric(horizontal: 20),
      cursorColor: Colors.green,
      dragHandleColor: Colors.green,
      selectionColor: Colors.green.withOpacity(0.5),
      textStyleConfiguration: TextStyleConfiguration(
        text: const TextStyle(
            fontSize: 18.0, color: Colors.white, fontFamily: 'San Francisco'),
        bold: const TextStyle(
          fontWeight: FontWeight.w900,
        ),
        href: TextStyle(
          color: Colors.red,
          decoration: TextDecoration.combine(
            [
              TextDecoration.overline,
              TextDecoration.underline,
            ],
          ),
        ),
        code: const TextStyle(
          fontSize: 14.0,
          fontStyle: FontStyle.italic,
          color: Colors.blue,
          backgroundColor: bgColor,
        ),
      ),
      textSpanDecorator: (context, node, index, text, before, _) {
        final attributes = text.attributes;
        final href = attributes?[AppFlowyRichTextKeys.href];
        if (href != null) {
          return TextSpan(
            text: text.text,
            style: before.style,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                debugPrint('onTap: $href');
              },
          );
        }
        return before;
      },
    );
  }
}

class _FixedToolbar extends StatelessWidget {
  const _FixedToolbar({
    required this.editorState,
  });

  final EditorState editorState;

  @override
  Widget build(BuildContext context) {
    final items = [
      Icons.format_bold,
      Icons.format_italic,
      Icons.title,
      Icons.format_underlined,
      Icons.format_strikethrough,
      Icons.check_box,
      Icons.format_list_bulleted,
      Icons.format_list_numbered,
      Icons.format_align_left,
      Icons.format_align_center,
      Icons.format_align_right,
      Icons.horizontal_rule,
    ];

    return ValueListenableBuilder(
      valueListenable: editorState.selectionNotifier,
      builder: (context, selection, _) {
        return GridView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            final isBold = _isTextDecorationActive(
              editorState,
              selection,
              AppFlowyRichTextKeys.bold,
            );
            return IconButton(
              icon: Icon(items[index]),
              color: items[index] == Icons.format_bold && isBold
                  ? Colors.blue
                  : Colors.white,
              onPressed: () {
                debugPrint(items[index].toString());
                switch (items[index]) {
                  case Icons.format_bold:
                    editorState.toggleAttribute(AppFlowyRichTextKeys.bold);
                    break;
                  case Icons.format_italic:
                    editorState.toggleAttribute(AppFlowyRichTextKeys.italic);
                    break;
                  case Icons.format_underlined:
                    editorState.toggleAttribute(AppFlowyRichTextKeys.underline);
                    break;
                  case Icons.format_strikethrough:
                    editorState
                        .toggleAttribute(AppFlowyRichTextKeys.strikethrough);
                    break;
                  case Icons.text_fields:
                    editorState.formatNode(null, (node) {
                      return node.copyWith(
                        type: ParagraphBlockKeys.type,
                      );
                    });
                    break;
                  case Icons.format_list_bulleted:
                    editorState.formatNode(null, (node) {
                      return node.copyWith(
                        type: node.type == BulletedListBlockKeys.type
                            ? ParagraphBlockKeys.type
                            : BulletedListBlockKeys.type,
                      );
                    });
                    break;
                  case Icons.format_list_numbered:
                    editorState.formatNode(null, (node) {
                      return node.copyWith(
                        type: node.type == NumberedListBlockKeys.type
                            ? ParagraphBlockKeys.type
                            : NumberedListBlockKeys.type,
                      );
                    });
                    break;
                  case Icons.format_align_left:
                    editorState.formatNode(null, (node) {
                      return node.copyWith(
                        attributes: {
                          ...node.attributes,
                          blockComponentAlign: 'left',
                        },
                      );
                    });
                    break;
                  case Icons.format_align_center:
                    editorState.formatNode(null, (node) {
                      return node.copyWith(
                        attributes: {
                          ...node.attributes,
                          blockComponentAlign: 'center',
                        },
                      );
                    });
                    break;
                  case Icons.format_align_right:
                    editorState.formatNode(null, (node) {
                      return node.copyWith(
                        attributes: {
                          ...node.attributes,
                          blockComponentAlign: 'right',
                        },
                      );
                    });
                    break;
                  case Icons.format_align_justify:
                    editorState.formatNode(null, (node) {
                      return node.copyWith(
                        attributes: {
                          ...node.attributes,
                          blockComponentAlign: 'justify',
                        },
                      );
                    });
                    break;
                  case Icons.title:
                    editorState.formatNode(null, (node) {
                      return node.copyWith(
                        type: node.type == HeadingBlockKeys.type
                            ? ParagraphBlockKeys.type
                            : HeadingBlockKeys.type,
                      );
                    });
                  case Icons.check_box:
                    final selection = editorState.selection;
                    if (selection == null) {
                      return;
                    }
                    final transaction = editorState.transaction;
                    transaction.insertNode(
                      selection.start.path.next,
                      todoListNode(checked: false),
                    );
                    editorState.apply(transaction);
                    break;
                  case Icons.horizontal_rule:
                    final selection = editorState.selection;
                    if (selection == null) {
                      return;
                    }
                    final transaction = editorState.transaction;
                    transaction.insertNode(
                      selection.start.path.next,
                      dividerNode(),
                    );
                    transaction.insertNode(
                      selection.start.path.next,
                      paragraphNode(),
                    );
                    editorState.apply(transaction);
                    break;
                }
              },
            );
          },
          itemCount: items.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: MediaQuery.of(context).size.width / 6,
          ),
        );
      },
    );
  }

  bool _isTextDecorationActive(
    EditorState editorState,
    Selection? selection,
    String name,
  ) {
    selection = selection ?? editorState.selection;
    if (selection == null) {
      return false;
    }
    final nodes = editorState.getNodesInSelection(selection);
    if (selection.isCollapsed) {
      return editorState.toggledStyle.containsKey(name);
    } else {
      return nodes.allSatisfyInSelection(selection, (delta) {
        return delta.everyAttributes(
          (attributes) => attributes[name] == true,
        );
      });
    }
  }
}
