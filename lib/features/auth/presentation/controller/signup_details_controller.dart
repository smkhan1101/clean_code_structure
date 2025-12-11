import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/auth_controller.dart';

class SignupDetailsController extends GetxController {
  final authController = Get.find<AuthController>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final selectedDate = Rx<DateTime?>(null);
  final selectedGender = RxString('');
  final selectedHandedness = RxString('Right-handed');
  final selectedHandicap = RxString('10');
  final selectedShaftLength = RxString('');
  final selectedPreferredUnits = RxString('Yards, MPH');
  final hasTrainedBefore = RxBool(false);

  final List<String> genderList = ['None', 'Male', 'Female', 'Other'];
  final List<String> handList = ['Right-handed', 'Left-handed'];
  final List<String> handicapList = List.generate(36, (i) => i.toString());
  final List<String> shaftLengthList = ['None', 'Standard', 'Long', 'Short'];
  final List<String> preferredUnitsList = ['Yards, MPH', 'Meters, KPH'];

  final Map<String, String> preferredUnitsMap = {
    'Yards, MPH': 'Yards/MPH',
    'Meters, KPH': 'Meters/KPH',
  };

  @override
  void onInit() {
    super.onInit();
    selectedDate.value = DateTime.now();
    firstNameController.addListener(_validateForm);
    lastNameController.addListener(_validateForm);
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }

  final isFormValid = RxBool(false);

  void _validateForm() {
    isFormValid.value = firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        selectedGender.value.isNotEmpty &&
        selectedHandedness.value.isNotEmpty &&
        selectedHandicap.value.isNotEmpty &&
        selectedShaftLength.value.isNotEmpty &&
        selectedPreferredUnits.value.isNotEmpty;
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      _validateForm();
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy').format(date);
  }

  void showDropdownMenu({
    required BuildContext context,
    required String title,
    required List<String> options,
    required Function(String) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final isHandicap = title == 'Handicap';
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    title: Center(
                      child: Text(
                        options[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isHandicap ? 20.sp : 16.sp,
                          fontWeight: isHandicap ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                    onTap: () {
                      onSelected(options[index]);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleGenderSelected(String value) {
    selectedGender.value = value == 'None' ? '' : value;
    _validateForm();
  }

  void handleHandednessSelected(String value) {
    selectedHandedness.value = value;
    _validateForm();
  }

  void handleHandicapSelected(String value) {
    selectedHandicap.value = value;
    _validateForm();
  }

  void handleShaftLengthSelected(String value) {
    selectedShaftLength.value = value == 'None' ? '' : value;
    _validateForm();
  }

  void handlePreferredUnitsSelected(String value) {
    selectedPreferredUnits.value = value;
    _validateForm();
  }

  void toggleHasTrainedBefore(bool? value) {
    hasTrainedBefore.value = value ?? false;
  }

  void handleConfirm() {
    if (!isFormValid.value) return;

    final preferredUnitValue = preferredUnitsMap[selectedPreferredUnits.value] ?? 'Yards/MPH';

    authController.setSignupDetails(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      dateOfBirth: selectedDate.value!,
      gender: selectedGender.value.isEmpty ? 'None' : selectedGender.value,
      handType: selectedHandedness.value,
      handicap: selectedHandicap.value,
      shaftLength: selectedShaftLength.value.isEmpty ? 'None' : selectedShaftLength.value,
      preferredUnit: preferredUnitValue,
      isTrainedBefore: hasTrainedBefore.value,
    );

    if (hasTrainedBefore.value) {
      Get.toNamed('/trained-before');
    } else {
      Get.toNamed('/notification-permission');
    }
  }
}

