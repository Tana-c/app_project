import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});


  @override
  Widget build(BuildContext context) {
    // Sample notification data matching the image
    final List<Map<String, String>> notifications = [
      {
        'image': 'assets/buffalo1.jpg',
        'title': 'ควายท้องถิ่น',
        'details': 'ได้รับ 5 คะแนน สิ้นสุดการแจ้งเตือน 3 วัน',
        'time': '20/02/68 09:00 น.'
      },
      {
        'image': 'assets/buffalo2.jpg',
        'title': 'ควายสวยงาม',
        'details': 'ได้รับ 1 คะแนน สิ้นสุดการแจ้งเตือน 3 วัน',
        'time': '20/02/68 10:00 น.'
      },
    ];

    return Scaffold(

      body: SafeArea(
        child: Container(
          color: Colors.grey[200], // Light grey background as shown in image
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'การแจ้งเตือน',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: notifications.isEmpty
                      ? Center(
                    child: Text(
                      'ไม่มีการแจ้งเตือน',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                      : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return Card(
                        elevation: 1,
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            notification['image']!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(notification['title']!),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(notification['details']!),
                              const SizedBox(height: 4),
                              Text(
                                notification['time']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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