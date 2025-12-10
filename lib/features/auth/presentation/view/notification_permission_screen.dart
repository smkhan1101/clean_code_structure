import 'package:firebase_messaging/firebase_messaging.dart';
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
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(25.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 25.sp),
                    Text(
                      'allow_notifications'.tr,
                      style: context.font26.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    SizedBox(height: 25.sp),
                    Text(
                      'notifications_desc'.tr,
                      style: context.font15.copyWith(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(25.sp),
              child: Column(
                children: [
                  PrimaryButton(
                    text: 'allow'.tr,
                    onPressed: _requestNotificationPermission,
                  ),
                  SizedBox(height: 6.sp),
                  GestureDetector(
                    onTap: _onSkip,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 17.sp),
                      child: Text(
                        'skip'.tr,
                        style: context.font18.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

