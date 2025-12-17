import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/core/widgets/sign_in_button.dart';
import 'package:startup_repo/core/widgets/getstarted_button.dart';
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
  final List<BaselineMeasurement> _baselineMeasurements = [];
  final TextEditingController _valueController = TextEditingController();
  DateTime? _selectedDate;

  final List<String> levelList = [
    'Level 1',
    'Level 2',
    'Level 3',
    'Level 4',
    'Level 5',
    'Level 6',
    'Level 7',
    'Level 8'
  ];
  final List<String> dayList = [
    'Day 1',
    'Day 2',
    'Day 3',
    'Day 4',
    'Day 5',
    'Day 6',
    'Day 7',
    'Day 8',
    'Day 9',
    'Day 10',
    'Day 11',
    'Day 12'
  ];

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

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

  void _showDropdownMenu({
    required BuildContext context,
    required String title,
    required List<String> options,
    required Function(String) onSelected,
  }) {
    String currentValue = title == 'Current level' ? 'Level $selectedLevel' : 'Day $selectedDay';

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 25.w),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 130.w,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 3,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (int index = 0; index < options.length; index++)
                    GestureDetector(
                      onTap: () {
                        onSelected(options[index]);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                        decoration: BoxDecoration(
                          border: index == options.length - 1
                              ? null
                              : Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[700]!,
                                    width: 0.5,
                                  ),
                                ),
                        ),
                        child: Row(
                          children: [
                            if (options[index] == currentValue)
                              Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20.sp,
                              )
                            else
                              SizedBox(width: 20.sp),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Center(
                                child: Text(
                                  options[index],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                  ),
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
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Catch us up on',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'your training.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 35.h),
                      Text(
                        'You will be able to pick up right from where you currently are in the training program. If you want to start training from the beginning, press Skip below.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      _buildFormField(
                        label: 'Current level',
                        child: GestureDetector(
                          onTap: () => _showDropdownMenu(
                            context: context,
                            title: 'Current level',
                            options: levelList,
                            onSelected: (value) {
                              setState(() {
                                selectedLevel = levelList.indexOf(value) + 1;
                              });
                            },
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Level $selectedLevel',
                                style: TextStyle(color: Colors.white, fontSize: 18.sp),
                              ),
                              SizedBox(width: 8.w),
                              Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  Transform.translate(
                                    offset: Offset(0, -8.h),
                                    child: Icon(
                                      Icons.keyboard_arrow_up,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                                  ),
                                  Transform.translate(
                                    offset: Offset(0, 4.h),
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      _buildFormField(
                        label: 'Current day',
                        child: GestureDetector(
                          onTap: () => _showDropdownMenu(
                            context: context,
                            title: 'Current day',
                            options: dayList,
                            onSelected: (value) {
                              setState(() {
                                selectedDay = dayList.indexOf(value) + 1;
                              });
                            },
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Day $selectedDay',
                                style: TextStyle(color: Colors.white, fontSize: 18.sp),
                              ),
                              SizedBox(width: 8.w),
                              Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  Transform.translate(
                                    offset: Offset(0, -2.h),
                                    child: Icon(
                                      Icons.keyboard_arrow_up,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                                  ),
                                  Transform.translate(
                                    offset: Offset(0, 4.h),
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Divider(color: Colors.grey[600], height: 14.h),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Baseline measurements',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          GestureDetector(
                            onTap: () => _showManualInputDialog(context),
                            child: Container(
                              width: 24.w,
                              height: 24.w,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromARGB(255, 43, 108, 46),
                                    Color(0xFF4CAF50),
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'If you did any baseline tests while training, input them here & we\'ll include them in your progress graphs and statistics.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      if (_baselineMeasurements.isEmpty)
                        Center(
                          child: Text(
                            'None specified',
                            style: TextStyle(
                              color: Color(0xFF777576),
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      else
                        ..._baselineMeasurements.map((measurement) => Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: _buildMeasurementCard(measurement),
                            )),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                children: [
                  SignInButton(
                    onPressed: _onConfirm,
                    text: 'Confirm',
                    isValid: true,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    height: 65.h,
                  ),
                  SizedBox(height: 25.h),
                  Center(
                    child: GestureDetector(
                      onTap: _onSkip,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Color(0xFF777576),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildFormField({
    required String label,
    required Widget child,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 18.sp),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: child,
          ),
        ),
      ],
    );
  }

  void _showManualInputDialog(BuildContext context) {
    _valueController.clear();
    _selectedDate = DateTime.now();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF191919),
                Color(0xFF252525),
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ),
          ),
          padding: EdgeInsets.only(
            left: 25.w,
            right: 25.w,
            top: 30.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 30.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    'Manual Input',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80.w,
                    child: TextField(
                      controller: _valueController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.left,
                      cursorColor: const Color(0xFF4CAF50),
                      onChanged: (value) => setDialogState(() {}),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 60.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                    ),
                  ),
                  SizedBox(width: 30.w),
                  Text(
                    'MPH',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Measured',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.dark(),
                            child: child!,
                          );
                        },
                      );
                      if (date != null) {
                        setDialogState(() {
                          _selectedDate = date;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        _selectedDate != null
                            ? '${_selectedDate!.day} ${_getMonthName(_selectedDate!.month)} ${_selectedDate!.year}'
                            : 'Select Date',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.h),
              Builder(
                builder: (context) {
                  final isValid = _valueController.text.isNotEmpty && _selectedDate != null;
                  return AbsorbPointer(
                    absorbing: !isValid,
                    child: Opacity(
                      opacity: isValid ? 1.0 : 0.5,
                      child: GradientButton(
                        onPressed: () {
                          if (_valueController.text.isNotEmpty && _selectedDate != null) {
                            setState(() {
                              _baselineMeasurements.add(
                                BaselineMeasurement(
                                  value: _valueController.text,
                                  date: _selectedDate!,
                                ),
                              );
                            });
                            Navigator.pop(context);
                          }
                        },
                        text: 'Add',
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        height: 64.h,
                        borderRadius: 12.0,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeasurementCard(BaselineMeasurement measurement) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${measurement.value} MPH',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${_getMonthName(measurement.date.month)} ${measurement.date.day}, ${measurement.date.year} • Baseline Test',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _baselineMeasurements.remove(measurement);
              });
            },
            child: Icon(
              Icons.delete_sharp,
              color: const Color.fromARGB(255, 219, 78, 78),
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}

class BaselineMeasurement {
  final String value;
  final DateTime date;

  BaselineMeasurement({
    required this.value,
    required this.date,
  });
}
