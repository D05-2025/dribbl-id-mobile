import 'package:flutter/material.dart';

// IMPORT halaman yang benar
import 'package:dribbl_id/main/main_page.dart';
import 'package:dribbl_id/main/menu.dart'; 
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DRIBBL.ID',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      home: const LandingPage(),
    );
  }
}
