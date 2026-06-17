import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/main_page_provider.dart';
import '../providers/prediction_provider.dart';
import '../providers/ranking_provider.dart';

// =========================
// 🔥 追加
// バナー切替用
// =========================
import '../providers/banner_provider.dart';

// =========================
// 🔥 追加
// スクロールTOP制御用
// =========================
import '../providers/scroll_top_provider.dart';

import 'home_page.dart';
import 'ranking_page.dart';
import 'review_page.dart';
import 'blog_page.dart';
import 'prediction_page.dart';

class MainPage extends StatefulWidget {

  // =========================
  // 🔥 初期タブIndex
  // DeepLink対応（超重要）
  // =========================
  final int initialIndex;

  const MainPage({

    super.key,

    // =========================
    // 🔥 デフォルトHOME
    // =========================
    this.initialIndex = 0,
  });

  @override
  State<MainPage> createState()
      => _MainPageState();
}

class _MainPageState
    extends State<MainPage> {

  // =========================
  // 🔥 タブページ一覧
  // IndexedStack用
  //
  // 超重要：
  // ページ状態保持
  // BottomNavigation消失防止
  // =========================
  late final List<Widget> pages;

  @override
  void initState() {

    super.initState();

    // =========================
    // 🔥 ページ生成
    // =========================
    pages = [

      const HomePage(),

      const RankingPage(),

      const ReviewPage(),

      const BlogPage(),

      const PredictionPage(),
    ];

    // =========================
    // 🔥 初期タブ設定
    // DeepLink対応（超重要）
    // =========================
    WidgetsBinding.instance
        .addPostFrameCallback((_) {

      if (!mounted) {
        return;
      }

      // =========================
      // 🔥 BottomNavigation切替
      // =========================
      context
          .read<MainPageProvider>()
          .changeIndex(
            widget.initialIndex,
          );

      // =========================
      // 🔥 ランキング初期化
      // ランキング遷移時は
      // 必ず獲得金額タブ
      // =========================
      if (widget.initialIndex == 1) {

        context
            .read<RankingProvider>()
            .changeTab(0);
      }

      // =========================
      // 🔥 初回バナー変更
      // =========================
      context
          .read<BannerProvider>()
          .pickRandomBanner();

      // =========================
      // 🔥 予想タブならロード
      // =========================
      if (widget.initialIndex == 4) {

        context
            .read<PredictionProvider>()
            .loadToday();
      }

      // =========================
      // 🔥 初回TOPスクロール
      // =========================
      context
          .read<ScrollTopProvider>()
          .scrollToTop(
            widget.initialIndex,
          );
    });

    // =========================
    // 🔥 通常起動時ロード
    // =========================
    WidgetsBinding.instance
        .addPostFrameCallback((_) {

      if (!mounted) {
        return;
      }

      context
          .read<PredictionProvider>()
          .loadToday();
    });
  }

  @override
  Widget build(BuildContext context) {

    final provider =
        context.watch<
            MainPageProvider>();

    return Scaffold(

      backgroundColor:
          Colors.black,

      // =========================
      // 🔥 IndexedStack化（超重要）
      //
      // BottomNavigation消失防止
      // タブ状態保持
      // スクロール位置保持
      // =========================
      body: IndexedStack(

        index: provider.index,

        children: pages,
      ),

      // =========================
      // 🔥 BottomNavigation
      // =========================
      bottomNavigationBar:
          BottomNavigationBar(

        currentIndex:
            provider.index,

        onTap: (i) {

          final currentIndex =
              provider.index;

          // =========================
          // 🔥 ランキングタブ押下時
          // 必ず獲得金額へ戻す
          // =========================
          if (i == 1) {

            context
                .read<RankingProvider>()
                .changeTab(0);
          }

          // =========================
          // 🔥 同じタブ押下
          // =========================
          if (currentIndex == i) {

            // =========================
            // 🔥 同じタブでも
            // TOPへ戻す
            // =========================
            context
                .read<ScrollTopProvider>()
                .scrollToTop(i);

            // =========================
            // 🔥 予想タブリセット
            // =========================
            if (i == 4) {

              context
                  .read<
                      PredictionProvider>()
                  .reset();

              context
                  .read<
                      PredictionProvider>()
                  .loadToday();
            }

            return;
          }

          // =========================
          // 🔥 バナー変更（超重要）
          //
          // ページ遷移時に
          // 必ず別バナーへ変更
          // =========================
          context
              .read<BannerProvider>()
              .pickRandomBanner();

          // =========================
          // 🔥 通常タブ切替
          // =========================
          context
              .read<
                  MainPageProvider>()
              .changeIndex(i);

          // =========================
          // 🔥 TOPへ戻す
          // =========================
          context
              .read<ScrollTopProvider>()
              .scrollToTop(i);

          // =========================
          // 🔥 予想ページロード
          // =========================
          if (i == 4) {

            final predictionProvider =
                context.read<
                    PredictionProvider>();

            // 🔥 選択状態リセット
            predictionProvider.reset();

            // 🔥 今日の予想再取得
            predictionProvider.loadToday();
          }
        },

        type:
            BottomNavigationBarType
                .fixed,

        backgroundColor:
            Colors.black,

        // =========================
        // 🔥 ラベル白
        // =========================
        selectedItemColor:
            Colors.white,

        unselectedItemColor:
            Colors.grey,

        selectedLabelStyle:
            const TextStyle(

          fontWeight:
              FontWeight.bold,
        ),

        // =========================
        // 🔥 アイコンサイズ
        // =========================
        iconSize: 30,

        items: const [

          // =========================
          // 🔥 HOME
          // =========================
          BottomNavigationBarItem(

            icon: Icon(
              Icons.home,
              color:
                  Color(0xFF1976D2),
            ),

            activeIcon: Icon(
              Icons.home,
              color:
                  Color(0xFF2196F3),
            ),

            label: "ホーム",
          ),

          // =========================
          // 🔥 Ranking
          // =========================
          BottomNavigationBarItem(

            icon: Icon(
              Icons.emoji_events,
              color:
                  Color(0xFFFBC02D),
            ),

            activeIcon: Icon(
              Icons.emoji_events,
              color:
                  Color(0xFFFFEB3B),
            ),

            label: "ランキング",
          ),

          // =========================
          // 🔥 Review
          // =========================
          BottomNavigationBarItem(

            icon: Icon(
              Icons.chat_bubble,
              color:
                  Color(0xFFD32F2F),
            ),

            activeIcon: Icon(
              Icons.chat_bubble,
              color:
                  Color(0xFFF44336),
            ),

            label: "クチコミ",
          ),

          // =========================
          // 🔥 Blog
          // =========================
          BottomNavigationBarItem(

            icon: Icon(
              Icons.article,
              color:
                  Color(0xFFC2185B),
            ),

            activeIcon: Icon(
              Icons.article,
              color:
                  Color(0xFFE91E63),
            ),

            label: "競馬ブログ",
          ),

          // =========================
          // 🔥 Prediction
          // =========================
          BottomNavigationBarItem(

            icon: Icon(
              Icons.show_chart,
              color:
                  Color(0xFF388E3C),
            ),

            activeIcon: Icon(
              Icons.show_chart,
              color:
                  Color(0xFF4CAF50),
            ),

            label: "無料予想",
          ),
        ],
      ),
    );
  }
}