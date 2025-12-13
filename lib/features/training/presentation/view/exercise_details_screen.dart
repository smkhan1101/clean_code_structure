import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/core/widgets/sign_in_button.dart';
import 'package:startup_repo/imports.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../controller/training_controller.dart';

class ExerciseDetailsScreen extends StatelessWidget {
  const ExerciseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TrainingController>();
    final exercise = controller.getCurrentExercise();

    if (exercise == null) {
      return Center(child: Text('no_exercise'.tr));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Up next:',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        exercise.exerciseName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  GetBuilder<TrainingController>(
                    builder: (controller) => Text(
                      _formatTime(controller.currentTime),
                      style: TextStyle(
                        color: const Color(0xFF4CAF50),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildVideoPlayer(exercise.videoId),
                    SizedBox(height: 32.h),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'PREPARE TO SWING',
                            style: TextStyle(
                              color: const Color(0xFF4CAF50),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          if (exercise.dominantStr.isNotEmpty)
                            Text(
                              exercise.dominantStr.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          if (exercise.dominantStr.isNotEmpty && exercise.weightStr.isNotEmpty)
                            SizedBox(height: 8.h),
                          if (exercise.weightStr.isNotEmpty)
                            Text(
                              exercise.weightStr.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          SizedBox(height: 32.h),
                          SignInButton(
                            onPressed: () {
                              if (exercise.time > 0) {
                                controller.startTimer(exercise.time.toInt());
                              } else if (exercise.requiresInput) {
                                controller.showSwingCountScreen(1);
                              } else {
                                controller.nextStep();
                              }
                            },
                            text: 'START',
                            isValid: true,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            height: 65.h,
                          ),
                          SizedBox(height: 12.h),
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
                    SizedBox(height: 40.h),
                    GetBuilder<TrainingController>(
                      builder: (controller) => _buildProgressBar(controller.progress),
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: GestureDetector(
                        onTap: controller.quitTraining,
                        child: Text(
                          'Quit training',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(String videoId) {
    if (videoId.isEmpty) {
      return Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_rounded,
                color: Colors.grey[400],
                size: 48.sp,
              ),
              SizedBox(height: 12.h),
              Text(
                'This video is unavailable',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
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
      );
    }

    return StatefulBuilder(
      builder: (context, setState) {
        final videoController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );

        return Container(
          height: 200.h,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: YoutubePlayer(
              controller: videoController,
              showVideoProgressIndicator: true,
              progressIndicatorColor: const Color(0xFF4CAF50),
              progressColors: const ProgressBarColors(
                playedColor: Color(0xFF4CAF50),
                handleColor: Color(0xFF4CAF50),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      height: 6.h,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (progress / 100).clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF237537),
                    Color(0xFF33C258),
                  ],
                ),
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
