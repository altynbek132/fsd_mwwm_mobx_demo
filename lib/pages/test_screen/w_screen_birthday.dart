// ignore: unused_import

import 'package:fsd_mwwm_mobx_demo/widgets/padding_default.dart';
import 'package:fsd_mwwm_mobx_demo/pages/test_screen/test_screen_wm.dart';
import 'package:fsd_mwwm_mobx_demo/pages/test_screen/w_input.dart';
import 'package:awesome_extensions/awesome_extensions_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:reactive_forms/reactive_forms.dart';

class WScreenBirthday extends StatelessWidget {
  const WScreenBirthday({
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
          'When’s your\nbirthday?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.sp,
            fontWeight: FontWeight.w800,
            height: 1.33,
          ),
        ).paddingDefault,
        58.h.heightBox,
        ReactiveForm(
          formGroup: wm.birthForm.nonObservableValue,
          child: Row(
            children: [
              WInput(
                autofocus: true,
                keyboardType: TextInputType.number,
                hintText: 'dd',
                inputFormatters: [MaskTextInputFormatter(mask: 'dd'.split('').map((e) => '#').join(''))],
                subtitile: 'Day',
                formControlName: 'day',
                onSubmitted: (_) => wm.birthForm.value.control('month').focus(),
              ),
              20.w.widthBox,
              WInput(
                keyboardType: TextInputType.number,
                hintText: 'mm',
                inputFormatters: [MaskTextInputFormatter(mask: 'mm'.split('').map((e) => '#').join(''))],
                subtitile: 'Month',
                formControlName: 'month',
                onSubmitted: (_) => wm.birthForm.value.control('year').focus(),
              ),
              20.w.widthBox,
              WInput(
                keyboardType: TextInputType.number,
                hintText: 'yyyy',
                inputFormatters: [MaskTextInputFormatter(mask: 'yyyy'.split('').map((e) => '#').join(''))],
                subtitile: 'Year',
                formControlName: 'year',
                onSubmitted: (_) => wm.onPressNext(),
              ),
            ],
          ).paddingDefault,
        ),
      ],
    );
  }
}
