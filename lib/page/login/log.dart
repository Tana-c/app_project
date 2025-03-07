import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'create_user/create_by_phone.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _phoneOrEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    final emailOrPhone = _phoneOrEmailController.text;
    final password = _passwordController.text;
    final scaffoldMessenger = ScaffoldMessenger.of(context); // เก็บ state ไว้ก่อน await

    final url = 'http://172.30.49.83:3000/login';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'emailOrPhone': emailOrPhone,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (!mounted) return; // ป้องกันการใช้ context หลังจาก async

    final data = json.decode(response.body);
    if (response.statusCode == 200 && data['message'] == 'Login successful') {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'เกิดข้อผิดพลาด')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/bg.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 30),
              const Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('lib/images/logo.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Smart Buff',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'ลงชื่อเข้าใช้งาน',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _phoneOrEmailController,
                        decoration: InputDecoration(
                          labelText: 'หมายเลขโทรศัพท์หรืออีเมล',
                          labelStyle: const TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'กรุณากรอกหมายเลขโทรศัพท์หรืออีเมล',
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.phone, color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black26),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกหมายเลขโทรศัพท์หรืออีเมล';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'รหัสผ่าน',
                          labelStyle: const TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'กรุณากรอกรหัสผ่าน',
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.lock, color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black26),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกรหัสผ่าน';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _login(); // เรียกใช้ฟังก์ชันการเข้าสู่ระบบ
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2e742b),
                        ),
                        child: const Text('เข้าสู่ระบบ', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 0),
              Center(
                child: SizedBox(
                  width: 300, // Fixed width of 400 pixels
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50), // Full width within 400px, 50 height
                      backgroundColor: Colors.white, // White background
                      foregroundColor: const Color(0xFF2E742B), // Green text color (for disabled state, but we use it for border)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Highly rounded corners for oval shape
                        side: const BorderSide(color: Color(0xFF2E742B), width: 2), // Green border
                      ),
                      elevation: 0, // No shadow for flat look
                    ),
                    child: const Text(
                      'สร้างบัญชีใหม่',
                      style: TextStyle(
                        color: Color(0xFF2E742B), // Green text color
                        fontSize: 16, // Match the font size in the image
                        fontWeight: FontWeight.normal, // Normal weight for consistency
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
