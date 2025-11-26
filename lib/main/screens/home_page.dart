import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "DRIBBL.ID",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: Image.asset(
                  "assets/background.png",
                  height: 330,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 40),
              Text(
                "welcome to dribbl.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              Text(
                "dribbl.id",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              Text(
                "Indonesia's biggest basketball community! "
                "A place where passion meets the court, and every dribble, "
                "dunk, and dream matters.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
