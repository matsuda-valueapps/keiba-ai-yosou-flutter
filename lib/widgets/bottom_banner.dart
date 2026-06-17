import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// =========================
// 🔥 キャッシュ画像
// =========================
import 'package:cached_network_image/cached_network_image.dart';

import '../providers/banner_provider.dart';

class BottomBanner extends StatelessWidget {

  const BottomBanner({
    super.key,
  });

  // =========================
  // APIベースURL
  // =========================
  static const String apiBaseUrl =
      "https://api.keiba-ai-yosou.com";

  // =========================
  // URL起動
  // =========================
  Future<void> openUrl(
    String url,
  ) async {

    try {

      // =========================
      // 空対策
      // =========================
      if (url.isEmpty) {

        debugPrint(
          "URL空",
        );

        return;
      }

      // =========================
      // https補完
      // =========================
      String fixedUrl = url.trim();

      if (
        !fixedUrl.startsWith("http://") &&
        !fixedUrl.startsWith("https://")
      ) {

        fixedUrl = "https://$fixedUrl";
      }

      debugPrint(
        "遷移URL: $fixedUrl",
      );

      final uri =
          Uri.parse(fixedUrl);

      final success =
          await launchUrl(

        uri,

        mode:
            LaunchMode.externalApplication,
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
  // 完全URL生成
  // =========================
  String buildImageUrl(
    String imageUrl,
  ) {

    if (imageUrl.isEmpty) {
      return "";
    }

    // localhost修正
    imageUrl = imageUrl.replaceAll(
      "127.0.0.1",
      "api.keiba-ai-yosou.com",
    );

    // 完全URL
    if (
      imageUrl.startsWith("http")
    ) {

      return imageUrl;
    }

    // /uploads/xxx
    if (
      imageUrl.startsWith("/")
    ) {

      return
          "$apiBaseUrl$imageUrl";
    }

    // uploads/xxx
    return
        "$apiBaseUrl/$imageUrl";
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    // =========================
    // Provider取得
    // =========================
    final provider =
        context.watch<
            BannerProvider>();

    // =========================
    // loading
    // =========================
    if (provider.isLoading) {

      return const SizedBox();
    }

    // =========================
    // バナーなし
    // =========================
    if (
      provider.currentBanner ==
          null
    ) {

      return const SizedBox();
    }

    // =========================
    // 現在バナー
    // =========================
    final banner =
        provider.currentBanner!;

    // =========================
    // URL生成
    // =========================
    final imageUrl =
        buildImageUrl(
      banner.imageUrl,
    );

    debugPrint(
      "🎯 表示バナー: "
      "${banner.title}",
    );

    debugPrint(
      "🖼 バナー画像URL: $imageUrl",
    );

    return SafeArea(

      top: false,

      child: GestureDetector(

        onTap: () {

          openUrl(
            banner.url,
          );
        },

        child: Container(

          width: double.infinity,

          height: 64,

          decoration:
              const BoxDecoration(
            color: Colors.black,
          ),

          child:
              CachedNetworkImage(

            imageUrl:
                imageUrl,

            fit: BoxFit.cover,

            filterQuality:
                FilterQuality.high,

            // =========================
            // 🔥 キャッシュ最適化
            // =========================
            memCacheWidth: 1200,

            fadeInDuration:
                const Duration(
              milliseconds: 120,
            ),

            fadeOutDuration:
                const Duration(
              milliseconds: 80,
            ),

            // =========================
            // loading
            // =========================
            placeholder:
                (
                  context,
                  url,
                ) {

              return Container(

                color: Colors.black,

                child: const Center(

                  child: SizedBox(

                    width: 22,

                    height: 22,

                    child:
                        CircularProgressIndicator(

                      strokeWidth: 2,

                      color:
                          Colors.white,
                    ),
                  ),
                ),
              );
            },

            // =========================
            // error
            // =========================
            errorWidget:
                (
                  context,
                  url,
                  error,
                ) {

              debugPrint(
                "❌ 画像表示エラー: "
                "$error",
              );

              debugPrint(
                "❌ 失敗URL: $imageUrl",
              );

              return Container(

                color: Colors.green,

                alignment:
                    Alignment.center,

                child: Text(

                  banner.title,

                  textAlign:
                      TextAlign.center,

                  style:
                      const TextStyle(

                    color:
                        Colors.white,

                    fontWeight:
                        FontWeight.bold,

                    fontSize: 20,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}