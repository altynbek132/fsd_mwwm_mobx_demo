import 'dart:async';

// ignore: unused_import
import 'package:fsd_mwwm_mobx_demo/shared/di/app_scope.dart';
import 'package:awesome_extensions/awesome_extensions_flutter.dart';
import 'package:flutter/material.dart' hide Action;
// ignore: unused_import
import 'package:collection/collection.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
// ignore: unused_import

import 'package:mobx/mobx.dart';
import 'package:utils/utils_dart.dart';
import 'package:utils/utils_flutter.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

import 'settings_screen.dart';

class SettingsScreenWm extends MobxWM<SettingsScreenWidget> with Store, LoggerMixin {
  // INIT ---------------------------------------------------------------------

  @override
  // ignore: unnecessary_overrides
  void initWidgetModel() {
    super.initWidgetModel();
  }

  // DI DEPENDENCIES ----------------------------------------------------------
  late final userPreferences = ScopeProvider.of<AppScopeContainer>(context, listen: false)!.userPreferencesDep.get;
  late final appPreferences = ScopeProvider.of<AppScopeContainer>(context, listen: false)!.appPreferencesDep.get;

  // FIELDS -------------------------------------------------------------------

  // PROXY --------------------------------------------------------------------

  // OBSERVABLES --------------------------------------------------------------
  late final username = userPreferences.loadNickname().obs();
  late final birthday = userPreferences.loadBirthData().obs();

  final lock = ObservableLock();
  // COMPUTED -----------------------------------------------------------------

  late final isLocked = appPreferences.isLocked().obs();

  late final birthDayFormatted = Computed<String?>(
    () {
      final birthData = birthday.value;
      if (birthData == null) {
        return null;
      }

      final date = DateTime(
        int.parse(birthData.year),
        int.parse(birthData.month),
        int.parse(birthData.day),
      ); // The date you want to format
      final formatter = DateFormat('d MMM yyyy'); // The desired format
      final formattedDate = formatter.format(date);
      return formattedDate;
    },
  );

  // STREAM REACTION ----------------------------------------------------------

  // ACTIONS ------------------------------------------------------------------
  void onPressBack() {
    context.pop();
  }

  Future<void> onPressUnlock() async {
    if (lock.obs.value.locked) return;

    await lock.synchronized(() async {
      final agreeToUnlock = (await _showUnlockAppDialog(context)) ?? false;
      if (agreeToUnlock) {
        await runInAsyncAction(() async {
          await appPreferences.saveIsLocked(false);
          if (!context.mounted) return;
          _showUnlockSuccessMessage(context);
        });
      }
    });
  }

  Future<void> onPressRate() async {
    if (lock.obs.value.locked) return;

    await lock.synchronized(() async {
      final inAppReview = InAppReview.instance;

      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      }
    });
  }

  Future<bool?> _showUnlockAppDialog(BuildContext context) async {
    return await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87, // Dark background for the dialog
          title: const Text(
            'Unlock Application',
            style: TextStyle(color: Colors.white), // White text for the title
          ),
          content: const Text(
            'Are you sure you want to unlock the application?',
            style: TextStyle(color: Colors.white), // White text for the content
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'No',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop(true); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showUnlockSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.black87, // Dark background for Snackbar
        content: Text(
          'Application successfully unlocked!',
          style: TextStyle(color: Colors.white), // White text for Snackbar content
        ),
        duration: Duration(seconds: 2),
      ),
    );
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
