import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension PaddingDefault on Widget {
  Padding get paddingDefault => Padding(
        key: key,
        padding: EdgeInsets.symmetric(
          horizontal: 25.w,
        ),
        child: this,
      );
}
