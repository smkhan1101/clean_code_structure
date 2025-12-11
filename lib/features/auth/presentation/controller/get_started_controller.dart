import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class GetStartedController extends GetxController {
  Future<void> handleGetStarted() async {
    Get.toNamed('/signup-details');
  }

  Future<void> handleAlreadyHaveAccount() async {
    Get.toNamed('/login');
  }

  Future<void> handlePrivacyPolicy() async {
    final uri = Uri.parse('https://rypstick.com/pages/privacy-policy');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> handleTermsOfService() async {
    final uri = Uri.parse('https://rypstick.com/pages/terms-of-service');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

