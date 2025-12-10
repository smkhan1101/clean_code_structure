import 'package:intl/intl.dart';
import 'package:startup_repo/imports.dart';
import '../controller/auth_controller.dart';

class SignupDetailsScreen extends StatefulWidget {
  const SignupDetailsScreen({super.key});

  @override
  State<SignupDetailsScreen> createState() => _SignupDetailsScreenState();
}

class _SignupDetailsScreenState extends State<SignupDetailsScreen> {
  final controller = Get.find<AuthController>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  DateTime? selectedDate;
  String selectedGender = 'None';
  String selectedHandType = 'Right-handed';
  String selectedHandicap = '10';
  String selectedShaftLength = 'None';
  String selectedPreferredUnit = 'Yards, MPH';
  bool isTrainedBefore = false;

  final List<String> genderList = ['None', 'Male', 'Female', 'Other', 'Prefer not to answer'];
  final List<String> handList = ['Left-handed', 'Right-handed'];
  final List<String> handicapList = [
    '+10', '+9', '+8', '+7', '+6', '+5', '+4', '+3', '+2', '+1', '0',
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15',
    '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30',
    '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', 'Beginner'
  ];
  final List<String> shaftLengthList = ['None', 'White 45"', 'Blue 44"', 'Green 41"', 'Orange 38"'];
  final List<String> measuredUnits = ['Yards, MPH', 'Meters, KM/H', 'Yards, M/S', 'Meters, MPH'];
  final List<String> valueUnits = ['Yards/MPH', 'Meters/KPH', 'Yards/MPS', 'Meters/MPH'];

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  bool _isFormValid() {
    return firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        selectedGender.toLowerCase() != 'none' &&
        selectedHandType.isNotEmpty &&
        selectedHandicap.isNotEmpty &&
        selectedShaftLength.toLowerCase() != 'none' &&
        selectedPreferredUnit.isNotEmpty;
  }

  void _onConfirm() {
    if (!_isFormValid()) return;

    final preferredUnitValue = valueUnits[measuredUnits.indexOf(selectedPreferredUnit)];
    
    controller.setSignupDetails(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      dateOfBirth: selectedDate!,
      gender: selectedGender,
      handType: selectedHandType,
      handicap: selectedHandicap,
      shaftLength: selectedShaftLength,
      preferredUnit: preferredUnitValue,
      isTrainedBefore: isTrainedBefore,
    );

    if (isTrainedBefore) {
      Get.toNamed('/trained-before');
    } else {
      Get.toNamed('/notification-permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(25.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  IconButton(
                    icon: Icon(
                      Iconsax.arrow_left,
                      color: Theme.of(context).colorScheme.surface,
                      size: 25.sp,
                    ),
                    onPressed: () => Get.back(),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.zero,
                  ),
                  SizedBox(height: 15.sp),
                  Text(
                    'tell_us_about'.tr,
                    style: context.font26.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  SizedBox(height: 10.sp),
                  Text(
                    'this_will_help'.tr,
                    style: context.font15.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  SizedBox(height: 30.sp),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: firstNameController,
                          hintText: 'first_name'.tr,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      SizedBox(width: 16.sp),
                      Expanded(
                        child: CustomTextField(
                          controller: lastNameController,
                          hintText: 'last_name'.tr,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.sp),
                  GestureDetector(
                    onTap: _selectDate,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 12.sp),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'dob'.tr,
                            style: context.font15.copyWith(
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 8.sp),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
                              borderRadius: BorderRadius.circular(8.sp),
                            ),
                            child: Text(
                              DateFormat('MMM dd, yyyy').format(selectedDate!),
                              style: context.font14.copyWith(
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.sp),
                  _buildDropdown(
                    label: 'gender'.tr,
                    value: selectedGender,
                    items: genderList,
                    onChanged: (value) => setState(() => selectedGender = value!),
                  ),
                  Divider(height: 1, color: Theme.of(context).colorScheme.onSecondary),
                  SizedBox(height: 16.sp),
                  _buildDropdown(
                    label: 'i_m'.tr,
                    value: selectedHandType,
                    items: handList,
                    onChanged: (value) => setState(() => selectedHandType = value!),
                  ),
                  SizedBox(height: 16.sp),
                  _buildDropdown(
                    label: 'handicap'.tr,
                    value: selectedHandicap,
                    items: handicapList,
                    onChanged: (value) => setState(() => selectedHandicap = value!),
                  ),
                  SizedBox(height: 16.sp),
                  _buildDropdown(
                    label: 'shaft_length'.tr,
                    value: selectedShaftLength,
                    items: shaftLengthList,
                    onChanged: (value) => setState(() => selectedShaftLength = value!),
                  ),
                  Divider(height: 1, color: Theme.of(context).colorScheme.onSecondary),
                  SizedBox(height: 16.sp),
                  _buildDropdown(
                    label: 'preferred_units'.tr,
                    value: selectedPreferredUnit,
                    items: measuredUnits,
                    onChanged: (value) => setState(() => selectedPreferredUnit = value!),
                  ),
                  SizedBox(height: 16.sp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'i_hve_trained_before'.tr,
                          style: context.font15.copyWith(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                      Checkbox(
                        value: isTrainedBefore,
                        onChanged: (value) => setState(() => isTrainedBefore = value ?? false),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.all(25.sp),
              child: PrimaryButton(
                text: isTrainedBefore ? 'continue_title'.tr : 'confirm'.tr,
                onPressed: _isFormValid() ? _onConfirm : null,
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
                  color: item.toLowerCase() == 'none'
                      ? Theme.of(context).colorScheme.onSecondary
                      : Theme.of(context).colorScheme.surface,
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

