import 'package:url_launcher/url_launcher.dart';
import 'package:startup_repo/imports.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              Images.splashImg,
              fit: BoxFit.fitWidth,
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
              child: Padding(
                padding: EdgeInsets.all(25.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 18.sp),
                    Text(
                      'splash_heading'.tr,
                      style: context.font26.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.surface,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 30.sp),
                    PrimaryButton(
                      text: 'get_started'.tr,
                      onPressed: () {
                        Get.toNamed('/signup-details');
                      },
                    ),
                    SizedBox(height: 15.sp),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/login');
                      },
                      child: Text(
                        'already_account'.tr,
                        style: context.font12.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 40.sp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _openUrl('https://rypstick.com/pages/privacy-policy'),
                          child: Text(
                            'privacy_policy'.tr,
                            style: context.font10.copyWith(
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                        Container(
                          width: 2.sp,
                          height: 2.sp,
                          margin: EdgeInsets.symmetric(horizontal: 4.sp),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSecondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _openUrl('https://rypstick.com/pages/terms-of-service'),
                          child: Text(
                            'terms_of_service'.tr,
                            style: context.font10.copyWith(
                              color: Colors.white.withOpacity(0.7),
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
        ],
      ),
    );
  }
}

