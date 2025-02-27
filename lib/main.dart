import 'package:flutter/material.dart';
import 'reminderScreen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, 
    home: wr_app()));
}

class wr_app extends StatelessWidget {
  const wr_app({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: ReminderScreen(), 
    );
  }
}
