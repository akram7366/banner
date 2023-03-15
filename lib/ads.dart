

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyAds {
  static MyAds? _ads;
  static MyAds get get => _ads ??= MyAds();

  final RouteObserver<ModalRoute<void>> routeObserver =
  RouteObserver<ModalRoute<void>>();

  Future<BannerAd> loadBanner(BuildContext context, void Function(Ad ad)? onAdLoaded) async {
    AdSize size = await _size(context);
    return BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
      ),
    )..load();
  }

  Future<AdSize> _size(BuildContext context) async {
    AdSize? size =
    await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate());
    if (context.mounted) {
      if (size == null ||
          MediaQuery.of(context).orientation == Orientation.landscape) {
        size = AdSize.fullBanner;
      }
    }
    return size!;
  }
}