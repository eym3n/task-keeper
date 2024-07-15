import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/model/task.dart';
import 'package:notes_app/pages/task_editor.dart';
import 'package:notes_app/service/notification_service';
import 'package:notes_app/utils/functions.dart';
import 'package:notes_app/utils/redux.dart';
import 'package:redux/redux.dart';
import 'package:toastification/toastification.dart';
import 'package:tuple/tuple.dart';

class TaskWidget extends StatefulWidget {
  final Task task;
  final bool showTime;

  const TaskWidget({super.key, required this.task, this.showTime = false});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  final titleColor = const Color(0xFF000000);
  final iconColor = const Color.fromARGB(255, 80, 80, 80);
  late bool isDeadlineApproaching;

  @override
  void initState() {
    super.initState();
    isDeadlineApproaching = deadlineApproaching(widget.task.date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState,
        Tuple2<void Function(String), void Function(String, Task)>>(
      converter: (Store<AppState> store) {
        return Tuple2(
          (taskId) => store.dispatch(DeleteTaskAction(taskId)),
          (taskId, updatedTask) =>
              store.dispatch(UpdateTaskAction(taskId, updatedTask)),
        );
      },
      builder: (context, actions) {
        final deleteTask = actions.item1;
        final updateTask = actions.item2;

        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onDoubleTap: () {
            widget.task.completed = !widget.task.completed;
            updateTask(widget.task.id, widget.task);

            toastification.show(
              context: context, // optional if you use ToastificationWrapper
              title: (widget.task.completed
                  ? const Text('Marked as done')
                  : const Text('Marked as undone')),
              primaryColor:
                  (widget.task.completed ? Colors.green : Colors.black),
              showProgressBar: false,
              icon: Icon(
                widget.task.completed
                    ? Icons.check_circle_outline
                    : Icons.timelapse_rounded,
                color: widget.task.completed ? Colors.green : Colors.black,
                size: 20,
              ),
              animationDuration: const Duration(milliseconds: 200),
              autoCloseDuration: const Duration(seconds: 2),
            );
          },
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                height: 140,
                margin: const EdgeInsets.symmetric(vertical: 20),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    (widget.task.completed
                        ? InkWell(
                            onTap: () {
                              widget.task.completed = false;
                              updateTask(widget.task.id, widget.task);
                              toastification.show(
                                context:
                                    context, // optional if you use ToastificationWrapper
                                title: (widget.task.completed
                                    ? const Text('Marked as done')
                                    : const Text('Marked as undone')),
                                primaryColor: (widget.task.completed
                                    ? Colors.green
                                    : Colors.black),
                                showProgressBar: false,
                                icon: Icon(
                                  widget.task.completed
                                      ? Icons.check_circle_outline
                                      : Icons.timelapse_rounded,
                                  color: widget.task.completed
                                      ? Colors.green
                                      : Colors.black,
                                  size: 20,
                                ),
                                animationDuration:
                                    const Duration(milliseconds: 200),
                                autoCloseDuration: const Duration(seconds: 2),
                              );
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              height: 70,
                              width: double.infinity,
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Mark as undone',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Icon(
                                    CupertinoIcons.check_mark_circled,
                                    size: 20,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              widget.task.completed = true;
                              updateTask(widget.task.id, widget.task);
                              toastification.show(
                                context:
                                    context, // optional if you use ToastificationWrapper
                                title: (widget.task.completed
                                    ? const Text('Marked as done')
                                    : const Text('Marked as undone')),
                                primaryColor: (widget.task.completed
                                    ? Colors.green
                                    : Colors.black),
                                showProgressBar: false,
                                icon: Icon(
                                  widget.task.completed
                                      ? Icons.check_circle_outline
                                      : Icons.timelapse_rounded,
                                  color: widget.task.completed
                                      ? Colors.green
                                      : Colors.black,
                                  size: 20,
                                ),
                                animationDuration:
                                    const Duration(milliseconds: 200),
                                autoCloseDuration: const Duration(seconds: 2),
                              );
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              height: 70,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Mark as done',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.green[800],
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Icon(
                                    CupertinoIcons.check_mark_circled,
                                    size: 20,
                                    color: Colors.green[800],
                                  )
                                ],
                              ),
                            ),
                          )),
                    InkWell(
                      onTap: () {
                        deleteTask(widget.task.id);
                        toastification.show(
                          context:
                              context, // optional if you use ToastificationWrapper
                          title: const Text('Task deleted'),
                          primaryColor: Colors.red,
                          showProgressBar: false,
                          animationDuration: const Duration(milliseconds: 200),
                          autoCloseDuration: const Duration(seconds: 2),
                        );
                        Navigator.pop(context);
                        NotificationService()
                            .deleteNotification(int.parse(widget.task.id));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 50),
                        height: 70,
                        width: double.infinity,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delete task',
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
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TaskEditor(
                task: widget.task,
              );
            }));
          },
          child: Container(
              decoration: BoxDecoration(
                color: widget.task.color,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: widget.task.color.withOpacity(0.5),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.task.color.withOpacity(0.3),
                    blurRadius: 5.0,
                    spreadRadius: 5.0,
                    offset: const Offset(0, 0),
                  )
                ],
              ),
              height: 150,
              width: 150,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 15, left: 15, right: 15, bottom: 15),
                child: Stack(
                  children: [
                    ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 50),
                      children: [
                        SizedBox(
                          child: Text(
                            widget.task.title,
                            softWrap: true,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                color: titleColor.withOpacity(0.8),
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.task.description,
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 30,
                        width: 150,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: widget.task.color.withOpacity(0.8),
                              blurRadius: 10.0,
                              spreadRadius: 16.0,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                height: 18,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: isDeadlineApproaching &&
                                          !widget.task.completed
                                      ? Colors.red.shade700.withOpacity(0.7)
                                      : Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(5.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.15),
                                      blurRadius: 10.0,
                                      spreadRadius: 5.0,
                                      offset: const Offset(0.5, 0.8),
                                    )
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    (widget.showTime
                                        ? DateFormat.jm()
                                            .format(widget.task.date.toLocal())
                                            .toString()
                                        : DateFormat.EEEE()
                                            .format(widget.task.date.toLocal())
                                            .toString()),
                                    style: TextStyle(
                                        color: isDeadlineApproaching &&
                                                !widget.task.completed
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                            const SizedBox(width: 5),
                            Container(
                              decoration: BoxDecoration(
                                color: widget.task.completed
                                    ? Colors.green.shade700
                                    : widget.task.color,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Icon(
                                !widget.task.completed
                                    ? CupertinoIcons.time_solid
                                    : CupertinoIcons.check_mark_circled_solid,
                                color: !widget.task.completed
                                    ? Colors.black.withOpacity(0.8)
                                    : Colors.white,
                                size: 30.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
        );
      },
    );
  }
}
