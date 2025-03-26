import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'setup.dart';

class WelcomeScreen extends StatefulWidget {
  final VoidCallback onContinue;
  const WelcomeScreen({super.key, required this.onContinue});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String _language = 'vi';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  void _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _language = prefs.getString('language_code') ?? 'vi';
    });
  }

  String t(String vi, String en) {
    return _language == 'vi' ? vi : en;
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_drink, size: 100, color: isDarkMode ? Colors.white : Colors.white),
            const SizedBox(height: 20),
            Text(
              t("Chào mừng đến với Water Reminder", "Welcome to Water Reminder"),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              t("Hãy uống đủ nước mỗi ngày!", "Stay hydrated, stay healthy!"),
              style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('hasSeenWelcome', true);
                if (!context.mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SetupScreen()),
                );
              },
              child: Text(t("Tiếp tục", "Continue")),
            ),
          ],
        ),
      ),
    );
  }
}
