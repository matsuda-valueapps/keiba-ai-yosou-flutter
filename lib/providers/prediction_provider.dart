import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../models/race_model.dart';
import '../services/race_service.dart';

class PredictionProvider extends ChangeNotifier {

  final RaceService _service = RaceService();

  /// ⭐ Logger
  final Logger _log = Logger('PredictionProvider');

  /// 🔥 除外競馬場
  static const excludePlaces = ["帯広"];

  List<String> places = [];

  List<RaceModel> races = [];

  String selectedPlace = "";

  bool isLoading = false;

  /// ⭐ キャッシュフラグ
  bool _loaded = false;

  /// ⭐ 日付キャッシュ
  String _loadedDate = "";

  /// ⭐ レースキャッシュ
  final Map<String, List<RaceModel>> _raceCache = {};

  /// =========================
  /// 🔥 多重実行ガード（超重要）
  /// =========================
  bool _isFetchingToday = false;

  bool _isFetchingRace = false;

  /// =========================
  /// ⭐ 今日取得
  /// =========================
  Future<void> loadToday() async {

    /// 🔥 多重実行防止
    if (_isFetchingToday) {

      _log.warning(
        "loadToday 多重実行をブロック",
      );

      return;
    }

    _isFetchingToday = true;

    final today =
        DateTime.now()
            .toString()
            .substring(0, 10);

    try {

      /// =========================
      /// ⭐ 日付変更
      /// =========================
      if (_loadedDate != today) {

        _log.info(
          "日付変更 → キャッシュリセット",
        );

        _loaded = false;

        _raceCache.clear();

        _loadedDate = today;
      }

      /// =========================
      /// ⭐ キャッシュ使用
      /// =========================
      if (_loaded) {

        _log.info(
          "キャッシュ使用（loadTodayスキップ）",
        );

        return;
      }

      isLoading = true;

      notifyListeners();

      final fetchedPlaces =
          await _service.fetchTodayPlaces();

      _log.info(
        "取得した競馬場一覧: $fetchedPlaces",
      );

      /// =========================
      /// 🔥 除外処理
      /// =========================
      places = fetchedPlaces
          .where(
            (p) =>
                !excludePlaces.contains(p),
          )
          .toList();

      /// =========================
      /// 🔥 重複除去（順序維持版）
      /// 超重要
      /// =========================
      final List<String> uniquePlaces = [];

      for (final place in places) {

        if (!uniquePlaces.contains(place)) {

          uniquePlaces.add(place);
        }
      }

      places = uniquePlaces;

      /// =========================
      /// ⭐ 初期化
      /// =========================
      selectedPlace = "";

      races = [];

      _loaded = true;

    } catch (e, stackTrace) {

      _log.severe(
        "競馬場取得エラー",
        e,
        stackTrace,
      );

      places = [];

      selectedPlace = "";

      races = [];

    } finally {

      isLoading = false;

      _isFetchingToday = false;

      notifyListeners();
    }
  }

  /// =========================
  /// ⭐ 強制リロード
  /// =========================
  Future<void> reloadToday() async {

    /// 🔥 多重防止
    if (_isFetchingToday) {

      _log.warning(
        "reloadToday 多重実行をブロック",
      );

      return;
    }

    _log.info("強制リロード実行");

    _loaded = false;

    _raceCache.clear();

    await loadToday();
  }

  /// =========================
  /// ⭐ 競馬場選択
  /// =========================
  Future<void> selectPlace(
    String place,
  ) async {

    /// 🔥 除外ガード
    if (excludePlaces.contains(place)) {

      _log.warning(
        "除外対象の競馬場をブロック: $place",
      );

      return;
    }

    /// 🔥 同一選択スキップ
    if (selectedPlace == place &&
        races.isNotEmpty) {

      _log.info(
        "同一競馬場のためスキップ: $place",
      );

      return;
    }

    selectedPlace = place;

    notifyListeners();

    await loadRaces(place);
  }

  /// =========================
  /// ⭐ レース取得
  /// =========================
  Future<void> loadRaces(
    String place,
  ) async {

    /// 🔥 多重実行防止
    if (_isFetchingRace) {

      _log.warning(
        "loadRaces 多重実行をブロック",
      );

      return;
    }

    _isFetchingRace = true;

    try {

      /// 🔥 除外ガード
      if (excludePlaces.contains(place)) {

        _log.warning(
          "除外対象のためスキップ: $place",
        );

        races = [];

        notifyListeners();

        return;
      }

      /// =========================
      /// ⭐ キャッシュ使用
      /// =========================
      if (_raceCache.containsKey(place)) {

        _log.info(
          "キャッシュ使用: $place",
        );

        races = _raceCache[place]!;

        notifyListeners();

        return;
      }

      isLoading = true;

      notifyListeners();

      final result =
          await _service.fetchRaces(place);

      _log.info(
        "$place のレース一覧: $result",
      );

      /// =========================
      /// 🔥 完全重複除去
      /// =========================
      final uniqueMap =
          <String, RaceModel>{};

      for (final race in result) {

        final key =
            "${race.place}_${race.raceNumber}";

        uniqueMap[key] = race;
      }

      races = uniqueMap.values.toList()

        ..sort((a, b) {

          return a.raceNumber.compareTo(
            b.raceNumber,
          );
        });

      /// =========================
      /// ⭐ キャッシュ保存
      /// =========================
      _raceCache[place] = races;

    } catch (e, stackTrace) {

      _log.severe(
        "レース取得エラー",
        e,
        stackTrace,
      );

      races = [];

    } finally {

      isLoading = false;

      _isFetchingRace = false;

      notifyListeners();
    }
  }

  /// =========================
  /// ⭐ 枠色
  /// =========================
  Color getColor(int number) {

    switch (number) {

      case 1:
        return Colors.white;

      case 2:
        return Colors.black;

      case 3:
        return Colors.red;

      case 4:
        return Colors.blue;

      case 5:
        return Colors.yellow;

      case 6:
        return Colors.green;

      case 7:
        return Colors.orange;

      case 8:
        return Colors.pink;

      default:
        return Colors.grey;
    }
  }

  /// =========================
  /// ⭐ リセット
  /// =========================
  void reset() {

    _log.info("PredictionProvider reset");

    selectedPlace = "";

    races = [];

    notifyListeners();
  }
}