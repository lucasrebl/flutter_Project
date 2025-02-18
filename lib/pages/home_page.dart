import 'package:flutter/material.dart';
import '../widgets/content_list.dart';
import 'profile_page.dart';
import 'blank_page.dart';

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
    const BlankPage(title: 'Page 2'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Mon App",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Ajout d'un espace entre l'AppBar et la search bar
          SizedBox(height: 10), // Tu peux ajuster cette valeur selon tes besoins

          // Utiliser Expanded pour le contenu pour qu'il prenne l'espace restant
          Expanded(
            child: _pages[_currentIndex],
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.pages), label: 'Page 2'),
        ],
      ),
    );
  }
}

