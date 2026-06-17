import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/site_model.dart';

class SiteCard extends StatelessWidget {

  final SiteModel site;

  const SiteCard({
    super.key,
    required this.site,
  });

  // =========================
  // 🔥 API BASE URL
  // =========================
  static const String baseUrl =
      "https://api.keiba-ai-yosou.com";

  // =========================
  // 🔥 URLオープン（安全版）
  // =========================
  Future<void> open() async {

    try {

      if (site.url.isEmpty) {
        return;
      }

      String fixedUrl =
          site.url.trim();

      // =========================
      // 🔥 https補完
      // =========================
      if (
          !fixedUrl.startsWith(
            "http://",
          ) &&
          !fixedUrl.startsWith(
            "https://",
          )) {

        fixedUrl =
            "https://$fixedUrl";
      }

      final uri =
          Uri.parse(fixedUrl);

      final success =
          await launchUrl(

        uri,

        mode:
            LaunchMode
                .externalApplication,
      );

      if (!success) {

        debugPrint(
          "URL起動失敗: $fixedUrl",
        );
      }

    } catch (e) {

      debugPrint(
        "URL起動エラー: $e",
      );
    }
  }

  // =========================
  // 🔥 画像URL完全ガード
  // =========================
  String buildImageUrl(
    String? raw,
  ) {

    if (raw == null ||
        raw.isEmpty) {

      return "";
    }

    // =========================
    // localhost対策
    // =========================
    raw = raw.replaceAll(
      "127.0.0.1",
      "api.keiba-ai-yosou.com",
    );

    // =========================
    // 完全URL
    // =========================
    if (raw.startsWith(
      "http",
    )) {

      return raw;
    }

    // =========================
    // 先頭 / 除去
    // =========================
    final cleaned =
        raw.replaceFirst(
      RegExp(r'^/+'),
      '',
    );

    return
        "$baseUrl/$cleaned";
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    final imageUrl =
        buildImageUrl(
      site.imageUrl,
    );

    return Material(

      color: Colors.transparent,

      child: InkWell(

        onTap: open,

        borderRadius:
            BorderRadius.circular(
          12,
        ),

        child: Container(

          padding:
              const EdgeInsets.symmetric(

            horizontal: 16,
            vertical: 14,
          ),

          child: Column(

            children: [

              Row(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  // =========================
                  // ⭐ 左テキスト
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

                          site.name,

                          style:
                              const TextStyle(

                            fontSize: 18,

                            fontWeight:
                                FontWeight
                                    .bold,

                            color:
                                Colors.blue,
                          ),
                        ),

                        const SizedBox(
                          height: 6,
                        ),

                        // =========================
                        // 🔥 説明文
                        // =========================
                        Text(

                          site.description
                                  .isNotEmpty
                              ? site
                                  .description
                              : "説明文が登録されていません",

                          style:
                              const TextStyle(

                            fontSize: 14,

                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  // =========================
                  // ⭐ 右画像
                  // =========================
                  ClipRRect(

                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),

                    child:
                        imageUrl.isEmpty

                            ? Container(

                                width: 100,
                                height: 100,

                                color:
                                    Colors
                                        .grey
                                        .shade300,

                                alignment:
                                    Alignment
                                        .center,

                                child:
                                    const Icon(

                                  Icons.image,

                                  size: 42,

                                  color:
                                      Colors
                                          .white,
                                ),
                              )

                            : CachedNetworkImage(

                                imageUrl:
                                    imageUrl,

                                width: 100,
                                height: 100,

                                fit:
                                    BoxFit.cover,

                                fadeInDuration:
                                    const Duration(
                                  milliseconds:
                                      150,
                                ),

                                memCacheWidth:
                                    300,

                                memCacheHeight:
                                    300,

                                maxWidthDiskCache:
                                    600,

                                maxHeightDiskCache:
                                    600,

                                filterQuality:
                                    FilterQuality
                                        .medium,

                                // =========================
                                // 読み込み中
                                // =========================
                                placeholder:
                                    (
                                  context,
                                  url,
                                ) {

                                  return Container(

                                    width: 100,
                                    height: 100,

                                    color:
                                        Colors
                                            .grey
                                            .shade200,

                                    alignment:
                                        Alignment
                                            .center,

                                    child:
                                        const SizedBox(

                                      width: 24,
                                      height: 24,

                                      child:
                                          CircularProgressIndicator(

                                        strokeWidth:
                                            2,
                                      ),
                                    ),
                                  );
                                },

                                // =========================
                                // エラー
                                // =========================
                                errorWidget:
                                    (
                                  context,
                                  url,
                                  error,
                                ) {

                                  debugPrint(
                                    "❌ SiteCard画像エラー: $error",
                                  );

                                  debugPrint(
                                    "❌ URL: $imageUrl",
                                  );

                                  return Container(

                                    width: 100,
                                    height: 100,

                                    color:
                                        Colors
                                            .grey
                                            .shade300,

                                    alignment:
                                        Alignment
                                            .center,

                                    child:
                                        const Icon(

                                      Icons
                                          .broken_image,

                                      size: 42,

                                      color:
                                          Colors
                                              .white,
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),

              const SizedBox(
                height: 14,
              ),

              const Divider(
                thickness: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}