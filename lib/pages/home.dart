import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/model/task.dart';
import 'package:notes_app/utils/redux.dart';
import 'package:notes_app/widget/task_card.dart';
import 'package:notes_app/widget/task_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

const cardColor = Color(0xFFFFF1BE);

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  final CardSwiperController controller = CardSwiperController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _name;
  late String _nameValue;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _name = _prefs.then((prefs) => prefs.getString('name') ?? '');
    _name.then((value) {
      setState(() {
        _nameValue = value;
        loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: loaded
              ? StoreConnector<AppState, List<Task>>(
                  converter: (store) => store.state.tasks,
                  builder: (BuildContext context, List<Task> tasks) {
                    final todaysDate = DateTime.now();
                    final todaysTasks = tasks
                        .where((task) =>
                            task.date.day == DateTime.now().day &&
                            task.date.month == DateTime.now().month &&
                            task.date.year == DateTime.now().year)
                        .toList();
                    final cards = todaysTasks
                        .map((task) => TaskCard(
                              key: Key(task.id.toString()),
                              task: task,
                              showDescription: false,
                            ))
                        .toList();

                    final thisWeeksTasks = tasks
                        .where((task) =>
                            task.date.isAfter(DateTime(
                                todaysDate.year,
                                todaysDate.month,
                                todaysDate.day,
                                23,
                                59,
                                59)) &&
                            task.date.isBefore(
                                DateTime.now().add(const Duration(days: 7))))
                        .toList();

                    final taskWidgets = thisWeeksTasks
                        .map((task) => TaskWidget(
                              key: Key(task.id.toString()),
                              task: task,
                            ))
                        .toList();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 60.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Good Morning\n$_nameValue',
                                style: const TextStyle(
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              const CircleAvatar(
                                radius: 25.0,
                                backgroundImage:
                                    AssetImage('assets/images/default.jpg'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    CupertinoIcons.calendar,
                                    color: Colors.black,
                                    size: 28.0,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Text(
                                        DateFormat.MMMEd()
                                            .format(DateTime.now())
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: (todaysTasks.isEmpty
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(
                                            CupertinoIcons.alarm_fill,
                                            color: Colors.black,
                                            size: 14.0,
                                          ),
                                          const SizedBox(width: 5.0),
                                          Text(
                                            'You have ${todaysTasks.length} task${todaysTasks.length > 1 ? 's' : ''} today',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      )),
                              )
                            ],
                          ),
                          (todaysTasks.length > 2
                              ? const SizedBox(height: 46.0)
                              : (todaysTasks.isEmpty
                                  ? const SizedBox(
                                      height: 0,
                                    )
                                  : const SizedBox(
                                      height: 35,
                                    ))),
                          (cards.isEmpty
                              ? SizedBox(
                                  height: 380,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: 250,
                                          child: Image.asset(
                                              'assets/images/empty.jpg')),
                                      const Text(
                                        'No tasks for today',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: 110,
                                  width: double.infinity,
                                  child: CardSwiper(
                                    maxAngle: 40,
                                    allowedSwipeDirection:
                                        const AllowedSwipeDirection.symmetric(
                                            horizontal: true, vertical: false),
                                    controller: controller,
                                    cardsCount: cards.length,
                                    onSwipe: _onSwipe,
                                    onUndo: _onUndo,
                                    numberOfCardsDisplayed:
                                        cards.length > 3 ? 3 : cards.length,
                                    backCardOffset: const Offset(0, -20),
                                    padding: EdgeInsets.zero,
                                    cardBuilder: (context,
                                        index,
                                        horizontalThresholdPercentage,
                                        verticalThresholdPercentage) {
                                      if (index < cards.length) {
                                        return cards[index];
                                      } else {
                                        return Container(); // Return an empty container if the index is out of range
                                      }
                                    },
                                  ),
                                )),
                          const SizedBox(height: 30.0),
                          (thisWeeksTasks.isEmpty
                              ? Container()
                              : Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Coming up',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(width: 12.0),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 5,
                                            width: 5,
                                            decoration: const BoxDecoration(
                                                color: Colors.blue,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.blue,
                                                      blurRadius: 8,
                                                      spreadRadius: 0.3)
                                                ],
                                                shape: BoxShape.circle),
                                          ),
                                          const SizedBox(width: 5.0),
                                          Text(
                                              '${thisWeeksTasks.length} tasks this week',
                                              style: TextStyle(
                                                  fontSize: 13.0,
                                                  color: Colors.blue.shade500,
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(width: 15.0),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          SizedBox(
                            width: double.infinity,
                            height: (taskWidgets.length ~/ 2 + 1) * 170.0 + 180,
                            child: GridView.count(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 5, top: 30),
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              children: [
                                ...taskWidgets,
                                // const AddTaskWidget(),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                )
              : Container(),
        ));
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    return true;
  }

  @override
  bool get wantKeepAlive => true;
}
