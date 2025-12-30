import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/core/theme/app_theme.dart';

Widget headerText(String text) {
  return Text(
    text,
    textAlign: TextAlign.left,
    style: TextStyle(
      fontFamily: 'poppins',

      fontSize: 28.sp,
      fontWeight: FontWeight.bold,
      color: AppThemeColors.whiteColor,
      // height: 1.2,
    ),
  );
}