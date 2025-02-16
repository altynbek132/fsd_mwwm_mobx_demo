// ignore: unused_import
import 'package:fsd_mwwm_mobx_demo/shared/ui/gen/assets.gen.dart';
import 'package:fsd_mwwm_mobx_demo/widgets/clip_material_ink.dart';
import 'package:fsd_mwwm_mobx_demo/shared/ui/colors.dart';
import 'package:fsd_mwwm_mobx_demo/widgets/padding_default.dart';
import 'package:fsd_mwwm_mobx_demo/widgets/w_divider.dart';
import 'package:awesome_extensions/awesome_extensions_flutter.dart';
import 'package:collection/collection.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: unused_import
import 'package:mobx/mobx.dart';
import 'package:platform_info/platform_info.dart';
import 'package:utils/utils_dart.dart';

import 'settings_screen_wm.dart';

SettingsScreenWm _wmFactory(BuildContext context) => SettingsScreenWm();

class SettingsScreenWidget extends ElementaryWidget<SettingsScreenWm> with LoggerMixin {
  const SettingsScreenWidget({
    super.key,
    WidgetModelFactory wmFactory = _wmFactory,
  }) : super(wmFactory);

  @override
  Widget build(wm, context) {
    return Observer(
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Positioned.fill(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    133.h.heightBox,
                    Observer(
                      builder: (context) {
                        final list = [
                          if (wm.isLocked.value ?? true) WSectionListData(label: 'Unlock App', onTap: wm.onPressUnlock),
                          if (Platform.I.mobile) WSectionListData(label: 'Rate Us', onTap: wm.onPressRate),
                        ];
                        if (list.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Settings',
                              style: TextStyle(
                                color: context.appColors.colorFF959595,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.69,
                              ),
                            ).paddingDefault,
                            7.h.heightBox,
                            WSection(list: list).paddingDefault.paddingOnly(bottom: 24.h),
                          ],
                        );
                      },
                    ),
                    Text(
                      'Settings',
                      style: TextStyle(
                        color: context.appColors.colorFF959595,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.69,
                      ),
                    ).paddingDefault,
                    7.h.heightBox,
                    Observer(
                      builder: (context) {
                        return WSection(
                          list: [
                            WSectionListData(label: 'Username', label2: wm.username.value),
                            WSectionListData(label: 'Birthday', label2: wm.birthDayFormatted.value),
                          ],
                        ).paddingDefault;
                      },
                    ),
                  ],
                ),
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
                        children: [
                          GestureDetector(
                            onTap: wm.onPressBack,
                            child: Assets.images.group25.svg(),
                          ),
                        ],
                      ).paddingDefault,
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

class WSectionListData {
  final String label;
  final String? label2;
  final void Function()? onTap;

  WSectionListData({
    required this.label,
    this.label2,
    this.onTap,
  });
}

class WSection extends StatelessWidget {
  const WSection({
    super.key,
    required this.list,
  });

  final List<WSectionListData> list;

  @override
  Widget build(BuildContext context) {
    return ClipMaterialInk(
      borderRadius: BorderRadius.circular(15),
      child: Ink(
        decoration: ShapeDecoration(
          color: context.appColors.color724A4052,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 16.h.heightBox,
            ...(() {
              return list.mapIndexed<Widget>(
                (i, e) {
                  return InkWell(
                    onTap: e.onTap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          e.label,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.62,
                          ),
                        ).paddingDefault.expanded(),
                        if (e.label2 != null)
                          Text(
                            e.label2!,
                            style: TextStyle(
                              color: context.appColors.colorFF959595,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.62,
                            ),
                          ).paddingDefault,
                      ],
                    ).paddingVertical(14.h).paddingOnly(top: i == 0 ? 2.h : 0, bottom: list.length - 1 == i ? 2.h : 0),
                  );
                },
              );
            })()
                .separated(
              const WDivider(),
            ),
          ],
        ),
      ),
    );
  }
}
