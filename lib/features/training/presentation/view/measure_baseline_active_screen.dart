import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../imports.dart';
import '../controller/measure_baseline_active_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MeasureBaselineActiveScreen extends StatelessWidget {
  const MeasureBaselineActiveScreen({super.key});

  static void show() {
    Get.to(() => const MeasureBaselineActiveScreen());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MeasureBaselineActiveController>(
      init: Get.find<MeasureBaselineActiveController>(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                controller.trainingCompleted
                    ? _buildTrainingCompletedView(controller)
                    : _buildStandardView(controller),
                if (controller.swingSheetPresented)
                  _buildSwingSheet(controller),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStandardView(MeasureBaselineActiveController controller) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          _buildHeader(controller),
          const Spacer(),
          _buildActionArea(controller),
          const Spacer(),
          _buildFooter(controller),
        ],
      ),
    );
  }

  Widget _buildHeader(MeasureBaselineActiveController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Baseline Test - Normal Golf Swings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20.h),
        _buildTutorialView(controller),
      ],
    );
  }

  Widget _buildTutorialView(MeasureBaselineActiveController controller) {
    final videoId = controller.baselineVideoId;
    if (videoId == null || videoId.isEmpty) {
      return Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12.r),
        ),
      );
    }

    final youtubeController = YoutubePlayerController(
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
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: YoutubePlayer(
          controller: youtubeController,
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

  Widget _buildActionArea(MeasureBaselineActiveController controller) {
    return Column(
      children: [
        if (controller.swingSequenceActive) ...[
          Text(
            'PREPARE TO SWING',
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
          Text(
            'Dominant, two weights or driver',
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15.h),
          Row(
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
            ],
          ),
        ] else
          _buildStartButton(controller),
      ],
    );
  }

  Widget _buildStartButton(MeasureBaselineActiveController controller) {
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

  Widget _buildFooter(MeasureBaselineActiveController controller) {
    return _buildProgressLine(controller);
  }

  Widget _buildProgressLine(MeasureBaselineActiveController controller) {
    final width = MediaQuery.of(Get.context!).size.width - 40.w;
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

  Widget _buildTrainingCompletedView(MeasureBaselineActiveController controller) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Great start!',
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
          _buildFinishButton(controller),
        ],
      ),
    );
  }

  Widget _buildNewBaselineView(MeasureBaselineActiveController controller) {
    final newBaseline = controller.newBaseline;
    final speedUnit = controller.speedUnit;

    return Column(
      children: [
        Text(
          'Your baseline speed:',
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
          'You can now begin training.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildFinishButton(MeasureBaselineActiveController controller) {
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: ElevatedButton(
        onPressed: () {
          controller.finishTraining();
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
      ),
    );
  }

  Widget _buildSwingSheet(MeasureBaselineActiveController controller) {
    return Container(
      color: Colors.black,
      child: _buildSwingSpeedInputView(controller),
    );
  }

  Widget _buildSwingSpeedInputView(MeasureBaselineActiveController controller) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: const Color(0xFF4CAF50),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'SWING',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          controller.currentSwingSpeed.isEmpty ? '0' : controller.currentSwingSpeed,
                          style: TextStyle(
                            fontSize: 64.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Text(
                            controller.speedUnit,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    GestureDetector(
                      onTap: () {
                        controller.confirmSwingSpeed();
                      },
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey[900],
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.all(20.sp),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16.w,
                          mainAxisSpacing: 16.h,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          if (index == 9) {
                            return _buildKeypadButton(
                              icon: Icons.language,
                              onTap: () {},
                            );
                          } else if (index == 10) {
                            return _buildKeypadButton(
                              text: '0',
                              onTap: () => controller.addSwingSpeedDigit('0'),
                            );
                          } else if (index == 11) {
                            return _buildKeypadButton(
                              icon: Icons.backspace,
                              onTap: controller.removeSwingSpeedDigit,
                            );
                          } else {
                            final number = (index + 1).toString();
                            return _buildKeypadButton(
                              text: number,
                              onTap: () => controller.addSwingSpeedDigit(number),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadButton({
    String? text,
    IconData? icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: text != null
              ? Text(
                  text,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                )
              : Icon(
                  icon,
                  color: Colors.white,
                  size: 28.sp,
                ),
        ),
      ),
    );
  }
}

