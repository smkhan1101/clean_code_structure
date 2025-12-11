import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/core/helper/navigation.dart';
import 'package:startup_repo/features/auth/presentation/controller/signup_details_controller.dart';
import 'package:startup_repo/imports.dart';

class SignupDetailsScreen extends StatelessWidget {
  const SignupDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupDetailsController());
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24.sp),
                    onPressed: () {
                      pop();
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tell us more about yourself.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'This will help us generate a training program that is just right for you. All of your data is stored securely, and we never share it.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    _buildFormField(
                      label: 'First name',
                      child: TextField(
                        controller: controller.firstNameController,
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        decoration: InputDecoration(
                          hintText: 'First name',
                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16.sp),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          filled: false,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _buildFormField(
                      label: 'Last name',
                      child: TextField(
                        controller: controller.lastNameController,
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        decoration: InputDecoration(
                          hintText: 'Last name',
                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16.sp),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          filled: false,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _buildFormField(
                      label: 'Date of birth',
                      child: Obx(
                        () => GestureDetector(
                          onTap: () => controller.selectDate(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
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
                          onTap: () => controller.showDropdownMenu(
                            context: context,
                            title: 'Gender',
                            options: ['None', 'Male', 'Female', 'Other'],
                            onSelected: controller.handleGenderSelected,
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
                                      ? Colors.grey[400]
                                      : Colors.white,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 16.sp),
                                  SizedBox(height: 2.h),
                                  Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16.sp),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey[700], height: 32.h),
                    _buildFormField(
                      label: 'I\'m...',
                      child: Obx(
                        () => GestureDetector(
                          onTap: () => controller.showDropdownMenu(
                            context: context,
                            title: 'I\'m...',
                            options: ['Right-handed', 'Left-handed'],
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
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 16.sp),
                                  SizedBox(height: 2.h),
                                  Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16.sp),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey[700], height: 32.h),
                    _buildFormField(
                      label: 'Handicap',
                      child: Obx(
                        () => GestureDetector(
                          onTap: () => controller.showDropdownMenu(
                            context: context,
                            title: 'Handicap',
                            options: List.generate(36, (i) => (i).toString()),
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
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 16.sp),
                                  SizedBox(height: 2.h),
                                  Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16.sp),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey[700], height: 32.h),
                    _buildFormField(
                      label: 'Shaft length',
                      child: Obx(
                        () => GestureDetector(
                          onTap: () => controller.showDropdownMenu(
                            context: context,
                            title: 'Shaft length',
                            options: ['None', 'Standard', 'Long', 'Short'],
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
                                      ? Colors.grey[400]
                                      : Colors.white,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 16.sp),
                                  SizedBox(height: 2.h),
                                  Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16.sp),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey[700], height: 32.h),
                    _buildFormField(
                      label: 'Preferred units',
                      child: Obx(
                        () => GestureDetector(
                          onTap: () => controller.showDropdownMenu(
                            context: context,
                            title: 'Preferred units',
                            options: ['Yards, MPH', 'Meters, KPH'],
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
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 16.sp),
                                  SizedBox(height: 2.h),
                                  Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16.sp),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Obx(
                      () => Row(
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
                            side: BorderSide(color: Colors.grey[600]!),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Obx(
                      () => AbsorbPointer(
                        absorbing: !controller.isFormValid.value,
                        child: Opacity(
                          opacity: controller.isFormValid.value ? 1.0 : 0.5,
                          child: Container(
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
                              onPressed: controller.handleConfirm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                elevation: 0,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                'Confirm',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
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
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
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
}
