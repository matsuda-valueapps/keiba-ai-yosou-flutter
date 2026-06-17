import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:provider/provider.dart';

// =========================
// 🔥 追加
// キャッシュ画像
// =========================
import 'package:cached_network_image/cached_network_image.dart';

// =========================
// 🔥 services
// =========================
import '../services/blog_service.dart';

// =========================
// 🔥 providers
// =========================
import '../providers/banner_provider.dart';

// =========================
// 🔥 widgets
// =========================
import '../widgets/bottom_banner.dart';

// =========================
// 🔥 pages
// BottomNavigation遷移用
// =========================
import 'main_page.dart';

class BlogDetailPage
    extends StatefulWidget {

  // =========================
  // 🔥 blog object
  // =========================
  final Map<String, dynamic>? blog;

  // =========================
  // 🔥 blog_id
  // =========================
  final int? blogId;

  const BlogDetailPage({

    super.key,

    this.blog,

    this.blogId,
  });

  @override
  State<BlogDetailPage> createState() =>
      _BlogDetailPageState();
}

class _BlogDetailPageState
    extends State<BlogDetailPage> {

  // =========================
  // 🔥 実データ
  // =========================
  Map<String, dynamic>? _blog;

  // =========================
  // loading
  // =========================
  bool _isLoading = true;

  // =========================
  // 🔥 現在タブ
  // ブログ
  // =========================
  static const int _currentIndex = 3;

  // =========================
  // init
  // =========================
  @override
  void initState() {

    super.initState();

    loadBlog();

    // =========================
    // 🔥 バナー変更
    // =========================
    WidgetsBinding.instance
        .addPostFrameCallback((_) {

      if (!mounted) {
        return;
      }

      context
          .read<BannerProvider>()
          .pickRandomBanner();
    });
  }

  // =========================
  // 🔥 blog取得
  // =========================
  Future<void> loadBlog() async {

    // =========================
    // ① blog object直接
    // =========================
    if (widget.blog != null) {

      _blog = widget.blog;

      _isLoading = false;

      if (mounted) {
        setState(() {});
      }

      return;
    }

    // =========================
    // ② blog_id取得
    // =========================
    if (widget.blogId != null) {

      final result =
          await BlogService
              .getBlogById(
        widget.blogId!,
      );

      _blog = result;

      _isLoading = false;

      if (mounted) {
        setState(() {});
      }

      return;
    }

    // =========================
    // ③ データなし
    // =========================
    _isLoading = false;

    if (mounted) {
      setState(() {});
    }
  }

  // =========================
  // ⭐ 画像URL補正
  // =========================
  String buildImageUrl(
    String path,
  ) {

    if (path.isEmpty) {
      return "";
    }

    // localhost → 実IP
    path = path.replaceAll(
      "127.0.0.1",
      "api.keiba-ai-yosou.com",
    );

    // 完全URL
    if (path.startsWith("http")) {
      return path;
    }

    // /uploads/xxx
    if (path.startsWith("/")) {

      return
          "https://api.keiba-ai-yosou.com$path";
    }

    // uploads/xxx
    return
        "https://api.keiba-ai-yosou.com/$path";
  }

  // =========================
  // ⭐ URL起動
  // =========================
  Future<void> openUrl(
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
  // 🔥 BottomNavigation遷移
  // =========================
  void onTabTapped(
    int index,
  ) {

    // =========================
    // 🔥 ブログ押下
    // =========================
    if (index == _currentIndex) {

      Navigator.pushAndRemoveUntil(

        context,

        MaterialPageRoute(

          builder: (_) => const MainPage(
            initialIndex: 3,
          ),
        ),

        (route) => false,
      );

      return;
    }

    // =========================
    // 🔥 他タブ
    // =========================
    Navigator.pushAndRemoveUntil(

      context,

      MaterialPageRoute(

        builder: (_) => MainPage(
          initialIndex: index,
        ),
      ),

      (route) => false,
    );
  }

  // =========================
  // 🔥 共通BottomNavigation
  // =========================
  Widget buildBottomNavigation() {

    return BottomNavigationBar(

      currentIndex:
          _currentIndex,

      onTap:
          onTabTapped,

      type:
          BottomNavigationBarType
              .fixed,

      backgroundColor:
          Colors.black,

      selectedItemColor:
          Colors.white,

      unselectedItemColor:
          Colors.grey,

      selectedLabelStyle:
          const TextStyle(

        fontWeight:
            FontWeight.bold,
      ),

      iconSize: 30,

      items: const [

        BottomNavigationBarItem(

          icon: Icon(
            Icons.home,
            color:
                Color(0xFF6EF3D6),
          ),

          activeIcon: Icon(
            Icons.home,
            color:
                Color(0xFF00F5D4),
          ),

          label: "Home",
        ),

        BottomNavigationBarItem(

          icon: Icon(
            Icons.emoji_events,
            color:
                Color(0xFFFFC107),
          ),

          activeIcon: Icon(
            Icons.emoji_events,
            color:
                Color(0xFFFFD54F),
          ),

          label: "ランキング",
        ),

        BottomNavigationBarItem(

          icon: Icon(
            Icons.chat_bubble,
            color:
                Color(0xFFFF4081),
          ),

          activeIcon: Icon(
            Icons.chat_bubble,
            color:
                Color(0xFFFF5C93),
          ),

          label: "クチコミ",
        ),

        BottomNavigationBarItem(

          icon: Icon(
            Icons.article,
            color:
                Color(0xFFFFB74D),
          ),

          activeIcon: Icon(
            Icons.article,
            color:
                Color(0xFFFFCC80),
          ),

          label: "ブログ",
        ),

        BottomNavigationBarItem(

          icon: Icon(
            Icons.show_chart,
            color:
                Color(0xFF64B5F6),
          ),

          activeIcon: Icon(
            Icons.show_chart,
            color:
                Color(0xFF90CAF9),
          ),

          label: "予想",
        ),
      ],
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    // =========================
    // loading
    // =========================
    if (_isLoading) {

      return Scaffold(

        backgroundColor:
            Colors.grey[200],

        appBar: AppBar(

          backgroundColor:
              Color(0xFFE91E63),

          centerTitle: true,

          title: const Text(

            "ブログ詳細",

            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),

        body: const Center(
          child:
              CircularProgressIndicator(),
        ),

        bottomNavigationBar:
            Column(

          mainAxisSize:
              MainAxisSize.min,

          children: [

            const BottomBanner(),

            buildBottomNavigation(),
          ],
        ),
      );
    }

    // =========================
    // null安全
    // =========================
    final safeBlog =
        _blog ?? {};

    final title =
        safeBlog["title"] ?? "";

    final rawContent =
        safeBlog["content"] ?? "";

    // =========================
    // 改行
    // =========================
    final content =
        rawContent.replaceAll(
      "\n",
      "<br>",
    );

    final imageUrl =
        buildImageUrl(
      safeBlog["image_url"] ?? "",
    );

    return Scaffold(

      backgroundColor:
          Colors.grey[200],

      appBar: AppBar(

        backgroundColor:
            Color(0xFFE91E63),

        centerTitle: true,

        leading: IconButton(

          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),

          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(

          "ブログ詳細",

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

            child:
                SingleChildScrollView(

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  // =========================
                  // 🔥 キャッシュ画像
                  // =========================
                  if (imageUrl.isNotEmpty)

                    CachedNetworkImage(

                      imageUrl: imageUrl,

                      width:
                          double.infinity,

                      fit: BoxFit.contain,

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

                          height: 350,

                          color:
                              Colors.grey
                                  .shade300,

                          alignment:
                              Alignment.center,

                          child:
                              const SizedBox(

                            width: 28,
                            height: 28,

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

                          height: 350,

                          color:
                              Colors.grey,

                          child:
                              const Center(

                            child: Icon(

                              Icons
                                  .image_not_supported,

                              color: Colors
                                  .white,

                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(
                    height: 16,
                  ),

                  Padding(

                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 16,
                    ),

                    child: Text(

                      title,

                      style:
                          const TextStyle(

                        fontSize: 20,

                        fontWeight:
                            FontWeight
                                .bold,

                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Padding(

                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 16,
                    ),

                    child: Html(

                      data: content,

                      onLinkTap: (

                        String? url,

                        Map<String,
                                String>
                            attributes,

                        element,

                      ) async {

                        if (url ==
                            null) {
                          return;
                        }

                        await openUrl(
                          url,
                        );
                      },

                      style: {

                        "body": Style(

                          fontSize:
                              FontSize(
                                  15),

                          lineHeight:
                              LineHeight(
                                  1.8),

                          color:
                              Colors.black,

                          margin:
                              Margins.zero,

                          padding:
                              HtmlPaddings
                                  .zero,
                        ),

                        "p": Style(

                          margin:
                              Margins(
                            bottom:
                                Margin(
                                    14),
                          ),
                        ),

                        "b": Style(
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),

                        "strong":
                            Style(
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),

                        "a": Style(
                          textDecoration:
                              TextDecoration
                                  .none,
                        ),

                        "h1": Style(

                          fontSize:
                              FontSize(
                                  28),

                          fontWeight:
                              FontWeight
                                  .bold,
                        ),

                        "h2": Style(

                          fontSize:
                              FontSize(
                                  24),

                          fontWeight:
                              FontWeight
                                  .bold,
                        ),

                        "ul": Style(

                          margin:
                              Margins(
                            left:
                                Margin(
                                    18),
                          ),
                        ),

                        "li": Style(

                          margin:
                              Margins(
                            bottom:
                                Margin(8),
                          ),
                        ),
                      },

                      extensions: [

                        TagExtension(

                          tagsToExtend: {
                            "a"
                          },

                          builder:
                              (context) {

                            final href =
                                context
                                        .attributes[
                                    "href"];

                            return Center(

                              child:
                                  GestureDetector(

                                onTap:
                                    () async {

                                  if (href ==
                                      null) {
                                    return;
                                  }

                                  await openUrl(
                                    href,
                                  );
                                },

                                child:
                                    Container(

                                  margin:
                                      const EdgeInsets.symmetric(
                                    vertical:
                                        16,
                                  ),

                                  padding:
                                      const EdgeInsets.symmetric(

                                    horizontal:
                                        20,

                                    vertical:
                                        6,
                                  ),

                                  decoration:
                                      BoxDecoration(

                                    color:
                                        Colors.blue,

                                    borderRadius:
                                        BorderRadius.circular(
                                      10,
                                    ),
                                  ),

                                  child:
                                      Text(

                                    context
                                            .element
                                            ?.text ??
                                        "リンクを開く",

                                    textAlign:
                                        TextAlign.center,

                                    style:
                                        const TextStyle(

                                      color:
                                          Colors.white,

                                      fontWeight:
                                          FontWeight.bold,

                                      fontSize:
                                          16,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),

          // =========================
          // 🔥 共通バナー
          // =========================
          const BottomBanner(),
        ],
      ),

      bottomNavigationBar:
          buildBottomNavigation(),
    );
  }
}