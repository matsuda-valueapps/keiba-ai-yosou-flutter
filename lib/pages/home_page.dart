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

    // =========================
    // データなし
    // =========================
    if (
        provider.sites.isEmpty &&
        provider.rankings.isEmpty &&
        provider.trendRankings
            .isEmpty) {

      return const Scaffold(

        body: Center(

          child: Text(
            "データがありません",
          ),
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

                  if (
                      index <
                          currentIndex +
                              provider
                                  .rankings
                                  .take(3)
                                  .length) {

                    final item =
                        provider.rankings
                            .take(3)
                            .toList()[
                                index -
                                    currentIndex];

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
                      index ==
                          currentIndex) {

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

                  if (
                      index <
                          currentIndex +
                              provider
                                  .trendRankings
                                  .take(3)
                                  .length) {

                    final item =
                        provider
                            .trendRankings
                            .take(3)
                            .toList()[
                                index -
                                    currentIndex];

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
                      index ==
                          currentIndex) {

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
                  // おすすめサイト
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

                  if (
                      index <
                          currentIndex +
                              provider
                                  .sites
                                  .length) {

                    final SiteModel site =
                        provider.sites[
                            index -
                                currentIndex];

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