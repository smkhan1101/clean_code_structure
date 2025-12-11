import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/core/helper/navigation.dart';
import 'package:startup_repo/imports.dart';
import '../controller/auth_controller.dart';
import '../../../../core/widgets/confirmation_dialog.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final emailController = TextEditingController();

    return GetBuilder<AuthController>(
      builder: (authController) {
        if (authController.showError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showConfirmationDialog(
              title: authController.errorTitle,
              subtitle: authController.errorMessage,
              actionText: 'ok'.tr,
              onAccept: () {
                controller.dismissDialog();
                if (authController.isSuccess) {
                  Get.back();
                }
              },
            );
          });
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
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
                                'reset_password'.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'We will send you an email with instructions to reset the password. Please enter the email address you use to sign into the app.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: 28.h),
                              TextField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(color: Colors.white, fontSize: 16.sp),
                                onChanged: (value) => controller.setResetEmail(value),
                                decoration: InputDecoration(
                                  hintText: 'email'.tr,
                                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16.sp),
                                  filled: true,
                                  fillColor: Colors.grey[900],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide(color: Colors.grey[700]!, width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide(color: Colors.grey[700]!, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide(color: Colors.grey[600]!, width: 1),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                                ),
                              ),
                              SizedBox(height: 24.h),
                              GetBuilder<AuthController>(
                                builder: (authCtrl) {
                                  final isValid = authCtrl.resetEmail.isNotEmpty &&
                                      authCtrl.isValidEmail(authCtrl.resetEmail);
                                  return AbsorbPointer(
                                    absorbing: !isValid,
                                    child: Opacity(
                                      opacity: isValid ? 1.0 : 0.5,
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
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () => controller.sendResetPasswordLink(),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            elevation: 0,
                                            foregroundColor: Colors.white,
                                            padding: EdgeInsets.symmetric(vertical: 18.h),
                                            minimumSize: Size(double.infinity, 50.h),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.r),
                                            ),
                                          ),
                                          child: Text(
                                            'send_reset_link'.tr,
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
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
                  padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                  child: Center(
                    child: Text(
                      'copy_rights'.tr,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
