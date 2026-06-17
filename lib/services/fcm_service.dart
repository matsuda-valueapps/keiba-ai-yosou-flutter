import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:http/http.dart' as http;

import 'package:logging/logging.dart';

import '../pages/blog_detail_page.dart';

// =========================
// 🔥 MainPageのみ使用
// BottomNavigation完全統一
// =========================
import '../pages/main_page.dart';

// =========================
// 🔥 Blog Service追加
// =========================
import 'blog_service.dart';


// =========================
// 🔥 Global Navigator Key
// main.dartで設定する
// =========================
final GlobalKey<NavigatorState>
    navigatorKey =
        GlobalKey<NavigatorState>();


class FcmService {

  static final Logger _logger =
      Logger('FcmService');

  static final FirebaseMessaging
      _firebaseMessaging =
          FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin
      _localNotifications =
          FlutterLocalNotificationsPlugin();

  // =========================
  // 🔥 Android Channel
  // =========================
  static const AndroidNotificationChannel
      _channel =
          AndroidNotificationChannel(
    'keiba_ai_channel',
    '競馬AI通知',
    description: '競馬AI予想通知',
    importance: Importance.max,
  );

  // =========================
  // 🔥 初期化
  // =========================
  static Future<void> initialize()
  async {

    _logger.info(
      '🔥 FCM initialize start',
    );

    // =========================
    // 🔥 通知許可
    // =========================
    _logger.info(
      '🔥 requestPermission start',
    );

    final permission =
        await _firebaseMessaging
            .requestPermission(
      alert: true,
      badge: true, 
      sound: true,
    );

    _logger.info(
      '🔥 permission: '
      '${permission.authorizationStatus}',
    );

    // =========================
    // 🔥 Android初期化設定
    // =========================
    const AndroidInitializationSettings
        androidSettings =
            AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // =========================
    // 🔥 iOS初期化設定
    // ★今回追加
    // =========================
    const DarwinInitializationSettings
        iosSettings =
            DarwinInitializationSettings();

    // =========================
    // 🔥 全体設定
    // =========================
    const InitializationSettings
        settings =
            InitializationSettings(
      android: androidSettings,

      // =========================
      // 🔥 iOS追加
      // =========================
      iOS: iosSettings,
    );

    await _localNotifications
        .initialize(
      settings,

      // =========================
      // 🔥 ローカル通知タップ
      // =========================
      onDidReceiveNotificationResponse:
          (
        NotificationResponse response,
      ) {

        _logger.info(
          '🔥 Local通知タップ'
        );

        final payload =
            response.payload;

        if (payload != null) {

          try {

            final data =
                jsonDecode(payload);

            _handleDeepLink(
              Map<String, dynamic>.from(
                data,
              ),
            );

          } catch (e) {

            _logger.severe(
              '❌ payload parse error: $e',
            );
          }
        }
      },
    );

    // =========================
    // 🔥 Notification Channel作成
    // Androidのみ
    // =========================
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          _channel,
        );

    // =========================
    // 🔥 iOSのみAPNS確認
    // =========================
    if (Platform.isIOS) {

      String? apnsToken;

      for (int i = 0; i < 10; i++) {

        apnsToken =
            await _firebaseMessaging
                .getAPNSToken();

        if (apnsToken != null) {

          _logger.info(
            '🔥 APNS TOKEN: $apnsToken',
          );

          break;
        }

        _logger.warning(
          '⚠️ APNS Token待機中...',
        );

        await Future.delayed(
          const Duration(seconds: 1),
        );
      }

      if (apnsToken == null) {

        _logger.severe(
          '❌ APNS TOKEN取得失敗',
        );

        return;
      }
    }

    // =========================
    // 🔥 FCM Token取得
    // =========================
    _logger.info(
      '🔥 getToken start',
    );

    final token =
        await _firebaseMessaging
            .getToken();

    _logger.info(
      '🔥 FCM TOKEN: $token',
    );

    // =========================
    // 🔥 FastAPIへ送信
    // =========================
    if (token != null) {

      await _sendTokenToServer(
        token,
      );
    }

    // =========================
    // 🔥 Token更新監視
    // =========================
    FirebaseMessaging.instance
        .onTokenRefresh
        .listen((newToken) async {

      _logger.info(
        '🔥 Token更新: $newToken',
      );

      await _sendTokenToServer(
        newToken,
      );
    });

    // =========================
    // 🔥 Foreground受信
    // =========================
    FirebaseMessaging.onMessage
        .listen((message) {

      _logger.info(
        '🔥 Push受信: '
        '${message.notification?.title}',
      );

      _logger.info(
        '🔥 Push Data: '
        '${message.data}',
      );

      // =========================
      // 🔥 通知表示
      // Android + iOS対応
      // =========================
      _localNotifications.show(

        0,

        message.notification?.title,

        message.notification?.body,

        NotificationDetails(

          // =========================
          // 🔥 Android
          // =========================
          android:
              AndroidNotificationDetails(

            _channel.id,

            _channel.name,

            channelDescription:
                _channel.description,

            importance:
                Importance.max,

            priority:
                Priority.high,
          ),

          // =========================
          // 🔥 iOS追加
          // ★今回追加
          // =========================
          iOS:
              const DarwinNotificationDetails(),
        ),

        payload: jsonEncode(
          message.data,
        ),
      );
    });

