// ignore: unused_import

import 'package:fsd_mwwm_mobx_demo/widgets/padding_default.dart';
import 'package:fsd_mwwm_mobx_demo/pages/test_screen/test_screen_wm.dart';
import 'package:fsd_mwwm_mobx_demo/pages/test_screen/w_input.dart';
import 'package:awesome_extensions/awesome_extensions_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WScreenNickname extends StatelessWidget {
  const WScreenNickname({
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
          'Choose your\nnickname',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.sp,
            fontWeight: FontWeight.w800,
            height: 1.33,
          ),
        ).paddingDefault,
        58.h.heightBox,
        WInput(
          autofocus: true,
          hintText: 'John Smith',
          intrinsiceWidth: false,
          formControl: wm.nicknameForm.nonObservableValue,
          onSubmitted: wm.onSubmittedNickname,
        ).paddingDefault,
      ],
    );
  }
}
