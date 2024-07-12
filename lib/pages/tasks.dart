import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/model/task.dart';
import 'package:notes_app/utils/redux.dart';
import 'package:notes_app/widget/add_task_widget.dart';
import 'package:notes_app/widget/task_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

const backgroundColor = Color(0xFFFF896F);

class _TasksPageState extends State<TasksPage>
    with AutomaticKeepAliveClientMixin<TasksPage> {
  late DateTime selectedDay;

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: StoreConnector<AppState, List<Task>>(
            converter: (store) => store.state.tasks,
            builder: (context, allTasks) {
              List<Task> tasks = allTasks.where((task) {
                return task.date.year == selectedDay.year &&
                    task.date.month == selectedDay.month &&
                    task.date.day == selectedDay.day;
              }).toList();

              final taskWidgets = tasks
                  .map((task) => TaskWidget(
                        key: ValueKey(task.id),
                        task: task,
                        showTime: true,
                      ))
                  .toList();
              return Column(
                children: [
                  Container(
                    height: 490,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: backgroundColor.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 3,
                          ),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            backgroundColor.withOpacity(0.65),
                            backgroundColor,
                          ],
                        )),
                    child: Column(
                      children: [
                        const SizedBox(height: 48.0),
                        Expanded(
                          child: TableCalendar(
                            onDaySelected: (day, focusedDay) => {
                              setState(() {
                                selectedDay = day;
                              }),
                            },
                            rowHeight: 56,
                            calendarStyle:
                                const CalendarStyle(outsideDaysVisible: false),
                            firstDay: DateTime.utc(2010, 10, 16),
                            lastDay: DateTime.utc(2030, 3, 14),
                            selectedDayPredicate: (day) =>
                                isSameDay(selectedDay, day),
                            focusedDay: selectedDay,
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
                                margin:
                                    const EdgeInsets.symmetric(vertical: 0.0),
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
                                for (var task in allTasks) {
                                  if (isSameDay(task.date, day)) {
                                    return Container(
                                      margin: const EdgeInsets.all(10.0),
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            day.day.toString(),
                                            style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Container(
                                            width: 8,
                                            height: 3,
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withOpacity(0.45),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }
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
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: double.infinity,
                      height:
                          (taskWidgets.length / 2 + 1).toInt() * 200.0 + 180,
                      child: GridView.count(
                        padding:
                            const EdgeInsets.only(left: 5.0, right: 5, top: 20),
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        children: [
                          ...taskWidgets,
                          AddTaskWidget(
                            date: selectedDay,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
