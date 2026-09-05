import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

// =========================
// 🔥 画像キャッシュ
// =========================
import 'package:cached_network_image/cached_network_image.dart';

import '../models/ranking_model.dart';

// =========================
// ⭐ ブログ詳細ページ
// =========================
import '../pages/blog_detail_page.dart';

class HitRankingCard extends StatelessWidget {
  final RankingModel ranking;

  const HitRankingCard({
    super.key,
    required this.ranking,
  });

  // =========================
  // 🔥 API BASE URL
  // =========================
  static const String baseUrl =
      "https://api.keiba-ai-yosou.com";

  // =========================
  // ⭐ メダル色
  // 1～3位で使用
  // =========================
  Color medal(int rank) {
    if (rank == 1) {
      return const Color(0xFFFFD700);
    }

    if (rank == 2) {
      return const Color(0xFFC0C0C0);
    }

    if (rank == 3) {
      return const Color(0xFFCD7F32);
    }

    return Colors.lime;
  }

  // =========================
  // ⭐ ランキングメダル画像
  // =========================
  String? medalAssetPath(int rank) {
    switch (rank) {
      case 1:
        return 'assets/images/medal_gold.png';

      case 2:
        return 'assets/images/medal_silver.png';

      case 3:
        return 'assets/images/medal_bronze.png';

      case 4:
        return 'assets/images/medal_4th.png';

      case 5:
        return 'assets/images/medal_5th.png';

      case 6:
        return 'assets/images/medal_6th.png';

      case 7:
        return 'assets/images/medal_7th.png';

      case 8:
        return 'assets/images/medal_8th.png';

      case 9:
        return 'assets/images/medal_9th.png';

      case 10:
        return 'assets/images/medal_10th.png';

      default:
        return null;
    }
  }

  // =========================
  // ⭐ ランキング順位ごとの
  // ⭐ メダル表示サイズ
  //
  // ここを変更することで、
  // 1～10位を個別に調整できます。
  //
  // ※ メダル配置領域そのものは
  //    110 × 110px のまま維持します。
  // =========================
  double medalSize(int rank) {
    switch (rank) {
      case 1:
        return 120;

      case 2:
        return 120;

      case 3:
        return 120;

      case 4:
        return 80;

      case 5:
        return 80;

      case 6:
        return 80;

      case 7:
        return 80;

      case 8:
        return 80;

      case 9:
        return 80;

      case 10:
        return 80;

      default:
        return 80;
    }
  }

  // =========================
  // ⭐ URL起動
  // =========================
  Future<void> open(
    String url,
  ) async {
    if (url.isEmpty) {
      return;
    }

    final uri = Uri.parse(url);

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  // =========================
  // ⭐ 金額フォーマット
  // =========================
  String formatYen(
    int amount,
  ) {
    final formatter = NumberFormat("#,###");

    return formatter.format(
      amount,
    );
  }

  // =========================
  // 🔥 画像URL補正
  // =========================
  String buildImageUrl(
    String raw,
  ) {
    if (raw.isEmpty) {
      return "";
    }

    // localhost → 実IP
    raw = raw.replaceAll(
      "127.0.0.1",
      "api.keiba-ai-yosou.com",
    );

    // 完全URL
    if (raw.startsWith("http")) {
      return raw;
    }

    // /uploads/xxx
    if (raw.startsWith("/")) {
      return "$baseUrl$raw";
    }

    // uploads/xxx
    return "$baseUrl/$raw";
  }

  // =========================
  // ⭐ ブログ詳細遷移
  // =========================
  void openBlogDetail(
    BuildContext context,
  ) {
    // =========================
    // 🔥 blog_id未設定
    // =========================
    if (!ranking.hasBlog) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("記事が存在しません"),
        ),
      );

