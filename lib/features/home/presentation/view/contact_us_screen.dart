import 'package:startup_repo/imports.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/widgets/sign_in_button.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  static void show() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ContactUsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 0.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    'Contact us',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFF0D5920),
                              Color(0xFF21E054),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.sp,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(text: 'Have questions? Our support team is just a step away at '),
                      TextSpan(
                        text: 'rypstickstaff@gmail.com',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              SignInButton(
                onPressed: () async {
                  try {
                    final uri = Uri.parse('mailto:rypstickstaff@gmail.com');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                    Get.back();
                  } catch (e) {
                    showToast('error_opening_email'.tr);
                  }
                },
                text: 'Open Mail app',
                isValid: true,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                height: 65.h,
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
