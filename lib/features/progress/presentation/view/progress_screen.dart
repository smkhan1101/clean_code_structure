import 'package:startup_repo/imports.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import 'package:flutter/gestures.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int selectedSegment = 0;

  final List<double> speedData = [110, 105, 95, 90];
  final List<double> carryData = [125, 120, 118, 115];
  final List<double> totalData = [140, 135, 130, 128];
  final List<String> months = ['Sep', 'Oct', 'Nov', 'Dec'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: _buildBottomNavBar(context, 2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                'Your progress',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24.h),
              _buildSegmentControl(),
              SizedBox(height: 32.h),
              _buildValueDisplay(),
              SizedBox(height: 24.h),
              _buildChart(),
              SizedBox(height: 24.h),
              _buildNote(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentControl() {
    return Container(
      padding: EdgeInsets.all(3.sp),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedSegment = 0;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.sp),
                decoration: BoxDecoration(
                  color: selectedSegment == 0 ? Colors.grey[700] : Colors.transparent,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'SPEED',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedSegment = 1;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.sp),
                decoration: BoxDecoration(
                  color: selectedSegment == 1 ? Colors.grey[700] : Colors.transparent,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'CARRY',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedSegment = 2;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.sp),
                decoration: BoxDecoration(
                  color: selectedSegment == 2 ? Colors.grey[700] : Colors.transparent,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'TOTAL',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSelectedLabel() {
    switch (selectedSegment) {
      case 0:
        return 'Swing speed';
      case 1:
        return 'Carry distance';
      case 2:
        return 'Total distance';
      default:
        return 'Swing speed';
    }
  }

  String _getSelectedValue() {
    switch (selectedSegment) {
      case 0:
        return '87 KM/H';
      case 1:
        return '118 M';
      case 2:
        return '135 M';
      default:
        return '87 KM/H';
    }
  }

  List<double> _getSelectedData() {
    switch (selectedSegment) {
      case 0:
        return speedData;
      case 1:
        return carryData;
      case 2:
        return totalData;
      default:
        return speedData;
    }
  }

  double _getMaxValue() {
    final data = _getSelectedData();
    return data.reduce((a, b) => a > b ? a : b) * 1.2;
  }

  double _getMinValue() {
    final data = _getSelectedData();
    return data.reduce((a, b) => a < b ? a : b) * 0.8;
  }

  Widget _buildValueDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _getSelectedLabel(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          _getSelectedValue(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildChart() {
    final data = _getSelectedData();
    final maxValue = _getMaxValue();
    final minValue = _getMinValue();
    final yAxisLabels = [60, 80, 100, 120, 140];

    return Container(
      height: 250.h,
      padding: EdgeInsets.only(left: 30.w, right: 10.w, top: 10.h, bottom: 30.h),
      child: CustomPaint(
        painter: LineChartPainter(
          data: data,
          months: months,
          yAxisLabels: yAxisLabels,
          minValue: minValue,
          maxValue: maxValue,
        ),
        child: Container(),
      ),
    );
  }

  Widget _buildNote() {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          height: 1.5,
        ),
        children: [
          const TextSpan(
            text:
                'Note: distance projections are based on standard attack angle and properly fit clubs. For help, reach out to ',
          ),
          TextSpan(
            text: 'rypstickstaff@gmail.com',
            style: TextStyle(
              color: const Color(0xFF4CAF50),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // TODO: Open email
              },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
    return AppBottomNavBar(
      currentIndex: currentIndex,
      onTap: AppBottomNavBar.navigateToScreen,
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> months;
  final List<int> yAxisLabels;
  final double minValue;
  final double maxValue;

  LineChartPainter({
    required this.data,
    required this.months,
    required this.yAxisLabels,
    required this.minValue,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final horizontalGridPaint = Paint()
      ..color = Colors.grey[500]!.withOpacity(0.4)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final verticalGridPaint = Paint()
      ..color = Colors.grey[500]!.withOpacity(0.4)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final linePaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;

    final textStyle = TextStyle(
      color: Colors.grey[400],
      fontSize: 10.sp,
    );

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final chartWidth = size.width - 20;
    final chartHeight = size.height - 0;
    final startX = 0.0;
    final startY = 0.0;

    final range = maxValue - minValue;
    final monthCount = months.length;
    final xStep = chartWidth / (monthCount - 1);

    final horizontalLineCount = 5;
    final verticalLineCount = 4;
    final horizontalSpacing = chartHeight / (horizontalLineCount + 1);
    final verticalSpacing = chartWidth / (verticalLineCount + 1);

    for (int i = 1; i <= horizontalLineCount; i++) {
      final y = startY + (i * horizontalSpacing);
      canvas.drawLine(
        Offset(startX, y),
        Offset(startX + chartWidth, y),
        horizontalGridPaint,
      );
    }

    for (int i = 1; i <= verticalLineCount; i++) {
      final x = startX + (i * verticalSpacing);
      final path = Path()
        ..moveTo(x, startY)
        ..lineTo(x, startY + chartHeight);
      final dashPath = _dashPath(path, dashArray: [4, 4]);
      canvas.drawPath(dashPath, verticalGridPaint);
    }

    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = startX + (i * xStep);
      final normalizedValue = (data[i] - minValue) / range;
      final y = startY + chartHeight - (normalizedValue * chartHeight);
      points.add(Offset(x, y));
    }

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, linePaint);

    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }

    for (int i = 0; i < yAxisLabels.length; i++) {
      final label = yAxisLabels[i].toString();
      final y = startY + ((horizontalLineCount - i) * horizontalSpacing);

      textPainter.text = TextSpan(text: label, style: textStyle);
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(chartWidth + 10, y - textPainter.height / 2),
      );
    }

    for (int i = 0; i < monthCount; i++) {
      final label = months[i];
      final x = startX + (i * xStep);

      textPainter.text = TextSpan(text: label, style: textStyle);
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, chartHeight + 15),
      );
    }
  }

  Path _dashPath(Path path, {List<double> dashArray = const [5, 5]}) {
    final dashPath = Path();
    final dashArrayLength = dashArray.length;
    var dashIndex = 0;

    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      var distance = 0.0;
      while (distance < metric.length) {
        final isDash = dashIndex % 2 == 0;
        final dashLength = dashArray[dashIndex % dashArrayLength];
        if (distance + dashLength > metric.length) {
          final remaining = metric.length - distance;
          if (isDash) {
            dashPath.addPath(
              metric.extractPath(distance, distance + remaining),
              Offset.zero,
            );
          }
          break;
        }
        if (isDash) {
          dashPath.addPath(
            metric.extractPath(distance, distance + dashLength),
            Offset.zero,
          );
        }
        distance += dashLength;
        dashIndex++;
      }
    }
    return dashPath;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
