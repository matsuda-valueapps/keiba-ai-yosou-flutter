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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2B2B2B),
            Color(0xFF4A4A4A),
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
                color: Colors.white70,
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
    );
  }
}