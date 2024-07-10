import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:notes_app/model/task.dart';
import 'package:notes_app/utils/redux.dart';
import 'package:redux/redux.dart';
import 'package:tuple/tuple.dart';

List<Color> colors = [
  const Color(0xffacaff2),
  const Color(0xffacefb9),
  const Color(0xffb8deeb),
  const Color(0xffc8f6d7),
  const Color(0xffcaeef9),
  const Color(0xffcbf8e8),
  const Color(0xffccf3ed),
  const Color(0xffd6e7b2),
  const Color(0xffd8c4ec),
  const Color(0xffebb0f1),
  const Color(0xffecc3e8),
  const Color(0xfff1bad1),
  const Color(0xfff1bdec),
  const Color(0xfff2c4ac),
  const Color(0xfff4c4b6),
  const Color(0xfff4d3d1),
  const Color(0xfff7cfdb),
  const Color(0xfffff2d1)
];

class TaskEditor extends StatefulWidget {
  final Task task;
  const TaskEditor({super.key, required this.task});

  @override
  State<TaskEditor> createState() => _TaskEditorState();
}

class _TaskEditorState extends State<TaskEditor> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task.title;
    _descriptionController.text = widget.task.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.task.color,
      body: StoreConnector<AppState,
              Tuple2<void Function(String), void Function(String, Task)>>(
          converter: (Store<AppState> store) {
        return Tuple2(
          (taskId) => store.dispatch(DeleteTaskAction(taskId)),
          (taskId, updatedTask) =>
              store.dispatch(UpdateTaskAction(taskId, updatedTask)),
        );
      }, builder: (context, actions) {
        final deleteTask = actions.item1;
        final updateTask = actions.item2;

        return SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      CupertinoIcons.back,
                      color: Colors.black.withOpacity(0.5),
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Row(
                    children: [
                      Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: (widget.task.completed
                              ? Colors.black.withOpacity(0.8)
                              : Colors.transparent),
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.black.withOpacity(0.5)),
                        ),
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              CupertinoIcons.check_mark,
                              color: (widget.task.completed
                                  ? widget.task.color
                                  : Colors.black.withOpacity(0.5)),
                              size: 16,
                            ),
                            onPressed: () {
                              widget.task.completed = !widget.task.completed;
                              updateTask(widget.task.id, widget.task);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.black.withOpacity(0.5)),
                        ),
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.brush_outlined,
                              color: Colors.black.withOpacity(0.5),
                              size: 16,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  var pickerColor = widget.task.color;

                                  void changeColor(Color color) {
                                    setState(() {
                                      pickerColor = color;
                                    });
                                  }

                                  return AlertDialog(
                                    title: const Text('Pick a color'),
                                    content: SingleChildScrollView(
                                      child: BlockPicker(
                                        pickerColor: widget.task.color,
                                        onColorChanged: changeColor,
                                        availableColors: colors,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Done'),
                                        onPressed: () {
                                          setState(() {
                                            widget.task.color = pickerColor;
                                          });
                                          updateTask(
                                              widget.task.id, widget.task);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.black.withOpacity(0.5)),
                        ),
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              CupertinoIcons.delete,
                              color: Colors.black.withOpacity(0.5),
                              size: 16,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete Task'),
                                    content: const Text(
                                        'Are you sure you want to delete this task?'),
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
                                          deleteTask(widget.task.id);
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Done',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6))))
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: TextField(
                controller: _titleController,
                onChanged: (value) {
                  widget.task.title = value;
                  updateTask(widget.task.id, widget.task);
                },
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'title',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey.shade700),
                ),
                style: const TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: TextField(
                controller: _descriptionController,
                onChanged: (value) {
                  widget.task.description = value;
                  updateTask(widget.task.id, widget.task);
                },
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'desription',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      color: Colors.grey.shade700.withOpacity(0.5),
                      fontWeight: FontWeight.w400),
                ),
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ]),
        );
      }),
    );
  }
}
