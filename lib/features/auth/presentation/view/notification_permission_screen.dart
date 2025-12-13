import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/core/widgets/sign_in_button.dart';
import 'package:startup_repo/imports.dart';
import '../controller/auth_controller.dart';

class NotificationPermissionScreen extends StatelessWidget {
  const NotificationPermissionScreen({super.key});

  Future<void> _requestNotificationPermission() async {
    final controller = Get.find<AuthController>();
    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      controller.setNotificationPermission(settings.authorizationStatus == AuthorizationStatus.authorized);
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        final token = await messaging.getToken();
        if (token != null) {
          // Token will be saved when user details are saved
        }
      }
    } catch (e) {
      controller.setNotificationPermission(false);
    }
    Get.toNamed('/signup');
  }

  void _onSkip() {
    final controller = Get.find<AuthController>();
    controller.setNotificationPermission(false);
    Get.toNamed('/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 25.h),
                      Text(
                        'allow_notifications'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Text(
                        'notifications_desc'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                children: [
                  SignInButton(
                    onPressed: _requestNotificationPermission,
                    text: 'allow'.tr,
                    isValid: true,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    height: 65.h,
                  ),
                  SizedBox(height: 25.h),
                  Center(
                    child: GestureDetector(
                      onTap: _onSkip,
                      child: Text(
                        'skip'.tr,
                        style: TextStyle(
                          color: Color(0xFF777576),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
