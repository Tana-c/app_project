import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});



  @override
  Widget build(BuildContext context) {
    // Sample history data matching the image
    final List<Map<String, String>> historyItems = [
      {
        'image': 'assets/buffalo1.jpg',
        'title': 'ควายท้องถิ่น',
        'time': '20/02/68 09:00 น.'
      },
      {
        'image': 'assets/buffalo2.jpg',
        'title': 'ควายสวยงาม',
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
                  'ประวัติ',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: historyItems.isEmpty
                      ? Center(
                    child: Text(
                      'ไม่มีประวัติ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                      : ListView.builder(
                    itemCount: historyItems.length,
                    itemBuilder: (context, index) {
                      final item = historyItems[index];
                      return Card(
                        elevation: 1,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Image.asset(
                            item['image']!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item['title']!),
                          subtitle: Text(item['time']!),
                          trailing: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios,
                                size: 16, color: Colors.green),
                            onPressed: () {
                              // Add navigation to detail page here
                            },
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