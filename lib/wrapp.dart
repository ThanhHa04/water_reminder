// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'reminderScreen.dart';
// import 'statistic.dart';
// import 'settings.dart';

// class WRApp extends StatefulWidget {
//   const WRApp({super.key});

//   @override
//   _WRAppState createState() => _WRAppState();
// }

// class _WRAppState extends State<WRApp> {
//   int _selectedIndex = 0;
//   bool _isDarkMode = false;

//   int? _waterGoal;
//   String _language = 'vi';
//   double _weight = 56;
//   bool _notifications = true;
//   String _wakeUpTime = "07:00";
//   String _sleepTime = "22:00";

//   @override
//   void initState() {
//     super.initState();
//     _loadTheme();
//     _loadSettings();
//   }

//   void _loadTheme() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _isDarkMode = prefs.getBool('isDarkMode') ?? false;
//     });
//   }

//   void _loadSettings() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _waterGoal = prefs.getInt('water_goal');
//       _language = prefs.getString('language_code') ?? 'vi';
//       _weight = prefs.getDouble('user_weight') ?? 56;
//       _notifications = prefs.getBool('notifications') ?? true;
//       _wakeUpTime = prefs.getString('wake_up_time') ?? "07:00";
//       _sleepTime = prefs.getString('sleep_time') ?? "22:00";
//     });
//   }

//   void _toggleTheme(bool isDark) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isDarkMode', isDark);
//     setState(() {
//       _isDarkMode = isDark;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_waterGoal == null) {
//       return Scaffold(
//         body: Center(child: CircularProgressIndicator()), // Loading nếu chưa load xong
//       );
//     }

//     return MaterialApp(
//       theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
//       home: Scaffold(
//         body: IndexedStack(
//           index: _selectedIndex,
//           children: _screens, // Hiển thị màn hình theo chỉ số được chọn
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: _selectedIndex,
//           onTap: (index) => setState(() => _selectedIndex = index),
//           items: const [
//             BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: "Trang chủ"),
//             BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Lịch sử"),
//             BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Cài đặt"),
//           ],
//           selectedItemColor: Colors.blueAccent,
//           unselectedItemColor: Colors.grey,
//         ),
//       ),
//     );
//   }

//   List<Widget> get _screens => [
//     ReminderScreen(waterGoal: _waterGoal!), // Truyền _waterGoal sau khi đảm bảo không null
//     StatisticScreen(),
//     SettingsScreen(
//       isDarkMode: _isDarkMode,
//       onDarkModeChanged: _toggleTheme,
//       initialLanguage: _language,
//       initialWeight: _weight,
//       initialNotifications: _notifications,
//       initialWaterGoal: _waterGoal!,
//       initialWakeUpTime: _wakeUpTime,
//       initialSleepTime: _sleepTime,
//     ),
//   ];
// }
