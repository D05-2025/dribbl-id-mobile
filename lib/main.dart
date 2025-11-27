import 'package:dribbl_id/main/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        theme: ThemeData(
          // Set the background to black
          scaffoldBackgroundColor: Colors.black,

          // Define the color scheme with Blue as the seed
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark, // Ensures text is white on black
            primary: Colors.blue,
            secondary: Colors.lightBlueAccent,
            surface: Colors.black, // Background for cards/sheets
          ),

          // Ensure app bar and other elements match the dark theme
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          useMaterial3: true,
        ),

        home: const LoginPage(),
      ),
    );
  }
}
