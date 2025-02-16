// ignore: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WTextButtonWhite extends StatelessWidget {
  const WTextButtonWhite({
    super.key,
    required this.onPressed,
    required this.text,
  });

  final void Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.white, // Background color
        padding: const EdgeInsets.all(0) + EdgeInsets.symmetric(vertical: 15.h), // Padding can be customized if needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 17.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
