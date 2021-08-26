import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMob extends GetxService {
  late InterstitialAd interstitialAd;
  late BannerAd banner;
  late BannerAd banner2;
  Future<AdMob> inicia() async {
    await MobileAds.instance.initialize();
    return this;
  }

  String get bannerAdUnitId => 'ca-app-pub-1205611887737485/2150742777';
  String get bannerAdUnitId2 => 'ca-app-pub-1205611887737485/8760342564';
  String get telacheiaId => 'ca-app-pub-1205611887737485/8760342564';
  Future<void> loadBanner() async {
    banner = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.getSmartBanner(Orientation.portrait),
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {},
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
        },
      ),
    );
    await banner.load();
  }

  Future<void> loadBanner2() async {
    banner2 = BannerAd(
      adUnitId: bannerAdUnitId2,
      size: AdSize.getSmartBanner(Orientation.portrait),
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {},
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
        },
      ),
    );
    await banner2.load();
  }

  Future<void> mostraTelaCheia() async {
    await InterstitialAd.load(
      adUnitId: telacheiaId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
    await interstitialAd.show();
  }
}
