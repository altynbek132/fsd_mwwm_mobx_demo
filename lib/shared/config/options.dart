import 'options_development.dart' as dev;
import 'options_production.dart' as prod;

late AppOptions kAppOptions;

class AppOptions {
  final Flavor flavor;
  final String? adsenseAdClient;
  final String? adsenseAdSlot;
  final double maxThrottleFrames;
  final bool isDevicePreviewEnabled;
  final bool resetStorageOnBoot;
  final List<String> admobTestIdentifiers;

  AppOptions({
    required this.flavor,
    required this.adsenseAdClient,
    required this.adsenseAdSlot,
    required this.maxThrottleFrames,
    this.isDevicePreviewEnabled = false,
    this.resetStorageOnBoot = false,
    this.admobTestIdentifiers = const <String>[],
  });
}

enum Flavor {
  development,
  production;

  // check is prod
  bool get isProd => this == Flavor.production;

  // check is dev
  bool get isDev => this == Flavor.development;
}

AppOptions relevantAppOptions(Flavor flavor) {
  return switch (flavor) {
    Flavor.production => prod.options,
    Flavor.development || _ => dev.options,
  };
}

extension AppOptionsAdsenseExtension on AppOptions {
  bool get hasAdsense => adsenseAdClient != null && adsenseAdSlot != null;
}
