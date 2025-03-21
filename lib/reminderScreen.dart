import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  String _language = 'vi';
  int _currentWaterIntake = 0;
  late int _totalWaterGoal;
  double _weight = 56; // Mặc định
  double get progress => _currentWaterIntake / _totalWaterGoal;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting().then((_) {
      _loadSettings();
    });
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _language = prefs.getString('language_code') ?? 'vi';
      _weight = prefs.getDouble('user_weight') ?? 56;
      _calculateWaterGoal();
    });
  }

  void _calculateWaterGoal() {
    _totalWaterGoal = ((_weight * 2.205 * 0.5) / 33.8 * 1000).round();
  }

  void _addWater() {
    setState(() {
      if (_currentWaterIntake < _totalWaterGoal) {
        _currentWaterIntake += 250; // Mỗi lần nhấn +250ml
      }
    });
  }

  String getTodayDate() {
    DateTime now = DateTime.now();
    return _language == 'vi'
        ? "Hôm nay là ${DateFormat('dd MMMM', 'vi').format(now)}"
        : "Today is ${DateFormat('dd MMM', 'en').format(now)}";
  }
  
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 104, 57, 212),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(_language == 'vi' ? "Nhắc nhở uống nước" : "Water Reminder",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 4.0,
                    color: Colors.black,
                    offset: Offset(5, 5),
                  ),
                ],
              )),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _language == 'vi'
                      ? "Xin chào 👋!\n${getTodayDate()}"
                      : "Hi there 👋!\n${getTodayDate()}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: _addWater,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: Size(200, 200),
                      painter: MiddleCircle(progress),
                    ),
                    Text("${(progress * 100).toInt()}%",
                        style: TextStyle(
                            fontSize: 36,
                            color: const Color.fromARGB(255, 33, 6, 77))),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InfoCard(
                    title: _language == 'vi' ? "Đã hoàn thành:" : "Done:",
                    value: "${_currentWaterIntake} ml",
                    icon: Icons.check_circle),
                SizedBox(width: 20),
                InfoCard(
                    title: _language == 'vi' ? "Mục tiêu:" : "Goals:",
                    value: "${_totalWaterGoal} ml",
                    icon: Icons.flag_circle),
              ],
            ),
            Spacer(),
            FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(_language == 'vi' ? "Chào đằng ấy!" : "Hi there!"),
                    content: Text(_language == 'vi'
                        ? "Cố lên, bạn đã hoàn thành ${(progress * 100).toInt()}% hôm nay!"
                        : "Fighting, you have completed ${(progress * 100).toInt()}% today!"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.water_drop, size: 30),
            ),
            SizedBox(height: 20),
          ],
        ),
      );
    }
  }


class MiddleCircle extends CustomPainter {
  final double progress;
  MiddleCircle(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()..color = Color.fromARGB(255, 190, 229, 249);
    Paint wavePaint = Paint()..color = Colors.lightBlueAccent;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, circlePaint);

    Path wavePath = Path();
    double waveHeight = size.height * (1 - progress);
    for (double i = 0; i < size.width; i += 1) {
      wavePath.lineTo(i, waveHeight + sin(i * 0.05) * 10);
    }
    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    canvas.clipPath(
        Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height)));
    canvas.drawPath(wavePath, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const InfoCard(
      {super.key,
      required this.title,
      required this.value,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepPurple.shade800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueAccent),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
                Text(value,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
