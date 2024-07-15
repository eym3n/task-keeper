import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:notes_app/model/task.dart';
import 'package:notes_app/pages/task_editor.dart';
import 'package:notes_app/service/notification_service';
import 'package:notes_app/utils/functions.dart';
import 'package:notes_app/utils/redux.dart';
import 'package:redux/redux.dart';

class AddTaskWidget extends StatefulWidget {
  final DateTime date;
  const AddTaskWidget({super.key, required this.date});

  @override
  State<AddTaskWidget> createState() => _AddTaskWidgetState();
}

const backgroundColor = Color(0xFFFF896F);

class _AddTaskWidgetState extends State<AddTaskWidget> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, void Function(Task)>(
      converter: (Store<AppState> store) {
        return (task) => store.dispatch(AddTaskAction(task));
      },
      builder: (context, addTask) {
        return InkWell(
          onTap: () async {
            var task = Task(
              id: randId(16),
              title: '',
              description: '',
              completed: false,
              date: widget.date.add(const Duration(minutes: 15)),
            );
            addTask(task);
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TaskEditor(
                          task: task,
                        )));
            NotificationService().scheduleNotification(
                id: int.parse(task.id),
                title: task.title,
                body: task.description,
                scheduledNotificationDateTime: task.date);
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: DashedBorder.fromBorderSide(
                  dashLength: 10,
                  side: BorderSide(
                      color: backgroundColor.withOpacity(0.8), width: 2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: backgroundColor.withOpacity(0),
                    blurRadius: 5.0,
                    spreadRadius: 3.0,
                    offset: const Offset(2, 2),
                  )
                ],
              ),
              height: 150,
              width: 150,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                child: Stack(
                  children: [
                    const Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hourglass_empty_rounded,
                          color: backgroundColor,
                          size: 18.0,
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          'New Task',
                          style: TextStyle(
                              color: backgroundColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Icon(
                          CupertinoIcons.add_circled_solid,
                          color: backgroundColor.withOpacity(0.8),
                          size: 30.0,
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
