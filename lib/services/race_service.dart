import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../models/race_model.dart';

class RaceService {

  /// ⭐ Logger
  final Logger _log =
      Logger('RaceService');

  /// 🔥 除外競馬場（バック漏れ対策）
  static const excludePlaces = [
    "帯広",
  ];

  /// =========================
  /// ⭐ 競馬場名を統一
  /// =========================
  String normalizePlaceName(
    String name,
  ) {

    return name
        .replaceAll(
          "競馬場",
          "",
        )
        .trim();
  }

  /// =========================
  /// ⭐ 競馬場一覧取得
  /// 完全防御版
  /// =========================
  Future<List<String>>
      fetchTodayPlaces() async {

    final url = Uri.parse(
      "https://api.keiba-ai-yosou.com/prediction/today",
    );

    final response =
        await http.get(url);

    if (response.statusCode != 200) {

      throw Exception(
        "API取得失敗",
      );
    }

    final data =
        jsonDecode(response.body);

    final places =
        data["places"] as List;

    /// =========================
    /// 🔥 API生データ確認
    /// =========================
    _log.info(
      "API RAW PLACES: $places",
    );

    /// =========================
    /// 🔥 順序維持しながら
    /// 正規化 + 除外 + 重複除去
    /// =========================
    final List<String>
        normalized = [];

    for (final p in places) {

      final placeName =
          normalizePlaceName(
        p["place"],
      );

      /// 帯広除外
      if (excludePlaces.any(
        (e) =>
            placeName.contains(e),
      )) {
        continue;
      }

      /// 重複除去（順序維持）
      if (!normalized.contains(
        placeName,
      )) {

        normalized.add(
          placeName,
        );
      }
    }

    /// =========================
    /// 🔥 正規化後確認
    /// =========================
    _log.info(
      "NORMALIZED PLACES: $normalized",
    );

    return normalized;
  }

  /// =========================
  /// ⭐ レース＋予想取得
  /// 完全防御版
  /// =========================
  Future<List<RaceModel>>
      fetchRaces(
    String place,
  ) async {

    /// 帯広ガード
    if (excludePlaces.any(
      (e) => place.contains(e),
    )) {

      return [];
    }

    final url = Uri.parse(
      "https://api.keiba-ai-yosou.com/prediction/today",
    );

    final response =
        await http.get(url);

    if (response.statusCode != 200) {

      throw Exception(
        "API取得失敗",
      );
    }

    final data =
        jsonDecode(response.body);

    final places =
        data["places"] as List;

    /// =========================
    /// 🔥 除外フィルタ
    /// =========================
    final filteredPlaces =
        places.where((p) {

      final normalized =
          normalizePlaceName(
        p["place"],
      );

      return !excludePlaces.any(
        (e) =>
            normalized.contains(e),
      );

    }).toList();

    /// =========================
    /// ⭐ 対象競馬場取得
    /// =========================
    final target =
        filteredPlaces.firstWhere(

      (p) =>
          normalizePlaceName(
            p["place"],
          ) ==
          place,

      orElse: () => {},
    );

    /// データなし
    if (target.isEmpty) {

      _log.warning(
        "競馬場データなし: $place",
      );

      return [];
    }

    final races =
        <RaceModel>[];

    for (final r
        in target["races"]) {

      races.add(

        RaceModel.fromJson(
          place,
          r,
        ),
      );
    }

    _log.info(
      "$place レース取得件数: ${races.length}",
    );

    return races;
  }
}