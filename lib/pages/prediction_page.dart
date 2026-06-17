import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/prediction_provider.dart';
import '../providers/home_provider.dart';
import '../providers/banner_provider.dart';

// =========================
// 🔥 追加
// TOPスクロール制御
// =========================
import '../providers/scroll_top_provider.dart';

import '../models/race_model.dart';

import '../widgets/site_card.dart';
import '../widgets/bottom_banner.dart';

/// =========================
/// 🔥 除外（部分一致対応）
/// =========================
const excludePlaces = <String>[
  "帯広",
];

bool isExcluded(String place) {
  return excludePlaces.any(
    (e) => place.contains(e),
  );
}

class PredictionPage extends StatefulWidget {

  const PredictionPage({
    super.key,
  });

  @override
  State<PredictionPage> createState() =>
      _PredictionPageState();
}

class _PredictionPageState
    extends State<PredictionPage>

    // =========================
    // 🔥 KeepAlive
    // =========================
    with AutomaticKeepAliveClientMixin {

  // =========================
  // 🔥 KeepAlive有効
  // =========================
  @override
  bool get wantKeepAlive => true;

  /// =========================
  /// 🔥 多重初期化防止
  /// =========================
  bool _initialized = false;

  @override
  void initState() {

    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) async {

      if (!mounted) return;

      /// =========================
      /// 🔥 多重実行防止
      /// =========================
      if (_initialized) return;

      _initialized = true;

      final predictionProvider =
          context.read<PredictionProvider>();

      final homeProvider =
          context.read<HomeProvider>();

      final bannerProvider =
          context.read<BannerProvider>();

      try {

        /// =========================
        /// 🔥 予想取得
        /// =========================
        await predictionProvider
            .reloadToday();

        if (!mounted) return;

        /// =========================
        /// 🔥 サイト取得
        /// =========================
        await homeProvider.loadHome();

        if (!mounted) return;

        /// =========================
        /// 🔥 ランダムバナー
        /// =========================
        bannerProvider.pickRandomBanner();

      } catch (e) {

        debugPrint(
          "PredictionPage init error: $e",
        );
      }
    });
  }

  // =========================
  // ⭐ 日付
  // =========================
  String getFormattedDate() {

    final now = DateTime.now();

    const weekdays = [
      "月",
      "火",
      "水",
      "木",
      "金",
      "土",
      "日",
    ];

    final weekday =
        weekdays[now.weekday - 1];

    return
        "${now.year}年${now.month}月${now.day}日（$weekday）";
  }

  // =========================
  // 🔥 競馬場選択
  // =========================
  void showPlaceDialog(
    BuildContext context,
    PredictionProvider provider,
  ) {

    final filteredPlaces = provider
        .places
        .where(
          (place) =>
              !isExcluded(place),
        )
        .toList();

    if (filteredPlaces.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
              Text("開催中の競馬場がありません"),
        ),
      );

      return;
    }

    showDialog(

      context: context,

      builder: (_) {

        return AlertDialog(

          title: const Text(
            "競馬場を以下から選択して下さい！",
          ),

          content: SizedBox(

            width: double.maxFinite,

            child: ListView(

              shrinkWrap: true,

              children:
                  filteredPlaces.map((place) {

                return ListTile(

                  title: Text(place),

                  onTap: () {

                    provider.selectPlace(
                      place,
                    );

                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  // =========================
  // 🔥 レースカード
  // =========================
  Widget raceCard(
    PredictionProvider provider,
    RaceModel race,
  ) {

    final picks = race.prediction;

    if (picks.isEmpty) {
      return const SizedBox();
    }

    final p1 =
        picks.isNotEmpty
            ? picks[0]
            : null;

    final p2 =
        picks.length >= 2
            ? picks[1]
            : null;

    final p3 =
        picks.length >= 3
            ? picks[2]
            : null;

    Widget buildBox(
      int? number,
      String label,
    ) {

      if (number == null) {
        return const SizedBox();
      }

      final color =
          provider.getColor(number);

      Color labelColor;

      double fontSize;

      if (label == "◎") {

        labelColor = Colors.red;

        fontSize = 30;

      } else if (label == "○") {

        labelColor =
            Colors.blue[900]!;

        fontSize = 27;

      } else {

        labelColor = Colors.black;

        fontSize = 25;
      }

      return Row(
        children: [

          Text(

            label,

            style: TextStyle(

              fontWeight:
                  FontWeight.bold,

              fontSize: fontSize,

              color: labelColor,
            ),
          ),

          const SizedBox(
            width: 6,
          ),

          Container(

            width: 42,
            height: 42,

            alignment:
                Alignment.center,

            decoration: BoxDecoration(

              color: color,

              borderRadius:
                  BorderRadius.circular(
                6,
              ),
            ),

            child: Text(

              "$number",

              style: TextStyle(

                fontWeight:
                    FontWeight.bold,

                fontSize: 16,

                color:
                    number == 1 ||
                            number == 5
                        ? Colors.black
                        : Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [

        Text(

          "${race.place}${race.raceNumber}R",

          style: const TextStyle(

            color: Colors.blue,

            fontWeight:
                FontWeight.bold,

            fontSize: 18,
          ),
        ),

        const SizedBox(
          height: 8,
        ),

        Row(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            const Text(

              "推奨馬 ",

              style: TextStyle(

                fontWeight:
                    FontWeight.bold,

                fontSize: 16,
              ),
            ),

            const SizedBox(
              width: 10,
            ),

            buildBox(p1, "◎"),

            const SizedBox(
              width: 10,
            ),

            buildBox(p2, "○"),

            const SizedBox(
              width: 10,
            ),

            buildBox(p3, "▲"),
          ],
        ),

        const Divider(
          height: 25,
        ),
      ],
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    // =========================
    // 🔥 KeepAlive必須
    // =========================
    super.build(context);

    final provider =
        context.watch<PredictionProvider>();

    final homeProvider =
        context.watch<HomeProvider>();

    // =========================
    // 🔥 ScrollController取得
    // =========================
    final scrollController =
        context
            .read<
                ScrollTopProvider>()
            .predictionController;

    /// =========================
    /// 🔥 API完全重複除去
    /// =========================
    final uniqueMap =
        <String, RaceModel>{};

    for (final race
        in provider.races) {

      final key =
          "${race.place}_${race.raceNumber}";

      uniqueMap[key] = race;
    }

    /// =========================
    /// 🔥 除外 + 重複除去
    /// =========================
    final filteredRaces =
        uniqueMap.values
            .where(
              (race) =>
                  !isExcluded(
                race.place,
              ),
            )
            .toList()

          ..sort(
            (a, b) {

              final placeCompare =
                  a.place.compareTo(
                b.place,
              );

              if (placeCompare != 0) {
                return placeCompare;
              }

              return a.raceNumber
                  .compareTo(
                b.raceNumber,
              );
            },
          );

    return Scaffold(

      backgroundColor:
          Colors.grey[100],

      appBar: AppBar(

        backgroundColor:
            Color(0xFF4CAF50),

        centerTitle: true,

        automaticallyImplyLeading:
            false,

        title: const Text(

          "競馬AI予想",

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
                provider.isLoading

                    ? const Center(
                        child:
                            CircularProgressIndicator(),
                      )

                    : ListView(

                        // =========================
                        // 🔥 TOPスクロール制御
                        // =========================
                        controller:
                            scrollController,

                        // =========================
                        // 🔥 スクロール保持
                        // =========================
                        key:
                            const PageStorageKey(
                          "prediction_page",
                        ),

                        children: [

                          const SizedBox(
                            height: 10,
                          ),

                          Padding(

                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 12,
                            ),

                            child: ClipRRect(

                              borderRadius:
                                  BorderRadius.circular(
                                12,
                              ),

                              child: Image.asset(

                                'assets/images/prediction_header_No.1.png',

                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Container(

                            margin:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 16,
                            ),

                            padding:
                                const EdgeInsets.all(
                              12,
                            ),

                            alignment:
                                Alignment.center,

                            color:
                                Colors.black87,

                            child: Text(

                              getFormattedDate(),

                              style:
                                  const TextStyle(

                                color:
                                    Colors.white,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          GestureDetector(

                            onTap: () {

                              showPlaceDialog(
                                context,
                                provider,
                              );
                            },

                            child: Container(

                              margin:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 16,
                              ),

                              padding:
                                  const EdgeInsets
                                      .all(
                                14,
                              ),

                              decoration:
                                  BoxDecoration(

                                color: Colors.white,

                                borderRadius:
                                    BorderRadius.circular(
                                  12,
                                ),

                                border: Border.all(
                                  color:
                                      Colors.green,
                                  width: 2,
                                ),
                              ),

                              child: Text(

                                provider
                                        .selectedPlace
                                        .isEmpty
                                    ? "タップして競馬場を選択して下さい！"
                                    : provider
                                        .selectedPlace,

                                style:
                                    const TextStyle(

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          const Padding(

                            padding:
                                EdgeInsets.symmetric(
                              horizontal: 16,
                            ),

                            child: Text(

                              "※20歳未満の方は、競馬法により馬券(勝馬投票券)を購入したり、譲り受けてはいけない事になっていますので、注意して下さい。",

                              style: TextStyle(

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          /// =========================
                          /// 🔥 レース一覧
                          /// =========================
                          ...filteredRaces.map(
                            (race) {

                              return raceCard(
                                provider,
                                race,
                              );
                            },
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          Padding(

                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 16,
                            ),

                            child: Container(

                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                vertical: 14,
                              ),

                              decoration:
                                  BoxDecoration(

                                borderRadius:
                                    BorderRadius.circular(
                                  20,
                                ),

                                gradient:
                                    const LinearGradient(

                                  colors: [

                                    Color(
                                      0xFF3A3A3A,
                                    ),

                                    Color(
                                      0xFF1F1F1F,
                                    ),
                                  ],
                                ),
                              ),

                              child:
                                  const Center(

                                child: Text(

                                  "▼ 優良サイトの無料予想を入手 ▼",

                                  style:
                                      TextStyle(

                                    color:
                                        Colors.white,

                                    fontWeight:
                                        FontWeight.bold,

                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          ...homeProvider.sites.map(
                            (e) {

                              return SiteCard(
                                site: e,
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