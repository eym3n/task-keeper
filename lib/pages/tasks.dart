import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

const backgroundColor = Color(0xFFFF896F);

class _TasksPageState extends State<TasksPage> {
  late DateTime selectedDay;

  @override
  void initState() {
    super.initState();

    selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 540,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: backgroundColor,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 60.0),
                  Expanded(
                    child: TableCalendar(
                      onDaySelected: (day, focusedDay) => {
                        setState(() {
                          selectedDay = day;
                        }),
                      },
                      rowHeight: 65,
                      calendarStyle:
                          const CalendarStyle(outsideDaysVisible: false),
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      selectedDayPredicate: (day) =>
                          isSameDay(selectedDay, day),
                      focusedDay: DateTime.now(),
                      headerStyle: const HeaderStyle(
                        headerPadding: EdgeInsets.only(bottom: 20),
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: Colors.transparent,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: Colors.transparent,
                        ),
                      ),
                      calendarBuilders: CalendarBuilders(
                        todayBuilder: (context, day, focusedDay) {
                          return Container(
                            margin: const EdgeInsets.all(6.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              day.day.toString(),
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                          );
                        },
                        selectedBuilder: (context, day, focusedDay) {
                          return Container(
                            margin: const EdgeInsets.all(6.0),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              day.day.toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                          );
                        },
                        dowBuilder: (context, day) => Container(
                          margin: const EdgeInsets.symmetric(vertical: 0.0),
                          child: Center(
                            child: Text(
                              [
                                'S',
                                'M',
                                'T',
                                'W',
                                'T',
                                'F',
                                'S'
                              ][day.weekday - 1],
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        outsideBuilder: (context, day, focusedDay) =>
                            Container(),
                        defaultBuilder: (context, day, focusedDay) {
                          return Container(
                            margin: const EdgeInsets.all(10.0),
                            alignment: Alignment.center,
                            child: Text(
                              day.day.toString(),
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                          );
                        },
                        disabledBuilder: (context, day, focusedDay) =>
                            Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            day.day.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        headerTitleBuilder: (context, day) => Center(
                          child: Text(
                            (day.year == DateTime.now().year
                                ? DateFormat.MMMM().format(day)
                                : '${DateFormat.MMMM().format(day)}, ${day.year}'),
                            style: const TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
