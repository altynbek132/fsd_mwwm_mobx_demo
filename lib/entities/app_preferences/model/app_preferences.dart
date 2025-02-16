import 'dart:async';

import 'package:fsd_mwwm_mobx_demo/shared/lib/rx_db.dart';

class AppPreferences {
  final RxDb db;

  AppPreferences({required this.db});

  final _isLockedKey = 'isLocked';

  // save unlocked locked value
  Future<void> saveIsLocked(bool isLocked) async {
    await db.write(key: _isLockedKey, value: isLocked.toString());
  }

  // load unlocked locked value
  // empty == locked
  Stream<bool> isLocked() {
    return db.read(key: _isLockedKey).map((value) => bool.tryParse(value ?? 'true') ?? true);
  }
}
