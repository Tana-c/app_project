import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add_buffalo_screen.dart'; // หน้าสำหรับเพิ่มข้อมูลกระบือ

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key}); // ใช้ super.key

  @override
  State<HomeScreen> createState() => HomeScreenState();
}


class HomeScreenState extends State<HomeScreen> {
  List<dynamic> buffaloes = []; // เก็บข้อมูลกระบือจาก API
  bool isLoading = true; // ตัวแปรสำหรับโหลดข้อมูล

  @override
  void initState() {
    super.initState();
    fetchBuffaloes(); // เรียกฟังก์ชันดึงข้อมูลเมื่อเริ่ม
  }

  // ฟังก์ชันดึงข้อมูลจาก API (สมมติว่าใช้ Node.js)
  Future<void> fetchBuffaloes() async {
    try {
      final response =
          await http.get(Uri.parse('http://your-backend-api.com/buffaloes'));
      if (response.statusCode == 200) {
        setState(() {
          buffaloes = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching buffaloes: $e'); // ใช้ debugPrint แทน
    }
  }

  @override
  Widget build(BuildContext context) {
    // ใช้สีจากที่คุณระบุ
    final baseColor = Color(0xFF2E742B); // สีเขียวเข้มตามที่ระบุ
    final lightShade = Color.fromRGBO(
      baseColor.r.toInt(), // แปลงเป็น int
      baseColor.g.toInt(), // แปลงเป็น int
      baseColor.b.toInt(), // แปลงเป็น int
      0.2, // ค่า opacity สามารถเป็น double ได้
    );




    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                height: 40, // ความสูงของช่องค้นหา
                width: 323, // ลดความกว้างของช่องค้นหาให้เข้ากับภาพ
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'ค้นหา',
                    prefixIcon: Icon(Icons.search, size: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // ขอบมน
                      borderSide: BorderSide(color: Colors.grey), // ขอบสีเทา
                    ),
                    filled: true,
                    fillColor: Colors.grey[200], // พพื้นหลังสีเทาอ่อน
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20), // ระยะห่างระหว่างช่องค้นหาและปุ่ม
          // ปุ่ม "เพิ่มข้อมูลกระบือ" ด้านบนของรายการ (ก่อน ListView)
          // ใน body ของ HomeScreen แทนที่ส่วนปุ่มเดิมด้วยส่วนนี้
          Container(
            width: 350, // ความกว้างของปุ่มชั้นนอกตามที่ระบุ
            height: 150, // ความสูงของปุ่มชั้นนอกตามที่ระบุ
            margin: EdgeInsets.symmetric(
                horizontal: 8.0, vertical: 8.0), // ระยะห่างจากขอบ
            decoration: BoxDecoration(
              color: lightShade, // ใช้สีอ่อนจาก #2E742B (เช่น เฉดสีเขียวอ่อน)
              borderRadius: BorderRadius.circular(12), // ขอบมน
              border: Border.all(
                  color: baseColor, width: 2), // เส้นขอบสีเขียวเข้ม #2E742B
            ),
            child: Container(
              width: 280, // ความกว้างของปุ่มชั้นในตามที่ระบุ
              height: 120, // ความสูงของปุ่มชั้นในตามที่ระบุ
              margin: EdgeInsets.symmetric(
                  horizontal: 8.0, vertical: 8.0), // ระยะห่างจากขอบ
              decoration: BoxDecoration(
                color: Color(0xFFE4EFE7), // ใช้สีพื้นหลังตามที่ระบุ
                borderRadius: BorderRadius.circular(12), // ขอบมน
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddBuffaloScreen()),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        size: 24, // รักษาขนาดไอคอนตามที่ระบุ
                        color: baseColor, // ใช้สีเขียวเข้ม #2E742B
                      ),
                      Text(
                        'เพิ่มข้อมูลกระบือ',
                        style: TextStyle(
                          color: baseColor, // ใช้สีเขียวเข้ม #2E742B
                          fontSize: 14, // รักษาขนาดข้อความตามที่ระบุ
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
    );
  }
}
