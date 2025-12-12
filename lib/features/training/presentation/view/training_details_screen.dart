import 'package:startup_repo/imports.dart';
import '../controller/training_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
              // TOP BAR
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
                        // TITLE
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Baseline Test -Normal\nGolfSwings',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.bold,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),

                        // VIDEO PLAYER
                        _buildVideoPlayer(),

                        SizedBox(height: 84.h),

                        // START BUTTON
                        Center(
                          child: Column(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
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
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
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
                      ],
                    ),
                  ),
                ),
              ),

              // --- PROGRESS BAR + QUIT TRAINING ---
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 16.h),
                child: Column(
                  children: [
                    buildProgressBar(controller.progress),
                    SizedBox(height: 16.h),
                    GestureDetector(
                      onTap: controller.quitTraining,
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
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------------------
  // TIMER SCREEN
  // -------------------------------------------------------------------------
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
                    SizedBox(height: 24.h),
                    Text(
                      'Baseline Test - Normal Golf Swings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _buildVideoPlayer(),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.timer, color: Colors.white, size: 24.sp),
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
                    buildProgressBar(controller.progress),
                    SizedBox(height: 24.h),
                    GestureDetector(
                      onTap: controller.quitTraining,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // PROGRESS BAR (IMAGE STYLE)
  // -------------------------------------------------------------------------
  Widget buildProgressBar(double progress) {
    return Container(
      width: double.infinity,
      height: 22.h,
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(40.r),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (progress / 100).clamp(0.0, 1.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: const Color(0xFF3FD156),
                borderRadius: BorderRadius.circular(40.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // VIDEO PLAYER
  // -------------------------------------------------------------------------
  Widget _buildVideoPlayer() {
    final videoId =
        YoutubePlayer.convertUrlToId('https://www.youtube.com/watch?v=IF0kLstvX6M') ?? 'IF0kLstvX6M';

    final controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );

    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: YoutubePlayer(
          controller: controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: const Color(0xFF4CAF50),
          progressColors: const ProgressBarColors(
            playedColor: Color(0xFF4CAF50),
            handleColor: Color(0xFF4CAF50),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // FORMAT TIME
  // -------------------------------------------------------------------------
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
