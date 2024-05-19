import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String _username = 'Username';
  bool _isReminderOn = false;
  TimeOfDay _selectedTime = TimeOfDay(hour: 8, minute: 0); // Default reminder time

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Initialize time zones
    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50), // Add some space at the top
              CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('assets/profile_icon.png'), // Add your profile icon here
                backgroundColor: Colors.grey[800],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.white, width: 1.0),
                    ),
                    child: Text(
                      _username,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50), // Add some space between username and settings
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(color: Colors.white, thickness: 0.3),
              ListTile(
                title: Text(
                  'Daily Reminder',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Switch(
                  value: _isReminderOn,
                  onChanged: (value) {
                    _toggleReminder(value, context);
                  },
                ),
              ),
              if (_isReminderOn)
                ListTile(
                  title: Text(
                    'Select Time',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: TextButton(
                    onPressed: () {
                      _selectTime(context);
                    },
                    child: Text(
                      _selectedTime.format(context),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              // Add more settings options here
            ],
          ),
        ),
      ),
    );
  }

  void _toggleReminder(bool value, BuildContext context) {
    setState(() {
      _isReminderOn = value;
    });
    if (value) {
      _selectTime(context);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
      _scheduleNotification();
    }
  }

  Future<void> _scheduleNotification() async {
    // Get the current time in your local time zone
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    // Calculate the scheduled time in your local time zone
    final tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );


    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'daily_reminder_channel',
      'Daily Reminder',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'app_icon',
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Expense Tracker',
        'Don\'t forget to track your expenses!',
        scheduledDate,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
    }
  }
}