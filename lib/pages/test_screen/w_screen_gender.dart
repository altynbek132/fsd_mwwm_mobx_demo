// ignore: unused_import

import 'package:fsd_mwwm_mobx_demo/shared/ui/color_opacity_extension.dart';
import 'package:fsd_mwwm_mobx_demo/shared/ui/colors.dart';
import 'package:fsd_mwwm_mobx_demo/widgets/padding_default.dart';
import 'package:fsd_mwwm_mobx_demo/pages/test_screen/test_screen_wm.dart';
import 'package:awesome_extensions/awesome_extensions_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:utils/utils_dart.dart';

class WScreenGender extends StatelessWidget {
  const WScreenGender({
    super.key,
    required this.wm,
  });

  final TestScreenWm wm;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            103.h.heightBox,
            Text(
              'Which gender do\nyou identify as?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.sp,
                fontWeight: FontWeight.w800,
                height: 1.33,
              ),
            ).paddingDefault,
            14.h.heightBox,
            Text(
              'Your gender helps us find the right matches for you.',
              style: TextStyle(
                color: context.appColors.colorFFA5A5A5,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                height: 1.33,
              ),
            ).paddingDefault,
            40.h.heightBox,
            ...wm.genders.map<Widget>(
              (e) {
                return WTextButton(
                  onPressed: () {
                    wm.onPressGender(e);
                  },
                  label: e,
                ).paddingDefault;
              },
            ).insertBetweenAllElements(
              (i, el) {
                return 25.h.heightBox;
              },
            ),
          ],
        );
      },
    );
  }
}

class WTextButton extends StatelessWidget {
  const WTextButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  final void Function() onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Colors.black.withOpacity_(0.25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            width: 1.w,
            color: context.appColors.colorFF959595, // Replace with your actual color reference
          ),
        ),
        padding: EdgeInsets.only(
          left: 22.w,
          top: 10.h,
          right: 22.w,
          bottom: 18.h,
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Colors.white,
          fontSize: 25.sp,
          fontWeight: FontWeight.w800,
          height: 1.36,
        ),
      ),
    );
  }
}
