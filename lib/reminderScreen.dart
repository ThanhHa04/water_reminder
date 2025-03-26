import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'statistic.dart';  // Import the Statistic Screen
import 'settings.dart';   // Import the Settings Screen

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  String _language = 'vi';
  int _currentWaterIntake = 0;
  late int _waterGoal;
  double _weight = 56; // Mặc định
  double get progress => _currentWaterIntake / _waterGoal;
  int _selectedIndex = 0; // Dùng để xác định trang hiện tại

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
    _waterGoal = ((_weight * 2.205 * 0.5) / 33.8 * 1000).round();
  }

  void _addWater() {
    setState(() {
      if (_currentWaterIntake < _waterGoal) {
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật chỉ mục trang khi nhấn vào biểu tượng
    });
  }

  @override
  Widget build(BuildContext context) {
    // Danh sách các trang
    List<Widget> _pages = [
      Column(
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
                  value: "${_waterGoal} ml",
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
      StatisticScreen(), // Chuyển sang màn hình Statistic
      SettingsScreen(
        isDarkMode: false,  // Trạng thái chế độ tối
        onDarkModeChanged: (bool value) {
          // Xử lý khi thay đổi chế độ tối
        },
        initialLanguage: 'vi',  // Ngôn ngữ mặc định
        initialWeight: 56,  // Cân nặng mặc định
        initialNotifications: true,  // Thông báo mặc định
        initialWaterGoal: 1960,  // Mục tiêu nước mặc định (56 * 35)
        initialWakeUpTime: '07:00 AM',  // Giờ thức dậy mặc định
        initialSleepTime: '10:00 PM',  // Giờ đi ngủ mặc định
      ),
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 104, 57, 212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _language == 'vi' ? "Nhắc nhở uống nước" : "Water Reminder",
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
          ),
        ),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex], // Hiển thị trang tương ứng với chỉ mục
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.water_drop),
            label: 'Reminder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// Các widget và phần còn lại không thay đổi
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
