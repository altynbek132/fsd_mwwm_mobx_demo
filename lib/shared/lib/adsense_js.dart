import 'package:fsd_mwwm_mobx_demo/shared/config/options.dart';
import 'package:flutter/material.dart';
import 'package:google_adsense/experimental/ad_unit_widget.dart';
import 'package:google_adsense/google_adsense.dart';
import 'package:utils/utils_dart.dart';

Future<void> initAdsens() async {
  if (!kAppOptions.hasAdsense) {
    loggerGlobal.e('initAdsens: No adsense configuration');
    return;
  }
  await adSense.initialize(kAppOptions.adsenseAdClient!);
}

class WAdUnitAdsense extends StatelessWidget {
  const WAdUnitAdsense({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!kAppOptions.hasAdsense) {
      loggerGlobal.e('WAdUnitAdsense: No adsense configuration');
      return const SizedBox.shrink();
    }
    return AdUnitWidget(
      configuration: AdUnitConfiguration.displayAdUnit(
        adSlot: kAppOptions.adsenseAdSlot!,
        // Remove AdFormat to make ads limited by height
        adFormat: AdFormat.AUTO,
      ),
    );
  }
}
