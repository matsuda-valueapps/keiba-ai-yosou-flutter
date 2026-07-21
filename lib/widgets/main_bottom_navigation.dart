import 'package:flutter/material.dart';

class MainBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MainBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,

      onTap: onTap,

      type: BottomNavigationBarType.fixed,

      backgroundColor: const Color(0xFF0D47A1),

      selectedItemColor: Colors.white,

      unselectedItemColor: Colors.grey,

      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
      ),

      iconSize: 30,

      items: const [
        // =========================
        // HOME
        // =========================
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: Colors.grey,
          ),
          activeIcon: Icon(
            Icons.home,
            color: Colors.white,
          ),
          label: "ホーム",
        ),

        // =========================
        // Ranking
        // =========================
        BottomNavigationBarItem(
          icon: Icon(
            Icons.emoji_events,
            color: Colors.grey,
          ),
          activeIcon: Icon(
            Icons.emoji_events,
            color: Colors.white,
          ),
          label: "ランキング",
        ),

        // =========================
        // Review
        // =========================
        BottomNavigationBarItem(
          icon: Icon(
            Icons.chat_bubble,
            color: Colors.grey,
          ),
          activeIcon: Icon(
            Icons.chat_bubble,
            color: Colors.white,
          ),
          label: "クチコミ",
        ),

        // =========================
        // Blog
        // =========================
        BottomNavigationBarItem(
          icon: Icon(
            Icons.article,
            color: Colors.grey,
          ),
          activeIcon: Icon(
            Icons.article,
            color: Colors.white,
          ),
          label: "ブログ",
        ),

        // =========================
        // AI Prediction
        // =========================
        BottomNavigationBarItem(
          icon: Icon(
            Icons.show_chart,
            color: Colors.grey,
          ),
          activeIcon: Icon(
            Icons.show_chart,
            color: Colors.white,
          ),
          label: "AI予想",
        ),
      ],
    );
  }
}