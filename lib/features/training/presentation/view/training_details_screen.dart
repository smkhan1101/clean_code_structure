import 'package:startup_repo/imports.dart';
import '../controller/training_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'countdown_screen.dart';
import 'swing_speed_input_screen.dart';

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

        if (controller.showCountdown) {
          return const CountdownScreen();
        }

        if (controller.showSwingSpeedInput) {
          return const SwingSpeedInputScreen();
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 14.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exercise?.exerciseName ?? 'Up next:\nBaseline Test -\nNormal Golf\nSwings',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _formatTime(controller.currentTime),
                        style: TextStyle(
                          color: const Color(0xFF4CAF50),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
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
                        _buildVideoPlayer(exercise?.videoId ?? 'https://www.youtube.com/watch?v=IF0kLstvX6M'),
                        SizedBox(height: 32.h),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'PREPARE TO SWING',
                                style: TextStyle(
                                  color: const Color(0xFF3DC45E),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                (exercise != null && exercise.dominantStr.isNotEmpty)
                                    ? exercise.dominantStr.toUpperCase()
                                    : 'DOMINANT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 0.h),
                              Text(
                                (exercise != null && exercise.weightStr.isNotEmpty)
                                    ? exercise.weightStr.toUpperCase()
                                    : '2 WEIGHTS OR DRIVER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 14.h),
                        Center(
                          child: controller.showTimer
                              ? Row(
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
                                          color: const Color(0xFF3DC45E),
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
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
                                          color: const Color(0xFF3DC45E),
                                          fontSize: 56.sp,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      'Press when ready',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        SizedBox(height: 18.h),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Column(
                    children: [
                      buildProgressBar(controller.progress),
                      SizedBox(height: 4.h),
                      Center(
                        child: GestureDetector(
                          onTap: controller.quitTraining,
                          child: Text(
                            'Quit training',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16.sp,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w700,
                              decorationColor: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------------------
  // PROGRESS BAR (IMAGE STYLE)
  // -------------------------------------------------------------------------
  Widget buildProgressBar(double progress) {
    return Container(
      width: double.infinity,
      height: 35.h,
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
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF3DC45E),
                    Color(0xFF4CAF50),
                  ],
                ),
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
  Widget _buildVideoPlayer(String videoIdOrUrl) {
    // Default YouTube video URL
    const defaultVideoUrl = 'https://www.youtube.com/watch?v=IF0kLstvX6M';

    // Extract video ID from URL if needed
    String? videoId;
    final urlToUse = videoIdOrUrl.isEmpty ? defaultVideoUrl : videoIdOrUrl;

    if (urlToUse.contains('youtube.com') || urlToUse.contains('youtu.be')) {
      videoId = YoutubePlayer.convertUrlToId(urlToUse);
    } else {
      videoId = urlToUse;
    }

    if (videoId == null || videoId.isEmpty) {
      return Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_rounded,
                color: Colors.white,
                size: 48.sp,
              ),
              SizedBox(width: 16.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
            ],
          ),
        ),
      );
    }

    return StatefulBuilder(
      builder: (context, setState) {
        final videoController = YoutubePlayerController(
          initialVideoId: videoId!,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            enableCaption: false,
          ),
        );

        return Container(
          height: 200.h,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: YoutubePlayer(
              controller: videoController,
              showVideoProgressIndicator: true,
              progressIndicatorColor: const Color(0xFF4CAF50),
              progressColors: const ProgressBarColors(
                playedColor: Color(0xFF4CAF50),
                handleColor: Color(0xFF4CAF50),
                bufferedColor: Color(0xFF4CAF50),
                backgroundColor: Colors.grey,
              ),
              onReady: () {
                // Video is ready to play
              },
            ),
          ),
        );
      },
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
