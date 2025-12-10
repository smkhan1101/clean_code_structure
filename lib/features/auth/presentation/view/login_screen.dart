import 'package:startup_repo/imports.dart';
import '../controller/auth_controller.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/loading.dart';

class LoginScreen extends StatelessWidget {
  final bool isLogin;
  const LoginScreen({this.isLogin = true, super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

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
              },
            );
          });
        }

        if (authController.isLoading) {
          showLoading();
        } else {
          hideLoading();
        }

        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  Images.closeupImg,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.sp),
                      topRight: Radius.circular(20.sp),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(25.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 18.sp),
                        Text(
                          isLogin ? 'welcome_back'.tr : 'welcome_to_rypstick'.tr,
                          style: context.font26.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30.sp),
                        CustomTextField(
                          controller: emailController,
                          hintText: 'email'.tr,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Iconsax.sms,
                          onChanged: (value) => controller.setEmail(value),
                        ),
                        SizedBox(height: 16.sp),
                        CustomTextField(
                          controller: passwordController,
                          hintText: 'password'.tr,
                          obscureText: true,
                          prefixIcon: Iconsax.lock,
                          onChanged: (value) => controller.setPassword(value),
                        ),
                        SizedBox(height: 24.sp),
                        PrimaryButton(
                          text: isLogin ? 'sign_in'.tr : 'sign_up'.tr,
                          onPressed: () {
                            if (isLogin) {
                              controller.login();
                            } else {
                              controller.register();
                            }
                          },
                        ),
                        SizedBox(height: 16.sp),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/reset-password');
                          },
                          child: Text(
                            'forgot_password'.tr,
                            style: context.font12.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 40.sp),
                        Text(
                          'copy_rights'.tr,
                          style: context.font10.copyWith(
                            color: Colors.white.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40.sp,
                left: 25.sp,
                child: IconButton(
                  icon: Icon(
                    Iconsax.arrow_left,
                    color: Theme.of(context).colorScheme.surface,
                    size: 25.sp,
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

