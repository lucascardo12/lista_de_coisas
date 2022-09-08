import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:listadecoisa/core/interfaces/service_interface.dart';

class AdMob extends IService {
  InterstitialAd? interstitialAd;

  @override
  Future<void> start() async {
    await MobileAds.instance.initialize();
  }

  String get bannerAdUnitId => 'ca-app-pub-1205611887737485/2150742777';
  String get bannerAdUnitId2 => 'ca-app-pub-1205611887737485/8760342564';
  String get telacheiaId => 'ca-app-pub-1205611887737485/8086429884';
  InterstitialAd? _adCheia;

  Future<BannerAd> loadBanner({required String adUnitId}) async {
    var banner = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {},
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
        },
      ),
    );
    await banner.load();
    return banner;
  }

  void disposeTelaCheia() {
    if (interstitialAd != null) interstitialAd!.dispose();
  }

  Future<void> mostraTelaCheia() async {
    try {
      if (_adCheia != null) await _adCheia!.show();
    } catch (e) {
      print(e);
    }
  }

  void loadInterstitialAd() async {
    try {
      await InterstitialAd.load(
        adUnitId: telacheiaId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) async {
            _adCheia = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {},
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
