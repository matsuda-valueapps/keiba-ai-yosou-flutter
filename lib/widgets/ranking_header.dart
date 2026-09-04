import 'package:flutter/material.dart';

class RankingHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  /// ランキング文字を表示するか
  final bool showRankingText;

  /// アイコンを表示するか
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
      // =========================
      // ランキングカードと左右幅を統一
      // HitRankingCard / TrendRankingCard
      // と同じ horizontal: 16
      // =========================
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),

      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),

        // =========================
        // 背景色
        // グラデーションなし
        // =========================
        color: const Color(0xFF1A237E),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // =========================
          // タイトル
          // =========================
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          // =========================
          // 「ランキング」
          // =========================
          if (showRankingText)
            const Text(
              "ランキング",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

          // =========================
          // アイコン
          // =========================
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