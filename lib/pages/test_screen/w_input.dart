// ignore: unused_import

import 'package:fsd_mwwm_mobx_demo/shared/ui/color_opacity_extension.dart';
import 'package:fsd_mwwm_mobx_demo/shared/ui/colors.dart';
import 'package:awesome_extensions/awesome_extensions_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reactive_forms/reactive_forms.dart';

class WInput extends StatelessWidget {
  const WInput({
    super.key,
    required this.hintText,
    this.subtitile,
    this.intrinsiceWidth = true,
    this.formControlName,
    this.keyboardType,
    this.formControl,
    this.onSubmitted,
    this.inputFormatters,
    this.autofocus = false,
  });

  final String hintText;
  final String? subtitile;
  final bool intrinsiceWidth;
  final String? formControlName;
  final FormControl<dynamic>? formControl;
  final TextInputType? keyboardType;
  final void Function(dynamic)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (() {
          final child = ReactiveTextField(
            autofocus: autofocus,
            inputFormatters: inputFormatters,
            onSubmitted: onSubmitted,
            formControlName: formControlName,
            formControl: formControl,
            keyboardType: keyboardType,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.sp,
              fontWeight: FontWeight.w800,
              height: 1.36,
            ),
            decoration: InputDecoration(
              errorStyle: const TextStyle(fontSize: 0),
              contentPadding: EdgeInsets.only(
                left: 22.w,
                top: 10.h,
                right: 22.w,
                bottom: 18.h,
              ),
              filled: true,
              fillColor: Colors.black.withOpacity_(0.25),
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.white.withOpacity_(0.5)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  width: 1.w,
                  color: context.appColors.colorFF959595,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  width: 1.w,
                  color: context.appColors.colorFF959595,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  width: 1.w,
                  color: context.appColors.colorFF959595,
                ),
              ),
            ),
          );
          if (!intrinsiceWidth) {
            return child;
          }
          return IntrinsicWidth(
            child: child,
          );
        })(),
        if (subtitile != null) ...[
          5.h.heightBox,
          Text(
            subtitile!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.appColors.colorFF959595,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              height: 2.12,
            ),
          ),
        ],
      ],
    );
  }
}
