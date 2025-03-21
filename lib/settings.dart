import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  const SettingsScreen({
    Key? key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _language = 'vi';
  double _weight = 56;
  bool _notifications = true;
  int _waterGoal = 2000;
  String _wakeUpTime = "07:00";
  String _sleepTime = "22:00";

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _language = prefs.getString('language_code') ?? 'vi';
      _weight = prefs.getDouble('user_weight') ?? 56;
      _notifications = prefs.getBool('notifications') ?? true;
      _waterGoal = prefs.getInt('water_goal') ?? 2000;
      _wakeUpTime = prefs.getString('wake_up_time') ?? "07:00";
      _sleepTime = prefs.getString('sleep_time') ?? "22:00";
    });
  }

  String t(String vi, String en) {
    return _language == 'vi' ? vi : en;
  }

  void _updateSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t("Cài đặt", "Settings"))),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          ListTile(
            title: Text(t("Ngôn ngữ", "Language")),
            trailing: DropdownButton<String>(
              value: _language,
              items: [
                DropdownMenuItem(value: 'vi', child: Text("Tiếng Việt")),
                DropdownMenuItem(value: 'en', child: Text("English")),
              ],
              onChanged: (newLang) {
                if (newLang != null) {
                  _updateSetting('language_code', newLang);
                  setState(() => _language = newLang);
                }
              },
            ),
          ),
          SwitchListTile(
            title: Text(t("Thông báo", "Notifications")),
            value: _notifications,
            onChanged: (value) {
              _updateSetting('notifications', value);
              setState(() => _notifications = value);
            },
          ),
          SwitchListTile(
            title: Text(t("Chế độ tối", "Dark Mode")),
            value: widget.isDarkMode,
            onChanged: (value) {
              widget.onDarkModeChanged(value);
            },
          ),
          ListTile(
            title: Text(t("Cân nặng", "Weight")),
            trailing: Text("$_weight kg", style: TextStyle(color: Colors.blue)),
            onTap: () async {
              double? newWeight = await showDialog(
                context: context,
                builder: (context) {
                  double tempWeight = _weight;
                  return StatefulBuilder(
                    builder: (context, setModalState) { // Thêm StatefulBuilder
                      return AlertDialog(
                        title: Text(t("Chỉnh sửa cân nặng", "Edit Weight")),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Slider(
                              value: tempWeight,
                              min: 30,
                              max: 150,
                              divisions: 120,
                              label: "${tempWeight.round()} kg",
                              onChanged: (value) {
                                setModalState(() { // Cập nhật giá trị slider
                                  tempWeight = value;
                                });
                              },
                            ),
                            Text("${tempWeight.round()} kg", style: TextStyle(fontSize: 18, color: Colors.blue)),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, null),
                            child: Text(t("Hủy", "Cancel")),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, tempWeight),
                            child: Text(t("Lưu", "Save")),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
              if (newWeight != null) {
                _updateSetting('user_weight', newWeight);
                setState(() => _weight = newWeight);
              }
            },
          ),
          ListTile(
            title: Text(t("Mục tiêu nước uống", "Water Intake Goal")),
            trailing: Text("$_waterGoal ml", style: TextStyle(color: Colors.blue)),
            onTap: () {
              _updateSetting('water_goal', _waterGoal + 100);
              setState(() => _waterGoal += 100);
            },
          ),
          ListTile(
            title: Text(t("Giờ thức dậy", "Wake-up Time")),
            trailing: Text(_wakeUpTime, style: TextStyle(color: Colors.blue)),
            onTap: () async {
              TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                  hour: int.parse(_wakeUpTime.split(":")[0]),
                  minute: int.parse(_wakeUpTime.split(":")[1]),
                ),
              );
              if (picked != null) {
                String newTime = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
                _updateSetting('wake_up_time', newTime);
                setState(() => _wakeUpTime = newTime);
              }
            },
          ),
          ListTile(
            title: Text(t("Giờ đi ngủ", "Sleep Time")),
            trailing: Text(_sleepTime, style: TextStyle(color: Colors.blue)),
            onTap: () async {
              TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                  hour: int.parse(_sleepTime.split(":")[0]),
                  minute: int.parse(_sleepTime.split(":")[1]),
                ),
              );
              if (picked != null) {
                String newTime = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
                _updateSetting('sleep_time', newTime);
                setState(() => _sleepTime = newTime);
              }
            },
          ),
        ],
      ),
    );
  }
}
