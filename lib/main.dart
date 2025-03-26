import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'reminderScreen.dart';
import 'welcome.dart'; // Đảm bảo rằng bạn đã tạo WelcomeScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(), // Chuyển đến màn hình chính
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasSeenWelcome = false;

  @override
  void initState() {
    super.initState();
    _loadWelcomeStatus(); // Kiểm tra trạng thái đã xem màn hình Welcome
  }

  void _loadWelcomeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hasSeenWelcome = prefs.getBool('hasSeenWelcome') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _hasSeenWelcome
          ? const ReminderScreen() // Nếu đã xem Welcome, hiển thị ReminderScreen
          : WelcomeScreen(onContinue: _markWelcomeSeen), // Nếu chưa, hiển thị WelcomeScreen
      bottomNavigationBar: _hasSeenWelcome
          ? BottomNavigationBar(
              currentIndex: 0, // Giữ trạng thái thanh menu
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Trang chủ',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: 'Lịch sử',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Cài đặt',
                ),
              ],
            )
          : null, // Không hiển thị BottomNavigationBar nếu chưa qua màn hình Welcome
    );
  }

  // Đánh dấu là đã xem màn hình Welcome
  void _markWelcomeSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenWelcome', true);
    setState(() {
      _hasSeenWelcome = true;
    });
  }
}