    // =========================
    // 🔥 Background通知タップ
    // =========================
    FirebaseMessaging
        .onMessageOpenedApp
        .listen((message) {

      _logger.info(
        '🔥 Push通知タップ'
      );

      _logger.info(
        '🔥 Push Data: '
        '${message.data}',
      );

      _handleDeepLink(

        Map<String, dynamic>.from(
          message.data,
        ),
      );
    });

    // =========================
    // 🔥 完全終了状態から起動
    // =========================
    final initialMessage =
        await _firebaseMessaging
            .getInitialMessage();

    if (initialMessage != null) {

      _logger.info(
        '🔥 terminated起動'
      );

      _logger.info(
        '🔥 Initial Data: '
        '${initialMessage.data}',
      );

      _handleDeepLink(

        Map<String, dynamic>.from(
          initialMessage.data,
        ),
      );
    }
  }

  // =========================
  // 🔥 DeepLink処理
  // =========================
  static Future<void>
      _handleDeepLink(
    Map<String, dynamic> data,
  ) async {

    // =========================
    // 🔥 RAW DATA確認
    // =========================
    _logger.info(
      '🔥 RAW DATA: $data',
    );

    // =========================
    // 🔥 type/value正規化
    // =========================
    final type =
        data['type']
            ?.toString()
            .trim()
            .toLowerCase();

    final value =
        data['value']
            ?.toString()
            .trim();

    _logger.info(
      '🔥 DeepLink type=$type value=$value',
    );

    // ==================================================
    // 🔥 HOME
    // ==================================================
    if (type == 'home') {

      _logger.info(
        '🔥 home open',
      );

      navigatorKey.currentState
          ?.pushAndRemoveUntil(

        MaterialPageRoute(

          builder: (_) =>
              const MainPage(
            initialIndex: 0,
          ),
        ),

        (route) => false,
      );

      _logger.info(
        '✅ Home tab open success',
      );
    }

    // ==================================================
    // 🔥 BLOG
    // ==================================================
    else if (type == 'blog') {

      _logger.info(
        '🔥 blog detail open: $value',
      );

      try {

        final blogId =
            int.tryParse(
          value.toString(),
        );

        if (blogId == null) {

          _logger.severe(
            '❌ blogId parse error',
          );

          return;
        }

        final blog =
            await BlogService
                .getBlogById(
          blogId,
        );

        if (blog == null) {

          _logger.severe(
            '❌ blog not found',
          );

          return;
        }

        navigatorKey.currentState
            ?.push(

          MaterialPageRoute(

            builder: (_) =>
                BlogDetailPage(
              blog: blog,
            ),
          ),
        );

        _logger.info(
          '✅ BlogDetailPage open success',
        );
      }

      catch (e) {

        _logger.severe(
          '❌ blog deeplink error: $e',
        );
      }
    }

    // ==================================================
    // 🔥 Ranking
    // ==================================================
    else if (
        type == 'ranking') {

      _logger.info(
        '🔥 ranking open',
      );

      navigatorKey.currentState
          ?.pushAndRemoveUntil(

        MaterialPageRoute(

          builder: (_) =>
              const MainPage(
            initialIndex: 1,
          ),
        ),

        (route) => false,
      );

      _logger.info(
        '✅ Ranking tab open success',
      );
    }

    // ==================================================
    // 🔥 Prediction
    // ==================================================
    else if (
        type == 'prediction') {

      _logger.info(
        '🔥 prediction open',
      );

      navigatorKey.currentState
          ?.pushAndRemoveUntil(

        MaterialPageRoute(

          builder: (_) =>
              const MainPage(
            initialIndex: 4,
          ),
        ),

        (route) => false,
      );

      _logger.info(
        '✅ Prediction tab open success',
      );
    }

    // =========================
    // 🔥 不明type
    // =========================
    else {

      _logger.warning(
        '⚠️ unknown deep link type: $type',
      );
    }
  }

  // =========================
  // 🔥 Token送信
  // Flutter集計対応版
  // =========================
  static Future<void>
      _sendTokenToServer(
    String token,
  ) async {

    try {

      final response =
          await http.post(

        Uri.parse(
          'https://api.keiba-ai-yosou.com/device-token/',
        ),

        headers: {

          'Content-Type':
              'application/json',
        },

        body: jsonEncode({

          // =========================
          // 🔥 FCM Token
          // =========================
          'token': token,

          // =========================
          // 🔥 iOS/Android自動化推奨
          // =========================
          'platform':
              Platform.isIOS
                  ? 'ios'
                  : 'android',

          // =========================
          // 🔥 Device Name
          // =========================
          'device_name':
              Platform.isIOS
                  ? 'iPhone'
                  : 'Android',

          // =========================
          // 🔥 App Version
          // =========================
          'app_version':
              '1.0.0',

          // =========================
          // 🔥 通知ON/OFF
          // =========================
          'is_active': true,
        }),
      );

      _logger.info(
        '🔥 Token送信成功: '
        '${response.statusCode}',
      );

      _logger.info(
        '🔥 Response: '
        '${response.body}',
      );
    }

    catch (e) {

      _logger.severe(
        '❌ Token送信失敗: $e',
      );
    }
  }
}