// ignore: unused_import

import 'package:fsd_mwwm_mobx_demo/shared/ui/gen/assets.gen.dart';
import 'package:fsd_mwwm_mobx_demo/shared/ui/color_opacity_extension.dart';
import 'package:fsd_mwwm_mobx_demo/shared/ui/colors.dart';
import 'package:fsd_mwwm_mobx_demo/widgets/padding_default.dart';
import 'package:fsd_mwwm_mobx_demo/pages/test_screen/test_screen_wm.dart';
import 'package:fsd_mwwm_mobx_demo/pages/welcome_screen/w_text_button_white.dart';
import 'package:awesome_extensions/awesome_extensions_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:utils/utils_dart.dart';

class WScreenPhotoRequest extends StatelessWidget {
  const WScreenPhotoRequest({
    super.key,
    required this.wm,
  });

  final TestScreenWm wm;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        103.h.heightBox,
        Text(
          'Add a nice photo\nof yourself',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.sp,
            fontWeight: FontWeight.w800,
            height: 1.33,
          ),
        ).paddingDefault,
        58.h.heightBox,
        WTextButtonWhite(onPressed: wm.onPressConfirmToTakePhoto, text: 'Take your first photo').paddingDefault,
        50.h.heightBox,
        Container(
          decoration: ShapeDecoration(
            color: Colors.black.withOpacity_(0.25),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.w, color: context.appColors.colorFF959595),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Make sure that your image',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.70,
                ),
              ),
              ...[
                'Shows your face clearly',
                'Yourself only, no group pic',
                'No fake pic, object or someone else',
              ].map<Widget>(
                (e) {
                  return Row(
                    children: [
                      Assets.images.vector.svg(),
                      8.w.widthBox,
                      Text(
                        e,
                        style: TextStyle(
                          color: context.appColors.colorFF959595,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          height: 2.12,
                        ),
                      ),
                    ],
                  );
                },
              ).insertBetweenAllElements(
                (i, el) {
                  return 10.h.heightBox;
                },
              ),
            ],
          ).paddingVertical(20.h).paddingHorizontal(22.w),
        ).paddingDefault,
      ],
    );
  }
}
