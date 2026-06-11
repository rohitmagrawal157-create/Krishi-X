import 'package:flutter/material.dart';
import 'package:krishix/core/models/user_location.dart';

class MyAdsScreen extends StatelessWidget {
  final UserLocation userLocation;
  
  const MyAdsScreen({super.key, required this.userLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Ads'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.list_alt, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              'Your Ads will appear here',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}