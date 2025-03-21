import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'reminderScreen.dart';
import 'statistic.dart';
import 'settings.dart';

void main() {
  runApp(const WRApp());
}

class WRApp extends StatefulWidget {
  const WRApp({super.key});

  @override
  _WRAppState createState() => _WRAppState();
}

class _WRAppState extends State<WRApp> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  void _toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
    setState(() {
      _isDarkMode = isDark;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        body: _selectedIndex == 2
            ? SettingsScreen(
                isDarkMode: _isDarkMode,
                onDarkModeChanged: _toggleTheme,
              )
            : _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: "Trang chủ"),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Lịch sử"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Cài đặt"),
          ],
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }

  List<Widget> get _screens => [
        ReminderScreen(),
        StatisticScreen(),
        SettingsScreen(
          isDarkMode: _isDarkMode,
          onDarkModeChanged: _toggleTheme,
        ),
      ];
}
