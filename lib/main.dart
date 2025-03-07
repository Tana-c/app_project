import 'package:app_project/page/Control_Center/control_center.dart';
import 'package:app_project/page/Control_Center/profile/info_user.dart';
import 'package:app_project/page/login/log.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Buff',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/', // Start with the login page
      routes: {
        '/': (context) => LoginPage(), // Login screen
        '/main': (context) => ControlCenter(), // Control center
        '/info_user': (context) => InfoUserScreen(userId: 1), // User info screen (default user ID)
      },
    );
  }
}