import 'package:startup_repo/imports.dart';
import '../controller/training_controller.dart';
import '../../../../core/widgets/loading.dart';
import 'training_details_screen.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  static void show() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TrainingScreen(),
    );
  }

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
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
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVideoPlayer(),
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
                        value: false,
                        onChanged: (value) {},
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
                      onTap: () {},
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
                _buildSlideToStartButton(controller),
                SizedBox(height: 24.h),
                Center(
                  child: Text(
                    'I don\'t have radar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ],
    );
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.white,
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
                    fontSize: 11.sp,
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

  Widget _buildSlideToStartButton(TrainingController controller) {
    return _SlideToStartButton(
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
                          '00:00',
                          style: TextStyle(
                            color: const Color(0xFF4CAF50),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                _buildTrainingVideoPlayer(),
                SizedBox(height: 32.h),
                Text(
                  'PREPARE TO SWING',
                  style: TextStyle(
                    color: const Color(0xFF4CAF50),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'DOMINANT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '2 WEIGHTS OR DRIVER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 48.h),
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
                              controller.showInputBaseline();
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
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
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
}

class _SlideToStartButton extends StatefulWidget {
  final VoidCallback onSlideComplete;

  const _SlideToStartButton({required this.onSlideComplete});

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
    final maxDrag = buttonWidth - 80.w;

    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(30.r),
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
          Positioned(
            left: _dragPosition.clamp(0.0, maxDrag),
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (!_isCompleted) {
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
                width: 80.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF5CBF60),
                      Color(0xFF4CAF50),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
