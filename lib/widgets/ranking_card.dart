import 'package:flutter/material.dart';
import '../models/ranking_model.dart';

class RankingCard extends StatelessWidget {
  final RankingModel ranking;

  const RankingCard({super.key, required this.ranking});

  Color _getMedalColor(int rank) {
    if (rank == 1) return const Color(0xFFFFD700);
    if (rank == 2) return const Color(0xFFC0C0C0);
    if (rank == 3) return const Color(0xFFCD7F32);
    return Colors.grey;
  }

  /// ⭐ 表示値判定（rankingType廃止対応）
  String _buildValueText() {
    if (ranking.amount > 0) {
      return "${_formatNumber(ranking.amount)}円";
    } else {
      return "${ranking.hitCount}回";
    }
  }

  /// ⭐ カンマ区切り
  String _formatNumber(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }

  @override
  Widget build(BuildContext context) {
    final medalColor = _getMedalColor(ranking.rank);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
          )
        ],
      ),
      child: Row(
        children: [

          /// メダル
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  medalColor.withValues(alpha: 0.7),
                  medalColor,
                ],
              ),
            ),
            child: Center(
              child: Text(
                ranking.rank.toString(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          /// 情報
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  ranking.siteName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                /// 🔥 修正済み（rankingType完全排除）
                Text(
                  _buildValueText(),
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}