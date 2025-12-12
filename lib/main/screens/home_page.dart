import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the CookieRequest provider
    final request = context.watch<CookieRequest>();

    // Retrieve username and role from the request's JSON data
    String username = request.jsonData['username'] ?? 'Guest';
    String role = request.jsonData['role'] ?? 'User';

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // --- Header Section with User Info ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // DRIBBL.ID Text (kept consistent with previous design but in a Row)
                  const Text(
                    "DRIBBL.ID",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  // User Info & Profile Icon
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            role,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 28,
                      ),
                    ],
                  ),
                ],
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
              const Text(
                "welcome to dribbl.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const Text(
                "dribbl.id",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              const Text(
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
