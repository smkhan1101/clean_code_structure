import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/core/helper/navigation.dart';
import 'package:startup_repo/imports.dart';
import '../controller/auth_controller.dart';
import '../../../../core/widgets/confirmation_dialog.dart';

class LoginScreen extends StatefulWidget {
  final bool isLogin;
  const LoginScreen({this.isLogin = true, super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final obscurePassword = true.obs;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  bool _hasShownError = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void _handleError(AuthController controller) {
    if (controller.showError && !_hasShownError) {
      _hasShownError = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showConfirmationDialog(
          title: controller.errorTitle,
          subtitle: controller.errorMessage,
          actionText: 'ok'.tr,
          onAccept: () {
            controller.dismissDialog();
            _hasShownError = false;
          },
        );
      });
    } else if (!controller.showError) {
      _hasShownError = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return GetBuilder<AuthController>(
      builder: (authController) {
        _handleError(authController);

        if (authController.isLoading) {
          showLoading();
        } else {
          hideLoading();
        }

        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: MediaQuery.of(context).size.height * 0.35,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        Images.closeupImg,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 40.h,
                        left: 0,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24.sp),
                          onPressed: () {
                            pop();
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Transform.translate(
                              offset: Offset(0, -20.h),
                              child: Text(
                                widget.isLogin ? 'welcome_back'.tr : 'welcome_to_rypstick'.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(color: Colors.white, fontSize: 16.sp),
                              onChanged: (value) => controller.setEmail(value),
                              decoration: InputDecoration(
                                hintText: 'email'.tr,
                                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16.sp),
                                filled: true,
                                fillColor: Colors.grey[900],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide(color: Colors.grey[700]!, width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide(color: Colors.grey[700]!, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide(color: Colors.grey[600]!, width: 1),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Obx(
                              () => TextField(
                                controller: passwordController,
                                obscureText: obscurePassword.value,
                                textInputAction: TextInputAction.done,
                                style: TextStyle(color: Colors.white, fontSize: 16.sp),
                                onChanged: (value) => controller.setPassword(value),
                                onSubmitted: (_) {
                                  if (controller.email.isNotEmpty && controller.password.isNotEmpty) {
                                    if (widget.isLogin) {
                                      controller.login();
                                    } else {
                                      controller.register();
                                    }
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'password'.tr,
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
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      obscurePassword.value
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: Colors.grey[400],
                                      size: 20.sp,
                                    ),
                                    onPressed: togglePasswordVisibility,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24.h),
                            GetBuilder<AuthController>(
                              builder: (authController) {
                                final isValid =
                                    authController.email.isNotEmpty && authController.password.isNotEmpty;
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
                                        onPressed: () {
                                          if (widget.isLogin) {
                                            controller.login();
                                          } else {
                                            controller.register();
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          elevation: 0,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(vertical: 18.h),
                                          minimumSize: Size(double.infinity, 50.h),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.r),
                                          ),
                                        ),
                                        child: Text(
                                          widget.isLogin ? 'sign_in'.tr : 'sign_up'.tr,
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
                            SizedBox(height: 8.h),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Get.toNamed('/reset-password');
                                },
                                child: Text(
                                  'forgot_password'.tr,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 14.sp,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    decorationThickness: 1,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h),
                            Text(
                              'copy_rights'.tr,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
