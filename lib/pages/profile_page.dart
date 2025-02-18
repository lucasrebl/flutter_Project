import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage("https://picsum.photos/200"),
          ),
          SizedBox(height: 20),
          Text("Lucas Reboulet", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text("20 ans", style: TextStyle(fontSize: 18)),
          Text("Dev", style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
