import 'package:flutter/material.dart';

class ScrollTopProvider
    extends ChangeNotifier {

  // =========================
  // 🔥 各ページ用Controller
  // =========================
  final ScrollController
      homeController =
      ScrollController();

  final ScrollController
      rankingController =
      ScrollController();

  final ScrollController
      reviewController =
      ScrollController();

  final ScrollController
      blogController =
      ScrollController();

  final ScrollController
      predictionController =
      ScrollController();

  // =========================
  // 🔥 TOPへ戻す
  // =========================
  void scrollToTop(
    int index,
  ) {

    ScrollController?
        controller;

    switch (index) {

      // =========================
      // HOME
      // =========================
      case 0:
        controller =
            homeController;
        break;

      // =========================
      // Ranking
      // =========================
      case 1:
        controller =
            rankingController;
        break;

      // =========================
      // Review
      // =========================
      case 2:
        controller =
            reviewController;
        break;

      // =========================
      // Blog
      // =========================
      case 3:
        controller =
            blogController;
        break;

      // =========================
      // Prediction
      // =========================
      case 4:
        controller =
            predictionController;
        break;
    }

    // =========================
    // 🔥 安全対策
    // =========================
    if (controller == null) {
      return;
    }

    // =========================
    // 🔥 attach済みのみ
    // =========================
    if (!controller.hasClients) {
      return;
    }

    // =========================
    // 🔥 TOPへアニメーション
    // =========================
    controller.animateTo(

      0,

      duration:
          const Duration(
        milliseconds: 350,
      ),

      curve:
          Curves.easeOut,
    );
  }

  // =========================
  // 🔥 メモリ解放
  // =========================
  @override
  void dispose() {

    homeController.dispose();

    rankingController.dispose();

    reviewController.dispose();

    blogController.dispose();

    predictionController.dispose();

    super.dispose();
  }
}