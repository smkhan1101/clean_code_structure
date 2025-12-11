import 'package:startup_repo/imports.dart';
import '../controller/training_controller.dart';

class TrainingDetailsScreen extends StatelessWidget {
  const TrainingDetailsScreen({super.key});

  static void show() {
    Get.to(
      () => const TrainingDetailsScreen(),
      fullscreenDialog: true,
      transition: Transition.fadeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrainingController>(
      init: Get.find<TrainingController>(),
      builder: (controller) {
        final exercise = controller.getCurrentExercise();

        if (controller.showTimer) {
          return _buildTimerView(controller, context);
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Expanded(
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Up next:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Baseline Test -\nNormal Golf\nSwings',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.bold,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                _formatTime(controller.currentTime),
                                style: TextStyle(
                                  color: const Color(0xFF4CAF50),
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        _buildVideoPlayer(),
                        SizedBox(height: 32.h),
                        Text(
                          'PREPARE TO SWING',
                          style: TextStyle(
                            color: const Color(0xFF4CAF50),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'DOMINANT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '2 WEIGHTS OR DRIVER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 64.h),
                        Center(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (exercise != null) {
                                    if (exercise.time > 0) {
                                      controller.startTimer(exercise.time.toInt());
                                    } else if (exercise.requiresInput) {
                                      controller.showInputBaseline();
                                      Get.back();
                                    } else {
                                      controller.nextStep();
                                      Get.back();
                                    }
                                  } else {
                                    controller.startTimer(5);
                                  }
                                },
                                child: Text(
                                  'START',
                                  style: TextStyle(
                                    color: const Color(0xFF4CAF50),
                                    fontSize: 48.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'Press when ready',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 48.h),
                        Container(
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Stack(
                            children: [
                              FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: (controller.progress / 100).clamp(0.0, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF5CBF60),
                                        Color(0xFF4CAF50),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              controller.quitTraining();
                            },
                            child: Text(
                              'Quit training',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14.sp,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.grey[500],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimerView(TrainingController controller, BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Up next:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Baseline Test - Normal Golf Swings',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            _formatTime(controller.currentTime),
                            style: TextStyle(
                              color: const Color(0xFF4CAF50),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    _buildVideoPlayer(),
                    SizedBox(height: 32.h),
                    Text(
                      'PREPARE TO SWING',
                      style: TextStyle(
                        color: const Color(0xFF4CAF50),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'DOMINANT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '2 WEIGHTS OR DRIVER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.timer,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          _formatTime(controller.currentTime),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 24.w),
                        GestureDetector(
                          onTap: controller.pauseResume,
                          child: Text(
                            controller.isPaused ? 'Resume' : 'Pause',
                            style: TextStyle(
                              color: const Color(0xFF4CAF50),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Container(
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Stack(
                        children: [
                          FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: (controller.progress / 100).clamp(0.0, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF5CBF60),
                                    Color(0xFF4CAF50),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          controller.quitTraining();
                        },
                        child: Text(
                          'Quit training',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14.sp,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.grey[500],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Widget _buildVideoPlayer() {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.sp),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'This video is unavailable',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Error code: 152 - 15',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 12.h,
            right: 12.w,
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 32.sp,
            ),
          ),
        ],
      ),
    );
  }
}
