import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class NarService {

  final Logger _log = Logger('NarService');

  /// ⭐ FastAPIから開催競馬場取得（本番対応版）
  Future<List<String>> fetchTodayPlaces() async {

    try {
      final response = await http.get(
        Uri.parse("https://api.keiba-ai-yosou.com/prediction/today"),
      );

      _log.info("HTTPステータス: ${response.statusCode}");

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        final places = data["places"] as List;

        /// ⭐ 競馬場名抽出 + 重複削除
        final result = places
            .map((p) => p["place"].toString())
            .toSet()      // ⭐ 重複削除
            .toList();

        _log.info("取得競馬場: $result");

        return result;
      }

    } catch (e) {
      _log.warning("NAR API取得エラー: $e");
    }

    return [];
  }
}