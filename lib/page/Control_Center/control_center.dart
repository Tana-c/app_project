import 'package:flutter/material.dart';

import 'History/history.dart';
import 'Home/home.dart';
import 'Notifications/notifications.dart';

class ControlCenter extends StatefulWidget {
  const ControlCenter({super.key});

  @override
  State<ControlCenter> createState() => _ControlCenterState();
}

class _ControlCenterState extends State<ControlCenter> {
  int _selectedIndex = 0;

  // List of pages for navigation
  static final List<Widget> _pages = <Widget>[
    HomeScreen(), // home.dart
    HistoryScreen(), // history.dart
    NotificationsScreen(), // notifications.dart
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Function to handle logout
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ออกจากระบบ'),
        content: const Text('คุณต้องการออกจากระบบหรือไม่?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              // Add your logout logic here (e.g., clearing user data, navigating to login screen)
              Navigator.of(context).pop(); // Close the dialog
              // Example: Navigate to login screen
              Navigator.pushReplacementNamed(context, '/login'); // Replace '/login' with your login route
            },
            child: const Text('ยืนยัน'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                // Navigate to info_user.dart
                Navigator.pushNamed(context, '/info_user');
              },
              child: const CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 15,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'SmartBuff',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.output, color: Colors.white),
            onPressed: _showLogoutDialog, // Trigger the logout confirmation dialog
          ),
        ],
      ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'ประวัติ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'การแจ้งเตือน',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Placeholder classes for the other pages (replace with actual implementations)

