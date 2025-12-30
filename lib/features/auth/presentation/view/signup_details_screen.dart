import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/core/helper/navigation.dart';
import 'package:startup_repo/core/theme/app_theme.dart';
import 'package:startup_repo/core/widgets/sign_in_button.dart';
import 'package:startup_repo/features/auth/presentation/controller/signup_details_controller.dart';
import 'package:startup_repo/imports.dart';

import '../../../../core/widgets/description.dart';
import '../../../../core/widgets/gap.dart';
import '../../../../core/widgets/header_text.dart';

class SignupDetailsScreen extends StatelessWidget {
  const SignupDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupDetailsController());
    return Scaffold(
      backgroundColor: AppThemeColors.appBgColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padding(
                    //   padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 0, bottom: 20),
                    //   child: Align(
                    //     alignment: Alignment.topLeft,
                    //     child: IconButton(
                    //       icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 28.sp),
                    //       onPressed: () {
                    //         pop();
                    //       },
                    //       padding: EdgeInsets.zero,
                    //       constraints: const BoxConstraints(),
                    //     ),
                    //   ),
                    // ),
                    gap(40.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          headerText('Tell us more about'),
                          headerText('yourself.'),
                          SizedBox(height: 24.h),

                          description('This will help us generate a training program that is just right for you. All of your data is stored securely, and we never share it.'),
                          SizedBox(height: 24.h),
                          _buildFormField(
                            label: 'First name',
                            child: SizedBox(
                              height: 32.h,
                              child: TextField(
                                controller: controller.firstNameController,
                                textAlign: TextAlign.right,
                                cursorColor: const Color(0xFF4CAF50),
                                style: TextStyle(color: Colors.white, fontSize: 16.sp),
                                decoration: InputDecoration(
                                  hintText: 'First name',
                                  hintStyle: TextStyle(
                                      color: Colors.grey[600], fontSize: 16.sp, fontWeight: FontWeight.w500),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  filled: false,
                                  isDense: true,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 0.h),
                          _buildFormField(
                            label: 'Last name',
                            child: TextField(
                              controller: controller.lastNameController,
                              textAlign: TextAlign.right,
                              cursorColor: const Color(0xFF4CAF50),
                              style: TextStyle(color: Colors.white, fontSize: 16.sp),
                              decoration: InputDecoration(
                                hintText: 'Last name',
                                hintStyle: TextStyle(
                                    color: Colors.grey[600], fontSize: 16.sp, fontWeight: FontWeight.w500),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                filled: false,
                              ),
                            ),
                          ),
                          _buildFormField(
                            label: 'Date of birth',
                            child: Obx(
                              () => GestureDetector(
                                onTap: () => controller.selectDate(context),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF262626),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(
                                    controller.selectedDate.value != null
                                        ? controller.formatDate(controller.selectedDate.value!)
                                        : '9 December 2025',
                                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                          _buildFormField(
                            label: 'Gender',
                            child: Obx(
                              () => GestureDetector(
                                onTap: () => _showGenderPopup(
                                  context: context,
                                  controller: controller,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      controller.selectedGender.value.isEmpty
                                          ? 'None'
                                          : controller.selectedGender.value,
                                      style: TextStyle(
                                        color: controller.selectedGender.value.isEmpty
                                            ? Colors.grey[600]
                                            : Colors.white,
                                        fontSize: 16.sp,
                                      ),
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
                                            color: controller.selectedGender.value.isEmpty
                                                ? Colors.grey[600]
                                                : Colors.white,
                                            size: 16.sp,
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(0, 4.h),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: controller.selectedGender.value.isEmpty
                                                ? Colors.grey[600]
                                                : Colors.white,
                                            size: 16.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 18.h),
                          Divider(color: Colors.grey[600], height: 32.h),
                          SizedBox(height: 2.h),
                          _buildFormField(
                            label: 'I\'m...',
                            child: Obx(
                              () => GestureDetector(
                                onTap: () => _showOptionsPopup(
                                  context: context,
                                  options: controller.handList,
                                  currentValue: controller.selectedHandedness.value,
                                  onSelected: controller.handleHandednessSelected,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      controller.selectedHandedness.value,
                                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
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
                                            color: controller.selectedHandedness.value.isEmpty
                                                ? Colors.grey[600]
                                                : Colors.white,
                                            size: 16.sp,
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(0, 4.h),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: controller.selectedHandedness.value.isEmpty
                                                ? Colors.grey[600]
                                                : Colors.white,
                                            size: 16.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 38.h),
                          _buildFormField(
                            label: 'Handicap',
                            child: Obx(
                              () => GestureDetector(
                                onTap: () => _showOptionsPopup(
                                  context: context,
                                  options: controller.handicapList,
                                  currentValue: controller.selectedHandicap.value,
                                  onSelected: controller.handleHandicapSelected,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      controller.selectedHandicap.value,
                                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
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
                                            color: controller.selectedHandicap.value.isEmpty
                                                ? Colors.grey[600]
                                                : Colors.white,
                                            size: 16.sp,
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(0, 4.h),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: controller.selectedHandicap.value.isEmpty
                                                ? Colors.grey[600]
                                                : Colors.white,
                                            size: 16.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 38.h),
                          _buildFormField(
                            label: 'Shaft length',
                            child: Obx(
                              () => GestureDetector(
                                onTap: () => _showOptionsPopup(
                                  context: context,
                                  options: controller.shaftLengthList,
                                  currentValue: controller.selectedShaftLength.value.isEmpty
                                      ? 'None'
                                      : controller.selectedShaftLength.value,
                                  onSelected: controller.handleShaftLengthSelected,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      controller.selectedShaftLength.value.isEmpty
                                          ? 'None'
                                          : controller.selectedShaftLength.value,
                                      style: TextStyle(
                                        color: controller.selectedShaftLength.value.isEmpty
                                            ? Colors.grey[600]
                                            : Colors.white,
                                        fontSize: 16.sp,
                                      ),
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
                                            color: controller.selectedShaftLength.value.isEmpty
                                                ? Colors.grey[600]
                                                : Colors.white,
                                            size: 16.sp,
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(0, 4.h),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: controller.selectedShaftLength.value.isEmpty
                                                ? Colors.grey[600]
                                                : Colors.white,
                                            size: 16.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Divider(color: Colors.grey[600], height: 32.h),
                          SizedBox(height: 2.h),
                          _buildFormField(
                            label: 'Preferred units',
                            child: Obx(
                              () => GestureDetector(
                                onTap: () => _showOptionsPopup(
                                  context: context,
                                  options: controller.preferredUnitsList,
                                  currentValue: controller.selectedPreferredUnits.value,
                                  onSelected: controller.handlePreferredUnitsSelected,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      controller.selectedPreferredUnits.value,
                                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
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
                                            color: controller.selectedPreferredUnits.value.isEmpty
                                                ? Colors.grey[600]
                                                : Colors.white,
                                            size: 16.sp,
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(0, 4.h),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: controller.selectedPreferredUnits.value.isEmpty
                                                ? Colors.grey[600]
                                                : Colors.white,
                                            size: 16.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 28.h),
                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'I have trained with Rypstick before',
                                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                                  ),
                                ),
                                Checkbox(
                                  value: controller.hasTrainedBefore.value,
                                  onChanged: controller.toggleHasTrainedBefore,
                                  activeColor: const Color(0xFF4CAF50),
                                  checkColor: Colors.white,
                                  side: BorderSide(color: Colors.white),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 25.w),
              child: Center(
                child: Obx(
                  () => SignInButton(
                    onPressed: controller.handleConfirm,
                    text: controller.hasTrainedBefore.value ? 'Continue' : 'Confirm',
                    isValid: controller.isFormValid.value,
                  ),
                ),
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
            style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w700),
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

  void _showGenderPopup({
    required BuildContext context,
    required SignupDetailsController controller,
  }) {
    final currentValue = controller.selectedGender.value;
    String displayValue = currentValue.isEmpty ? 'None' : currentValue;
    _showOptionsPopup(
      context: context,
      options: controller.genderList,
      currentValue: displayValue,
      onSelected: controller.handleGenderSelected,
    );
  }

  void _showOptionsPopup({
    required BuildContext context,
    required List<String> options,
    required String currentValue,
    required Function(String) onSelected,
  }) {
    final isHandicap = options.length > 20;
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
              width: isHandicap ? 120.w : 200.w,
              constraints: BoxConstraints(
                maxHeight: isHandicap ? 56.h * 14 : MediaQuery.of(context).size.height * 0.6,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (int index = 0; index < options.length; index++)
                    _buildPopupOption(
                      option: options[index],
                      isSelected: options[index] == currentValue,
                      isLast: index == options.length - 1,
                      isHandicap: isHandicap,
                      onTap: () {
                        onSelected(options[index]);
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPopupOption({
    required String option,
    required bool isSelected,
    required bool isLast,
    required bool isHandicap,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isHandicap ? 8.w : 16.w,
          vertical: isHandicap ? 16.h : 16.h,
        ),
        height: isHandicap ? 56.h : null,
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: Colors.grey[700]!,
                    width: 0.5,
                  ),
                ),
        ),
        child: isHandicap
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isSelected)
                    Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20.sp,
                    )
                  else
                    SizedBox(width: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    option,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  if (isSelected)
                    Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20.sp,
                    )
                  else
                    SizedBox(width: 20.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
