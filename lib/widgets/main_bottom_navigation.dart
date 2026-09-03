import 'package:flutter/material.dart';

class MainBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  // =========================
  // アイコンサイズ
  //
  // 各アイコンを個別に調整可能
  // =========================
  final double homeIconSize;
  final double rankingIconSize;
  final double reviewIconSize;
  final double blogIconSize;
  final double aiPredictionIconSize;

  const MainBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,

    // =========================
    // デフォルトサイズ
    //
    // 従来のMaterial Iconと同じ30px
    // =========================
    this.homeIconSize = 42,
    this.rankingIconSize = 40,
    this.reviewIconSize = 42,
    this.blogIconSize = 42,
    this.aiPredictionIconSize = 42,
  });

  @override
  Widget build(BuildContext context) {
    // =========================
    // ナビゲーション項目
    // =========================
    const items = [
      _NavigationItem(
        assetPath: 'assets/icon/home.png',
        label: 'ホーム',
      ),
      _NavigationItem(
        assetPath: 'assets/icon/ranking.png',
        label: 'ランキング',
      ),
      _NavigationItem(
        assetPath: 'assets/icon/review.png',
        label: 'クチコミ',
      ),
      _NavigationItem(
        assetPath: 'assets/icon/blog.png',
        label: 'ブログ',
      ),
      _NavigationItem(
        assetPath: 'assets/icon/AI prediction.png',
        label: 'AI予想',
      ),
    ];

    // =========================
    // 各アイコンのサイズ
    // =========================
    final iconSizes = [
      homeIconSize,
      rankingIconSize,
      reviewIconSize,
      blogIconSize,
      aiPredictionIconSize,
    ];

    return Container(
      // =========================
      // BottomNavigation背景
      // =========================
      color: const Color(0xFF0D47A1),

      child: SafeArea(
        top: false,

        child: SizedBox(
          height: 72,

          child: Row(
            children: List.generate(
              items.length,
              (index) {
                final item = items[index];

                final bool isSelected =
                    currentIndex == index;

                // =========================
                // ラベルカラー
                // =========================
                final Color labelColor =
                    isSelected
                        ? Colors.white
                        : Colors.grey;

                return Expanded(
                  child: Material(
                    color: Colors.transparent,

                    child: InkWell(
                      // =========================
                      // タップ処理
                      // =========================
                      onTap: () {
                        onTap(index);
                      },

                      // =========================
                      // Ripple設定
                      //
                      // タップ時に白い光を表示
                      // =========================
                      splashColor:
                          Colors.white.withValues(
                        alpha: 0.25,
                      ),

                      // =========================
                      // 押している間のハイライト
                      // =========================
                      highlightColor:
                          Colors.white.withValues(
                        alpha: 0.10,
                      ),

                      // =========================
                      // Rippleの角丸
                      // =========================
                      borderRadius:
                          BorderRadius.circular(12),

                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [
                          // =========================
                          // アイコン
                          //
                          // PNG画像を使用
                          //
                          // 各アイコンごとにサイズ調整可能
                          // =========================
                          SizedBox(
                            width: iconSizes[index],
                            height: iconSizes[index],

                            child: Image.asset(
                              item.assetPath,

                              // =========================
                              // 画像の表示方法
                              //
                              // アイコン全体を収める
                              // =========================
                              fit: BoxFit.contain,

                              // =========================
                              // 画像読み込み失敗時
                              // =========================
                              errorBuilder:
                                  (
                                context,
                                error,
                                stackTrace,
                              ) {
                                return const Icon(
                                  Icons.image_not_supported,
                                  size: 24,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),

                          const SizedBox(
                            height: 2,
                          ),

                          // =========================
                          // ラベル
                          //
                          // 選択中 → w900
                          // 非選択 → w900
                          //
                          // 色・サイズは既存仕様を維持
                          //
                          // w900 + Paint
                          // =========================
                          Stack(
                            alignment:
                                Alignment.center,

                            children: [
                              // =========================
                              // 後ろ側
                              //
                              // Paintのストロークで
                              // 文字の外周を太くする
                              // =========================
                              Text(
                                item.label,

                                style: TextStyle(
                                  fontSize:
                                      isSelected
                                          ? 13
                                          : 12,

                                  fontWeight:
                                      FontWeight.w900,

                                  foreground:
                                      Paint()
                                        ..style =
                                            PaintingStyle
                                                .stroke
                                        ..strokeWidth =
                                            0.8
                                        ..color =
                                            labelColor,
                                ),

                                textAlign:
                                    TextAlign.center,

                                maxLines: 1,

                                overflow:
                                    TextOverflow
                                        .ellipsis,
                              ),

                              // =========================
                              // 前側
                              //
                              // 通常のw900文字
                              // =========================
                              Text(
                                item.label,

                                style: TextStyle(
                                  color: labelColor,

                                  fontSize:
                                      isSelected
                                          ? 13
                                          : 12,

                                  fontWeight:
                                      FontWeight.w900,
                                ),

                                textAlign:
                                    TextAlign.center,

                                maxLines: 1,

                                overflow:
                                    TextOverflow
                                        .ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// =========================
// BottomNavigation項目
// =========================
class _NavigationItem {
  final String assetPath;
  final String label;

  const _NavigationItem({
    required this.assetPath,
    required this.label,
  });
}