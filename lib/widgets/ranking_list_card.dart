import 'package:flutter/material.dart';
import '../models/ranking_detail_model.dart';

class RankingListCard extends StatelessWidget {
  final RankingDetailModel ranking;

  const RankingListCard({super.key, required this.ranking});

  String moneyFormat(int v) {
    return v.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }

  @override
  Widget build(BuildContext context) {

    final bool isTrend = ranking.isTrend;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "${ranking.rank}位 ${ranking.siteName}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text("${ranking.date} ${ranking.raceName}"),

            const SizedBox(height: 8),

            Text(
              isTrend
                  ? "直近の的中数：${ranking.hitCount}回"
                  : "${moneyFormat(ranking.hitAmount)}円的中",
              style: const TextStyle(
                color: Colors.red,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {},
              child: const Text("詳細を見る"),
            )
          ],
        ),
      ),
    );
  }
}