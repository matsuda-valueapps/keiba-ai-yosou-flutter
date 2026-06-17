import 'package:flutter/material.dart';
import '../services/ranking_service.dart';
import '../models/ranking_model.dart';

class RankingProvider extends ChangeNotifier {

  // =========================
  // ⭐ 状態
  // =========================
  List<RankingModel> rankings = [];
  bool isLoading = false;

  /// 0: amount（獲得金額） / 1: hit_count（的中数）
  int tabIndex = 0;

  /// ⭐ 初回ロード防止
  bool _initialized = false;

  // =========================
  // ⭐ ランキング取得（10件固定）
  // =========================
  Future<void> fetchRanking({bool force = false}) async {

    /// 🔥 無駄リクエスト防止
    if (_initialized && !force) return;

    isLoading = true;
    notifyListeners();

    try {
      final type = tabIndex == 0
          ? RankingService.typeAmount
          : RankingService.typeHit;

      /// 🔥 ★ここが重要（10件取得）
      rankings = await RankingService.fetchRankings(
        type,
        limit: 10,
      );

      _initialized = true;

    } catch (e) {
      debugPrint('Ranking fetch error: $e');
      rankings = [];
    }

    isLoading = false;
    notifyListeners();
  }

  // =========================
  // ⭐ タブ切替
  // =========================
  Future<void> changeTab(int index) async {

    if (tabIndex == index) return;

    tabIndex = index;

    /// 🔥 タブ変更時は再取得
    _initialized = false;

    await fetchRanking(force: true);
  }

  // =========================
  // ⭐ 強制リロード（PullToRefresh用）
  // =========================
  Future<void> refresh() async {
    _initialized = false;
    await fetchRanking(force: true);
  }
}