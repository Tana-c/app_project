  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;
  import 'dart:convert';

  class InfoUserScreen extends StatefulWidget {
    final int userId;

    const InfoUserScreen({super.key, required this.userId});

    @override
    State<InfoUserScreen> createState() => _InfoUserScreenState();
  }

  class _InfoUserScreenState extends State<InfoUserScreen> {
    Map<String, dynamic> userData = {};

    @override
    void initState() {
      super.initState();
      fetchUserData();
    }

    Future<void> fetchUserData() async {
      final response = await http.get(
        Uri.parse('http://192.168.188.45:3000/api/user/${widget.userId}'),
      );

      if (!mounted) return; // ป้องกัน context ที่ไม่ถูกต้อง

      if (response.statusCode == 200) {
        setState(() {
          userData = jsonDecode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load user data')),
        );
      }
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context); // Go back to the previous screen
            },
          ),
          title: const Text(
            'ข้อมูลผู้ใช้',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          color: Colors.lightGreen[50], // Light green background as in the screenshot
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Picture
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: userData['profile_picture'] != null
                          ? NetworkImage(userData['profile_picture']) // Load image from URL
                          : const AssetImage('assets/default_profile.png') as ImageProvider, // Fallback image
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Name and Surname
              ListTile(
                title: const Text('ชื่อ นามสกุล'),
                subtitle: Text('${userData['name'] ?? ''} ${userData['surname'] ?? ''}'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Add navigation or action for name/surname (optional)
                },
              ),
              // Email or Phone
              ListTile(
                title: const Text('อีเมล หรือ โทรศัพท์'),
                subtitle: Text(userData['email'] ?? userData['phone'] ?? ''),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Add navigation or action for email/phone (optional)
                },
              ),
              // Date of Birth
              ListTile(
                title: const Text('วันเกิด'),
                subtitle: Text(userData['dob']?.toString() ?? ''),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Add navigation or action for DOB (optional)
                },
              ),
            ],
          ),
        ),
      );
    }
  }