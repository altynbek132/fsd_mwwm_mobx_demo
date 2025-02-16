import 'package:fsd_mwwm_mobx_demo/entities/app_preferences/model/app_preferences.dart';
import 'package:fsd_mwwm_mobx_demo/shared/lib/rx_db.dart';
import 'package:fsd_mwwm_mobx_demo/entities/user/model/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_service/image_service.dart';
import 'package:yx_scope/yx_scope.dart';

class AppScopeContainer extends ScopeContainer {
  late final userPreferencesDep = dep(
    () => UserPreferences(
      db: rxDbDep.get,
    ),
  );

  late final appPreferencesDep = dep(
    () => AppPreferences(
      db: rxDbDep.get,
    ),
  );

  late final flutterSecureStorageDep = dep(() => const FlutterSecureStorage());

  late final rxDbDep = dep(() => RxDb(storage: flutterSecureStorageDep.get));

  late final routeObserverDep = dep(() => RouteObserver<ModalRoute<void>>());

  late final imageServiceWorkerDep = dep(() => ImageServiceWorker());
}

class AppScopeHolder extends ScopeHolder<AppScopeContainer> {
  @override
  AppScopeContainer createContainer() => AppScopeContainer();
}
