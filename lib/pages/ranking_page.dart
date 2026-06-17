import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ranking_provider.dart';
import '../providers/banner_provider.dart';

// =========================
// 🔥 追加
// TOPスクロール制御
// =========================
import '../providers/scroll_top_provider.dart';

import '../models/ranking_model.dart';

import '../widgets/hit_ranking_card.dart';
import '../widgets/trend_ranking_card.dart';
import '../widgets/bottom_banner.dart';

class RankingPage extends StatefulWidget {

  const RankingPage({
    super.key,
  });

  @override
  State<RankingPage> createState() =>
      _RankingPageState();
}

class _RankingPageState
    extends State<RankingPage>

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
      // 🔥 ランキング取得
      // =========================
      context
          .read<RankingProvider>()
          .fetchRanking();

      // =========================
      // 🔥 ランダムバナー
      // =========================
      context
          .read<BannerProvider>()
          .pickRandomBanner();
    });
  }

  // =========================
  // 🔥 ダミー補完
  // =========================
  List<RankingModel> buildDummy(

    List<RankingModel> list,

    bool isAmountTab,
  ) {

    if (list.length >= 10) {
      return list;
    }

    final newList = [...list];

    for (

      int i = list.length + 1;

      i <= 10;

      i++
    ) {

      newList.add(

        RankingModel(

          // =========================
          // 基本
          // =========================
          id: -i,

          rank: i,

          // =========================
          // site
          // =========================
          siteId: 0,

          siteName:
              "ダミー競馬サイト$i",

          // =========================
          // 🔥 追加
          // ダミー画像
          // =========================
          imageUrl: "",

          // =========================
          // 🔥 blog_id
          // =========================
          blogId: null,

          // =========================
          // 🔥 site_url
          // =========================
          siteUrl: "",

          // =========================
          // レース
          // =========================
          raceName:
              "中山${i}R",

          // =========================
          // 日付
          // =========================
          date:
              "2026-03-${10 + i}",

          // =========================
          // 金額
          // =========================
          amount:
              isAmountTab
                  ? 300000 -
                      (i - 4) * 20000
                  : 0,

          // =========================
          // 的中数
          // =========================
          hitCount:
              isAmountTab
                  ? 0
                  : 60 -
                      (i - 4) * 3,

          // =========================
          // 🔥 ranking_type
          // =========================
          rankingType:
              isAmountTab
                  ? "amount"
                  : "hit_count",
        ),
      );
    }

    return newList;
  }

  // =========================
  // 🔥 TOPへ戻す
  // =========================
  void scrollToTop(
    ScrollController controller,
  ) {

    WidgetsBinding.instance
        .addPostFrameCallback((_) {

      if (!controller.hasClients) {
        return;
      }

      controller.animateTo(

        0,

        duration:
            const Duration(
          milliseconds: 250,
        ),

        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    super.build(context);

    final provider =
        context.watch<
            RankingProvider>();

    // =========================
    // 🔥 ScrollController
    // =========================
    final scrollController =
        context
            .read<
                ScrollTopProvider>()
            .rankingController;

    final displayList =
        buildDummy(

      provider.rankings,

      provider.tabIndex == 0,
    );

    return Scaffold(

      backgroundColor:
          Colors.grey[100],

      appBar: AppBar(

        backgroundColor:
            Color(0xFFFFEB3B),

        centerTitle: true,

        automaticallyImplyLeading:
            false,

        title: Text(

          provider.tabIndex == 0
              ? "高額的中ランキング"
              : "的中数ランキング",

          style: const TextStyle(

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
                provider.isLoading

                    ? const Center(
                        child:
                            CircularProgressIndicator(),
                      )

                    : ListView(

                        // =========================
                        // 🔥 共通Controller
                        // =========================
                        controller:
                            scrollController,

                        children: [

                          const SizedBox(
                            height: 16,
                          ),

                          // =========================
                          // タイトル
                          // =========================
                          Row(

                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,

                            children: [

                              Text(

                                provider.tabIndex ==
                                        0
                                    ? "高額的中"
                                    : "的中数",

                                style:
                                    const TextStyle(

                                  color:
                                      Color(0xFFFBC02D),

                                  fontSize: 32,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                width: 6,
                              ),

                              const Icon(
                                Icons.gps_fixed,
                                size: 28,
                              ),

                              const SizedBox(
                                width: 6,
                              ),

                              const Text(

                                "ランキング",

                                style:
                                    TextStyle(

                                  fontSize: 32,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          // =========================
                          // 説明
                          // =========================
                          const Padding(

                            padding:
                                EdgeInsets.symmetric(
                              horizontal:
                                  16,
                            ),

                            child: Text(

                              "的中金額が高額なサイト、的中数が多いサイトを、ランキング形式でご紹介しますので、競馬予想サイト選びの参考にして下さい！",

                              style:
                                  TextStyle(

                                fontWeight:
                                    FontWeight.bold,

                                fontSize: 15,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // =========================
                          // タブ
                          // =========================
                          Padding(

                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal:
                                  16,
                            ),

                            child: Row(

                              children: [

                                // =========================
                                // 高額的中
                                // =========================
                                Expanded(

                                  child:
                                      GestureDetector(

                                    onTap: () {

                                      provider
                                          .changeTab(
                                        0,
                                      );

                                      // =========================
                                      // 🔥 TOPへ戻す
                                      // =========================
                                      scrollToTop(
                                        scrollController,
                                      );
                                    },

                                    child:
                                        Container(

                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        vertical:
                                            14,
                                      ),

                                      decoration:
                                          BoxDecoration(

                                        color:
                                            provider.tabIndex ==
                                                    0
                                                ? Colors.black
                                                : Colors.grey
                                                    .shade300,

                                        borderRadius:
                                            BorderRadius.circular(
                                          16,
                                        ),
                                      ),

                                      child:
                                          Center(

                                        child:
                                            Text(

                                          "高額的中",

                                          style:
                                              TextStyle(

                                            color:
                                                provider.tabIndex ==
                                                        0
                                                    ? Colors.white
                                                    : Colors.black,

                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                // =========================
                                // 的中数
                                // =========================
                                Expanded(

                                  child:
                                      GestureDetector(

                                    onTap: () {

                                      provider
                                          .changeTab(
                                        1,
                                      );

                                      // =========================
                                      // 🔥 TOPへ戻す
                                      // =========================
                                      scrollToTop(
                                        scrollController,
                                      );
                                    },

                                    child:
                                        Container(

                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        vertical:
                                            14,
                                      ),

                                      decoration:
                                          BoxDecoration(

                                        color:
                                            provider.tabIndex ==
                                                    1
                                                ? Colors.black
                                                : Colors.grey
                                                    .shade300,

                                        borderRadius:
                                            BorderRadius.circular(
                                          16,
                                        ),
                                      ),

                                      child:
                                          Center(

                                        child:
                                            Text(

                                          "的中数",

                                          style:
                                              TextStyle(

                                            color:
                                                provider.tabIndex ==
                                                        1
                                                    ? Colors.white
                                                    : Colors.black,

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
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          // =========================
                          // ランキング一覧
                          // =========================
                          ...displayList.map(
                            (e) {

                              if (
                                  provider.tabIndex ==
                                  0) {

                                return HitRankingCard(
                                  ranking: e,
                                );
                              }

                              return TrendRankingCard(
                                ranking: e,
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
          // 🔥 共通バナー
          // =========================
          const BottomBanner(),
        ],
      ),
    );
  }
}