import 'package:flutter/material.dart';
import '../models/site_model.dart';
import '../models/ranking_model.dart';

import '../services/api_service.dart';
import '../services/ranking_service.dart';

class HomeProvider extends ChangeNotifier {

  List<SiteModel> sites = [];

  /// ⭐ 獲得金額ランキング（TOP3）
  List<RankingModel> rankings = [];

  /// ⭐ 的中数ランキング（TOP3）
  List<RankingModel> trendRankings = [];

  bool isLoading = true;

  /// ⭐ キャッシュ防止
  bool _loaded = false;

  Future loadHome({bool force = false}) async {

    /// 🔥 無駄リクエスト防止
    if (_loaded && !force) return;

    isLoading = true;
    notifyListeners();

    /// =========================
    /// ⭐ サイト取得
    /// =========================
    try {
      final siteJson = await ApiService.getSites();

      sites = siteJson
          .map<SiteModel>((e) => SiteModel.fromJson(e))
          .toList();

    } catch (e) {
      debugPrint("SITE ERROR: $e");
      sites = [];
    }

    /// =========================
    /// ⭐ 獲得金額ランキング（TOP3）
    /// =========================
    try {
      rankings = await RankingService.fetchRankings(
        RankingService.typeAmount,
        limit: 3, // 🔥 ここが最重要
      );
    } catch (e) {
      debugPrint("RANKING ERROR: $e");
      rankings = [];
    }

    /// =========================
    /// ⭐ 的中数ランキング（TOP3）
    /// =========================
    try {
      trendRankings = await RankingService.fetchRankings(
        RankingService.typeHit,
        limit: 3, // 🔥 ここが最重要
      );
    } catch (e) {
      debugPrint("TREND ERROR: $e");
      trendRankings = [];
    }

    _loaded = true;

    isLoading = false;
    notifyListeners();
  }

  /// ⭐ 強制リロード（PullToRefresh用）
  Future<void> refresh() async {
    _loaded = false;
    await loadHome(force: true);
  }
}