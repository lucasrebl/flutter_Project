import 'package:flutter/material.dart';
import '../widgets/content_list.dart';
import 'profile_page.dart';
import 'maps_page.dart';
import 'users_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ContentList(),
    const ProfilePage(),
    const MapsPage(),
    const UsersPage(),  // Ajout de la page Users
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Max ton pote",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: const Color(0xFFFB266A),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: _pages[_currentIndex],
          ),
        ],
      ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Permet d'afficher la couleur de fond
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Maps'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
          ],
          backgroundColor: Color(0xFFFB266A), // Remet la couleur
          selectedItemColor: Colors.white, // Couleur de l'icône et du texte sélectionné
          unselectedItemColor: Colors.white70, // Couleur des icônes non sélectionnées
        )
    );
  }
}
