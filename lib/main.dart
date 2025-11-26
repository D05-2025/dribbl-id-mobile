import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text("Home Page")),
    Center(child: Text("News Page")),
    Center(child: Text("Events Page")),
    Center(child: Text("Matches Page")),
    Center(child: Text("Other Page")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: "News",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event), 
            label: "Events",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Matches",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: "Other",
          ),
        ],
      ),
    );
  }
}
