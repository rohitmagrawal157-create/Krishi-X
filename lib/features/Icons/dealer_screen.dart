import 'package:flutter/material.dart';
import 'package:krishix/core/models/user_location.dart';

class DealerScreen extends StatelessWidget {
  final UserLocation userLocation;
  
  const DealerScreen({super.key, required this.userLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dealers'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.store, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              'Nearby Dealers will appear here',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}