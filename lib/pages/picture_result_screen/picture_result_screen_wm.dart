// ignore: unused_import
import 'package:fsd_mwwm_mobx_demo/shared/di/app_scope.dart';
import 'package:fsd_mwwm_mobx_demo/pages/settings_screen/settings_screen.dart';
import 'package:awesome_extensions/awesome_extensions_flutter.dart';
// ignore: unused_import
import 'package:collection/collection.dart';
// ignore: unused_import

import 'package:mobx/mobx.dart';
import 'package:utils/utils_dart.dart';
import 'package:utils/utils_flutter.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

import 'picture_result_screen.dart';

class PictureResultScreenWm extends MobxWM<PictureResultScreenWidget> with Store, LoggerMixin {
  // INIT ---------------------------------------------------------------------

  @override
  // ignore: unnecessary_overrides
  void initWidgetModel() {
    super.initWidgetModel();
  }

  // DI DEPENDENCIES ----------------------------------------------------------
  late final appPreferences = ScopeProvider.of<AppScopeContainer>(context, listen: false)!.appPreferencesDep.get;

  // FIELDS -------------------------------------------------------------------

  // PROXY --------------------------------------------------------------------

  late final isLocked = appPreferences.isLocked().obs();

  // OBSERVABLES --------------------------------------------------------------

  // COMPUTED -----------------------------------------------------------------

  // STREAM REACTION ----------------------------------------------------------

  // ACTIONS ------------------------------------------------------------------

  void onPressBack() {
    context.pop();
  }

  void onPressSettings() {
    context.push(const SettingsScreenWidget());
  }
  // UI -----------------------------------------------------------------------

  // UTIL METHODS -------------------------------------------------------------

  @override
  void setupLoggers() {
    setupObservableLoggers(
      [
        () => 'isLocked.value = ${isLocked.value}',
      ],
      logger,
    );
  }
}
