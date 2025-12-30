import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../imports.dart';
import '../controller/swing_sheet_controller.dart';

class SwingSheetScreen extends StatelessWidget {
  final bool requiresInput;
  final Function(int?) onComplete;

  const SwingSheetScreen({
    super.key,
    required this.requiresInput,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SwingSheetController>(
      init: Get.find<SwingSheetController>(),
      builder: (controller) {
        // Listen to sequenceFinished and call onComplete
        if (controller.sequenceFinished) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!controller.hasCalledComplete) {
              controller.markCompleteCalled();
              if (controller.requiresInput) {
                final speed = controller.validatedInput;
                onComplete(speed);
              } else {
                onComplete(null);
              }
            }
          });
        }

        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF237537),
                Color(0xFF33C258),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  controller.countDownString,
                  style: TextStyle(
                    fontSize: 80.sp,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 30.h),
                if (controller.requiresInput && controller.presentInputField)
                  _buildInputArea(controller),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputArea(SwingSheetController controller) {
    return Column(
      children: [
        Row(
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
                    color: Colors.white.withOpacity(0.5),
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
                controller.speedUnit,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        GestureDetector(
          onTap: controller.confirmActionAllowed
              ? () {
                  controller.confirm();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final speed = controller.validatedInput;
                    onComplete(speed);
                  });
                }
              : null,
          child: Text(
            'Confirm',
            style: TextStyle(
              fontSize: 16.sp,
              decoration: TextDecoration.underline,
              color: controller.confirmActionAllowed
                  ? Colors.white
                  : Colors.white.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}

