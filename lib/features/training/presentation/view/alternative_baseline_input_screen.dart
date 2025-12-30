import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../imports.dart';
import '../controller/alternative_baseline_input_controller.dart';
import '../../../../core/widgets/sign_in_button.dart';
import '../../../home/presentation/controller/home_controller.dart';

class AlternativeBaselineInputScreen extends StatelessWidget {
  const AlternativeBaselineInputScreen({super.key});

  static void show() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xFF1E1E1E),
      builder: (context) => const AlternativeBaselineInputScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlternativeBaselineInputController>(
      init: Get.find<AlternativeBaselineInputController>(),
      builder: (controller) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF191919),
                Color(0xFF252525),
              ],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          ),
          child: Column(
            children: [
              _buildHeader(context),
              if (controller.isLoading)
                _buildProgressView()
              else if (controller.resultPresented)
                _buildResultView(controller, context)
              else
                Expanded(
                  child: Column(
                    children: [
                      _buildInfoArea(),
                      const Spacer(),
                      _buildInputArea(controller),
                      const Spacer(),
                      _buildConfirmButton(controller),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.sp),
      child: Stack(
        children: [
          Center(
            child: Text(
              'Your driver distance',
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
                width: 30.w,
                height: 30.w,
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
    );
  }

  Widget _buildProgressView() {
    return const Expanded(
      child: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF4CAF50),
        ),
      ),
    );
  }

  Widget _buildInfoArea() {
    return Padding(
      padding: EdgeInsets.all(20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Let us know how far you usually hit your driver, and we will approximate your baseline speed.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              height: 1.3,
            ),
          ),
          SizedBox(height: 15.h),
          Text(
            'Note: We won\'t be able to track your swing speed without a radar. If you choose to get one going forward, you can change this selection in Preferences.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(AlternativeBaselineInputController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 120.w,
            child: TextField(
              controller: controller.inputController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 60.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 60.sp,
                ),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                controller.updateInput(value);
              },
            ),
          ),
          SizedBox(width: 10.w),
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Text(
              controller.distanceUnit,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(AlternativeBaselineInputController controller) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Opacity(
        opacity: controller.approximateBaseline != null ? 1.0 : 0.35,
        child: SignInButton(
          onPressed: () {
            if (controller.approximateBaseline != null) {
              controller.submitBaseline();
            }
          },
          text: 'Confirm',
          isValid: controller.approximateBaseline != null,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          height: 65.h,
        ),
      ),
    );
  }

  Widget _buildResultView(AlternativeBaselineInputController controller, BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              'Your estimated baseline:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              '${controller.approximateBaseline?.toInt() ?? 0} ${controller.speedUnit}',
              style: TextStyle(
                fontSize: 60.sp,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: [
                      Color(0xFF237537),
                      Color(0xFF33C258),
                    ],
                  ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'You can now begin training.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.sp,
              ),
            ),
            const Spacer(),
            SignInButton(
              onPressed: () {
                if (controller.submittedBaseline) {
                  Navigator.pop(context);
                  Get.find<HomeController>().refreshData();
                }
              },
              text: 'Done',
              isValid: controller.submittedBaseline,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              height: 65.h,
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

