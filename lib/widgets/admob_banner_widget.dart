import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobBannerWidget extends StatefulWidget {

  final String adUnitId;

  const AdmobBannerWidget({
    super.key,
    required this.adUnitId,
  });

  @override
  State<AdmobBannerWidget> createState() =>
      _AdmobBannerWidgetState();
}

class _AdmobBannerWidgetState
    extends State<AdmobBannerWidget> {

  BannerAd? _bannerAd;

  bool _isLoaded = false;

  @override
  void initState() {

    super.initState();

    _loadBanner();
  }

  void _loadBanner() {

    final BannerAd bannerAd =
        BannerAd(

      adUnitId: widget.adUnitId,

      size: AdSize.banner,

      request: const AdRequest(),

      listener: BannerAdListener(

        onAdLoaded: (Ad ad) {

          debugPrint(
            '✅ AdMob Banner Loaded',
          );

          if (!mounted) {
            ad.dispose();
            return;
          }

          setState(() {

            _bannerAd =
                ad as BannerAd;

            _isLoaded = true;
          });
        },

        onAdFailedToLoad: (
          Ad ad,
          LoadAdError error,
        ) {

          debugPrint(
            '❌ Banner Load Error: $error',
          );

          ad.dispose();
        },
      ),
    );

    bannerAd.load();
  }

  @override
  void dispose() {

    _bannerAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    if (!_isLoaded ||
        _bannerAd == null) {

      return const SizedBox();
    }

    return Container(

      margin:
          const EdgeInsets.symmetric(
        vertical: 10,
      ),

      alignment: Alignment.center,

      child: SizedBox(

        width:
            _bannerAd!
                .size
                .width
                .toDouble(),

        height:
            _bannerAd!
                .size
                .height
                .toDouble(),

        child: AdWidget(
          ad: _bannerAd!,
        ),
      ),
    );
  }
}