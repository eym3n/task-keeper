import 'package:floating_navbar/floating_navbar.dart';
import 'package:floating_navbar/floating_navbar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/pages/home.dart';
import 'package:notes_app/pages/notes.dart';
import 'package:notes_app/pages/tasks.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return FloatingNavBar(
      borderRadius: 40,
      resizeToAvoidBottomInset: false,
      color: Colors.black,
      hapticFeedback: false,
      items: [
        FloatingNavBarItem(
          iconData: CupertinoIcons.house,
          title: 'Home',
          page: const HomePage(),
        ),
        FloatingNavBarItem(
          iconData: CupertinoIcons.calendar,
          title: 'Tasks',
          page: const TasksPage(),
        ),
        FloatingNavBarItem(
          iconData: CupertinoIcons.create_solid,
          title: 'Tasks',
          page: const NotesPage(),
        ),
      ],
      selectedIconColor: Colors.white,
      horizontalPadding: 90,
    );
  }
}
