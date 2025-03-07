import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../log.dart';
import 'create_by_mail.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final data = {
        'name': _nameController.text.trim(),
        'surname': _surnameController.text.trim(),
        'dob': _dobController.text,
        'phone': _phoneController.text.trim(),
        'password': _passwordController.text,
      };

      const url = 'http://172.30.49.83:3000/signup';

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (!mounted) return;

      if (response.statusCode == 201) {
        _showSnackBar('สมัครสมาชิกสำเร็จ', isSuccess: true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        final errorData = json.decode(response.body);
        _showSnackBar(errorData['message'] ?? 'เกิดข้อผิดพลาด');
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4EFE7),
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Smart Buff',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
              backgroundColor: const Color(0xFFE4EFE7),
              elevation: 0,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'สร้างบัญชีด้วยเบอร์โทรศัพท์',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField('ชื่อ', _nameController),
                      _buildTextField('นามสกุล', _surnameController),
                      _buildDatePicker('วันเกิด'),
                      _buildPhoneField('เบอร์โทรศัพท์'),
                      _buildPasswordField('รหัสผ่าน'),
                      _buildPasswordField('ยืนยันรหัสผ่าน', isConfirm: true),
                      const SizedBox(height: 18),
                      _buildSubmitButton(),
                      const SizedBox(height: 18),
                      _buildEmailSignUpButton(),
                    ],
                  ),
                ),
              ),
            ),
            _buildLoginLink(), // Moved to the bottom of the screen
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
      child: SizedBox(
        width: 400, // Set a specific width (e.g., 300 pixels) to reduce width
        child: TextFormField(
          controller: controller,
          decoration: _inputDecoration(label).copyWith(
            fillColor: Colors.white, // Keep white background
            filled: true, // Keep fill enabled
          ),
          validator: (value) => value?.trim().isEmpty ?? true ? '$label is required' : null,
        ),
      ),
      ),
    );
  }

  Widget _buildDatePicker(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
      child: SizedBox(
        width: 400,
        child: TextFormField(
        controller: _dobController,
        decoration: _inputDecoration(label).copyWith(
          fillColor: Colors.white, // Add white background
          filled: true, // Enable the fill color
        ),
        readOnly: true,
        onTap: _selectDate,
        validator: (value) => value?.isEmpty ?? true ? '$label is required' : null,
      ),
      ),
      ),
    );
  }

  Widget _buildPhoneField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
      child: SizedBox(
        width: 400,
        child: TextFormField(
        controller: _phoneController,
        decoration: _inputDecoration(label).copyWith(
          fillColor: Colors.white, // Add white background
          filled: true, // Enable the fill color
        ),
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value?.isEmpty ?? true ) {
            return 'กรุณากรอกเบอร์โทรที่ถูกต้อง';
          }
          return null;
        },
      ),
    ),
      ),
    );
  }

  Widget _buildPasswordField(String label, {bool isConfirm = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
      child: SizedBox(
        width: 400,
        child: TextFormField(
        controller: isConfirm ? _confirmPasswordController : _passwordController,
        obscureText: !_passwordVisible,
        decoration: _inputDecoration(label).copyWith(
          fillColor: Colors.white,
          filled: true,
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey[600],
            ),
            onPressed: _togglePasswordVisibility,
          ),
        ),
        validator: (value) {
          if (value?.isEmpty ?? true) return '$label is required';
          if (isConfirm && value != _passwordController.text) {
            return 'รหัสผ่านไม่ตรงกัน';
          }
          return null;
        },
      ),
    ),),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: SizedBox(
        width: 400, // Set a specific width of 400 pixels
        child: ElevatedButton(
          onPressed: _isLoading ? null : _submitForm,
          style: _buttonStyle(),
          child: _isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : const Text('สร้างบัญชี', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildEmailSignUpButton() {
    return Center(
        child: SizedBox(
        width: 400,
    child : ElevatedButton(
      onPressed: _isLoading
          ? null
          : () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUpScreen2()),
      ),
      style: _buttonStyle(),
      child: const Text('สมัครด้วยอีเมล', style: TextStyle(color: Colors.white)),
    ),
    ),
    );
  }

  Widget _buildLoginLink() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0), // Add some padding from the bottom
        child: TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          ),
          child: const Text(
            'ฉันมีบัญชีแล้ว',
            style: TextStyle(
              color: Color(0xFF2E742B),
              fontSize: 16,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFF2E742B)// Add underline
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF2E742B), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 50),
      backgroundColor: const Color(0xFF2E742B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      elevation: 0,
    );
  }

  void _togglePasswordVisibility() => setState(() => _passwordVisible = !_passwordVisible);

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E742B),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xFF2E742B)),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && mounted) {
      setState(() {
        _dobController.text = pickedDate.toLocal().toIso8601String().split('T')[0];
      });
    }
  }
}