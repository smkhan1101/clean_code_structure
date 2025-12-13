import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/core/helper/navigation.dart';
import 'package:startup_repo/imports.dart';
import '../controller/auth_controller.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/sign_in_button.dart';

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
                bottom: MediaQuery.of(context).size.height * 0.45,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        Images.closeupImg,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 40.h,
                        left: 10,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 30.sp),
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
                              offset: Offset(0, -30.h),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 3.h),
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
                                fillColor: Color(0xFF191919),
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
                                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
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
                                  fillColor: Color(0xFF191919),
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
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      obscurePassword.value
                                          ? Icons.visibility_off_outlined
                                          : Icons.remove_red_eye_outlined,
                                      color: Colors.grey[400],
                                      size: 22.sp,
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
                                return SignInButton(
                                  onPressed: () {
                                    if (widget.isLogin) {
                                      controller.login();
                                    } else {
                                      controller.register();
                                    }
                                  },
                                  text: widget.isLogin ? 'sign_in'.tr : 'sign_up'.tr,
                                  isValid: isValid,
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
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w900,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 32.h),
                            Text(
                              'copy_rights'.tr,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 11.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 0.h),
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
