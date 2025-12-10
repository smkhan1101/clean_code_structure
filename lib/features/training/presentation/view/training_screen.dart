import 'package:startup_repo/imports.dart';
import '../controller/training_controller.dart';
import '../../../../core/widgets/loading.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrainingController>(
      init: Get.find<TrainingController>(),
      builder: (controller) {
        if (controller.isLoading) {
          return Scaffold(
            body: Center(child: Loading()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('training'.tr),
            actions: [
              IconButton(
                icon: Icon(Iconsax.close_circle),
                onPressed: controller.quitTraining,
              ),
            ],
          ),
          body: _buildTrainingContent(controller, context),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ready_to_start'.tr,
            style: context.font24.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24.sp),
          PrimaryButton(
            text: 'start_training'.tr,
            onPressed: controller.startTraining,
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingDetailsView(TrainingController controller, BuildContext context) {
    final exercise = controller.getCurrentExercise();
    if (exercise == null) {
      return Center(child: Text('no_exercise'.tr));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: controller.progress / 100,
            backgroundColor: Get.theme.colorScheme.onSecondary.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
          SizedBox(height: 24.sp),
          Text(
            exercise.heading.isNotEmpty ? exercise.heading : exercise.exerciseName,
            style: context.font20.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.sp),
          Text(
            exercise.exerciseName,
            style: context.font16,
          ),
          if (exercise.dominantStr.isNotEmpty) ...[
            SizedBox(height: 8.sp),
            Text(
              '${'dominant'.tr}: ${exercise.dominantStr}',
              style: context.font14,
            ),
          ],
          if (exercise.weightStr.isNotEmpty) ...[
            SizedBox(height: 8.sp),
            Text(
              '${'weight'.tr}: ${exercise.weightStr}',
              style: context.font14,
            ),
          ],
          SizedBox(height: 32.sp),
          if (exercise.time > 0)
            PrimaryButton(
              text: 'start_timer'.tr,
              onPressed: () => controller.startTimer(exercise.time.toInt()),
            )
          else if (exercise.requiresInput)
            PrimaryButton(
              text: 'enter_baseline'.tr,
              onPressed: controller.showInputBaseline,
            )
          else
            PrimaryButton(
              text: 'next'.tr,
              onPressed: controller.nextStep,
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
            '${controller.currentTime}',
            style: context.font48.copyWith(
              fontWeight: FontWeight.bold,
              color: primaryColor,
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
            style: context.font20.copyWith(fontWeight: FontWeight.bold),
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
              color: primaryColor,
            ),
            SizedBox(height: 24.sp),
            Text(
              'training_completed'.tr,
              style: context.font24.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.sp),
            if (controller.baselineCompleted > 0)
              Text(
                'baseline_completed'.tr + ': ${controller.baselineCompleted}',
                style: context.font16,
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
}

