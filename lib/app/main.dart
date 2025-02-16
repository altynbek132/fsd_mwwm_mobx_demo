import 'dart:ui';

import 'package:fsd_mwwm_mobx_demo/shared/config/options.dart';
import 'package:fsd_mwwm_mobx_demo/shared/di/app_scope.dart';
import 'package:fsd_mwwm_mobx_demo/shared/config/firebase_options.dart';
import 'package:fsd_mwwm_mobx_demo/shared/ui/gen/fonts.gen.dart';
import 'package:fsd_mwwm_mobx_demo/shared/lib/adsense.dart';
import 'package:fsd_mwwm_mobx_demo/pages/welcome_screen/welcome_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:platform_info/platform_info.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:utils/utils_dart.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> bootstrap(Flavor flavor) async {
  loggerGlobal.d('AppOptions.currentFlavor: $flavor');
  kAppOptions = relevantAppOptions(flavor);

  WidgetsFlutterBinding.ensureInitialized();

  final appScopeHolder = AppScopeHolder();
  await appScopeHolder.create();

  if (kAppOptions.resetStorageOnBoot) {
    if (appScopeHolder.scope == null) {
      throw Exception('appScopeHolder.scope is null');
    }
    loggerGlobal.d("resetStorageOnBoot");
    await appScopeHolder.scope!.flutterSecureStorageDep.get.deleteAll();
  }

  await configFirebase();
  await configAds();

  runApp(MainApp(appScopeHolder: appScopeHolder));
}

Future<void> configAds() async {
  if (Platform.I.mobile) {
    await MobileAds.instance.initialize();
  }
  if (Platform.I.js) {
    await initAdsens();
  }
}

Future<void> configFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}

class MainApp extends StatelessWidget {
  final AppScopeHolder appScopeHolder;

  const MainApp({super.key, required this.appScopeHolder});

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      enabled: kDebugMode && kAppOptions.isDevicePreviewEnabled,
      builder: (context) {
        return ScreenUtilInit(
          designSize: const Size(393, 852),
          child: ScopeProvider<AppScopeContainer>(
            holder: appScopeHolder,
            child: GestureDetector(
              onTapUp: (details) {
                loggerGlobal.d("unfocus");
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: MaterialApp(
                title: 'fsd_mwwm_mobx_demo',
                navigatorObservers: <NavigatorObserver>[appScopeHolder.scope!.routeObserverDep.get],
                scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: PointerDeviceKind.values.toSet()),
                theme: ThemeData(
                  fontFamily: FontFamily.lato,
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                  useMaterial3: true,
                ),

                // device preview
                locale: DevicePreview.locale(context),
                builder: DevicePreview.appBuilder,
                home: WelcomeScreenWidget(),
              ),
            ),
          ),
        );
      },
    );
  }
}
