import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

// =========================
// 🔥 追加
// 画像キャッシュ
// =========================
import 'package:cached_network_image/cached_network_image.dart';

import '../models/ranking_model.dart';

import '../pages/blog_detail_page.dart';

class TrendRankingCard extends StatelessWidget {

  final RankingModel ranking;

  const TrendRankingCard({
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
  // ⭐ URL起動
  // =========================
  Future<void> open(
    String url,
  ) async {

    if (url.isEmpty) {
      return;
    }

    final uri = Uri.parse(
      url,
    );

    await launchUrl(

      uri,

      mode:
          LaunchMode
              .externalApplication,
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

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
              Text("記事が存在しません"),
        ),
      );

      return;
    }

    // =========================
    // ⭐ ブログ詳細ページ遷移
    // =========================
    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => BlogDetailPage(

          // =========================
          // ⭐ blog_id渡す
          // =========================
          blogId:
              ranking.blogId,
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    final color =
        medal(ranking.rank);

    // =========================
    // 🔥 画像URL
    // =========================
    final imageUrl =
        buildImageUrl(
      ranking.imageUrl,
    );

    return Container(

      margin:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),

      padding:
          const EdgeInsets.all(14),

      decoration: BoxDecoration(

        borderRadius:
            BorderRadius.circular(
          16,
        ),

        gradient: LinearGradient(

          colors: [

            color.withValues(
              alpha: .15,
            ),

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
              // メダル
              // =========================
              Stack(

                clipBehavior:
                    Clip.none,

                children: [

                  Container(

                    width: 80,

                    height: 80,

                    decoration:
                        BoxDecoration(

                      shape:
                          BoxShape.circle,

                      gradient:
                          LinearGradient(

                        colors: [

                          color.withValues(
                            alpha: .8,
                          ),

                          color,
                        ],
                      ),
                    ),

                    child: Center(

                      child: Text(

                        ranking.rank
                            .toString(),

                        style:
                            const TextStyle(

                          color:
                              Colors.white,

                          fontSize: 30,

                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                    ),
                  ),

                  Positioned(

                    top: -10,

                    right: -10,

                    child: Container(

                      padding:
                          const EdgeInsets
                              .all(4),

                      decoration:
                          const BoxDecoration(

                        shape:
                            BoxShape.circle,

                        color:
                            Colors.white,
                      ),

                      child: Icon(

                        Icons
                            .workspace_premium,

                        color: color,

                        size: 34,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                width: 12,
              ),

              // =========================
              // 情報
              // =========================
              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

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
                        // 左情報
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

                                  fontWeight:
                                      FontWeight.bold,

                                  fontSize: 17,
                                ),
                              ),

                              const SizedBox(
                                height: 24,
                              ),

                              // =========================
                              // 🔥 月間表示
                              // =========================
                              const Text(

                                "先月の月間",

                                style: TextStyle(

                                  fontSize: 15,

                                  fontWeight:
                                      FontWeight.w600,

                                  color:
                                      Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          width: 10,
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
                                  BoxDecoration(

                                shape:
                                    BoxShape.circle,

                                boxShadow: [

                                  BoxShadow(

                                    color:
                                        Colors.black26,

                                    blurRadius: 8,

                                    offset:
                                        const Offset(
                                      0,
                                      4,
                                    ),
                                  ),
                                ],
                              ),

                              child: Container(

                                padding:
                                    const EdgeInsets.all(
                                  2,
                                ),

                                decoration:
                                    BoxDecoration(

                                  shape:
                                      BoxShape.circle,

                                  border: Border.all(

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

                                    width: 64,

                                    height: 64,

                                    fit: BoxFit.cover,

                                    filterQuality:
                                        FilterQuality.high,

                                    placeholder:
                                        (_, _) {

                                      return Container(

                                        width: 64,

                                        height: 64,

                                        alignment:
                                            Alignment.center,

                                        child:
                                            const SizedBox(

                                          width: 20,

                                          height: 20,

                                          child:
                                              CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      );
                                    },

                                    errorWidget:
                                        (_, _, _) {

                                      return Container(

                                        width: 64,

                                        height: 64,

                                        decoration:
                                            BoxDecoration(

                                          color:
                                              Colors.grey
                                                  .shade300,

                                          shape:
                                              BoxShape.circle,
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
                      height: 20,
                    ),

                    // =========================
                    // 的中数
                    // =========================
                    Text(

                      "的中数：${ranking.hitCount}回",

                      style:
                          const TextStyle(

                        color: Colors.red,

                        fontSize: 22,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(
            height: 12,
          ),

          // =========================
          // ボタン
          // =========================
          Row(

            children: [

              // =========================
              // 的中詳細
              // =========================
              Expanded(

                child: ElevatedButton(

                  style:
                      ElevatedButton.styleFrom(

                    backgroundColor:
                        Color(0xFFE91E63),

                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 14,
                    ),

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),

                    elevation: 3,
                  ),

                  onPressed: () {

                    openBlogDetail(
                      context,
                    );
                  },

                  child: const Text(

                    "競馬ブログを読む！",

                    style: TextStyle(

                      color: Colors.white,

                      fontWeight:
                          FontWeight.bold,

                      fontSize: 15,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              // =========================
              // 🏠
              // =========================
              InkWell(

                onTap: () {

                  open(
                    ranking.siteUrl,
                  );
                },

                child: Container(

                  padding:
                      const EdgeInsets
                          .all(12),

                  decoration:
                      BoxDecoration(

                    color: Colors.orange,

                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),

                    boxShadow: const [

                      BoxShadow(

                        color: Colors.black12,

                        blurRadius: 6,

                        offset: Offset(
                          0,
                          3,
                        ),
                      ),
                    ],
                  ),

                  child: const Icon(

                    Icons.home,

                    color: Colors.white,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}