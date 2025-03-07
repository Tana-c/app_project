import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';


class AddBuffaloScreen extends StatefulWidget {
  const AddBuffaloScreen({super.key}); // ใช้ super parameter

  @override
  State<AddBuffaloScreen> createState() => AddBuffaloScreenState();
}


class AddBuffaloScreenState extends State<AddBuffaloScreen> {
  final _formKey = GlobalKey<FormState>();
  String buffaloId = ''; // รหัสกระบือ
  String birthDate = ''; // วันเดือนปีเกิด
  String age = ''; // อายุ
  String weight = ''; // น้ำหนัก
  String diseases = ''; // โรคของกระบือ
  File? _image; // ไฟล์ภาพกระบือ

  final ImagePicker _picker = ImagePicker();

  // ฟังก์ชันเลือกภาพจากกล้องหรือแกลเลอรี
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> addBuffalo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var request = http.MultipartRequest('POST', Uri.parse('http://192.168.163.45:3000/add-buffalo'));

      request.fields['buffaloId'] = buffaloId;
      request.fields['birthDate'] = birthDate;
      request.fields['age'] = age;
      request.fields['weight'] = weight;
      request.fields['diseases'] = diseases;

      if (_image != null) {
        request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
      }

      try {
        final response = await request.send();

        if (!mounted) return; // ตรวจสอบก่อนใช้ context

        if (response.statusCode == 201) {
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('เพิ่มข้อมูลกระบือสำเร็จ')),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('เพิ่มข้อมูลไม่สำเร็จ')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลกระบือ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // เพิ่มเพื่อรองรับการเลื่อนเมื่อฟอร์มยาว
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'รหัสกระบือ'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกรหัสกระบือ';
                    }
                    return null;
                  },
                  onSaved: (value) => buffaloId = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'วันเดือนปีเกิด (เช่น 20/02/68)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกวันเดือนปีเกิด';
                    }
                    return null;
                  },
                  onSaved: (value) => birthDate = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'อายุ (ปี)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกอายุ';
                    }
                    return null;
                  },
                  onSaved: (value) => age = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'น้ำหนัก (กิโลกรัม)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกน้ำหนัก';
                    }
                    return null;
                  },
                  onSaved: (value) => weight = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'โรคของกระบือ'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกโรคของกระบือ';
                    }
                    return null;
                  },
                  onSaved: (value) => diseases = value!,
                ),
                SizedBox(height: 20),
                // ช่องสำหรับเลือกและแสดงภาพ
                _image == null
                    ? ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('เลือกภาพกระบือ'),
                )
                    : Column(
                  children: [
                    Image.file(
                      _image!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('เปลี่ยนภาพ'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity, // ทำให้ปุ่มกว้างเต็มหน้าจอ
                  height: 60, // ความสูงตามภาพ
                  decoration: BoxDecoration(
                    color: Color(0xFFE4EFE7), // ใช้สีพื้นหลังตามที่ระบุ
                    borderRadius: BorderRadius.circular(12), // ขอบมน
                    border: Border.all(color: Color(0xFF2E742B), width: 2), // เส้นขอบสีเขียวเข้ม
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: addBuffalo,
                      borderRadius: BorderRadius.circular(12),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: 30, // ขนาดไอคอน +
                              color: Color(0xFF2E742B), // ใช้สีเขียวเข้ม #2E742B
                            ),
                            Text(
                              'เพิ่มข้อมูลกระบือ',
                              style: TextStyle(
                                color: Color(0xFF2E742B), // ใช้สีเขียวเข้ม #2E742B
                                fontSize: 14, // ขนาดข้อความ
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}