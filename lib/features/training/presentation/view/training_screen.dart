import 'package:startup_repo/imports.dart';
import '../controller/training_controller.dart';
import '../../../../core/widgets/loading.dart';
import '../../../../core/widgets/sign_in_button.dart';
import 'training_active_screen.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  static void show() {
    final trainingController = Get.find<TrainingController>();
    trainingController.loadTrainingData();
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(0xFF1E1E1E),
      builder: (context) => const TrainingScreen(),
    );
  }

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  bool _hasWarmedUp = false;
  YoutubePlayerController? _videoController;
  YoutubePlayerController? _trainingVideoController;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayers();
  }

  void _initializeVideoPlayers() {
    final videoId =
        YoutubePlayer.convertUrlToId('https://www.youtube.com/watch?v=IF0kLstvX6M') ?? 'IF0kLstvX6M';
    _videoController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    _trainingVideoController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _trainingVideoController?.dispose();
    super.dispose();
  }

  void _showWarmUpScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(0xFF1E1E1E),
      builder: (context) => _WarmUpScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrainingController>(
      init: Get.find<TrainingController>(),
      builder: (controller) {
        if (controller.isLoading) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
            ),
            child: Center(child: Loading()),
          );
        }

        return Container(
          height: MediaQuery.of(context).size.height * 0.93,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          ),
          child: _buildTrainingContent(controller, context),
        );
      },
    );
  }

  Widget _buildTrainingContent(TrainingController controller, BuildContext context) {
    if (controller.trainingFinishView) {
      return _buildFinishView(controller, context);
    }

    if (controller.showSwingSpeedInput) {
      return _buildSwingSpeedInputView(controller, context);
    }

    if (controller.showSwingCount) {
      return _buildSwingCountView(controller, context);
    }

    if (controller.showTimer) {
      return _buildTimerView(controller, context);
    }

    if (controller.inputBaselineView) {
      return _buildInputBaselineView(controller, context);
    }

    return _buildStartView(controller, context);
  }

  Widget _buildStartView(TrainingController controller, BuildContext context) {
    if (controller.baselineExists) {
      return _buildTrainingView(controller, context);
    } else {
      return _buildBaselineView(controller, context);
    }
  }

  Widget _buildTrainingView(TrainingController controller, BuildContext context) {
    return Column(
      children: [
        _buildTrainingHeader(controller, context),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                if (controller.protocolVideoId != null) _buildTutorialView(controller),
                SizedBox(height: 30.h),
                _buildComingUpView(controller),
                SizedBox(height: 30.h),
                _buildTimeToCompleteView(),
                SizedBox(height: 30.h),
                _buildRadarSelectionView(controller),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
        _buildTrainingFooter(controller),
      ],
    );
  }

  Widget _buildTrainingHeader(TrainingController controller, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 20.sp),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Level ${controller.currentLevel}, Day ${controller.currentDay}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildChangeDayButton(controller),
          SizedBox(width: 10.w),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Container(
              width: 35.w,
              height: 35.w,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF237537),
                    Color(0xFF33C258),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeDayButton(TrainingController controller) {
    if (controller.isChangingTimeline) {
      return const SizedBox(
        width: 36,
        height: 36,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        ),
      );
    }

    return PopupMenuButton<String>(
      icon: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.16),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.swap_horiz,
          color: Colors.white,
          size: 16.sp,
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text('Level ${controller.currentLevel}'),
          enabled: false,
        ),
        ...List.generate(5, (index) {
          final level = index + 1;
          return PopupMenuItem(
            value: 'level_$level',
            child: Text('Level $level'),
            onTap: () {
              Future.delayed(Duration.zero, () {
                controller.changeTimeline(level, 1);
              });
            },
          );
        }),
        const PopupMenuDivider(),
        PopupMenuItem(
          child: Text('Day ${controller.currentDay}'),
          enabled: false,
        ),
        ...List.generate(30, (index) {
          final day = index + 1;
          return PopupMenuItem(
            value: 'day_$day',
            child: Text('Day $day'),
            onTap: () {
              Future.delayed(Duration.zero, () {
                controller.changeTimeline(controller.currentLevel, day);
              });
            },
          );
        }),
      ],
    );
  }

  Widget _buildTutorialView(TrainingController controller) {
    final videoId = controller.protocolVideoId;
    if (videoId == null || videoId.isEmpty) {
      return Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            'No video available',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14.sp,
            ),
          ),
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

  Widget _buildComingUpView(TrainingController controller) {
    if (controller.trainingExercises.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Coming up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15.h),
        ...controller.trainingExercises.map((exercise) {
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Text(
              exercise.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTimeToCompleteView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time to complete',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15.h),
        Text(
          'Around 15 minutes.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildRadarSelectionView(TrainingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Radar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.bluetooth,
                color: Colors.grey[400],
                size: 20.sp,
              ),
              SizedBox(width: 10.w),
              Text(
                'Not connected',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingFooter(TrainingController controller) {
    return Padding(
      padding: EdgeInsets.all(15.w),
      child: Column(
        children: [
          Divider(color: Colors.grey[600], thickness: 1),
          SizedBox(height: 30.h),
          _buildWarmUpCheck(context),
          SizedBox(height: 16.h),
          _buildSlideToStartButton(controller, _hasWarmedUp, context),
        ],
      ),
    );
  }

  Widget _buildWarmUpCheck(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF4CAF50), width: 2),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Checkbox(
            value: _hasWarmedUp,
            onChanged: (value) {
              setState(() {
                _hasWarmedUp = value ?? false;
              });
            },
            activeColor: const Color(0xFF4CAF50),
            checkColor: Colors.white,
            side: BorderSide.none,
          ),
        ),
        SizedBox(width: 18.w),
        Text(
          'I have warmed up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(width: 16.w),
        GestureDetector(
          onTap: () {
            _showWarmUpScreen(context);
          },
          child: Text(
            'See video',
            style: TextStyle(
              color: const Color(0xFF4CAF50),
              fontSize: 15.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBaselineView(TrainingController controller, BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 20.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Measure\nyour baseline',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Container(
                  width: 35.w,
                  height: 35.w,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF237537),
                        Color(0xFF33C258),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
                onPressed: controller.quitTraining,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              // Sticky Video Player
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: _buildVideoPlayer(),
              ),
              SizedBox(height: 20.h),
              // Scrollable Text Section
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overview',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Once you press Start, you will be asked to swing 5 times with Rypstick (2 weights) or driver. Knowing your baseline speed will help track your progress as you go through training.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.sp,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Text(
                        'You will need:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      _buildRequirementItem('1. A RypRadar or other speed measurement tool.'),
                      SizedBox(height: 18.h),
                      _buildRequirementItem('2. A Rypstick (2 weights) or driver.'),
                      SizedBox(height: 18.h),
                      Text(
                        'Swipe and start when you\'re ready!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.sp,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 12.h),
                    ],
                  ),
                ),
              ),
              // Sticky Bottom Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Column(
                  children: [
                    SizedBox(height: 14.h),
                    Divider(
                      color: Colors.grey[600],
                      thickness: 1,
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF4CAF50), width: 2),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Checkbox(
                            value: _hasWarmedUp,
                            onChanged: (value) {
                              setState(() {
                                _hasWarmedUp = value ?? false;
                              });
                            },
                            activeColor: const Color(0xFF4CAF50),
                            checkColor: Colors.white,
                            side: BorderSide.none,
                          ),
                        ),
                        SizedBox(width: 18.w),
                        Text(
                          'I have warmed up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        GestureDetector(
                          onTap: () {
                            _showWarmUpScreen(context);
                          },
                          child: Text(
                            'See video',
                            style: TextStyle(
                              color: const Color(0xFF4CAF50),
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    _buildSlideToStartButton(controller, _hasWarmedUp, context),
                    SizedBox(height: 8.h),
                    Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'I don\'t have a radar',
                          style: TextStyle(
                            color: Color(0xFF777576),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 34.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    if (_videoController == null) {
      return Container(
        height: 150.h,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(
          child: const CircularProgressIndicator(
            color: Colors.green,
            strokeWidth: 3.0,
          ),
        ),
      );
    }

    return Container(
      height: 190.h,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: YoutubePlayer(
          controller: _videoController!,
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

  Widget _buildRequirementItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17.sp,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlideToStartButton(TrainingController controller, bool isEnabled, BuildContext context) {
    return _SlideToStartButton(
      enabled: isEnabled,
      onSlideComplete: () {
        Navigator.pop(context);
        TrainingActiveScreen.show();
      },
    );
  }

  Widget _buildTimerView(TrainingController controller, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatTime(controller.currentTime),
            style: TextStyle(
              fontSize: 64.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4CAF50),
            ),
          ),
          SizedBox(height: 24.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  controller.isPaused ? Iconsax.play : Iconsax.pause,
                  size: 32.sp,
                  color: Colors.white,
                ),
                onPressed: controller.pauseResume,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputBaselineView(TrainingController controller, BuildContext context) {
    final baselineController = TextEditingController();
    return Padding(
      padding: EdgeInsets.all(20.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'enter_baseline_value'.tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.sp),
          CustomTextField(
            controller: baselineController,
            hintText: 'baseline_value'.tr,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 24.sp),
          PrimaryButton(
            text: 'submit'.tr,
            onPressed: () {
              final value = int.tryParse(baselineController.text);
              if (value != null) {
                controller.addBaselineInput(value);
              } else {
                showToast('invalid_value'.tr);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFinishView(TrainingController controller, BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.tick_circle,
              size: 64.sp,
              color: const Color(0xFF4CAF50),
            ),
            SizedBox(height: 24.sp),
            Text(
              'training_completed'.tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.sp),
            if (controller.baselineCompleted > 0)
              Text(
                'baseline_completed'.tr + ': ${controller.baselineCompleted}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
            SizedBox(height: 32.sp),
            PrimaryButton(
              text: 'done'.tr,
              onPressed: () => Get.back(),
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

  Widget _buildSwingCountView(TrainingController controller, BuildContext context) {
    return Container(
      color: const Color(0xFF4CAF50),
      child: Center(
        child: Text(
          '${controller.currentSwingNumber}',
          style: TextStyle(
            fontSize: 120.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSwingSpeedInputView(TrainingController controller, BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Green top section
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
                      onTap: controller.confirmSwingSpeed,
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
          // Numeric keypad section
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
                            // Globe icon
                            return _buildKeypadButton(
                              icon: Icons.language,
                              onTap: () {},
                            );
                          } else if (index == 10) {
                            // Number 0
                            return _buildKeypadButton(
                              text: '0',
                              onTap: () => controller.addSwingSpeedDigit('0'),
                            );
                          } else if (index == 11) {
                            // Backspace
                            return _buildKeypadButton(
                              icon: Icons.backspace,
                              onTap: controller.removeSwingSpeedDigit,
                            );
                          } else {
                            // Numbers 1-9
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

class _SlideToStartButton extends StatefulWidget {
  final VoidCallback onSlideComplete;
  final bool enabled;

  const _SlideToStartButton({
    required this.onSlideComplete,
    this.enabled = false,
  });

  @override
  State<_SlideToStartButton> createState() => _SlideToStartButtonState();
}

class _SlideToStartButtonState extends State<_SlideToStartButton> {
  double _dragPosition = 0.0;
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth - 20.w;
    final maxDrag = buttonWidth - 70.w;

    return Opacity(
      opacity: widget.enabled ? 1.0 : 0.5,
      child: Container(
        height: 70.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF237537),
              Color(0xFF33C258),
            ],
          ),
          borderRadius: BorderRadius.circular(60.r),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Slide to start',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            if (widget.enabled)
              Positioned(
                left: _dragPosition.clamp(0.0, maxDrag),
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onHorizontalDragUpdate: widget.enabled
                      ? (details) {
                          if (!_isCompleted) {
                            setState(() {
                              _dragPosition = (_dragPosition + details.delta.dx).clamp(0.0, maxDrag);
                              if (_dragPosition >= maxDrag - 5) {
                                _isCompleted = true;
                                widget.onSlideComplete();
                              }
                            });
                          }
                        }
                      : null,
                  onHorizontalDragEnd: widget.enabled
                      ? (details) {
                          if (!_isCompleted) {
                            setState(() {
                              _dragPosition = 0.0;
                            });
                          }
                        }
                      : null,
                  child: Container(
                    width: 70.w,
                    height: 70.w,
                    margin: EdgeInsets.all(2.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: _dragPosition >= maxDrag * 0.8
                          ? Icon(
                              Icons.check,
                              color: const Color(0xFF4CAF50),
                              size: 28.sp,
                            )
                          : Icon(
                              Icons.arrow_forward,
                              color: const Color(0xFF4CAF50),
                              size: 24.sp,
                            ),
                    ),
                  ),
                ),
              )
            else
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 70.w,
                  height: 70.w,
                  margin: EdgeInsets.all(2.h),
                  decoration: BoxDecoration(
                    color: Color(0x76BDF4BC).withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF19D00F).withOpacity(0.8),
                      size: 24.sp,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WarmUpScreen extends StatefulWidget {
  const _WarmUpScreen();

  @override
  State<_WarmUpScreen> createState() => _WarmUpScreenState();
}

class _WarmUpScreenState extends State<_WarmUpScreen> {
  YoutubePlayerController? _warmUpVideoController;

  @override
  void initState() {
    super.initState();
    _initializeWarmUpVideo();
  }

  void _initializeWarmUpVideo() {
    final videoId =
        YoutubePlayer.convertUrlToId('https://www.youtube.com/watch?v=IF0kLstvX6M') ?? 'IF0kLstvX6M';
    _warmUpVideoController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _warmUpVideoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.93,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 20.sp),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    'Warm up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWarmUpVideoPlayer(),
                  SizedBox(height: 18.h),
                  Text(
                    'Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Please complete these steps before training. A quick warmup helps prevent injuries and makes sure you gain your top speed.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    'You will need:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    'A Rypstick.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Time to complete:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Around 5 minutes.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.sp),
            child: SignInButton(
              onPressed: () => Navigator.pop(context),
              text: 'Done',
              isValid: true,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              height: 65.h,
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildWarmUpVideoPlayer() {
    if (_warmUpVideoController == null) {
      return Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: const CircularProgressIndicator(
            color: Colors.green,
            strokeWidth: 3.0,
          ),
        ),
      );
    }

    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: YoutubePlayer(
          controller: _warmUpVideoController!,
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
}
