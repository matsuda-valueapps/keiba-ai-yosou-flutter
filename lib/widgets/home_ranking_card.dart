import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/ranking_model.dart';

class HomeRankingCard extends StatelessWidget {

  final RankingModel model;
  final bool isTrend;
  final int trendCount;

  const HomeRankingCard({
    super.key,
    required this.model,
    required this.isTrend,
    required this.trendCount,
  });

  @override
  Widget build(BuildContext context) {

    final formatter = NumberFormat('#,###');

    Color medalColor;

    if (model.rank == 1) {
      medalColor = const Color(0xFFFFD700);
    } else if (model.rank == 2) {
      medalColor = const Color(0xFFC0C0C0);
    } else if (model.rank == 3) {
      medalColor = const Color(0xFFCD7F32);
    } else {
      medalColor = Colors.grey.shade300;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: model.rank <= 3
            ? const LinearGradient(
                colors: [Color(0xFFEAD8A6), Colors.white],
              )
            : null,
        color: model.rank > 3 ? Colors.grey.shade100 : null,
      ),
      child: Row(
        children: [

          /// ⭐順位メダル
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: medalColor,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                model.rank.toString(),
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    size: 18,
                    color: Colors.orange,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(width: 16),

          /// ⭐右側情報
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                if (!isTrend) ...[
                  Text(
                    model.date,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    model.raceName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ] else ...[
                  Text(
                    model.siteName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],

                const SizedBox(height: 10),

                /// ⭐ 修正：hitAmount → amount
                Text(
                  isTrend
                      ? "的中数: $trendCount回"
                      : "${formatter.format(model.amount)}円的中",
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "詳細を見る",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.home, color: Colors.white),
                    ),
                  ],
                )

              ],
            ),
          )

        ],
      ),
    );
  }
}