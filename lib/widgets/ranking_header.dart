import 'package:flutter/material.dart';

class RankingHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  /// ⭐追加
  final bool showRankingText;
  final bool showIcon;

  const RankingHeader({
    super.key,
    required this.title,
    required this.icon,
    this.showRankingText = true,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.90,
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0D47A1),
            Color(0xFF1565C0),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          if (showRankingText) ...[
            const SizedBox(width: 6),
            const Text(
              "Ranking",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],

          if (showIcon) ...[
            const SizedBox(width: 8),
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ],
        ],
      ),
      ),
    ),
  );
}
}