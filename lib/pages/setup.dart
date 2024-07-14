import 'package:flutter/material.dart';
import 'package:notes_app/utils/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setup extends StatefulWidget {
  final Function() onContinue;
  const Setup({super.key, required this.onContinue});

  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  final _nameController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _prefs.then((value) {
      prefs = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 80,
                ),
                SizedBox(
                    height: 250,
                    child: Image.asset('assets/images/welcome.jpg')),
                const Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 80),
                const Text(
                  'Please enter your name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 60,
                  child: TextField(
                    controller: _nameController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'Your name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF896F),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: (nameValid(_nameController.text)
                      ? () {
                          prefs.setString('name', _nameController.text.trim());
                          prefs.setBool('isInitialized', true);
                          widget.onContinue();
                        }
                      : null),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
