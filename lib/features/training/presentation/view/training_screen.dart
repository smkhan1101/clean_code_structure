import 'package:startup_repo/imports.dart';
import '../controller/training_controller.dart';
import '../../../../core/widgets/loading.dart';
import 'training_details_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  static void show() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.grey.withOpacity(0.8),
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
      barrierColor: Colors.grey.withOpacity(0.8),
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
            height: MediaQuery.of(context).size.height * 0.95,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
            ),
            child: Center(child: Loading()),
          );
        }

        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
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

    if (controller.showTrainingDetails) {
      return _buildTrainingDetailsView(controller, context);
    }

    return _buildStartView(controller, context);
  }

  Widget _buildStartView(TrainingController controller, BuildContext context) {
    return Column(
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 20.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Measure your baseline',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16.sp,
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
              SizedBox(height: 24.h),
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
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Once you press Start, you will be asked to swing 5 times with Rypstick (2 weights) or driver. Knowing your baseline speed will help track your progress as you go through training.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'You will need:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildRequirementItem('A RypRadar or other speed measurement tool.', index: 1),
                      SizedBox(height: 8.h),
                      _buildRequirementItem('A Rypstick (2 weights) or driver.', index: 2),
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
                    Divider(
                      color: Colors.grey[700],
                      thickness: 1,
                    ),
                    SizedBox(height: 32.h),
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
                        SizedBox(width: 12.w),
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
                    SizedBox(height: 32.h),
                    _buildSlideToStartButton(controller, _hasWarmedUp),
                    SizedBox(height: 24.h),
                    Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'I don\'t have a radar',
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    if (_videoController == null) {
      return Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: const Color(0xFF4CAF50),
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

  Widget _buildRequirementItem(String text, {int? index}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (index != null) ...[
          Text(
            '$index.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              height: 1.5,
            ),
          ),
          SizedBox(width: 8.w),
        ] else
          Container(
            margin: EdgeInsets.only(top: 6.h),
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlideToStartButton(TrainingController controller, bool isEnabled) {
    return _SlideToStartButton(
      enabled: isEnabled,
      onSlideComplete: () {
        controller.startTraining();
        TrainingDetailsScreen.show();
      },
    );
  }

  Widget _buildTrainingDetailsView(TrainingController controller, BuildContext context) {
    final exercise = controller.getCurrentExercise();
    if (exercise == null) {
      return Center(child: Text('no_exercise'.tr));
    }

    return Column(
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
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  bottom: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                _buildTrainingVideoPlayer(),
                SizedBox(height: 32.h),

                Center(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 60.h,
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
                          onPressed: () {
                            if (exercise.time > 0) {
                              controller.startTimer(exercise.time.toInt());
                            } else if (exercise.requiresInput) {
                              controller.showSwingCountScreen(1);
                            } else {
                              controller.nextStep();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'START',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
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
                // Progress bar
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
    );
  }

  Widget _buildTrainingVideoPlayer() {
    if (_trainingVideoController == null) {
      return Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: const Color(0xFF4CAF50),
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
          controller: _trainingVideoController!,
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
    final buttonWidth = screenWidth - 40.w;
    final maxDrag = buttonWidth - 56.w;

    return Opacity(
      opacity: widget.enabled ? 1.0 : 0.5,
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: widget.enabled ? const Color(0xFF4CAF50) : Colors.grey[800],
          borderRadius: BorderRadius.circular(28.r),
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
                  onHorizontalDragUpdate: (details) {
                    if (!_isCompleted && widget.enabled) {
                      setState(() {
                        _dragPosition = (_dragPosition + details.delta.dx).clamp(0.0, maxDrag);
                        if (_dragPosition >= maxDrag - 5) {
                          _isCompleted = true;
                          widget.onSlideComplete();
                        }
                      });
                    }
                  },
                  onHorizontalDragEnd: (details) {
                    if (!_isCompleted) {
                      setState(() {
                        _dragPosition = 0.0;
                      });
                    }
                  },
                  child: Container(
                    width: 56.w,
                    height: 56.w,
                    margin: EdgeInsets.all(2.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_forward,
                        color: const Color(0xFF4CAF50),
                        size: 20.sp,
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
                  width: 56.w,
                  height: 56.w,
                  margin: EdgeInsets.all(2.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white.withOpacity(0.5),
                      size: 20.sp,
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
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 20.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Warm up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
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
                  SizedBox(height: 24.h),
                  Text(
                    'Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Please complete these steps before training. A quick warmup helps prevent injuries and makes sure you gain your top speed.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'You will need:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'A Rypstick.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Time to complete:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Around 5 minutes.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.sp),
            child: Container(
              width: double.infinity,
              height: 56.h,
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
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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
          child: CircularProgressIndicator(
            color: const Color(0xFF4CAF50),
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
