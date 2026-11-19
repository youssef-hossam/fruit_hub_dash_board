import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class AppStyles {
  // Cairo is bundled in assets/fonts, so text looks the same offline and on web.
  static const String _font = 'Cairo';

  // Headings
  static TextStyle heading1Regular = TextStyle(
    fontFamily: _font,
    fontSize: 48.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle heading1Bold = TextStyle(
    fontFamily: _font,
    fontSize: 48.sp,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static TextStyle heading2Regular = TextStyle(
    fontFamily: _font,
    fontSize: 40.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle heading2Bold = TextStyle(
    fontFamily: _font,
    fontSize: 40.sp,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static TextStyle heading3Regular = TextStyle(
    fontFamily: _font,
    fontSize: 33.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle heading3Bold = TextStyle(
    fontFamily: _font,
    fontSize: 33.sp,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static TextStyle heading4Regular = TextStyle(
    fontFamily: _font,
    fontSize: 28.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle heading4Bold = TextStyle(
    fontFamily: _font,
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static TextStyle heading5Regular = TextStyle(
    fontFamily: _font,
    fontSize: 23.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle heading5Bold = TextStyle(
    fontFamily: _font,
    fontSize: 23.sp,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  // Body
  static TextStyle bodyLargeRegular = TextStyle(
    fontFamily: _font,
    fontSize: 19.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle bodyLargeBold = TextStyle(
    fontFamily: _font,
    fontSize: 19.sp,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static TextStyle bodyBaseRegular = TextStyle(
    fontFamily: _font,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle bodyBaseBold = TextStyle(
    fontFamily: _font,
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static TextStyle bodySmallRegular = TextStyle(
    fontFamily: _font,
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static TextStyle bodySmallBold = TextStyle(
    fontFamily: _font,
    fontSize: 13.sp,
    fontWeight: FontWeight.w700,
    height: 1.7,
  );
  static TextStyle bodySmallsemiBold = TextStyle(
    fontFamily: _font,
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    height: 1.7,
  );

  static TextStyle bodyXSmallRegular = TextStyle(
    fontFamily: _font,
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle bodyXSmallBold = TextStyle(
    fontFamily: _font,
    fontSize: 11.sp,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static TextStyle bodyXSmallSemiBold = TextStyle(
    fontFamily: _font,
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );
}
