import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../main.dart';

class MyBanner extends StatefulWidget {
  const MyBanner({Key? key}) : super(key: key);

  @override
  State<MyBanner> createState() => _MyBannerState();
}

class _MyBannerState extends State<MyBanner> with RouteAware {
  BannerAd? bannerAd;
  bool visible = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    routeObserver.subscribe(this, ModalRoute.of(context)!);

    AdSize size = await _size();

    bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
      ),
    )..load();
  }

  Future<AdSize> _size() async {
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

  void onAdLoaded(Ad ad) {
    Fluttertoast.showToast(msg: 'load');
    setState(() {});
  }

  @override
  void didPushNext() => setState(() => visible = false);

  @override
  void didPopNext() => setState(() => visible = true);

  @override
  void dispose() {
    bannerAd!.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return bannerAd != null
        ? SizedBox(
            width: bannerAd!.size.width.toDouble(),
            height: bannerAd!.size.height.toDouble(),
            child: Visibility(
              visible: visible,
              child: AdWidget(ad: bannerAd!),
            ),
          )
        : const SizedBox();
  }
}
