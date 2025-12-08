import 'package:flutter/material.dart';
import 'package:dribbl_id/main/widget/navbar.dart';
import 'package:dribbl_id/main/screens/home_page.dart';
import 'package:dribbl_id/news/screens/news_list.dart';
import 'package:dribbl_id/main/screens/others_page.dart';
import 'package:dribbl_id/matches/screens/match_schedule.dart';

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
    Widget bodyContent;

    if (_currentIndex == 0) {
      bodyContent = const HomePage();
    } else if (_currentIndex == 1) {
      // Ubah bagian ini untuk menggunakan halaman baru
      bodyContent = const MatchSchedulePage();
    } else if (_currentIndex == 2) {
      bodyContent = const NewsEntryListPage();
    } else if (_currentIndex == 3) {
      bodyContent = const Center(
        child: Text("Events Page", style: TextStyle(color: Colors.white)),
      );
    } else {
      bodyContent = const OthersPage();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: bodyContent,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
