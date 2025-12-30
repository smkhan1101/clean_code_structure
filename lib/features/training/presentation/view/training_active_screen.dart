import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../imports.dart';
import '../controller/training_active_controller.dart';
import '../controller/swing_sheet_controller.dart';
import '../../data/model/exercise_data.dart';
import '../../domain/service/training_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'swing_sheet_screen.dart';

class TrainingActiveScreen extends StatefulWidget {
  const TrainingActiveScreen({super.key});

  static void show() {
    // Ensure TrainingActiveController is initialized
    if (!Get.isRegistered<TrainingActiveController>()) {
      final trainingService = Get.find<TrainingService>();
      Get.put(TrainingActiveController(trainingService: trainingService));
    }
    Get.to(() => const TrainingActiveScreen());
  }

  @override
  State<TrainingActiveScreen> createState() => _TrainingActiveScreenState();
}

class _TrainingActiveScreenState extends State<TrainingActiveScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrainingActiveController>(
      init: Get.find<TrainingActiveController>(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              SafeArea(
                child: controller.trainingCompleted
                    ? _buildTrainingCompletedView(controller)
                    : _buildStandardView(controller),
              ),
              if (controller.swingSheetPresented)
                _buildSwingSheet(controller),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSwingSheet(TrainingActiveController controller) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: SwingSheetScreen(
          requiresInput: controller.currentAction?.requiresInput ?? false,
          onComplete: (speedValue) {
            // Handle speed input
            if (speedValue != null) {
              controller.addBaselineSpeed(speedValue.toDouble());
            }
            
            // Finish swing (closes swing sheet)
            controller.finishSwing();
            
            // Prepare next swing (this moves to next action/swing)
            controller.prepareNextSwing();
            
            // Reset swing sheet state after swing is finished
            Future.delayed(const Duration(milliseconds: 300), () {
              final swingSheetController = Get.find<SwingSheetController>();
              swingSheetController.reset();
            });
            
            // After preparing next swing, handle countdown or exercise switch
            if (!controller.trainingCompleted) {
              if (controller.notifyExerciseSwitch) {
                // Don't countdown if exercise switch notification is active
                // User needs to press Start button again
                controller.update();
              } else {
                // Start countdown to next swing (this will show countdown on screen)
                controller.countDownToNextSwing();
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildStandardView(TrainingActiveController controller) {
    if (controller.currentAction == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF4CAF50),
        ),
      );
    }

    return Column(
      children: [
        _buildHeader(controller),
        const Spacer(),
        _buildActionArea(controller),
        const Spacer(),
        _buildFooter(controller),
      ],
    );
  }

  Widget _buildHeader(TrainingActiveController controller) {
    final action = controller.currentAction;
    if (action == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Up next:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                controller.clockString,
                style: TextStyle(
                  color: const Color(0xFF4CAF50),
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            action.exerciseName.isNotEmpty ? action.exerciseName : action.heading,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          if (action.videoId.isNotEmpty) _buildTutorialView(action.videoId),
        ],
      ),
    );
  }

  Widget _buildTutorialView(String videoId) {
    return Container(
      key: ValueKey('video_$videoId'),
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
            ),
          ),
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

  Widget _buildActionArea(TrainingActiveController controller) {
    return Column(
      children: [
        if (controller.swingSequenceActive) ...[
          Text(
            controller.nextSwingNotification,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [
                    Color(0xFF237537),
                    Color(0xFF33C258),
                  ],
                ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
            ),
          ),
          SizedBox(height: 15.h),
          if (controller.currentAction != null)
            Text(
              _getSwingParametersDescription(controller.currentAction!).toUpperCase(),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          SizedBox(height: 15.h),
          if (controller.notifyExerciseSwitch)
            _buildStartButton(controller)
          else
            _buildCountdownView(controller),
        ] else
          _buildStartButton(controller),
      ],
    );
  }

  Widget _buildStartButton(TrainingActiveController controller) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            controller.startSwingSequence();
          },
          child: Text(
            'START',
            style: TextStyle(
              fontSize: 60.sp,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [
                    Color(0xFF237537),
                    Color(0xFF33C258),
                  ],
                ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
            ),
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          'Press when ready',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildCountdownView(TrainingActiveController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.hourglass_empty,
          color: Colors.white,
          size: 20.sp,
        ),
        SizedBox(width: 5.w),
        Text(
          controller.nextSwingCountdownString,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
          ),
        ),
        SizedBox(width: 15.w),
        GestureDetector(
          onTap: () {
            controller.toggleNextSwingTimer();
          },
          child: Text(
            controller.nextSwingTimerPaused ? 'Continue' : 'Pause',
            style: TextStyle(
              color: const Color(0xFF4CAF50),
              fontSize: 16.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(TrainingActiveController controller) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          _buildProgressLine(controller),
          SizedBox(height: 15.h),
          _buildQuitButton(controller),
        ],
      ),
    );
  }

  Widget _buildProgressLine(TrainingActiveController controller) {
    final width = MediaQuery.of(context).size.width - 40.w;
    return Stack(
      children: [
        Container(
          width: width,
          height: 30.h,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.25),
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        Container(
          width: width * controller.trainingProgressPercentage,
          height: 30.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF237537),
                Color(0xFF33C258),
              ],
            ),
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
      ],
    );
  }

  Widget _buildQuitButton(TrainingActiveController controller) {
    return GestureDetector(
      onTap: () {
        controller.quit();
      },
      child: Text(
        'Quit training',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16.sp,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildTrainingCompletedView(TrainingActiveController controller) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Training completed',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          _buildNewBaselineView(controller),
          const Spacer(),
          Column(
            children: [
              _buildShareButton(controller),
              SizedBox(height: 8.h),
              _buildFinishButton(controller),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewBaselineView(TrainingActiveController controller) {
    if (controller.baselineSpeeds.isEmpty) {
      return Column(
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF237537),
                  Color(0xFF33C258),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 100.w,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Great job!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    final newBaseline = controller.newBaseline;
    final speedUnit = controller.speedUnit;
    final baselineDiff = controller.baselineDifferenceDescription;

    return Column(
      children: [
        Text(
          'Your new baseline:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          '${newBaseline.toInt()} $speedUnit',
          style: TextStyle(
            fontSize: 60.sp,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: [
                  Color(0xFF237537),
                  Color(0xFF33C258),
                ],
              ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          '($baselineDiff $speedUnit)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildShareButton(TrainingActiveController controller) {
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: ElevatedButton(
        onPressed: () {
          controller.shareWorkout();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF237537),
                Color(0xFF33C258),
              ],
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Text(
              'Share',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFinishButton(TrainingActiveController controller) {
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: ElevatedButton(
        onPressed: () {
          controller.finishTraining();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF252525),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Finish',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10.w),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  String _getSwingParametersDescription(ExerciseData action) {
    var result = '';
    if (action.dominant) {
      result += 'Dominant';
    } else if (action.dominantStr.isNotEmpty) {
      result += action.dominantStr;
    }
    if (result.isNotEmpty) {
      result += ', ${_getWeightDescription(action.weight)}';
    } else {
      result = _getWeightDescription(action.weight);
    }
    return result;
  }

  String _getWeightDescription(int weight) {
    switch (weight) {
      case 0:
        return 'zero weights';
      case 1:
        return '1 weight';
      case 2:
        return '2 weights';
      case 3:
        return '3 weights';
      default:
        return 'zero weights';
    }
  }
}

