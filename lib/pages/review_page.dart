import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import '../providers/banner_provider.dart';

// =========================
// 🔥 追加
// TOPスクロール制御
// =========================
import '../providers/scroll_top_provider.dart';

import '../widgets/bottom_banner.dart';
import '../widgets/admob_banner_widget.dart';

class ReviewPage extends StatefulWidget {

  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() =>
      _ReviewPageState();
}

class _ReviewPageState
    extends State<ReviewPage>

    // =========================
    // 🔥 KeepAlive追加
    // =========================
    with AutomaticKeepAliveClientMixin {

  // =========================
  // 🔥 KeepAlive有効化
  // =========================
  @override
  bool get wantKeepAlive => true;

  final String baseUrl =
      "https://api.keiba-ai-yosou.com";

  List reviews = [];

  bool isLoading = true;

  // =========================
  // ⭐ クチコミ投稿フォーム
  // =========================
  final TextEditingController
      siteController =
      TextEditingController();

  final TextEditingController
      userController =
      TextEditingController();

  final TextEditingController
      commentController =
      TextEditingController();

  int selectedRating = 5;

  @override
  void initState() {

    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {

      if (!mounted) return;

      // =========================
      // レビュー取得
      // =========================
      fetchReviews();

      // =========================
      // ⭐ ランダムバナー変更
      // =========================
      context
          .read<BannerProvider>()
          .pickRandomBanner();
    });
  }

  @override
  void dispose() {

    siteController.dispose();

    userController.dispose();

    commentController.dispose();

    super.dispose();
  }

  // =========================
  // API取得
  // =========================
  Future<void> fetchReviews() async {

    try {

      final res = await http.get(
        Uri.parse(
          "$baseUrl/reviews/all",
        ),
      );

      if (!mounted) return;

      if (res.statusCode == 200) {

        final data =
            json.decode(res.body);

        log("取得データ: $data");

        setState(() {

          reviews = data;

          isLoading = false;
        });

      } else {

        log(
          "ステータスエラー: ${res.statusCode}",
        );

        setState(() {
          isLoading = false;
        });
      }

    } catch (e) {

      log("レビュー取得エラー: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  // =========================
  // 🔥 丸画像
  // 白枠 + 影 + 高画質
  // =========================
  Widget buildAvatar(
    String? imageUrl,
  ) {

    return Container(

      width: 62,
      height: 62,

      decoration: BoxDecoration(

        shape: BoxShape.circle,

        boxShadow: [

          BoxShadow(

            color: Colors.black26,

            blurRadius: 8,

            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child: Container(

        padding: const EdgeInsets.all(
          2,
        ),

        decoration: BoxDecoration(

          shape: BoxShape.circle,

          border: Border.all(

            color: Colors.white,

            width: 2,
          ),
        ),

        child: ClipRRect(

          borderRadius:
              BorderRadius.circular(
            30,
          ),

          child:
              imageUrl == null ||
                      imageUrl.isEmpty

                  ? Container(

                      color:
                          Colors.grey
                              .shade200,

                      child:
                          const Icon(

                        Icons
                            .account_circle,

                        size: 54,

                        color:
                            Colors.grey,
                      ),
                    )

                  : CachedNetworkImage(

                      imageUrl:
                          imageUrl,

                      fit: BoxFit.cover,

                      filterQuality:
                          FilterQuality.high,

                      placeholder:
                          (_, _) =>
                              const Center(

                        child:
                            SizedBox(

                          width: 20,
                          height: 20,

                          child:
                              CircularProgressIndicator(
                            strokeWidth:
                                2,
                          ),
                        ),
                      ),

                      errorWidget:
                          (_, _, _) =>
                              Container(

                        color:
                            Colors.grey
                                .shade200,

                        child:
                            const Icon(

                          Icons
                              .account_circle,

                          size: 54,

                          color:
                              Colors.grey,
                        ),
                      ),
                    ),
        ),
      ),
    );
  }

  // =========================
  // URL遷移
  // =========================
  Future<void> openUrl(
    String? url,
  ) async {

    if (url == null ||
        url.isEmpty) {

      return;
    }

    try {

      final uri = Uri.parse(url);

      final success =
          await launchUrl(

        uri,

        mode: LaunchMode
            .externalApplication,
      );

      if (!success) {

        log(
          "URL起動失敗: $url",
        );
      }

    } catch (e) {

      log(
        "URL起動エラー: $e",
      );
    }
  }

  // =========================
  // ⭐ 星UI
  // =========================
  Widget buildStarSelector() {

    return Row(

      children: List.generate(
        5,
        (index) {

          final star = index + 1;

          return GestureDetector(

            onTap: () {

              setState(() {

                selectedRating = star;
              });
            },

            child: Padding(

              padding:
                  const EdgeInsets.only(
                right: 6,
              ),

              child: Icon(

                Icons.star,

                size: 36,

                color:
                    star <= selectedRating

                        ? Colors.amber

                        : Colors.grey
                            .shade400,
              ),
            ),
          );
        },
      ),
    );
  }

  // =========================
  // ⭐ クチコミ投稿フォーム
  // =========================
  Widget buildReviewForm() {

    return Container(

      margin: const EdgeInsets.all(16),

      padding: const EdgeInsets.all(
        20,
      ),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          20,
        ),

        boxShadow: const [

          BoxShadow(

            color: Colors.black12,

            blurRadius: 8,
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Center(

            child: Text(

              "クチコミ投稿",

              style: TextStyle(

                fontSize: 26,

                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(
            height: 24,
          ),

          // =========================
          // サイト名
          // =========================
          Text.rich(

            TextSpan(

              children: [

                const TextSpan(

                  text: "サイト名",

                  style: TextStyle(

                    color: Colors.black,

                    fontWeight: FontWeight.bold,

                    fontSize: 16,
                  ),
                ),

                TextSpan(

                  text: " *",

                  style: TextStyle(

                    color: Colors.red.shade500,

                    fontWeight: FontWeight.bold,

                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          TextField(

            controller:
                siteController,

            decoration: InputDecoration(

              hintText:
                  "例：競馬○◯",

              border:
                  OutlineInputBorder(

                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          // =========================
          // 投稿者名
          // =========================
          const Text(

            "投稿者名",

            style: TextStyle(

              fontWeight:
                  FontWeight.bold,

              fontSize: 16,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          TextField(

            controller:
                userController,

            decoration: InputDecoration(

              hintText:
                  "例：Keibaサポーター",

              border:
                  OutlineInputBorder(

                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          // =========================
          // 星評価
          // =========================
          Text.rich(

            TextSpan(

              children: [

                const TextSpan(

                  text: "★5段階評価 (タップして評価)",

                  style: TextStyle(

                    color: Colors.black,

                    fontWeight: FontWeight.bold,

                    fontSize: 16,
                  ),
                ),

                TextSpan(

                  text: " *",

                  style: TextStyle(

                    color: Colors.red.shade500,

                    fontWeight: FontWeight.bold,

                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          buildStarSelector(),

          const SizedBox(
            height: 20,
          ),

          // =========================
          // コメント
          // =========================
          Text.rich(

            TextSpan(

              children: [

                const TextSpan(

                  text: "クチコミ内容",

                  style: TextStyle(

                    color: Colors.black,

                    fontWeight: FontWeight.bold,

                    fontSize: 16,
                  ),
                ),

                TextSpan(

                  text: " *",

                  style: TextStyle(

                    color: Colors.red.shade500,

                    fontWeight: FontWeight.bold,

                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          TextField(

            controller: commentController,

            maxLines: 4,

            decoration: InputDecoration(

              hintText: "サイトを利用した感想を入力して下さい。",

              contentPadding: const EdgeInsets.all(14),

              border: OutlineInputBorder(

                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          Text(
            "* は必須項目です",
            style: TextStyle(
              color: Colors.red.shade500,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 6),

          Text(

            "※クチコミ内容は、当アプリで審査後に反映されます。反映まで時間が掛かる場合がございますので、予めご了承下さい。",

            style: TextStyle(

              color: Colors.grey.shade700,

              fontSize: 14,
            ),
          ),

          const SizedBox(
            height: 24,
          ),

          Center(
            child: SizedBox(

              width: 240,

              height: 56,

              child: DecoratedBox(

                decoration: BoxDecoration(

                  color: const Color(0xFF1A237E),

                  borderRadius:
                      BorderRadius.circular(14),

                  boxShadow: const [

                    BoxShadow(

                      color: Colors.black26,

                      blurRadius: 8,

                      offset: Offset(0, 3),

                    ),

                  ],
                ),

                child: ElevatedButton(

                  onPressed: () {

                    showDialog(

                      context: context,

                      builder: (_) {

                        return AlertDialog(

                          title: const Text(
                            "クチコミ送信完了",
                          ),

                          content: const Text(
                            "投稿ありがとうございました！",
                          ),

                          actions: [

                            TextButton(

                              onPressed: () {

                                Navigator.pop(context);

                              },

                              child: const Text(
                                "OK",
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    siteController.clear();

                    userController.clear();

                    commentController.clear();

                    setState(() {

                      selectedRating = 5;

                    });
                  },

                  style: ElevatedButton.styleFrom(

                    backgroundColor:
                      Colors.transparent,

                    shadowColor:
                      Colors.transparent,

                    foregroundColor:
                      Colors.white,

                    elevation: 0,

                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 14,
                    ),

                    shape: RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),

                  child: const Text(

                    "送信する",

                    style: TextStyle(

                      fontSize: 20,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // カードUI
  // =========================
  Widget reviewCard({

    required String siteName,

    required String userName,

    required String content,

    required int rating,

    String? imageUrl,

    String? url,
  }) {

    return InkWell(

      borderRadius:
          BorderRadius.circular(
        16,
      ),

      onTap: () => openUrl(url),

      child: Container(

        margin:
            const EdgeInsets.symmetric(

          horizontal: 16,
          vertical: 10,
        ),

        padding:
            const EdgeInsets.all(16),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            16,
          ),

          boxShadow: const [

            BoxShadow(

              color: Colors.black12,

              blurRadius: 8,

              offset: Offset(0, 3),
            ),
          ],
        ),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Row(

              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

                buildAvatar(
                  imageUrl,
                ),

                const SizedBox(
                  width: 12,
                ),

                Expanded(

                  child: Padding(

                    padding: const EdgeInsets.only(left: 10),

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                      Text(

                        siteName
                                .isNotEmpty
                            ? siteName
                            : "不明サイト",

                        maxLines: 1,

                        overflow:
                            TextOverflow
                                .ellipsis,

                        style:
                            const TextStyle(

                          fontSize: 20,

                          fontWeight:
                              FontWeight
                                  .w900,

                          color:
                              Color(0xFF1A237E),
                        ),
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      Row(

                        children: [

                          Row(

                            children: List.generate(

                              rating,

                              (_) => const Padding(

                                padding: EdgeInsets.only(right: 2),

                                child: Icon(

                                  Icons.star,

                                  color: Colors.amber,

                                  size: 18,

                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(

                            child: Align(

                              alignment: Alignment.centerRight,

                              child: Text(

                                userName.isNotEmpty
                                    ? userName
                                    : "匿名",

                                style: TextStyle(

                                  fontWeight: FontWeight.bold,

                                  color: Colors.grey.shade700,

                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 14,
            ),

            Container(

              width:
                  double.infinity,

              padding:
                  const EdgeInsets.all(
                12,
              ),

              decoration:
                  BoxDecoration(

                color:
                    Colors.grey.shade200,

                borderRadius:
                    BorderRadius
                        .circular(
                  12,
                ),
              ),

              child: Text(

                content.isNotEmpty
                    ? content
                    : "コメントなし",

                style:
                    const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),

            const SizedBox(
              height: 14,
            ),

            Center(
              child: SizedBox(
                width: 240,

                child: DecoratedBox(

                  decoration: BoxDecoration(

                    color: const Color(0xFF1A237E),

                    borderRadius: BorderRadius.circular(14),

                    boxShadow: const [

                      BoxShadow(

                        color: Colors.black26,

                        blurRadius: 8,

                        offset: Offset(0, 3),

                      ),

                    ],
                  ),

                  child: ElevatedButton(

                  onPressed: () {
                    openUrl(url);
                  },

                  style: ElevatedButton.styleFrom(

                    backgroundColor: Colors.transparent,

                    shadowColor: Colors.transparent,

                    foregroundColor: Colors.white,

                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),

                    elevation: 0,
                  ),

                  child: const Text(

                    "サイトを確認する",

                    style: TextStyle(

                      fontSize: 16,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // build
  // =========================
  @override
  Widget build(
    BuildContext context,
  ) {

    super.build(context);

    final scrollController =
        context
            .read<
                ScrollTopProvider>()
            .reviewController;

    return Scaffold(

      backgroundColor:
          Colors.grey[100],

      appBar: AppBar(

        backgroundColor:
            const Color(
          0xFF1A237E,
        ),

        centerTitle: true,

        automaticallyImplyLeading:
            false,

        title: const Text(

          "クチコミ",

          style: TextStyle(

            color: Colors.white,

            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: Column(

        children: [

          Expanded(

            child: isLoading

                ? const Center(

                    child:
                        CircularProgressIndicator(),
                  )

                : ListView.builder(

                    controller:
                        scrollController,

                    key:
                        const PageStorageKey(
                      "review_page",
                    ),

                    // =========================
                    // 🔥 投稿フォーム追加
                    // =========================
                    itemCount:
                        reviews.length +
                            3,

                    itemBuilder:
                        (
                          context,
                          index,
                        ) {

                      // =========================
                      // HEADER
                      // =========================
                      if (index == 0) {

                        return Column(

                          children: [

                            const SizedBox(
                              height: 12,
                            ),

                            Padding(

                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),

                              child: ClipRRect(

                                borderRadius:
                                    BorderRadius.circular(18),

                                child: Image.asset(

                                  'assets/images/review_header.png',

                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 14,
                            ),

                          ],
                        );
                      }

                      // =====================
                      // クチコミ0件対応
                      // =====================
                      if (reviews.isEmpty) {

                        if (index == 1) {

                          return const Padding(

                            padding: EdgeInsets.symmetric(
                              vertical: 30,
                            ),

                            child: Center(

                              child: Text(

                                "クチコミはまだありません",

                                style: TextStyle(

                                  fontSize: 16,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }

                        // 投稿フォーム
                        if (index == 2) {

                          return buildReviewForm();
                        }

                        return const SizedBox();
                      }

                      // =========================
                      // 🔥 AdMob
                      // クチコミ3件目と4件目の間
                      // =========================
                      if (index == 4) {

                        return const Padding(

                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),

                          child: AdmobBannerWidget(

                            adUnitId:
                                'ca-app-pub-7409422327092258/9138551624',
                          ),
                        );
                      }
                      
                      // reviews.isEmpty の場合は
                      // 上で buildReviewForm() を返している
                      // =========================
                      // 🔥 最下部フォーム
                      // =========================
                      if (index ==
                          reviews.length +
                              2) {

                        return buildReviewForm();
                      }

                      final reviewIndex =
                          index > 4
                              ? index - 2
                              : index - 1;

                      // =========================
                      // 安全対策
                      // =========================
                      if (reviewIndex < 0 ||
                          reviewIndex >= reviews.length) {

                        return const SizedBox();
                      }

                      final r =
                          reviews[reviewIndex];

                      final rawImage =
                          r["image_url"]
                              ?.toString();

                      final rawUrl =
                          r["url"]
                              ?.toString();

                      String? imageUrl;

                      if (rawImage !=
                              null &&
                          rawImage
                              .isNotEmpty) {

                        if (rawImage
                            .startsWith(
                          "http",
                        )) {

                          imageUrl =
                              rawImage;

                        } else {

                          final cleanedPath =
                              rawImage
                                  .replaceFirst(
                            RegExp(
                              r'^/+',
                            ),
                            '',
                          );

                          imageUrl =
                              "$baseUrl/$cleanedPath";
                        }
                      }

                      return reviewCard(

                        siteName:
                            (r["site_name"] ??
                                    "")
                                .toString(),

                        userName:
                            (r["user_name"] ??
                                    "")
                                .toString(),

                        content:
                            (r["comment"] ??
                                    "")
                                .toString(),

                        rating:
                            int.tryParse(
                                  r["rating"]
                                      .toString(),
                                ) ??
                                0,

                        imageUrl:
                            imageUrl,

                        url: rawUrl,
                      );
                    },
                  ),
          ),

          const BottomBanner(),
        ],
      ),
    );
  }
}