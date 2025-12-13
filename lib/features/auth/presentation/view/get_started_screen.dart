import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/features/auth/presentation/controller/get_started_controller.dart';
import 'package:startup_repo/core/widgets/getstarted_button.dart';
import 'package:startup_repo/imports.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GetStartedController());
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.30,
            child: Image.asset(
              'assets/images/login.jpeg',
              fit: BoxFit.cover,
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        child: Transform.translate(
                          offset: Offset(0, -20.h),
                          child: Padding(
                            padding: EdgeInsets.only(top: 0.h, bottom: 0.h),
                            child: Text(
                              'Get your swing up to speed with Rypstick.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GradientButton(
                              onPressed: controller.handleGetStarted,
                              text: 'Get started',
                            ),
                            SizedBox(height: 4.h),
                            TextButton(
                              onPressed: controller.handleAlreadyHaveAccount,
                              child: Text(
                                'I already have an account',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w900,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 34.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          TextButton(
                            onPressed: controller.handlePrivacyPolicy,
                            child: Text(
                              'Privacy policy',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 11.sp,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Text(
                            ' • ',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 11.sp,
                              letterSpacing: 0.5,
                            ),
                          ),
                          TextButton(
                            onPressed: controller.handleTermsOfService,
                            child: Text(
                              'Terms of service',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 11.sp,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
