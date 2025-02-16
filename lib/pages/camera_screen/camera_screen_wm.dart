import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
// ignore: unused_import
import 'package:fsd_mwwm_mobx_demo/shared/config/options.dart';
import 'package:fsd_mwwm_mobx_demo/shared/di/app_scope.dart';
import 'package:fsd_mwwm_mobx_demo/pages/picture_result_screen/picture_result_screen.dart';
import 'package:awesome_extensions/awesome_extensions_dart.dart';
import 'package:awesome_extensions/awesome_extensions_flutter.dart';
import 'package:camera/camera.dart';
import 'package:disposing/disposing_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Action, Image;
// ignore: unused_import
import 'package:collection/collection.dart';
// ignore: unused_import

import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_utils/shared_utils.dart';
import 'package:utils/utils_dart.dart';
import 'package:utils/utils_flutter.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

import 'camera_screen.dart';

class CameraScreenWm extends MobxWM<CameraScreenWidget> with Store, LoggerMixin, WidgetsBindingObserver, RouteAware {
  // INIT ---------------------------------------------------------------------

  @override
  void dispose() {
    _disposeCamera();
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _disposeCamera() async {
    logger.d("🚀~camera_screen_wm.dart:42~CameraScreenWm~");

    await runInAsyncAction(
      () async {
        await cameraController.value?.dispose();
        cameraController.value = null;
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    appLifecycleSink.add(state);
  }

  Future<void> reconfigCamera() async {
    logger.d("🚀~camera_screen_wm.dart:58~CameraScreenWm~");

    await lock.synchronized(
      () async {
        final state = await appLifecycleStream.first;
        logger.d("🚀~camera_screen_wm.dart:63~CameraScreenWm~");
        if (!context.mounted) return;
        final isCurrentRoute = ModalRoute.of(context)?.isCurrent ?? false;
        logger.d('didChangeAppLifecycleState: AppLifecycleState: $state');

        if (!isCurrentRoute || state == AppLifecycleState.inactive) {
          await _disposeCamera();
          logger.d('didChangeAppLifecycleState: camera disposed');
        } else if (isCurrentRoute && state == AppLifecycleState.resumed) {
          logger.d(
            "🚀~camera_screen_wm.dart:63~CameraScreenWm~voiddidChangeAppLifecycleState~lastCameraDir.value: ${lastCameraDesc.value}",
          );
          await _initCameraWith(newCameraDesc_: lastCameraDesc.value, newCameraDir_: CameraLensDirection.front);
          logger.d('didChangeAppLifecycleState: camera resumed');
        }
      },
      label: 'reconfigCamera',
    );
  }

  @override
  void didPushNext() {
    reconfigCamera();
    logger.d('didPushNext: camera disposed');
  }

  @override
  void didPopNext() {
    reconfigCamera();
    logger.d('didPopNext: camera resumed');
  }

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    initLateFields([
      lastCameraDesc,
      appLifecycleSubject,
      appLifecycleSink,
      appLifecycleStream,
    ]);

    WidgetsBinding.instance.addObserver(this);
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    initCamera();
    appLifecycleStream.listen((_) => reconfigCamera())..disposeOn(this);
  }

  Future<void> initCamera() async {
    logger.d("🚀~camera_screen_wm.dart:110~CameraScreenWm~");

    await lock.synchronized(
      () async {
        await runInAsyncAction(() async {
          final status = await Permission.camera.request();

          if (!status.isGranted) {
            _showSnackBar("Camera permission not granted");
            return;
          }
          await _initCameraWith(newCameraDir_: CameraLensDirection.front);
        });
      },
      label: 'initCamera',
    );
  }

  void _handleError(Object e) {
    if (e is CameraException) {
      String errorMessage;
      switch (e.code) {
        case 'CameraAccessDenied':
          errorMessage = "Camera access denied";
          break;
        default:
          errorMessage = "Error initializing camera: ${e.description}";
          break;
      }
      _showSnackBar(errorMessage);
    }
    logger.e('camera error', error: e);
  }

  void _showSnackBar(String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // DI DEPENDENCIES ----------------------------------------------------------
  late final routeObserver = ScopeProvider.of<AppScopeContainer>(context, listen: false)!.routeObserverDep.get;

  // FIELDS -------------------------------------------------------------------
  late final imageServiceWorker =
      ScopeProvider.of<AppScopeContainer>(context, listen: false)!.imageServiceWorkerDep.get;
  // PROXY --------------------------------------------------------------------

  // OBSERVABLES --------------------------------------------------------------
  final cameraController = makeObsNull<CameraController?>();

  final lock = ObservableLock();

  // COMPUTED -----------------------------------------------------------------

  bool get isCameraReady => cameraController.value?.value.isInitialized ?? false;

  // STREAM REACTION ----------------------------------------------------------

  late final lastCameraDesc = cameraController.toObsStream().whereNotNull().map((e) => e.description).obs()
    ..listen(null).disposeOn(this);

  late final appLifecycleSubject = BehaviorSubject<AppLifecycleState>.seeded(AppLifecycleState.resumed)
    ..disposeOn(this);
  late final appLifecycleSink = appLifecycleSubject.sink;
  late final appLifecycleStream = appLifecycleSubject.stream.distinct().shareReplay(maxSize: 1);
  // ACTIONS ------------------------------------------------------------------

  Future<void> onPressTakePhoto() async {
    logger.d("🚀~camera_screen_wm.dart:176~CameraScreenWm~");

    if (!isCameraReady) return;
    if (lock.obs.value.locked) return;

    await lock.synchronized(
      () async {
        await runInAsyncAction(() async {
          try {
            await cameraController.value?.pausePreview();
            final imageBytes = await trace('take picture and crop', () => _takePictureAndCrop());
            if (imageBytes == null) {
              _showSnackBar("Failed to take a picture");
              return;
            }
            if (!context.mounted) return;
            // unawaited because we want to dispose camera in [didPushNext]
            unawaited(context.push(PictureResultScreenWidget(imageBytes: imageBytes)));
          } on Object catch (e) {
            _handleError(e);
          }
        });
      },
      label: 'onPressTakePhoto',
    );
  }

  Future<void> onPressBack() async {
    await runInAsyncAction(() async {
      context.pop();
    });
  }

  Future<void> onPressChangeCamera() async {
    if (lock.obs.value.locked) return;

    await lock.synchronized(
      () async {
        await _swapCamera();
      },
      label: 'onPressChangeCamera',
    );
  }

  // UI -----------------------------------------------------------------------

  // UTIL METHODS -------------------------------------------------------------

  Future<void> _initCameraWith({
    CameraDescription? newCameraDesc_,
    CameraLensDirection? newCameraDir_,
  }) async {
    logger.d("🚀~camera_screen_wm.dart:221~CameraScreenWm~_initCameraWith");

    if (isCameraReady) {
      logger.d("🚀~camera_screen_wm.dart:223~CameraScreenWm~_initCameraWith: camera is ready, abort");
      return;
    }

    assert(newCameraDesc_ != null || newCameraDir_ != null);

    await runInAsyncAction(() async {
      try {
        final newCameraDesc =
            newCameraDesc_ != null ? await _getCameraFromDesc(newCameraDesc_) : await _getCameraFromDir(newCameraDir_!);
        if (newCameraDesc == null) {
          _showSnackBar("No camera found");
          return;
        }
        await cameraController.value?.dispose();
        cameraController.value = CameraController(newCameraDesc, ResolutionPreset.max);
        await cameraController.value!.initialize();
        cameraController.reportManualChange();
      } on Exception catch (e) {
        _handleError(e);
      }
    });
  }

  Future<void> _swapCamera() async {
    final availableCamerasList = await availableCameras();
    logger.d(
      "🚀~camera_screen_wm.dart:185~CameraScreenWm~Future<void>_swapCamera~availableCamerasList: ${availableCamerasList}",
    );
    if (availableCamerasList.length < 2) {
      logger.d("🚀~camera_screen_wm.dart:247~CameraScreenWm~");
      _showSnackBar('No other cameras');
      return;
    }
    await runInAsyncAction(() async {
      try {
        final currentCameraDesc = cameraController.value?.description;
        final index = availableCamerasList.indexWhere((element) => element == currentCameraDesc);
        assert(index != -1);
        final nextIndex = (index + 1) % availableCamerasList.length;
        final newCamera = availableCamerasList[nextIndex];
        await cameraController.value?.dispose();
        cameraController.value = CameraController(newCamera, ResolutionPreset.max);
        await cameraController.value!.initialize();
        cameraController.reportManualChange();
      } on Exception catch (e) {
        _handleError(e);
      }
    });
  }

  Future<Uint8List?> _takePictureAndCrop() async {
    final XFile file = await trace('take picture', () => cameraController.value!.takePicture());
    logger.d("_takePictureAndCrop~file.path: ${file.path}");

    if (!context.mounted) return null;
    final screenWidth = context.width;
    final screenHeight = context.height;

    final screenAspectRatio = screenWidth / screenHeight;

    final bytes = await trace('read file bytes', () => file.readAsBytes());

    final chunks = await bytesToChunks(bytes, await getMaxTransferByteNumberInFrame()).toList();
    for (final chunk in chunks) {
      await imageServiceWorker.cropImageToAspectRatioSendBytes(bytes: chunk);
    }

    return await chunksToBytes(
      imageServiceWorker.cropImageToAspectRatioProcess(
        aspectRatio: screenAspectRatio,
        shouldFlipHorizontal: cameraController.value?.description.lensDirection == CameraLensDirection.front,
      ),
    );
  }

  Future<CameraDescription?> _getCameraFromDir(CameraLensDirection dir) async {
    final cameras = await availableCameras();
    final camera = cameras.firstWhereOrNull((element) => element.lensDirection == dir) ?? cameras.firstOrNull;
    return camera;
  }

  Future<CameraDescription?> _getCameraFromDesc(CameraDescription desc) async {
    final cameras = await availableCameras();
    final camera = cameras.firstWhereOrNull((element) => element == desc) ?? cameras.firstOrNull;
    return camera;
  }

  Future<int> getMaxTransferByteNumberInFrame() async {
    Future<int> impl() async {
      for (int i = 0; i < 52; i++) {
        final n = pow(2, i).toInt();
        final stopwatch = Stopwatch()..start();
        await trace(
          'test speed of transfer $n',
          () async {
            await imageServiceWorker.getEmptyBytes(n);
          },
          microseconds: true,
        );
        final maxThrottleFrames = kAppOptions.maxThrottleFrames;
        if (stopwatch.elapsedMilliseconds > 1000 / 60 * maxThrottleFrames) {
          logger.d("🚀~camera_screen_wm.dart:245~CameraScreenWm~Future<int>getMaxTransferByteNumberInFrame~n: ${n}");
          return n;
        }
      }
      return pow(2, 52).toInt();
    }

    // hack: sometimes n == 1
    return await () async {
      while (true) {
        final n = await impl();
        if (n > pow(2, 8)) {
          return n;
        }
      }
    }()
        .timeout(3.seconds);
  }

  @override
  void setupLoggers() {
    setupObservableLoggers(
      [
        () => 'lastCameraDir.value: ${lastCameraDesc.value}',
        () => 'lock.obs.value: ${lock.obs.value.locked}',
      ],
      logger,
    );
  }
}
