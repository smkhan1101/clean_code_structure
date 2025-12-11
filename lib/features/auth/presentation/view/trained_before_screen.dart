import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/imports.dart';
import '../controller/auth_controller.dart';

class TrainedBeforeScreen extends StatefulWidget {
  const TrainedBeforeScreen({super.key});

  @override
  State<TrainedBeforeScreen> createState() => _TrainedBeforeScreenState();
}

class _TrainedBeforeScreenState extends State<TrainedBeforeScreen> {
  final controller = Get.find<AuthController>();
  int selectedLevel = 1;
  int selectedDay = 1;

  final List<String> levelList = [
    'Level 1',
    'Level 2',
    'Level 3',
    'Level 4',
    'Level 5',
    'Level 6',
    'Level 7',
    'Level 8'
  ];
  final List<String> dayList = [
    'Day 1',
    'Day 2',
    'Day 3',
    'Day 4',
    'Day 5',
    'Day 6',
    'Day 7',
    'Day 8',
    'Day 9',
    'Day 10',
    'Day 11',
    'Day 12'
  ];

  void _onConfirm() {
    controller.setTrainedBeforeDetails(
      currentLevel: selectedLevel,
      currentDay: selectedDay,
      isSkipped: false,
    );
    Get.toNamed('/notification-permission');
  }

  void _onSkip() {
    controller.setTrainedBeforeDetails(
      currentLevel: 1,
      currentDay: 1,
      isSkipped: true,
    );
    Get.toNamed('/notification-permission');
  }

  void _showDropdownMenu({
    required BuildContext context,
    required String title,
    required List<String> options,
    required Function(String) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            ...options.map((option) => ListTile(
                  title: Text(
                    option,
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                  onTap: () {
                    onSelected(option);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Catch us up on',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'your training.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'You will be able to pick up right from where you currently are in the training program. If you want to start training from the beginning, press Skip below.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 50.h),
                      _buildFormField(
                        label: 'Current level',
                        child: GestureDetector(
                          onTap: () => _showDropdownMenu(
                            context: context,
                            title: 'Current level',
                            options: levelList,
                            onSelected: (value) {
                              setState(() {
                                selectedLevel = levelList.indexOf(value) + 1;
                              });
                            },
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Level $selectedLevel',
                                style: TextStyle(color: Colors.white, fontSize: 18.sp),
                              ),
                              SizedBox(width: 8.w),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 18.sp),
                                  SizedBox(height: 2.h),
                                  Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18.sp),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      _buildFormField(
                        label: 'Current day',
                        child: GestureDetector(
                          onTap: () => _showDropdownMenu(
                            context: context,
                            title: 'Current day',
                            options: dayList,
                            onSelected: (value) {
                              setState(() {
                                selectedDay = dayList.indexOf(value) + 1;
                              });
                            },
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Day $selectedDay',
                                style: TextStyle(color: Colors.white, fontSize: 18.sp),
                              ),
                              SizedBox(width: 8.w),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 18.sp),
                                  SizedBox(height: 2.h),
                                  Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18.sp),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Divider(color: Colors.grey[700], height: 32.h),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Baseline measurements',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 30.w,
                              height: 30.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'If you did any baseline tests while training, input them here & we\'ll include them in your progress graphs and statistics.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Divider(color: Colors.grey[700], height: 32.h),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF5CBF60),
                          Color(0xFF4CAF50),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ElevatedButton(
                      onPressed: _onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        minimumSize: Size(double.infinity, 56.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Center(
                    child: GestureDetector(
                      onTap: _onSkip,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required Widget child,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 18.sp),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: child,
          ),
        ),
      ],
    );
  }
}
