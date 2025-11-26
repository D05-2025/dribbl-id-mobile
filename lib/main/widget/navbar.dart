import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Theme(
      data: theme.copyWith(
        canvasColor: colorScheme.surface, // Dark grey background for the navbar
      ),
      child: Container(
        // Optional: Add a top border or shadow to separate from body if needed
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
        ),
        child: BottomNavigationBar(
          backgroundColor: colorScheme.surface,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: onTap,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            // 1. Home
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
            ),
            // 2. Matches
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: "Matches",
            ),
            // 3. News
            BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: "News"),
            // 4. Events
            BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
            // 5. Others
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: "Others",
            ),
          ],
        ),
      ),
    );
  }
}
