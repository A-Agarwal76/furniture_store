import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
          SizedBox(height: 12),
          Text('Guest User'),
        ],
      ),
    );
  }
}
