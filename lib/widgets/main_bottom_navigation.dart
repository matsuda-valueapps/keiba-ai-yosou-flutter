import 'package:flutter/material.dart';

class MainBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MainBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  BottomNavigationBarItem item({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return BottomNavigationBarItem(
      label: label,
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: currentIndex == _indexOf(label)
              ? color.withValues(alpha: .15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
    );
  }

  int _indexOf(String label) {
    switch (label) {
      case "Home":
        return 0;
      case "ランキング":
        return 1;
      case "クチコミ":
        return 2;
      case "ブログ":
        return 3;
      case "予想":
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: const Color(0xFF1E1E1E), // ⭐黒帯
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      items: [

        /// ⭐ HOME
        item(
          icon: Icons.home,
          label: "Home",
          color: Colors.tealAccent,
        ),

        /// ⭐ ランキング
        item(
          icon: Icons.emoji_events,
          label: "ランキング",
          color: Colors.amber,
        ),

        /// ⭐ クチコミ
        item(
          icon: Icons.chat_bubble,
          label: "クチコミ",
          color: Colors.pinkAccent,
        ),

        /// ⭐ ブログ
        item(
          icon: Icons.article,
          label: "ブログ",
          color: Colors.orangeAccent,
        ),

        /// ⭐ 予想
        item(
          icon: Icons.show_chart,
          label: "予想",
          color: Colors.lightBlueAccent,
        ),
      ],
    );
  }
}