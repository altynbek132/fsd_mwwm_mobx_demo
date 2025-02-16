// ignore: unused_import

import 'dart:typed_data';

import 'package:fsd_mwwm_mobx_demo/shared/config/options.dart';
import 'package:fsd_mwwm_mobx_demo/shared/lib/adsense_stub.dart';
import 'package:fsd_mwwm_mobx_demo/shared/ui/color_opacity_extension.dart';
import 'package:fsd_mwwm_mobx_demo/widgets/w_banner_mobile.dart';
import 'package:awesome_extensions/awesome_extensions_flutter.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: unused_import
import 'package:mobx/mobx.dart';
import 'package:platform_info/platform_info.dart';
import 'package:utils/utils_dart.dart';
// ignore: unused_import
import 'package:fsd_mwwm_mobx_demo/shared/ui/gen/assets.gen.dart';
import 'package:fsd_mwwm_mobx_demo/widgets/padding_default.dart';
// ignore: unused_import

import 'picture_result_screen_wm.dart';

PictureResultScreenWm _wmFactory(BuildContext context) => PictureResultScreenWm();

class PictureResultScreenWidget extends ElementaryWidget<PictureResultScreenWm> with LoggerMixin {
  const PictureResultScreenWidget({
    super.key,
    required this.imageBytes,
    WidgetModelFactory wmFactory = _wmFactory,
  }) : super(wmFactory);

  final Uint8List imageBytes;

  @override
  Widget build(wm, context) {
    return Observer(
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: false,
          body: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Image.memory(imageBytes, fit: BoxFit.contain),
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
                            onTap: wm.onPressSettings,
                            child: Assets.images.group154.svg(),
                          ),
                        ],
                      ).paddingDefault,
                    ],
                  ),
                ),
              ),
              if (wm.isLocked.value ?? true)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: (() {
                    if (Platform.I.mobile) {
                      return const WBannerMobile();
                    }
                    if (Platform.I.js) {
                      if (kAppOptions.hasAdsense) {
                        return const WAdUnitAdsense();
                      }
                      if (kAppOptions.flavor.isDev) {
                        return Container(
                          height: 50.h,
                          color: Colors.red.withOpacity_(0.5),
                          child: const Text('Adsense is not configured'),
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  })(),
                ),
            ],
          ),
        );
      },
    );
  }
}
