// MODIFIED EXAMPLE CODE FROM
// https://github.com/googleads/googleads-mobile-flutter/blob/main/samples/admob/banner_example/lib/main.dart

// ignore_for_file: unawaited_futures

import 'package:fsd_mwwm_mobx_demo/shared/config/options.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:platform_info/platform_info.dart';

typedef OnConsentGatheringCompleteListener = void Function(FormError? error);

/// The Google Mobile Ads SDK provides the User Messaging Platform (Google's IAB
/// Certified consent management platform) as one solution to capture consent for
/// users in GDPR impacted countries. This is an example and you can choose
/// another consent management platform to capture consent.
class ConsentManager {
  /// Helper variable to determine if the app can request ads.
  Future<bool> canRequestAds() async {
    return await ConsentInformation.instance.canRequestAds();
  }

  /// Helper variable to determine if the privacy options form is required.
  Future<bool> isPrivacyOptionsRequired() async {
    return await ConsentInformation.instance.getPrivacyOptionsRequirementStatus() ==
        PrivacyOptionsRequirementStatus.required;
  }

  /// Helper method to call the Mobile Ads SDK to request consent information
  /// and load/show a consent form if necessary.
  void gatherConsent(OnConsentGatheringCompleteListener onConsentGatheringCompleteListener) {
    // For testing purposes, you can force a DebugGeography of Eea or NotEea.
    ConsentDebugSettings debugSettings = ConsentDebugSettings(
      // debugGeography: DebugGeography.debugGeographyEea,
      testIdentifiers: kAppOptions.admobTestIdentifiers,
    );
    ConsentRequestParameters params = ConsentRequestParameters(consentDebugSettings: debugSettings);

    // Requesting an update to consent information should be called on every app launch.
    ConsentInformation.instance.requestConsentInfoUpdate(params, () async {
      ConsentForm.loadAndShowConsentFormIfRequired((loadAndShowError) {
        // Consent has been gathered.
        onConsentGatheringCompleteListener(loadAndShowError);
      });
    }, (FormError formError) {
      onConsentGatheringCompleteListener(formError);
    });
  }

  /// Helper method to call the Mobile Ads SDK method to show the privacy options form.
  void showPrivacyOptionsForm(OnConsentFormDismissedListener onConsentFormDismissedListener) {
    ConsentForm.showPrivacyOptionsForm(onConsentFormDismissedListener);
  }
}

/// An example app that loads a banner ad.
class WBannerMobile extends StatefulWidget {
  const WBannerMobile({super.key});

  @override
  WBannerMobileState createState() => WBannerMobileState();
}

class WBannerMobileState extends State<WBannerMobile> {
  final _consentManager = ConsentManager();
  var _isMobileAdsInitializeCalled = false;
  // ignore: unused_field
  var _isPrivacyOptionsRequired = false;
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  final String _adUnitId =
      Platform.I.android ? 'ca-app-pub-3940256099942544/9214589741' : 'ca-app-pub-3940256099942544/2435281174';

  @override
  void initState() {
    super.initState();

    _consentManager.gatherConsent((consentGatheringError) {
      if (consentGatheringError != null) {
        // Consent not obtained in current session.
        debugPrint("${consentGatheringError.errorCode}: ${consentGatheringError.message}");
      }

      // Check if a privacy options entry point is required.
      _getIsPrivacyOptionsRequired();

      // Attempt to initialize the Mobile Ads SDK.
      _initializeMobileAdsSDK();
    });

    // This sample attempts to load ads using consent obtained in the previous session.
    _initializeMobileAdsSDK();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd == null || !_isLoaded) {
      return const SizedBox.shrink();
    }
    return SafeArea(
      child: SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }

  /// Loads and shows a banner ad.
  ///
  /// Dimensions of the ad are determined by the width of the screen.
  void _loadAd() async {
    // Only load an ad if the Mobile Ads SDK has gathered consent aligned with
    // the app's configured messages.
    var canRequestAds = await _consentManager.canRequestAds();
    if (!canRequestAds) {
      return;
    }

    if (!mounted) {
      return;
    }

    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(MediaQuery.sizeOf(context).width.truncate());

    if (size == null) {
      // Unable to get width of anchored banner.
      return;
    }

    BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    ).load();
  }

  /// Redraw the app bar actions if a privacy options entry point is required.
  void _getIsPrivacyOptionsRequired() async {
    if (await _consentManager.isPrivacyOptionsRequired()) {
      setState(() {
        _isPrivacyOptionsRequired = true;
      });
    }
  }

  /// Initialize the Mobile Ads SDK if the SDK has gathered consent aligned with
  /// the app's configured messages.
  void _initializeMobileAdsSDK() async {
    if (_isMobileAdsInitializeCalled) {
      return;
    }

    if (await _consentManager.canRequestAds()) {
      _isMobileAdsInitializeCalled = true;

      // Initialize the Mobile Ads SDK.
      MobileAds.instance.initialize();

      // Load an ad.
      _loadAd();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
