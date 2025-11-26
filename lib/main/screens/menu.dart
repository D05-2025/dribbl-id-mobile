import 'package:flutter/material.dart';
import 'package:dribbl_id/main/widget/navbar.dart';
import 'package:dribbl_id/main/screens/home_page.dart';
import 'package:dribbl_id/news/screens/news_list.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define a variable to hold the current page widget
    Widget bodyContent;

    if (_currentIndex == 0) {
      bodyContent = const HomePage();
    } else if (_currentIndex == 1) {
      bodyContent = const NewsEntryListPage();
    } else if (_currentIndex == 2) {
      bodyContent = const Center(
        child: Text("News Page", style: TextStyle(color: Colors.white)),
      );
    } else if (_currentIndex == 3) {
      bodyContent = const Center(
        child: Text("Events Page", style: TextStyle(color: Colors.white)),
      );
    } else {
      bodyContent = const Center(
        child: Text("Others Page", style: TextStyle(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black, // Ensure the main scaffold is dark
      body: bodyContent,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
