import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'reminderScreen.dart';

class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int _currentStep = 0;
  String _gender = 'Nam';
  int _weight = 50;
  String _language = 'vi';
  
  TimeOfDay _wakeUpTime = TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _sleepTime = TimeOfDay(hour: 23, minute: 0);

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

  void _changeLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', lang);
    setState(() {
      _language = lang;
    });
  }

  String t(String vi, String en) {
    return _language == 'vi' ? vi : en;
  }
  
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gender', _gender);
    await prefs.setInt('weight', _weight);
    await prefs.setString('wakeUpTime', _wakeUpTime.format(context));
    await prefs.setString('sleepTime', _sleepTime.format(context));
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isWakeUpTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isWakeUpTime ? _wakeUpTime : _sleepTime,
    );
    if (pickedTime != null) {
      setState(() {
        if (isWakeUpTime) {
          _wakeUpTime = pickedTime;
        } else {
          _sleepTime = pickedTime;
        }
      });
    }
  }

List<Widget> _buildSteps() {
  return [
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          t("Giới tính của bạn", "Your gender"),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _genderOption(t("Nam", "Male"), Icons.male),
            SizedBox(width: 40),
            _genderOption(t("Nữ", "Female"), Icons.female),
          ],
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          t("Cân nặng của bạn", "Your weight"),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Container(
          height: 150,
          child: CupertinoPicker(
            itemExtent: 40,
            onSelectedItemChanged: (int value) {
              setState(() {
                _weight = value + 30;
              });
            },
            children: List.generate(
              91,
              (index) => Text("${index + 30} kg", style: TextStyle(fontSize: 20)),
            ),
          ),
        ),
        Text(
          "${_weight} kg",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    ),

    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          t("Thời gian thức dậy", "Wake-up Time"),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _selectTime(context, true),
          child: Text("${t("Chọn giờ", "Select Time")}: ${_wakeUpTime.format(context)}"),
        ),
      ],
    ),

    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          t("Thời gian đi ngủ", "Sleep Time"),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _selectTime(context, false),
          child: Text("${t("Chọn giờ", "Select Time")}: ${_sleepTime.format(context)}"),
        ),
      ],
    ),
  ];
}

  Widget _genderOption(String gender, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _gender = gender;
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: _gender == gender ? Colors.blue : Colors.grey[300],
            child: Icon(icon, size: 40, color: _gender == gender ? Colors.white : Colors.black),
          ),
          SizedBox(height: 10),
          Text(gender, style: TextStyle(fontSize: 18, color: _gender == gender ? Colors.blue : Colors.black)),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    List<IconData> icons = [Icons.person, Icons.fitness_center, Icons.wb_sunny, Icons.nightlight_round];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _currentStep == index ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icons[index], color: _currentStep == index ? Colors.white : Colors.black),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_language == 'vi' ? "Thiết lập thông tin" : "Setup Information"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              _changeLanguage(value);
            },
            icon: Row(
              children: [
                Image.network(
                  _language == 'vi'
                      ? 'https://st.quantrimang.com/photos/image/2021/09/05/Co-Vietnam.png'
                      : 'https://tse2.mm.bing.net/th?id=OIP.Xw6xskosUxZSMtpKTclZMAHaEc&pid=Api&P=0&h=180',
                  width: 30,
                  height: 20,
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'vi',
                child: Row(
                  children: [
                    Image.network(
                      'https://st.quantrimang.com/photos/image/2021/09/05/Co-Vietnam.png',
                      width: 30,
                      height: 20,
                    ),
                    SizedBox(width: 8),
                    Text("Tiếng Việt"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'en',
                child: Row(
                  children: [
                    Image.network(
                      'https://tse2.mm.bing.net/th?id=OIP.Xw6xskosUxZSMtpKTclZMAHaEc&pid=Api&P=0&h=180',
                      width: 30,
                      height: 20,
                    ),
                    SizedBox(width: 8),
                    Text("English"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10), 
          _buildProgressIndicator(), 
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(child: _buildSteps()[_currentStep]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentStep > 0)
              ElevatedButton(
                onPressed: _prevStep,
                child: Row(children: [Icon(Icons.arrow_back), Text(t(" Quay lại", "Back")),]),
              )
            else
              SizedBox(width: 100),
            ElevatedButton(
              onPressed: () {
                if (_currentStep < 3) {
                  setState(() {
                    _currentStep++;
                  });
                } else {
                  _savePreferences();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ReminderScreen()),
                  );
                }
              },
              child: Row(
                children: [
                  Text(_currentStep == 3 ? t("Hoàn tất", "Finish") : t("Tiếp theo ", "Next")),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
