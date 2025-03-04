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

double _weight = 50; // Cân nặng mặc định
String _wakeUpTime = "07:00";
String _bedTime = "23:00";


// Hàm hiển thị thanh trượt chỉnh cân nặng
void _showWeightSlider(BuildContext context) {
  double tempWeight = _weight;
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.all(20),
            height: 200,
            child: Column(
              children: [
                Text(
                  _language == 'vi' ? "Chỉnh sửa cân nặng" : "Adjust Weight",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: tempWeight,
                  min: 30,
                  max: 150,
                  divisions: 120,
                  label: "${tempWeight.round()} kg",
                  onChanged: (value) {
                    setModalState(() {
                      tempWeight = value;
                    });
                  },
                ),
                Text("${tempWeight.round()} kg",
                    style: TextStyle(fontSize: 18, color: Colors.blue)),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _weight = tempWeight.roundToDouble();
                    });
                    Navigator.pop(context);
                  },
                  child: Text(_language == 'vi' ? "Lưu" : "Save"),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

void _selectTime(BuildContext context, {required bool isWakeUp}) async {
  TimeOfDay initialTime = isWakeUp
      ? TimeOfDay(hour: 7, minute: 0)
      : TimeOfDay(hour: 23, minute: 0);
  TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: initialTime,
  );
  if (pickedTime != null) {
    String formattedTime =
        "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";

    setState(() {
      if (isWakeUp) {
        _wakeUpTime = formattedTime;
      } else {
        _bedTime = formattedTime;
      }
    });
  }
}

void _showSettingsBottomSheet(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    transitionDuration: Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.white,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 62, 46, 188),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(_language == 'vi' ? "Cài đặt" : "Settings",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Divider(),
                  ListTile(
                    title: Text(_language == 'vi' ? "Ngôn ngữ" : "Language", style: TextStyle(color: Colors.black)),
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
                          child: Text("English",
                              style: TextStyle(color: Colors.black)),
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
                    title: Text(_language == 'vi' ?"Thông báo" : "Notification", style: TextStyle(color: Colors.black)),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeColor: Colors.blue,
                    ),
                  ),
                  ListTile(
                    title: Text(_language == 'vi' ? "Chế độ tối" : "Dark mode", style: TextStyle(color: Colors.black)),
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {},
                      activeColor: Colors.blue,
                    ),
                  ),

                  Divider(),
                  ListTile(
                    title: Text(_language == 'vi' ? "Đơn vị" : "Unit", 
                        style: TextStyle(color: Colors.black)),
                    trailing: Text("kg, ml",
                        style: TextStyle(color: Colors.blue, fontSize: 16)),
                  ),
                  ListTile(
                    title: Text(_language == 'vi' ? "Cân nặng" : "Weight",
                        style: TextStyle(color: Colors.black)),
                    trailing: Text("$_weight kg",
                        style: TextStyle(color: Colors.blue, fontSize: 16)),
                    onTap: () => _showWeightSlider(context),
                  ),
                  ListTile(
                    title: Text(_language == 'vi' ? "Mục tiêu lượng nước uống" : "Water Intake Goal",
                        style: TextStyle(color: Colors.black)),
                    trailing: Text("${_calculateWaterIntake()} ml",
                        style: TextStyle(color: Colors.blue, fontSize: 16)),
                  ),

                  Divider(),
                  ListTile(
                    title: Text(_language == 'vi' ? "Giờ thức dậy" : "Wake-up Time",
                        style: TextStyle(color: Colors.black)),
                    trailing: Text(_wakeUpTime,
                        style: TextStyle(color: Colors.blue, fontSize: 16)),
                    onTap: () => _selectTime(context, isWakeUp: true),
                  ),
                  ListTile(
                    title: Text(_language == 'vi' ? "Giờ đi ngủ" : "Bedtime",
                        style: TextStyle(color: Colors.black)),
                    trailing: Text(_bedTime,
                        style: TextStyle(color: Colors.blue, fontSize: 16)),
                    onTap: () => _selectTime(context, isWakeUp: false),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: Offset(1, 0),
          end: Offset(0, 0),
        ).animate(animation),
        child: child,
      );
    },
  );
}

// Công thức tính lượng nước uống
int _calculateWaterIntake() {
  double waterIntakeLiters = (_weight * 2.205 * 0.5) / 33.8;
  return (waterIntakeLiters * 1000).round();
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
