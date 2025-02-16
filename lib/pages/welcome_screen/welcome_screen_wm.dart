// ignore: unused_import
import 'package:fsd_mwwm_mobx_demo/shared/ui/gen/assets.gen.dart';
import 'package:fsd_mwwm_mobx_demo/pages/test_screen/test_screen.dart';
import 'package:awesome_extensions/awesome_extensions_flutter.dart';
// ignore: unused_import
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
// ignore: unused_import

import 'package:mobx/mobx.dart';
import 'package:utils/utils_dart.dart';
import 'package:utils/utils_flutter.dart';

import 'welcome_screen.dart';

class WelcomeScreenWm extends MobxWM<WelcomeScreenWidget> with Store, LoggerMixin {
  // INIT ---------------------------------------------------------------------

  @override
  // ignore: unnecessary_overrides
  void initWidgetModel() {
    super.initWidgetModel();

    precacheImage(AssetImage(Assets.images.parallax.path), context);
  }

  // DI DEPENDENCIES ----------------------------------------------------------

  // FIELDS -------------------------------------------------------------------

  // PROXY --------------------------------------------------------------------

  // OBSERVABLES --------------------------------------------------------------

  // COMPUTED -----------------------------------------------------------------

  // STREAM REACTION ----------------------------------------------------------

  // ACTIONS ------------------------------------------------------------------
  void onPressContinue() {
    context.push(const TestScreenWidget());
  }
  // UI -----------------------------------------------------------------------

  // UTIL METHODS -------------------------------------------------------------

  @override
  void setupLoggers() {
    setupObservableLoggers(
      [
        () => '',
      ],
      logger,
    );
  }
}
