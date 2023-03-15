import 'package:banner/ads.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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

    MyAds.get.routeObserver.subscribe(this, ModalRoute.of(context)!);

    bannerAd = await MyAds.get.loadBanner(context, (ad) => setState(() {}));
  }


  @override
  void didPushNext() => setState(() => visible = false);

  @override
  void didPopNext() => setState(() => visible = true);

  @override
  void dispose() {
    bannerAd!.dispose();
    MyAds.get.routeObserver.unsubscribe(this);
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
