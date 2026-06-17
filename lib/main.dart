import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// =========================
// 🔥 Google Fonts追加
// =========================
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';

import 'services/fcm_service.dart';

import 'providers/home_provider.dart';
import 'providers/ranking_provider.dart';
import 'providers/main_page_provider.dart';
import 'providers/prediction_provider.dart';
import 'providers/banner_provider.dart';

// =========================
// 🔥 追加
// TOPスクロール管理
// =========================
import 'providers/scroll_top_provider.dart';

import 'pages/main_page.dart';

// =========================
// 🔥 FCM Background Handler
// =========================
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {

  await Firebase.initializeApp(

    options:
        DefaultFirebaseOptions
            .currentPlatform,
  );

  final Logger logger =
      Logger('FCM_BACKGROUND');

  logger.info(

    "🔥 BACKGROUND MESSAGE: "
    "${message.messageId}",
  );

  logger.info(
    "🔥 BACKGROUND DATA: "
    "${message.data}",
  );
}

Future<void> main() async {

  // =========================
  // 🔥 Flutter初期化
  // =========================
  WidgetsFlutterBinding
      .ensureInitialized();

  // =========================
  // 🔥 Firebase初期化
  // =========================
  await Firebase.initializeApp(

    options:
        DefaultFirebaseOptions
            .currentPlatform,
  );

  // =========================
  // 🔥 Background Message
  // =========================
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  // =========================
  // 🔥 Logging設定
  // ※FCMより先に設定
  // =========================
  const bool isProduction =
      bool.fromEnvironment(
    'dart.vm.product',
  );

  if (isProduction) {

    Logger.root.level = Level.OFF;

  } else {

    Logger.root.level = Level.ALL;

    Logger.root.onRecord.listen(

      (LogRecord record) {

        debugPrint(

          '[${record.level.name}] '
          '${record.time}: '
          '${record.message}',
        );
      },
    );
  }

  // =========================
  // 🔥 FCM初期化
  // Logging設定後に実行
  // =========================
  await FcmService.initialize();

  // =========================
  // 🔥 App起動
  // =========================
  runApp(

    MultiProvider(

      providers: [

        // =========================
        // 🔥 Home
        // =========================
        ChangeNotifierProvider(

          create: (_) =>
              HomeProvider(),
        ),

        // =========================
        // 🔥 Ranking
        // =========================
        ChangeNotifierProvider(

          create: (_) =>
              RankingProvider(),
        ),

        // =========================
        // 🔥 Main Page
        // =========================
        ChangeNotifierProvider(

          create: (_) =>
              MainPageProvider(),
        ),

        // =========================
        // 🔥 Prediction
        // =========================
        ChangeNotifierProvider(

          create: (_) =>
              PredictionProvider(),
        ),

        // =========================
        // 🔥 Scroll Top
        // =========================
        ChangeNotifierProvider(

          create: (_) =>
              ScrollTopProvider(),
        ),

        // =========================
        // 🔥 Banner
        // =========================
        ChangeNotifierProvider(

          create: (_) {

            final BannerProvider provider =
                BannerProvider();

            // =========================
            // 🔥 初回ロード
            // =========================
            provider.loadBanners();

            return provider;
          },
        ),
      ],

      child: const MyApp(),
    ),
  );
}

class MyApp
    extends StatelessWidget {

  const MyApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return MaterialApp(

      // =========================
      // 🔥 DeepLink用
      // =========================
      navigatorKey: navigatorKey,

      debugShowCheckedModeBanner:
          false,

      title: "競馬AI予想",

      theme: ThemeData(

        // =========================
        // 🔥 Noto Sans JP
        // 全体適用
        // =========================
        textTheme:
            GoogleFonts
                .notoSansJpTextTheme(

          Theme.of(context)
              .textTheme,
        ),

        // =========================
        // 🔥 基本カラー
        // =========================
        primarySwatch:
            Colors.indigo,

        scaffoldBackgroundColor:
            const Color(
          0xFFF4F4F4,
        ),

        // =========================
        // 🔥 AppBar Theme
        // =========================
        appBarTheme:
            AppBarTheme(

          elevation: 0,

          backgroundColor:
              Colors.black,

          foregroundColor:
              Colors.white,

          centerTitle: true,

          titleTextStyle:
              GoogleFonts.notoSansJp(

            fontSize: 24,

            fontWeight:
                FontWeight.bold,

            color: Colors.white,
          ),
        ),

        // =========================
        // 🔥 BottomNavigation
        // =========================
        bottomNavigationBarTheme:
            BottomNavigationBarThemeData(

          backgroundColor:
              Colors.black,

          selectedItemColor:
              Colors.white,

          unselectedItemColor:
              Colors.grey,

          selectedLabelStyle:
              GoogleFonts.notoSansJp(

            fontWeight:
                FontWeight.bold,

            fontSize: 13,
          ),

          unselectedLabelStyle:
              GoogleFonts.notoSansJp(

            fontSize: 12,
          ),
        ),

        // =========================
        // 🔥 ElevatedButton
        // =========================
        elevatedButtonTheme:
            ElevatedButtonThemeData(

          style:
              ElevatedButton.styleFrom(

            backgroundColor:
                Colors.black,

            foregroundColor:
                Colors.white,

            textStyle:
                GoogleFonts.notoSansJp(

              fontWeight:
                  FontWeight.bold,
            ),

            shape:
                RoundedRectangleBorder(

              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),
          ),
        ),

        // =========================
        // 🔥 Card Theme
        // =========================
        cardTheme: CardThemeData(

          elevation: 3,

          shape:
              RoundedRectangleBorder(

            borderRadius:
                BorderRadius.circular(
              16,
            ),
          ),
        ),
      ),

      // =========================
      // 🔥 TOP PAGE
      // =========================
      home: const MainPage(),
    );
  }
}