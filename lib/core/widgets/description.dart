import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/core/theme/app_theme.dart';

Widget description(text) {
return  Text(
  text,
  style: TextStyle(
    color: AppThemeColors.whiteColor,
    fontSize: 16.sp,
    height: 1.5,
  ),
);
}