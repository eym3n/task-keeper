import 'package:flutter/material.dart';
import 'package:notes_app/pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0x00ff896f)),
          useMaterial3: true,
          fontFamily: 'Poppins'),
      home: const MainPage(),
    );
  }
}