      return;
    }

    // =========================
    // ⭐ ブログ詳細ページへ遷移
    // =========================
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlogDetailPage(
          // =========================
          // ⭐ blog_id渡す
          // =========================
          blogId: ranking.blogId,
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final color = medal(ranking.rank);

    // =========================
    // 🔥 サイト画像URL
    // =========================
    final imageUrl = buildImageUrl(
      ranking.imageUrl,
    );

    // =========================
    // ⭐ ランキングメダル画像
    // =========================
    final medalImage = medalAssetPath(
      ranking.rank,
    );

    // =========================
    // ⭐ ランキングメダル表示サイズ
    // =========================
    final medalDisplaySize = medalSize(
      ranking.rank,
    );

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      padding: const EdgeInsets.fromLTRB(
        8,
        14,
        10,
        14,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          16,
        ),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            ranking.rank <= 3
                ? color.withValues(alpha: .15)
                : const Color(0xFFBBDEFB),
            Colors.white,
          ],
        ),
      ),
      child: Column(
        children: [
          // =========================
          // 上部
          // =========================
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // =========================
              // ⭐ 順位表示
              //
              // 1～10位：
              // それぞれのメダル画像を表示
              //
              // メダル画像の表示サイズは
              // medalSize() で順位ごとに
              // 個別設定
              //
              // それ以外：
              // 従来の順位表示を表示
              // =========================
              SizedBox(
                width: 130,
                height: 130,
                child: medalImage != null
                    ? Center(
                        child: Image.asset(
                          medalImage,
                          width: medalDisplaySize,
                          height: medalDisplaySize,
                          fit: BoxFit.contain,
                          filterQuality:
                              FilterQuality.high,
                        ),
                      )
                    : Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                const Color(0xFF1A237E),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(
                                  alpha: 0.08,
                                ),
                                blurRadius: 4,
                                offset:
                                    const Offset(
                                  0,
                                  1,
                                ),
                              ),
                            ],
                          ),
                          alignment:
                              Alignment.center,
                          child: Text(
                            ranking.rank.toString(),
                            style:
                                const TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
              ),

              const SizedBox(
                width: 6,
              ),

              // =========================
              // 情報
              // =========================
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(
                    left: 12,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      // =========================
                      // 上段
                      // サイト名 + 画像
                      // =========================
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          // =========================
                          // サイト名等
                          // =========================
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                // =========================
                                // サイト名
                                // =========================
                                Text(
                                  ranking.siteName,
                                  style:
                                      const TextStyle(
                                    fontSize: 17,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                  height: 4,
                                ),

                                // =========================
                                // 日付
                                // =========================
                                Text(
                                  ranking.date,
                                  style:
                                      const TextStyle(
                                    fontSize: 13,
                                  ),
                                ),

                                const SizedBox(
                                  height: 4,
                                ),

                                // =========================
                                // レース名
                                // =========================
                                Text(
                                  ranking.raceName,
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            width: 4,
                          ),

                          // =========================
                          // 🔥 丸画像（タップ可能）
                          // =========================
                          if (imageUrl.isNotEmpty)
                            InkWell(
                              borderRadius:
                                  BorderRadius.circular(
                                100,
                              ),
                              onTap: () {
                                open(
                                  ranking.siteUrl,
                                );
                              },
                              child: Container(
                                decoration:
                                    const BoxDecoration(
                                  shape:
                                      BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black26,
                                      blurRadius: 8,
                                      offset:
                                          Offset(
                                        0,
                                        4,
                                      ),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  padding:
                                      const EdgeInsets
                                          .all(
                                    2,
                                  ),
                                  decoration:
                                      BoxDecoration(
                                    shape:
                                        BoxShape.circle,
                                    border:
                                        Border.all(
                                      color:
                                          Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child:
                                        CachedNetworkImage(
                                      imageUrl:
                                          imageUrl,
                                      width: 72,
                                      height: 72,
                                      fit: BoxFit.cover,
                                      filterQuality:
                                          FilterQuality
                                              .high,
                                      placeholder:
                                          (_, _) {
                                        return Container(
                                          width: 72,
                                          height: 72,
                                          alignment:
                                              Alignment
                                                  .center,
                                          child:
                                              const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child:
                                                CircularProgressIndicator(
                                              strokeWidth:
                                                  2,
                                            ),
                                          ),
                                        );
                                      },
                                      errorWidget:
                                          (_, _, _) {
                                        return Container(
                                          width: 72,
                                          height: 72,
                                          decoration:
                                              BoxDecoration(
                                            color: Colors
                                                .grey
                                                .shade300,
                                            shape:
                                                BoxShape
                                                    .circle,
                                          ),
                                          child:
                                              const Icon(
                                            Icons.image,
                                            color:
                                                Colors.white,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      // =========================
                      // 金額
                      // =========================
                      Text(
                        "${formatYen(ranking.amount)}円",
                        style:
                            const TextStyle(
                          color: Colors.red,
                          fontSize: 26,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 18,
          ),

          // =========================
          // 下部ボタン
          // =========================
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              // =========================
              // 詳細はコチラ
              // =========================
              SizedBox(
                width: 180,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFF1A237E),
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset:
                            Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.transparent,
                      shadowColor:
                          Colors.transparent,
                      padding:
                          const EdgeInsets
                              .symmetric(
                        vertical: 14,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),
                      ),
                    ),
                    onPressed: () {
                      openBlogDetail(
                        context,
                      );
                    },
                    child: const Text(
                      "詳細はコチラ",
                      style:
                          TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 6,
              ),

              // =========================
              // 🔗 外部サイト
              // =========================
              InkWell(
                onTap: () {
                  open(
                    ranking.siteUrl,
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.all(
                    12,
                  ),
                  decoration:
                      BoxDecoration(
                    color:
                        Colors.indigo[900],
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color:
                            Colors.black12,
                        blurRadius: 6,
                        offset:
                            Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.open_in_new,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}