import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ranking_model.dart';

/// =========================
/// 🔥 ランキング種別（バグ防止）
/// =========================
class RankingType {
  static const String amount = "amount";
  static const String hitCount = "hit_count";
}

class RankingService {

  /// =========================
  /// 🔥 互換用（Provider対応）
  /// =========================
  static const String typeAmount = RankingType.amount;
  static const String typeHit = RankingType.hitCount;

  /// 🔥 実機対応（自分のPCのIP）
  static const String baseUrl = "https://api.keiba-ai-yosou.com";

  /// =========================
  /// ⭐ ランキング取得（完全版）
  /// =========================
  static Future<List<RankingModel>> fetchRankings(
    String type, {
    int limit = 10,
  }) async {

    /// 🔥 安全チェック
    if (type != RankingType.amount && type != RankingType.hitCount) {
      throw Exception("ranking_typeが不正です: $type");
    }

    final uri = Uri.parse("$baseUrl/rankings").replace(
      queryParameters: {
        "ranking_type": type,
        "limit": limit.toString(),
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data
          .map<RankingModel>((e) => RankingModel.fromJson(e))
          .toList();
    } else {
      throw Exception(
        "ランキング取得失敗: ${response.statusCode} / ${response.body}"
      );
    }
  }
}