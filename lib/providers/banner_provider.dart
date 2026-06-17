import 'dart:math';

import 'package:flutter/material.dart';

import '../models/banner_model.dart';
import '../services/banner_service.dart';

class BannerProvider extends ChangeNotifier {

  // =========================
  // バナー一覧
  // =========================
  List<BannerModel> banners = [];

  // =========================
  // 現在表示中バナー
  // =========================
  BannerModel? currentBanner;

  // =========================
  // 直前表示ID
  // =========================
  int? lastBannerId;

  // =========================
  // 初回取得済み判定
  // =========================
  bool isLoaded = false;

  // =========================
  // ローディング
  // =========================
  bool isLoading = false;

  // =========================
  // 🔥 Random固定化
  // 毎回new Random()しない
  // =========================
  final Random _random = Random();

  // =========================
  // 初回のみAPI取得
  // =========================
  Future<void> loadBanners() async {

    // =========================
    // 二重取得防止
    // =========================
    if (isLoaded || isLoading) {
      return;
    }

    try {

      isLoading = true;

      debugPrint(
        "🎯 バナー初回取得開始",
      );

      // =========================
      // API取得
      // =========================
      final result =
          await BannerService.fetchBanners();

      banners = result;

      debugPrint(
        "✅ バナー取得件数: ${banners.length}",
      );

      // =========================
      // 初回ランダム抽選
      // =========================
      pickRandomBanner();

      isLoaded = true;

      notifyListeners();

    } catch (e) {

      debugPrint(
        "❌ バナー取得失敗: $e",
      );

    } finally {

      isLoading = false;
    }
  }

  // =========================
  // 🔥 最強ランダム抽選
  //
  // ・直前バナー除外
  // ・同一連続防止
  // ・無限ループ防止
  // ・空対策
  // ・1件対策
  // =========================
  void pickRandomBanner() {

    // =========================
    // 空対策
    // =========================
    if (banners.isEmpty) {

      debugPrint(
        "⚠ バナー0件",
      );

      return;
    }

    // =========================
    // 1件のみ
    // =========================
    if (banners.length == 1) {

      currentBanner = banners.first;

      lastBannerId =
          currentBanner?.id;

      debugPrint(
        "🎯 単一バナー表示: "
        "${currentBanner?.title}",
      );

      notifyListeners();

      return;
    }

    // =========================
    // 🔥 現在ID取得
    // =========================
    final currentId =
        currentBanner?.id;

    BannerModel selected;

    int retry = 0;

    // =========================
    // 🔥 同一連続回避
    // =========================
    do {

      selected = banners[
        _random.nextInt(
          banners.length,
        )
      ];

      retry++;

      // =========================
      // 🔥 異常ループ防止
      // =========================
      if (retry >= 20) {
        break;
      }

    } while (

      // =========================
      // 🔥 現在表示中と同じ
      // =========================
      selected.id == currentId ||

      // =========================
      // 🔥 直前表示と同じ
      // =========================
      selected.id == lastBannerId
    );

    // =========================
    // 🔥 更新
    // =========================
    currentBanner = selected;

    lastBannerId = selected.id;

    debugPrint(
      "🎲 ランダムバナー変更: "
      "${selected.title}"
      " (ID:${selected.id})",
    );

    notifyListeners();
  }

  // =========================
  // 🔥 強制変更
  // （将来用）
  // =========================
  void forcePick() {

    debugPrint(
      "🔥 強制バナー変更",
    );

    pickRandomBanner();
  }

  // =========================
  // 手動リロード
  // （将来用）
  // =========================
  Future<void> reload() async {

    try {

      debugPrint(
        "🔄 バナー再取得開始",
      );

      isLoaded = false;

      banners = [];

      currentBanner = null;

      lastBannerId = null;

      notifyListeners();

      await loadBanners();

    } catch (e) {

      debugPrint(
        "❌ バナー再取得失敗: $e",
      );
    }
  }

  // =========================
  // 🔥 現在表示中判定
  // =========================
  bool isCurrentBanner(
    int bannerId,
  ) {

    return currentBanner?.id ==
        bannerId;
  }

  // =========================
  // 🔥 バナー件数
  // =========================
  int get bannerCount {

    return banners.length;
  }

  // =========================
  // 🔥 表示中バナー存在判定
  // =========================
  bool get hasBanner {

    return currentBanner != null;
  }
}