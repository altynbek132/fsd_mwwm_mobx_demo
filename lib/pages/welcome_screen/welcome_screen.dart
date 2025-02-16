// ignore: unused_import
import 'package:fsd_mwwm_mobx_demo/shared/ui/gen/assets.gen.dart';
import 'package:fsd_mwwm_mobx_demo/shared/ui/colors.dart';
import 'package:fsd_mwwm_mobx_demo/widgets/padding_default.dart';
import 'package:fsd_mwwm_mobx_demo/pages/welcome_screen/w_text_button_white.dart';
import 'package:awesome_extensions/awesome_extensions_flutter.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: unused_import
import 'package:mobx/mobx.dart';
import 'package:utils/utils_dart.dart';

import 'welcome_screen_wm.dart';

class WelcomeScreenWidget extends ElementaryWidget<WelcomeScreenWm> with LoggerMixin {
  WelcomeScreenWidget({super.key}) : super((context) => WelcomeScreenWm());

  @override
  Widget build(wm, context) {
    return Observer(
      builder: (context) {
        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                bottom: 96.h,
                child: Assets.images.background.image(
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: const ShapeDecoration(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      30.h.heightBox,
                      Text(
                        'Are you ready for\nyour test?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.36,
                        ),
                      ).paddingDefault,
                      11.h.heightBox,
                      Text(
                        'Start now by creating your profile and connect!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.appColors.colorFF959595,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          height: 2.12,
                        ),
                      ).paddingDefault,
                      15.h.heightBox,
                      (() {
                        const text = 'Continue';
                        return WTextButtonWhite(onPressed: wm.onPressContinue, text: text);
                      })()
                          .paddingDefault,
                      83.h.heightBox,
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
