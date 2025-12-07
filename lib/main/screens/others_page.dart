import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:dribbl_id/main/screens/login.dart'; // Import the Login Page
import 'package:dribbl_id/teams/screens/team_page.dart';

class OthersPage extends StatelessWidget {
  const OthersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the CookieRequest provider
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: Colors.black, // Ensure background is black
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // --- Header Section ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Explore",
                    style: TextStyle(
                      color: Colors.cyanAccent, // Use distinct cyan
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      shadows: [
                        Shadow(
                          color: Colors.cyanAccent.withOpacity(0.6),
                          blurRadius: 20,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // --- Subheader ---
              Text(
                "Explore more basketball content",
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),

              const SizedBox(height: 20),

              // --- Players Card ---
              _buildNavigationCard(
                context,
                icon: Icons.groups_outlined,
                iconColor: Colors.cyanAccent,
                title: "Players",
                subtitle: "Browse basketball player statistics",
                onTap: () {
                  // Navigate to Players page logic here
                },
              ),

              const SizedBox(height: 16),

              // --- Teams Card ---
              _buildNavigationCard(
                context,
                icon: Icons.shield_outlined,
                iconColor: Colors.deepOrange,
                title: "Teams",
                subtitle: "Explore basketball teams",
                onTap: () {
                  // Navigate to Teams Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeamsPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // --- Logout Card ---
              _buildNavigationCard(
                context,
                icon: Icons.logout,
                iconColor: Colors.redAccent,
                title: "Logout",
                subtitle: "Sign out of your account",
                onTap: () async {
                  // Logout Logic
                  final response = await request.logout(
                    // TODO: Change this URL to your actual Django app URL
                    "http://localhost:8000/auth/logout/",
                  );

                  String message = response["message"];

                  if (context.mounted) {
                    if (response['status']) {
                      String uname = response["username"];
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("$message See you again, $uname."),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(message)));
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212), // Dark card background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10, width: 0.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 32),
                ),

                const SizedBox(width: 16),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ],
                  ),
                ),

                // Chevron Icon
                Icon(Icons.chevron_right, color: Colors.grey[600], size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
