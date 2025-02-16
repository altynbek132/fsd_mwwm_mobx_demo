// ignore: unused_import
import 'package:fsd_mwwm_mobx_demo/shared/config/options.dart';
import 'package:fsd_mwwm_mobx_demo/shared/ui/gen/assets.gen.dart';
import 'package:fsd_mwwm_mobx_demo/shared/ui/color_opacity_extension.dart';
import 'package:fsd_mwwm_mobx_demo/widgets/padding_default.dart';
import 'package:awesome_extensions/awesome_extensions_flutter.dart';
import 'package:camera/camera.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: unused_import
import 'package:mobx/mobx.dart';
import 'package:platform_info/platform_info.dart';
import 'package:utils/utils_dart.dart';

import 'camera_screen_wm.dart';

CameraScreenWm _wmFactory(BuildContext context) => CameraScreenWm();

class CameraScreenWidget extends ElementaryWidget<CameraScreenWm> with LoggerMixin {
  const CameraScreenWidget({
    super.key,
    WidgetModelFactory wmFactory = _wmFactory,
  }) : super(wmFactory);

  @override
  Widget build(wm, context) {
    return Observer(
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.black.withOpacity_(0.5),
          resizeToAvoidBottomInset: false,
          body: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: ClipRect(
                  child: SizedBox(
                    width: context.width,
                    child: OverflowBox(
                      maxWidth: double.infinity,
                      maxHeight: context.height,
                      child: (() {
                        if (!wm.isCameraReady) {
                          return const SizedBox.shrink();
                        }
                        final dir = wm.cameraController.value?.description.lensDirection;
                        final cameraPreview = CameraPreview(wm.cameraController.value!);
                        if (dir == CameraLensDirection.front && Platform.I.android) {
                          return Transform.scale(
                            scaleX: -1,
                            child: cameraPreview,
                          );
                        }
                        return cameraPreview;
                      })(),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 34,
                left: 0,
                right: 0,
                child: WCircularButton(
                  onTap: wm.onPressTakePhoto,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Column(
                    children: [
                      12.h.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: wm.onPressBack,
                            child: Assets.images.group25.svg(),
                          ),
                          GestureDetector(
                            onTap: wm.onPressChangeCamera,
                            child: Assets.images.group32.svg(),
                          ),
                        ],
                      ).paddingDefault,
                    ],
                  ),
                ),
              ),
              if (wm.lock.obs.value.locked)
                Positioned.fill(
                  child: Stack(
                    children: [
                      Container(color: Colors.black.withOpacity_(0.5)),
                      Center(
                        child: Transform.scale(
                          scale: 2.0,
                          child: const CircularProgressIndicator.adaptive(
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (kAppOptions.flavor.isDev)
                Center(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white.withOpacity_(0.5),
                        child: const Column(
                          children: [
                            Text('visual debug fps check'),
                            CircularProgressIndicator(),
                          ],
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          wm.getMaxTransferByteNumberInFrame();
                        },
                        child: const Text('testSpeedOfTransfer'),
                      ),
                    ],
                  ).paddingOnly(top: 100),
                ),
            ],
          ),
        );
      },
    );
  }
}

class WCircularButton extends StatelessWidget {
  final VoidCallback onTap;

  const WCircularButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer circle
        Container(
          width: 100, // Adjust size as needed
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity_(0.5), // Semi-transparent
          ),
        ),
        // Inner circle (actual button)
        Container(
          width: 80, // Slightly smaller than outer circle
          height: 80,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
