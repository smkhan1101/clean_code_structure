import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/core/widgets/getstarted_button.dart';
import 'package:startup_repo/imports.dart';

class SignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isValid;
  final double fontSize;
  final FontWeight fontWeight;
  final double? height;
  final List<Color>? activeGradientColors;
  final List<Color>? inactiveGradientColors;
  final double activeOpacity;
  final double inactiveOpacity;
  final Widget? icon;

  const SignInButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.isValid,
    this.fontSize = 18.0,
    this.fontWeight = FontWeight.bold,
    this.height,
    this.activeGradientColors,
    this.inactiveGradientColors,
    this.activeOpacity = 1.0,
    this.inactiveOpacity = 1.0,
    this.icon,
  });

  List<Color> get _gradientColors {
    if (isValid) {
      return activeGradientColors ??
          const [
            Color(0xFF237537),
            Color(0xFF33C258),
          ];
    } else {
      return inactiveGradientColors ??
          const [
            Color.fromARGB(77, 35, 117, 56),
            Color.fromARGB(135, 51, 194, 89),
          ];
    }
  }

  double get _opacity => isValid ? activeOpacity : inactiveOpacity;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !isValid,
      child: Opacity(
        opacity: _opacity,
        child: GradientButton(
          onPressed: onPressed,
          text: text,
          fontSize: 24.sp,
          fontWeight: fontWeight,
          height: height ?? 65.h,
          gradientColors: _gradientColors,
          icon: icon,
        ),
      ),
    );
  }
}
