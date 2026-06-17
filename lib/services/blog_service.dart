import 'dart:async';

import 'dart:convert';

import 'package:http/http.dart'
    as http;

import 'package:logging/logging.dart';

class BlogService {

  // =========================
  // 🔥 Logger
  // =========================
  static final Logger _logger =
      Logger('BlogService');

  // =========================
  // 🔥 API Base
  // =========================
  static const String _baseUrl =
      'https://api.keiba-ai-yosou.com';

  // =========================
  // 🔥 timeout
  // =========================
  static const Duration _timeout =
      Duration(seconds: 10);

  // =========================
  // 🔥 Blog単体取得
  // GET /blogs/{id}
  // =========================
  static Future<Map<String, dynamic>?>
      getBlogById(
    int blogId,
  ) async {

    try {

      // =========================
      // 🔥 ID防御
      // =========================
      if (blogId <= 0) {

        _logger.warning(
          '⚠️ 不正blogId: $blogId',
        );

        return null;
      }

      _logger.info(
        '🔥 Blog取得開始 '
        'ID=$blogId',
      );

      final url =
          '$_baseUrl/blogs/$blogId';

      final response =
          await http

              .get(
                Uri.parse(url),
              )

              .timeout(
                _timeout,
              );

      // =========================
      // 🔥 成功
      // =========================
      if (response.statusCode == 200) {

        final decoded =
            jsonDecode(
          response.body,
        );

        // =========================
        // 🔥 型安全
        // =========================
        if (decoded
            is Map<String, dynamic>) {

          _logger.info(
            '✅ Blog取得成功 '
            'ID=$blogId',
          );

          return decoded;
        }

        _logger.warning(
          '⚠️ JSON形式不正',
        );

        return null;
      }

      // =========================
      // 🔥 404
      // =========================
      if (response.statusCode == 404) {

        _logger.warning(
          '⚠️ Blog未存在 '
          'ID=$blogId',
        );

        return null;
      }

      // =========================
      // 🔥 その他エラー
      // =========================
      _logger.severe(

        '❌ Blog取得失敗 '

        'status=${response.statusCode} '
        'body=${response.body}',
      );

      return null;
    }

    // =========================
    // 🔥 timeout
    // =========================
    on TimeoutException {

      _logger.severe(
        '⏰ Blog取得Timeout '
        'ID=$blogId',
      );

      return null;
    }

    // =========================
    // 🔥 Exception
    // =========================
    catch (e, stackTrace) {

      _logger.severe(

        '❌ Blog取得Exception',

        e,

        stackTrace,
      );

      return null;
    }
  }
}