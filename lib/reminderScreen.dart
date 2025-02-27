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

  @override
  void initState() {
    super.initState();
    initializeDateFormatting().then((_) {
      _loadLanguage();
    });
  }

  void _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _language = prefs.getString('language_code') ?? 'vi';
    });
  }

  void _changeLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', langCode);
    setState(() {
      _language = langCode;
    });
  }

  String getTodayDate() {
    DateTime now = DateTime.now();
    return _language == 'vi'
        ? "Hôm nay là ${DateFormat('dd MMMM', 'vi').format(now)}"
        : "Today is ${DateFormat('dd MMM', 'en').format(now)}";
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 62, 46, 188),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("Cài đặt",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            Divider(),
            ListTile(
              title: Text("Ngôn ngữ", style: TextStyle(color: Colors.black)),
              trailing: DropdownButton<String>(
                value: _language,
                dropdownColor: Colors.white,
                items: [
                  DropdownMenuItem(
                    value: 'vi',
                    child: Text("Tiếng Việt",
                        style: TextStyle(color: Colors.black)),
                  ),
                  DropdownMenuItem(
                    value: 'en',
                    child:
                        Text("English", style: TextStyle(color: Colors.black)),
                  ),
                ],
                onChanged: (newLang) {
                  if (newLang != null) {
                    _changeLanguage(newLang);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            ListTile(
              title: Text("Thông báo", style: TextStyle(color: Colors.black)),
              trailing: Switch(
                  value: true,
                  onChanged: null,
                  inactiveThumbColor: Colors.blue),
            ),
            ListTile(
              title: Text("Chế độ tối", style: TextStyle(color: Colors.black)),
              trailing: Switch(value: false, onChanged: null),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = 0.55;
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
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () => _showSettingsBottomSheet(context),
          ),
        ],
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
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InfoCard(
                  title: _language == 'vi' ? "Đã hoàn thành:" : "Done:",
                  value: "21 oz",
                  icon: Icons.check_circle),
              SizedBox(width: 20),
              InfoCard(
                  title: _language == 'vi' ? "Mục tiêu:" : "Goals:",
                  value: "57 oz",
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
                  content: Text(_language == 'vi' ? "Cố lên, bạn đã hoàn thành 55% hôm nay!" : "Fightting, you have complete 55% today!"),
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
