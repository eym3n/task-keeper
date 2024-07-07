import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/model/task.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final bool showDescription;

  const TaskCard(
      {super.key, required this.task, required this.showDescription});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  final titleColor = const Color(0xFF1B188E);
  final iconColor = const Color.fromARGB(255, 80, 80, 80);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: widget.task.color,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: widget.task.color.withOpacity(0.5),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              blurRadius: 20.0,
              spreadRadius: 20.0,
              offset: const Offset(0, -20),
            )
          ],
        ),
        height: 150,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: double.infinity,
                child: Text(
                  widget.task.title,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                      color: titleColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 13.0),
                  Icon(
                    !widget.task.completed
                        ? CupertinoIcons.time_solid
                        : CupertinoIcons.check_mark_circled_solid,
                    color: iconColor.withOpacity(0.8),
                    size: 30.0,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Flexible(
                    child: Text(
                        DateFormat.jm().format(widget.task.date).toString(),
                        style: TextStyle(
                            color: Colors.grey.shade600.withOpacity(0.8),
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
