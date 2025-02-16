import 'dart:async';

// ignore: unused_import
import 'package:fsd_mwwm_mobx_demo/shared/di/app_scope.dart';
import 'package:fsd_mwwm_mobx_demo/entities/user/model/birth_data.dart';
import 'package:fsd_mwwm_mobx_demo/pages/camera_screen/camera_screen.dart';
import 'package:fsd_mwwm_mobx_demo/pages/test_screen/birth_form.dart';
import 'package:fsd_mwwm_mobx_demo/pages/test_screen/w_screen_birthday.dart';
import 'package:fsd_mwwm_mobx_demo/pages/test_screen/w_screen_gender.dart';
import 'package:fsd_mwwm_mobx_demo/pages/test_screen/w_screen_nickname.dart';
import 'package:fsd_mwwm_mobx_demo/pages/test_screen/w_screen_photo_request.dart';
import 'package:awesome_extensions/awesome_extensions_dart.dart';
import 'package:awesome_extensions/awesome_extensions_flutter.dart';
import 'package:disposing/disposing_dart.dart';
import 'package:flutter/material.dart' hide Action;
// ignore: unused_import
import 'package:collection/collection.dart';
// ignore: unused_import

import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:utils/utils_dart.dart';
import 'package:utils/utils_flutter.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

import 'test_screen.dart';

class TestScreenWm extends MobxWM<TestScreenWidget> with Store, LoggerMixin {
  // INIT ---------------------------------------------------------------------

  @override
  // ignore: unnecessary_overrides
  void initWidgetModel() {
    super.initWidgetModel();

    birthForm.value.statusChanged
        .listen(
          (status) => runInAction(() => birthForm.reportManualChange()),
        )
        .disposeOn(this);
    nicknameForm.value.statusChanged
        .listen(
          (status) => runInAction(() => nicknameForm.reportManualChange()),
        )
        .disposeOn(this);
  }

  // DI DEPENDENCIES ----------------------------------------------------------
  late final userPreferences = ScopeProvider.of<AppScopeContainer>(context, listen: false)!.userPreferencesDep.get;
  // FIELDS -------------------------------------------------------------------
  final genders = [
    'Male',
    'Female',
    'Other',
  ];

  late final pages = [
    WScreenBirthday(
      wm: this,
    ),
    WScreenNickname(
      wm: this,
    ),
    WScreenGender(
      wm: this,
    ),
    WScreenPhotoRequest(
      wm: this,
    ),
  ];

  // PROXY --------------------------------------------------------------------

  // OBSERVABLES --------------------------------------------------------------
  final lock = ObservableLock();

  late final pageControllerUnsafe = MobxUtils.fromCN(PageController()).disposeOnR(this);

  final selectedGender = makeObsNull<String>();

  late final birthForm = makeObs(
    FormGroup({
      'day': FormControl<String>(validators: [const RequiredValidator(), const DayValidator()]),
      'month': FormControl<String>(validators: [const RequiredValidator(), const MonthValidator()]),
      'year': FormControl<String>(validators: [const RequiredValidator(), const YearValidator()]),
    }),
  );

  late final nicknameForm = makeObs(FormControl<String>(validators: [Validators.required]));
  // COMPUTED -----------------------------------------------------------------

  // because detached pagecontroller throws
  PageController? get pageControllerSafe {
    final c = pageControllerUnsafe.value;
    if (c.positions.length == 1) {
      return c;
    }
    return null;
  }

  double get currentPage => pageControllerSafe?.page ?? 0;
  Widget get currentPageWidget => pages[currentPage.round()];

  bool get showNextButton {
    return currentPageValidated ?? false;
  }

  bool? get currentPageValidated {
    if (currentPageWidget is WScreenBirthday) {
      return birthForm.value.valid;
    }
    if (currentPageWidget is WScreenNickname) {
      return nicknameForm.value.valid;
    }
    return null;
  }

  // STREAM REACTION ----------------------------------------------------------

  // ACTIONS ------------------------------------------------------------------
  Future<void> onSubmittedNickname(dynamic value) async {
    loggerGlobal.d("unfocus");
    FocusManager.instance.primaryFocus?.unfocus();
    await _validateSaveGoNext();
  }

  void onPressClose() {
    context.pop();
  }

  Future<void> onPressBack() async {
    if (lock.obs.value.locked) return;

    await lock.synchronized(() async {
      await pageControllerSafe?.previousPage(
        duration: 300.milliseconds,
        curve: Curves.easeInOutCubic,
      );
    });
  }

  Future<void> onPressNext() async {
    if (lock.obs.value.locked) return;

    await lock.synchronized(() async {
      loggerGlobal.d("unfocus");
      FocusManager.instance.primaryFocus?.unfocus();
      await _validateSaveGoNext();
    });
  }

  void onPressGender(String value) {
    runInAction(() {
      selectedGender.value = value;
      _validateSaveGoNext();
    });
  }

  void onPressConfirmToTakePhoto() {
    context.push(
      const CameraScreenWidget(),
    );
  }

  // UI -----------------------------------------------------------------------

  // UTIL METHODS -------------------------------------------------------------

  Future<void> _validateSaveGoNext() async {
    if (currentPageValidated == false) return;
    if (currentPageWidget is WScreenBirthday) {
      await userPreferences.saveBirthData(
        BirthData(
          day: birthForm.value.control('day').value,
          month: birthForm.value.control('month').value,
          year: birthForm.value.control('year').value,
        ),
      );
    }
    if (currentPageWidget is WScreenNickname) {
      await userPreferences.saveNickname(nicknameForm.value.value ?? '');
    }
    if (currentPageWidget is WScreenGender) {
      await userPreferences.saveSelectedGender(selectedGender.value ?? '');
    }
    await pageControllerSafe?.nextPage(
      duration: 300.milliseconds,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void setupLoggers() {
    setupObservableLoggers(
      [
        () => 'selectedGender: ${selectedGender.value}',
        () => 'showNextButton: ${showNextButton}',
      ],
      logger,
    );
  }
}
