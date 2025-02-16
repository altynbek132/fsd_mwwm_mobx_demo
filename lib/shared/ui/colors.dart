import 'package:flutter/material.dart';

class AppColors {
  final colorFF0E0E0E = const Color(0xFF0E0E0E);
  final colorFF959595 = const Color(0xFF959595);
  final colorFF550D8E = const Color(0xFF550D8E);
  final colorFF10001A = const Color(0xFF10001A);
  final colorD8151515 = const Color(0xD8151515);
  final colorFF6F6F70 = const Color(0xFF6F6F70);
  final color4C000000 = const Color(0x4C000000);
  final colorFFA5A5A5 = const Color(0xFFA5A5A5);
  final color724A4052 = const Color(0x724A4052);
  final colorFF3E3743 = const Color(0xFF3E3743);
  final color724B4053 = const Color(0x724B4053);
  final colorFF3E3744 = const Color(0xFF3E3744);
}

extension AppColorsExtension on BuildContext {
  AppColors get appColors => AppColors();
}
