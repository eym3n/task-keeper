import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/db/sqflite.dart';
import 'package:notes_app/model/task.dart';
import 'package:notes_app/widget/task_card.dart';
import 'package:notes_app/widget/task_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

const cardColor = Color(0xFFFFF1BE);

class _HomePageState extends State<HomePage> {
  final CardSwiperController controller = CardSwiperController();
  var tasks = <Task>[];

  void getData() async {
    var t = await Db.getTasks();

    setState(() {
      tasks = t.map((e) => Task.fromMap(e)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final cards = tasks
        .map((task) => TaskCard(
              task: task,
              showDescription: false,
            ))
        .toList();

    final taskWidgets = tasks
        .map((task) => TaskWidget(
              task: task,
            ))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 60.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Good Morning\nAymen',
                    style:
                        TextStyle(fontSize: 28.0, fontWeight: FontWeight.w500),
                  ),
                  CircleAvatar(
                    radius: 25.0,
                    backgroundImage: AssetImage('assets/images/default.jpg'),
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
                                fontSize: 16, fontWeight: FontWeight.w600),
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
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            CupertinoIcons.alarm_fill,
                            color: Colors.black,
                            size: 14.0,
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            'You have 7 tasks today',
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 60.0),
              (cards.isEmpty
                  ? Container()
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
                        cardBuilder: (
                          context,
                          index,
                          horizontalThresholdPercentage,
                          verticalThresholdPercentage,
                        ) =>
                            cards[index],
                      ),
                    )),
              const SizedBox(height: 30.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Coming up',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 12.0),
                    Text('${tasks.length} tasks',
                        style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: (taskWidgets.length / 2 + 1).toInt() * 155.0 + 180,
                child: GridView.count(
                  padding: const EdgeInsets.only(left: 5.0, right: 5, top: 20),
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: [
                    ...taskWidgets,
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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
}
