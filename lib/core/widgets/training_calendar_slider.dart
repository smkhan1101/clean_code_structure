import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/core/widgets/training_calendar_dialog.dart';
import 'dart:math' as math;

class TrainingCalendarSlider extends StatelessWidget {
  final double? height;
  final double? width;

  const TrainingCalendarSlider({
    super.key,
    this.height,
    this.width,
  });

  static const _circleSize = 75.0;
  static const _borderWidth = 5.0;
  static const _progressColor = Color(0xFF36C557);
  static const _backgroundColor = Color(0xFF252525);
  static const _greyColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Training Calendar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCalendarItem(
                progress: 1.0,
                value: '16',
                month: 'Dec',
                label: 'Last',
                context: context,
              ),
              SizedBox(width: 8.w),
              _buildCalendarItem(
                progress: 1.0,
                value: '18',
                month: 'Dec',
                label: 'Next',
                context: context,
              ),
              SizedBox(width: 8.w),
              _buildCalendarItem(
                progress: 1 / 3,
                value: '1/3',
                label: 'This week',
                context: context,
              ),
              SizedBox(width: 8.w),
              _buildCalendarItem(
                progress: 1 / 12,
                value: '1/12',
                label: 'This month',
                context: context,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarItem({
    required double progress,
    required String value,
    required String label,
    String? month,
    required BuildContext context,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => TrainingCalendarDialog.show(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: _circleSize.w,
              height: _circleSize.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size(_circleSize.w, _circleSize.w),
                    painter: CircularProgressPainter(
                      progress: progress,
                      backgroundColor: _greyColor[800]!,
                      progressColor: _progressColor,
                      isBorder: true,
                      borderWidth: _borderWidth.sp,
                    ),
                  ),
                  month != null ? _buildDateText(value, month) : _buildProgressText(value),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateText(String day, String month) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          day,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        Text(
          month,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            height: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressText(String value) {
    return Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final bool isBorder;
  final double borderWidth;

  CircularProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    this.isBorder = false,
    this.borderWidth = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    if (isBorder) {
      _drawBorderProgress(canvas, center, radius);
    } else {
      _drawFilledProgress(canvas, center, radius);
    }
  }

  void _drawBorderProgress(Canvas canvas, Offset center, double radius) {
    final adjustedRadius = radius - borderWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: adjustedRadius);

    final greyPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, 2 * math.pi, false, greyPaint);

    if (progress > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        progressPaint,
      );
    }
  }

  void _drawFilledProgress(Canvas canvas, Offset center, double radius) {
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, backgroundPaint);

    if (progress > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.fill;

      final rect = Rect.fromCircle(center: center, radius: radius);
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * progress,
        true,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.isBorder != isBorder;
  }
}
