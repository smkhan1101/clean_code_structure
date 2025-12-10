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
                          'reset_password'.tr,
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
                          onChanged: (value) => controller.setResetEmail(value),
                        ),
                        SizedBox(height: 24.sp),
                        PrimaryButton(
                          text: 'send_reset_link'.tr,
                          onPressed: () => controller.sendResetPasswordLink(),
                        ),
                        SizedBox(height: 40.sp),
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

