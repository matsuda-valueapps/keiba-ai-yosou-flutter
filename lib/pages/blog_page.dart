import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart'
    as http;

import 'package:provider/provider.dart';

// =========================
// 🔥 追加
// キャッシュ画像
// =========================
import 'package:cached_network_image/cached_network_image.dart';

// =========================
// ⭐ 詳細
// =========================
import 'blog_detail_page.dart';

// =========================
// ⭐ Banner
// =========================
import '../widgets/bottom_banner.dart';
import '../widgets/admob_banner_widget.dart';
import '../providers/banner_provider.dart';

// =========================
// 🔥 追加
// TOPスクロール制御
// =========================
import '../providers/scroll_top_provider.dart';

class BlogPage extends StatefulWidget {

  const BlogPage({
    super.key,
  });

  @override
  State<BlogPage> createState() =>
      _BlogPageState();
}

class _BlogPageState
    extends State<BlogPage>

    with AutomaticKeepAliveClientMixin {

  // =========================
  // 🔥 型安全化
  // =========================
  List<Map<String, dynamic>>
      blogs = [];

  bool isLoading = true;

  // =========================
  // API BASE URL
  // =========================
  static const String apiBaseUrl =
      "https://api.keiba-ai-yosou.com";

  // =========================
  // ⭐ KeepAlive
  // =========================
  @override
  bool get wantKeepAlive => true;

  // =========================
  // ⭐ API取得
  // =========================
  Future<void> fetchBlogs() async {

    try {

      final res = await http.get(

        Uri.parse(
          "$apiBaseUrl/blogs",
        ),
      );

      if (!mounted) {
        return;
      }

      final decoded =
          jsonDecode(res.body);

      final List<Map<String, dynamic>>
          safeList = [];

      if (decoded is List) {

        for (final item
            in decoded) {

          if (item
              is Map<String, dynamic>) {

            safeList.add(item);
          }
        }
      }

      setState(() {

        blogs = safeList;

        isLoading = false;
      });

    } catch (e) {

      debugPrint(
        "取得エラー: $e",
      );

      if (!mounted) {
        return;
      }

      setState(() {

        isLoading = false;
      });
    }
  }

  @override
  void initState() {

    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {

      if (!mounted) {
        return;
      }

      // =========================
      // ブログ取得
      // =========================
      fetchBlogs();

      // =========================
      // ⭐ ランダムバナー
      // =========================
      context
          .read<BannerProvider>()
          .pickRandomBanner();
    });
  }

  // =========================
  // ⭐ 画像URL
  // =========================
  String buildImageUrl(
    String path,
  ) {

    if (path.isEmpty) {
      return "";
    }

    // localhost対策
    path = path.replaceAll(
      "127.0.0.1",
      "api.keiba-ai-yosou.com",
    );

    // 完全URL
    if (path.startsWith("http")) {
      return path;
    }

    // /uploads
    if (path.startsWith("/")) {

      return "$apiBaseUrl$path";
    }

    // uploads
    return "$apiBaseUrl/$path";
  }

  // =========================
  // ⭐ カード
  // =========================
  Widget blogCard(
    Map<String, dynamic> b,
  ) {

    final title =
        (b["title"] ?? "")
            .toString();

    final image =
        buildImageUrl(

      (b["image_url"] ?? "")
          .toString(),
    );

    return GestureDetector(

      // =========================
      // ⭐ 詳細遷移
      // =========================
      onTap: () {

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (_) =>
                BlogDetailPage(
              blog: b,
            ),
          ),
        );
      },

      child: Container(

        margin:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),

        padding:
            const EdgeInsets.all(14),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            14,
          ),

          boxShadow: const [

            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
            ),
          ],
        ),

        child: Row(

          children: [

            // =========================
            // 左
            // =========================
            Expanded(

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  Text(

                    title,

                    maxLines: 2,

                    overflow:
                        TextOverflow
                            .ellipsis,

                    style:
                        const TextStyle(

                      fontSize: 17,

                      fontWeight:
                          FontWeight.bold,

                      color:
                          Colors.blue,
                    ),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  Container(

                    padding:
                        const EdgeInsets
                            .symmetric(

                      horizontal: 18,
                      vertical: 10,
                    ),

                    decoration:
                        BoxDecoration(

                      color: Color(0xFFE91E63),

                      borderRadius:
                          BorderRadius
                              .circular(
                        12,
                      ),
                    ),

                    child: const Text(

                      "競馬ブログを読む！",

                      style: TextStyle(

                        color:
                            Colors.white,

                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              width: 10,
            ),

            // =========================
            // 🔥 キャッシュ画像
            // =========================
            ClipRRect(

              borderRadius:
                  BorderRadius.circular(
                10,
              ),

              child: image.isEmpty

                  ? Container(

                      width: 90,

                      height: 90,

                      color:
                          Colors.grey,
                    )

                  : CachedNetworkImage(

                      imageUrl: image,

                      width: 90,

                      height: 90,

                      fit: BoxFit.cover,

                      fadeInDuration:
                          Duration.zero,

                      fadeOutDuration:
                          Duration.zero,

                      placeholder:
                          (
                            context,
                            url,
                          ) {

                        return Container(

                          width: 90,

                          height: 90,

                          color:
                              Colors.grey
                                  .shade300,

                          alignment:
                              Alignment.center,

                          child:
                              const SizedBox(

                            width: 22,
                            height: 22,

                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },

                      errorWidget:
                          (
                            context,
                            url,
                            error,
                          ) {

                        return Container(

                          width: 90,

                          height: 90,

                          color:
                              Colors.grey,

                          alignment:
                              Alignment.center,

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
          ],
        ),
      ),
    );
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(
    BuildContext context,
  ) {

    super.build(context);

    // =========================
    // 🔥 ScrollController取得
    // =========================
    final scrollController =
        context
            .read<
                ScrollTopProvider>()
            .blogController;

    return Scaffold(

      backgroundColor:
          Colors.grey[200],

      // =========================
      // AppBar
      // =========================
      appBar: AppBar(

        backgroundColor:
            Color(0xFFE91E63),

        centerTitle: true,

        automaticallyImplyLeading:
            false,

        title: const Text(

          "競馬ブログ",

          style: TextStyle(

            color: Colors.white,

            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      // =========================
      // Body
      // =========================
      body: Column(

        children: [

          Expanded(

            child: isLoading

                ? const Center(
                    child:
                        CircularProgressIndicator(),
                  )

                : ListView(

                    controller:
                        scrollController,

                    key:
                        const PageStorageKey(
                      "blog_page",
                    ),

                    children: [

                      const SizedBox(
                        height: 16,
                      ),

                      Row(

                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,

                        children: const [

                          Text(

                            "競馬",

                            style:
                                TextStyle(

                              color:
                                  Color(0xFFE91E63),

                              fontSize:
                                  34,

                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          SizedBox(
                            width: 6,
                          ),

                          Icon(
                            Icons.menu_book,
                            size: 30,
                          ),

                          SizedBox(
                            width: 6,
                          ),

                          Text(

                            "ブログ",

                            style:
                                TextStyle(

                              fontSize: 34,

                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      const Padding(

                        padding:
                            EdgeInsets
                                .symmetric(
                          horizontal: 20,
                        ),

                        child: Text(

                          "競馬予想サイトの紹介や予想の検証等、サイト選びの役に立つブログを掲載しています！",

                          textAlign:
                              TextAlign.center,

                          style: TextStyle(

                            fontSize: 15,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      if (blogs.isEmpty)

                        const Center(

                          child: Padding(

                            padding:
                                EdgeInsets.all(
                              20,
                            ),

                            child: Text(
                              "ブログがありません",
                            ),
                          ),
                        )

                      else

                        ...List.generate(

                          blogs.length +

                              // 4件以上なら広告1個追加
                              (blogs.length >= 4 ? 1 : 0),

                          (index) {

                            // =========================
                            // 🔥 記事3件目と4件目の間
                            // =========================
                            if (
                                blogs.length >= 4 &&
                                index == 3) {

                              return const Padding(

                                      padding:
                                          EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),

                                      child: AdmobBannerWidget(

                                        // blog_banner
                                        adUnitId:
                                            'ca-app-pub-7409422327092258/3007991614',
                                      ),
                                    );
                            }

                            // =========================
                            // 広告以降はIndex補正
                            // =========================
                            final blogIndex =

                                blogs.length >= 4 &&
                                        index > 3
                                    ? index - 1
                                    : index;

                            return blogCard(
                              blogs[blogIndex],
                            );
                          },
                        ),

                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
          ),

          // =========================
          // Banner
          // =========================
          const BottomBanner(),
        ],
      ),
    );
  }
}