import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

class AddTaskWidget extends StatefulWidget {
  const AddTaskWidget({super.key});

  @override
  State<AddTaskWidget> createState() => _AddTaskWidgetState();
}

const backgroundColor = Color(0xFFFF896F);

class _AddTaskWidgetState extends State<AddTaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: DashedBorder.fromBorderSide(
            dashLength: 10,
            side: BorderSide(color: backgroundColor.withOpacity(0.8), width: 2),
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
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
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
        ));
  }
}
