import 'package:startup_repo/imports.dart';
import '../controller/auth_controller.dart';

class TrainedBeforeScreen extends StatefulWidget {
  const TrainedBeforeScreen({super.key});

  @override
  State<TrainedBeforeScreen> createState() => _TrainedBeforeScreenState();
}

class _TrainedBeforeScreenState extends State<TrainedBeforeScreen> {
  final controller = Get.find<AuthController>();
  int selectedLevel = 1;
  int selectedDay = 1;

  final List<String> levelList = ['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5', 'Level 6', 'Level 7', 'Level 8'];
  final List<String> dayList = [
    'Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5', 'Day 6',
    'Day 7', 'Day 8', 'Day 9', 'Day 10', 'Day 11', 'Day 12'
  ];

  void _onConfirm() {
    controller.setTrainedBeforeDetails(
      currentLevel: selectedLevel,
      currentDay: selectedDay,
      isSkipped: false,
    );
    Get.toNamed('/notification-permission');
  }

  void _onSkip() {
    controller.setTrainedBeforeDetails(
      currentLevel: 1,
      currentDay: 1,
      isSkipped: true,
    );
    Get.toNamed('/notification-permission');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(25.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'catch_us_up'.tr,
                      style: context.font26.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    SizedBox(height: 10.sp),
                    Text(
                      'trained_before_description'.tr,
                      style: context.font15.copyWith(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    SizedBox(height: 30.sp),
                    _buildDropdown(
                      label: 'current_level'.tr,
                      value: 'Level $selectedLevel',
                      items: levelList,
                      onChanged: (value) {
                        setState(() {
                          selectedLevel = levelList.indexOf(value!) + 1;
                        });
                      },
                    ),
                    SizedBox(height: 16.sp),
                    _buildDropdown(
                      label: 'current_day'.tr,
                      value: 'Day $selectedDay',
                      items: dayList,
                      onChanged: (value) {
                        setState(() {
                          selectedDay = dayList.indexOf(value!) + 1;
                        });
                      },
                    ),
                    SizedBox(height: 20.sp),
                    Divider(height: 1, color: Theme.of(context).colorScheme.onSecondary),
                    SizedBox(height: 20.sp),
                    Text(
                      'baseline_measurement'.tr,
                      style: context.font18.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    SizedBox(height: 10.sp),
                    Text(
                      'baseline_measurement_description'.tr,
                      style: context.font15.copyWith(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    SizedBox(height: 20.sp),
                    Container(
                      padding: EdgeInsets.all(15.sp),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.sp),
                      ),
                      child: Text(
                        'none_specified'.tr,
                        style: context.font15.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(25.sp),
              child: Column(
                children: [
                  PrimaryButton(
                    text: 'confirm'.tr,
                    onPressed: _onConfirm,
                  ),
                  SizedBox(height: 15.sp),
                  GestureDetector(
                    onTap: _onSkip,
                    child: Text(
                      'skip'.tr,
                      style: context.font18.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.font15.copyWith(
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
        DropdownButton<String>(
          value: value,
          underline: const SizedBox(),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: context.font14.copyWith(
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

