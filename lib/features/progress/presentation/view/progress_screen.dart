import 'package:startup_repo/imports.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int selectedSegment = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: _buildBottomNavBar(context, 2),
      body: SafeArea(
        child: Padding(
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
              Text(
                _getSelectedLabel(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 24.h),
              Expanded(
                child: Center(
                  child: Text(
                    'Your progress will appear here.',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
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

  Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
    return AppBottomNavBar(
      currentIndex: currentIndex,
      onTap: AppBottomNavBar.navigateToScreen,
    );
  }
}
