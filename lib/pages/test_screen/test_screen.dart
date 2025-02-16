// ignore: unused_import
import 'dart:math';

import 'package:fsd_mwwm_mobx_demo/shared/ui/gen/assets.gen.dart';
import 'package:fsd_mwwm_mobx_demo/shared/ui/colors.dart';
import 'package:fsd_mwwm_mobx_demo/widgets/padding_default.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_extensions/awesome_extensions_dart.dart';
import 'package:awesome_extensions/awesome_extensions_flutter.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: unused_import
import 'package:mobx/mobx.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:utils/utils_dart.dart';

import 'test_screen_wm.dart';

TestScreenWm _wmFactory(BuildContext context) => TestScreenWm();

class TestScreenWidget extends ElementaryWidget<TestScreenWm> with LoggerMixin {
  const TestScreenWidget({
    super.key,
    WidgetModelFactory wmFactory = _wmFactory,
  }) : super(wmFactory);

  @override
  Widget build(wm, context) {
    return Observer(
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                AnimatedBuilder(
                  animation: wm.pageControllerUnsafe.nonObservableValue,
                  builder: (context, child) {
                    return WDataImage(
                      pageCount: wm.pages.length + 1,
                      screenSize: MediaQuery.of(context).size,
                      offset: wm.currentPage,
                    );
                  },
                ),
                Positioned.fill(
                  child: SafeArea(
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: wm.pageControllerUnsafe.nonObservableValue,
                      children: wm.pages,
                    ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AnimatedSwitcher(
                              duration: 300.milliseconds,
                              child: (() {
                                if (wm.currentPage == 0) {
                                  return GestureDetector(
                                    key: const ValueKey(1),
                                    onTap: wm.onPressClose,
                                    child: Assets.images.group15.svg(),
                                  );
                                }
                                return GestureDetector(
                                  key: const ValueKey(2),
                                  onTap: wm.onPressBack,
                                  child: Assets.images.group25.svg(),
                                );
                              })(),
                            ),
                            RepaintBoundary(
                              child: AnimatedBuilder(
                                animation: wm.pageControllerUnsafe.nonObservableValue,
                                builder: (context, child) {
                                  final length = wm.pages.length;
                                  final index = wm.currentPage;
                                  final percent = (index + 1) / length;
                                  return CircularPercentIndicator(
                                    radius: 44 / 2,
                                    lineWidth: 1,
                                    animation: true,
                                    animationDuration: 1000,
                                    percent: percent,
                                    animateFromLastPercent: true,
                                    circularStrokeCap: CircularStrokeCap.butt,
                                    progressColor: Colors.white,
                                    backgroundColor: context.appColors.colorFF959595,
                                    curve: Curves.easeInOutCubic,
                                    center: AutoSizeText(
                                      '${(percent * 100).round()}%',
                                      style: TextStyle(
                                        color: context.appColors.colorFF959595,
                                        fontWeight: FontWeight.w600,
                                        height: 2.86,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ).paddingDefault,
                      ],
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: 300.milliseconds,
                  bottom: 17.h + context.mqViewInsets.bottom - (wm.showNextButton ? 0 : 100.h),
                  right: 25.w,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.all(16.r),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: wm.onPressNext,
                    icon: Assets.images.group10.svg(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WDataImage extends StatelessWidget {
  const WDataImage({
    super.key,
    required this.pageCount,
    required this.screenSize,
    required this.offset,
  });

  final Size screenSize;
  final int pageCount;
  final double offset;

  @override
  Widget build(BuildContext context) {
    final lastPageIdx = pageCount - 1;
    final firstPageIdx = 0;
    final alignmentMax = 1;
    final alignmentMin = -1;
    final pageRange = (lastPageIdx - firstPageIdx) - 1;
    final alignmentRange = (alignmentMax - alignmentMin);
    final alignment = (((offset - firstPageIdx) * alignmentRange) / pageRange) + alignmentMin;

    return SizedBox(
      height: screenSize.height,
      width: screenSize.width,
      child: Image(
        image: AssetImage(Assets.images.parallax.path),
        alignment: Alignment(alignment, 0),
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
