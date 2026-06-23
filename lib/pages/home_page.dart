import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/home_provider.dart';
import '../providers/ranking_provider.dart';
import '../providers/main_page_provider.dart';
import '../providers/banner_provider.dart';

// =========================
// 🔥 追加
// TOPスクロール制御
// =========================
import '../providers/scroll_top_provider.dart';

import '../widgets/site_card.dart';
import '../widgets/hit_ranking_card.dart';
import '../widgets/trend_ranking_card.dart';
import '../widgets/ranking_header.dart';
import '../widgets/bottom_banner.dart';
import '../widgets/admob_banner_widget.dart';

import '../models/site_model.dart';

class HomePage extends StatefulWidget {

  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState()
      => _HomePageState();
}

class _HomePageState
    extends State<HomePage>

    // =========================
    // 🔥 IndexedStack状態保持
    // =========================
    with AutomaticKeepAliveClientMixin {

  // =========================
  // 🔥 KeepAlive
  // =========================
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {

    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {

      if (!mounted) return;

      // =========================
      // ホーム取得
      // =========================
      context
          .read<HomeProvider>()
          .loadHome();

      // =========================
      // ランダムバナー変更
      // =========================
      context
          .read<BannerProvider>()
          .pickRandomBanner();
    });
  }

  @override
  Widget build(BuildContext context) {

    // =========================
    // 🔥 KeepAlive必須
    // =========================
    super.build(context);

    final provider =
        context.watch<HomeProvider>();

    // =========================
    // 🔥 ScrollController取得
    // =========================
    final scrollController =
        context
            .read<
                ScrollTopProvider>()
            .homeController;

    // =========================
    // ローディング
    // =========================
    if (provider.isLoading) {

      return const Scaffold(

        body: Center(

          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(

      backgroundColor:
          Colors.white,

      // =========================
      // AppBar
      // =========================
      appBar: AppBar(

        backgroundColor:
            Color(0xFF2196F3),

        centerTitle: true,

        // =========================
        // 🔥 MainPage管理用
        // 戻る矢印非表示
        // =========================
        automaticallyImplyLeading:
            false,

        title: const Text(

          "ホーム",

          style: TextStyle(

            color: Colors.white,

            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      // =========================
      // 本体
      // =========================
      body: Column(

        children: [

          // =========================
          // メインコンテンツ
          // =========================
          Expanded(

            child: RefreshIndicator(

              // =========================
              // async gap警告修正版
              // =========================
              onRefresh: () async {

                final homeProvider =
                    context.read<HomeProvider>();

                final bannerProvider =
                    context.read<BannerProvider>();

                await homeProvider.loadHome();

                if (!mounted) return;

                bannerProvider
                    .pickRandomBanner();

                // =========================
                // 🔥 更新後TOPへ
                // =========================
                scrollController
                    .jumpTo(0);
              },

              child: ListView.builder(

                // =========================
                // 🔥 TOPスクロール制御
                // =========================
                controller:
                    scrollController,

                // =========================
                // 🔥 スクロール位置保持
                // =========================
                key:
                    const PageStorageKey(
                  "home_page",
                ),

                itemCount:
                    1 +
                    provider.rankings
                        .take(3)
                        .length +
                    1 +
                    1 + // AdMob
                    provider
                        .trendRankings
                        .take(3)
                        .length +
                    1 +
                    provider
                        .sites
                        .length +
                    10,

                itemBuilder:
                    (context, index) {

                  // =========================
                  // TOPバナー
                  // =========================
                  if (index == 0) {

                    return Padding(

                      padding:
                          const EdgeInsets
                              .all(12),

                      child: ClipRRect(

                        borderRadius:
                            BorderRadius
                                .circular(
                          12,
                        ),

                        child: Image.asset(

                          'assets/images/home_header_No.1.png',

                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  }

                  int currentIndex = 1;

                  // =========================
                  // 高額的中ランキング
                  // =========================
                  if (
                      index ==
                          currentIndex) {

                    return const RankingHeader(

                      title: "高額的中",

                      icon:
                          Icons.gps_fixed,
                    );
                  }

                  currentIndex++;

                  // =========================
                  // 高額的中ランキング0件
                  // =========================
                  if (provider.rankings.isEmpty &&
                      index == currentIndex) {

                    return const Padding(

                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                      ),

                      child: Center(

                        child: Text(

                          "現在ランキングはありません",

                          style: TextStyle(

                            fontSize: 16,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }

                  currentIndex++;

                  if (
                      provider.rankings.isNotEmpty &&
                      index <
                          currentIndex +
                              provider
                                  .rankings
                                  .take(3)
                                  .length) {

                    final rankingIndex =
                        index - currentIndex;

                    if (
                        rankingIndex < 0 ||
                        rankingIndex >=
                            provider.rankings.length) {

                      return const SizedBox();
                    }

                    final item =
                        provider.rankings
                            .take(3)
                            .toList()[rankingIndex];

                    return HitRankingCard(
                      ranking: item,
                    );
                  }

                  currentIndex +=
                      provider.rankings
                          .take(3)
                          .length;

                  // =========================
                  // もっと見る
                  // =========================
                  if (
                      provider.rankings.isNotEmpty &&
                      index == currentIndex) {

                    return Center(

                      child:
                          ElevatedButton(

                        style:
                            ElevatedButton
                                .styleFrom(

                          backgroundColor:
                              Colors.blue,

                          padding:
                              const EdgeInsets
                                  .symmetric(

                            horizontal:
                                30,

                            vertical:
                                10,
                          ),
                        ),

                        onPressed: () {

                          context
                              .read<
                                  RankingProvider>()
                              .changeTab(
                            0,
                          );

                          context
                              .read<
                                  MainPageProvider>()
                              .changeIndex(
                            1,
                          );
                        },

                        child: const Text(

                          "View more",

                          style:
                              TextStyle(
                            color: Colors
                                .white,
                          ),
                        ),
                      ),
                    );
                  }

                  currentIndex++;

                  // =========================
                  // 🔥 AdMob
                  // 高額的中と的中数の間
                  // =========================
                  if (index == currentIndex) {

                    return const Padding(

                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),

                      child: AdmobBannerWidget(
                        adUnitId:
                            'ca-app-pub-7409422327092258/1674994570',
                      ),
                    );
                  }

                  currentIndex++;

                  // =========================
                  // 的中数ランキング
                  // =========================
                  if (
                      index ==
                          currentIndex) {

                    return const RankingHeader(

                      title: "的中数",

                      icon:
                          Icons
                              .trending_up,
                    );
                  }

                  currentIndex++;

                  // =========================
                  // 的中数ランキング0件
                  // =========================
                  if (provider.trendRankings.isEmpty &&
                      index == currentIndex) {

                    return const Padding(

                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                      ),

                      child: Center(

                        child: Text(

                          "現在ランキングはありません",

                          style: TextStyle(

                            fontSize: 16,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }

                  currentIndex++;

                  if (
                      provider.trendRankings.isNotEmpty &&
                      index <
                          currentIndex +
                              provider
                                  .trendRankings
                                  .take(3)
                                  .length) {

                    final rankingIndex =
                        index - currentIndex;

                    if (
                        rankingIndex < 0 ||
                        rankingIndex >=
                            provider.trendRankings.length) {

                      return const SizedBox();
                    }

                    final item =
                        provider
                            .trendRankings
                            .take(3)
                            .toList()[rankingIndex];

                    return TrendRankingCard(
                      ranking: item,
                    );
                  }

                  currentIndex +=
                      provider
                          .trendRankings
                          .take(3)
                          .length;

                  // =========================
                  // もっと見る
                  // =========================
                  if (
                      provider.trendRankings.isNotEmpty &&
                      index == currentIndex) {

                    return Center(

                      child:
                          ElevatedButton(

                        style:
                            ElevatedButton
                                .styleFrom(

                          backgroundColor:
                              Colors.blue,

                          padding:
                              const EdgeInsets
                                  .symmetric(

                            horizontal:
                                30,

                            vertical:
                                10,
                          ),
                        ),

                        onPressed: () {

                          context
                              .read<
                                  RankingProvider>()
                              .changeTab(
                            1,
                          );

                          context
                              .read<
                                  MainPageProvider>()
                              .changeIndex(
                            1,
                          );
                        },

                        child: const Text(

                          "View more",

                          style:
                              TextStyle(
                            color: Colors
                                .white,
                          ),
                        ),
                      ),
                    );
                  }

                  currentIndex++;

                  // =========================
                  // 優良競馬サイト一覧
                  // =========================
                  if (
                      index ==
                          currentIndex) {

                    return const RankingHeader(

                      title:
                          "優良競馬サイト一覧",

                      icon: Icons.star,

                      showRankingText:
                          false,

                      showIcon: false,
                    );
                  }

                  currentIndex++;

                  // =========================
                  // 掲載サイト0件
                  // =========================
                  if (provider.sites.isEmpty &&
                      index == currentIndex) {

                    return const Padding(

                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                      ),

                      child: Center(

                        child: Text(

                          "現在掲載サイトはありません",

                          style: TextStyle(

                            fontSize: 16,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }

                  currentIndex++;

                  if (
                      provider.sites.isNotEmpty &&
                      index <
                          currentIndex +
                              provider.sites.length) {

                    final siteIndex =
                        index - currentIndex;

                    if (
                        siteIndex < 0 ||
                        siteIndex >=
                            provider.sites.length) {

                      return const SizedBox();
                    }

                    final SiteModel site =
                        provider.sites[siteIndex];

                        return SiteCard(
                          site: site,
                        );
                      }

                  return const SizedBox(
                    height: 40,
                  );
                },
              ),
            ),
          ),

          // =========================
          // 共通バナー
          // =========================
          const BottomBanner(),
        ],
      ),
    );
  }
}