import 'package:flutter/material.dart';
import '../models/ranking_model.dart';

class RankingCard extends StatelessWidget {
  final RankingModel ranking;

  const RankingCard({
    super.key,
    required this.ranking,
  });

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

  /// ⭐ ランク画像取得
  String _getMedalImage() {
    switch (ranking.rank) {
      case 1:
        return "assets/images/medal_gold.png";

      case 2:
        return "assets/images/medal_silver.png";

      case 3:
        return "assets/images/medal_bronze.png";

      default:
        return "assets/images/medal_bronze.png";
    }
  }

  @override
  Widget build(BuildContext context) {
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
          ),
        ],
      ),
      child: Row(
        children: [

          /// ⭐ 金・銀・銅メダル
          Image.asset(
            _getMedalImage(),
            width: 90,
            height: 90,
            fit: BoxFit.contain,
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