// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:startup_repo/core/widgets/loading.dart';
import 'package:startup_repo/imports.dart';
import 'core/theme/design_helper.dart';
import 'features/theme/presentation/controller/theme_controller.dart';
import 'core/helper/get_di.dart' as di;
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'core/utils/messages.dart';
import 'core/utils/scroll_behavior.dart';
import 'features/home/presentation/view/home.dart';
import 'features/auth/presentation/view/get_started_screen.dart';
import 'features/auth/presentation/view/login_screen.dart';
import 'features/auth/presentation/view/reset_password_screen.dart';
import 'features/auth/presentation/view/signup_details_screen.dart';
import 'features/auth/presentation/view/trained_before_screen.dart';
import 'features/auth/presentation/view/notification_permission_screen.dart';
import 'features/auth/presentation/controller/auth_controller.dart';
import 'features/feed/presentation/view/feed_screen.dart';
import 'features/training/presentation/view/training_screen.dart';
import 'features/rewards/presentation/view/rewards_screen.dart';
import 'features/settings/presentation/view/settings_screen.dart';
import 'features/paywall/presentation/view/paywall_screen.dart';
import 'features/progress/presentation/view/progress_screen.dart';
import 'features/tutorials/presentation/view/tutorials_screen.dart';
import 'features/feed/presentation/view/feed_image_detail_screen.dart';
import 'features/feed/presentation/view/feed_video_detail_screen.dart';
import 'features/feed/presentation/view/post_feed_screen.dart';
import 'features/pro_content/presentation/view/pro_content_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Map<String, Map<String, String>> languages = await di.init();
  runApp(MyApp(languages: languages));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  const MyApp({required this.languages, super.key});

  @override
  Widget build(BuildContext context) {
    final designSize = DesignHelper.getDesignSize(context);
    final isTablet = MediaQuery.of(context).size.shortestSide > 600;
    final isLargeTablet = MediaQuery.of(context).size.shortestSide > 800;
    return GetBuilder<LocalizationController>(builder: (localizeController) {
      return ScreenUtilInit(
        designSize: designSize,
        minTextAdapt: true,
        splitScreenMode: true,
        fontSizeResolver: (size, util) => _screenSize(size, isTablet, isLargeTablet, util),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.2),
            ),
          ),
          child: GetBuilder<ThemeController>(builder: (themeController) {
            return GetMaterialApp(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,
              themeMode: themeController.themeMode,
              theme: light,
              darkTheme: dark,
              locale: localizeController.locale,
              translations: Messages(languages: languages),
              fallbackLocale: Locale(
                appLanguages.first.languageCode,
                appLanguages.first.countryCode,
              ),
              navigatorObservers: [FlutterSmartDialog.observer],
              builder: FlutterSmartDialog.init(
                loadingBuilder: (string) => const LoadingWidget(),
                builder: (context, child) {
                  return ScrollConfiguration(
                    behavior: CustomScrollBehavior(),
                    child: child ?? const SizedBox(),
                  );
                },
              ),
              getPages: [
                GetPage(name: '/get-started', page: () => const GetStartedScreen()),
                GetPage(name: '/login', page: () => const LoginScreen(isLogin: true)),
                GetPage(name: '/signup', page: () => const LoginScreen(isLogin: false)),
                GetPage(name: '/signup-details', page: () => const SignupDetailsScreen()),
                GetPage(name: '/trained-before', page: () => const TrainedBeforeScreen()),
                GetPage(name: '/notification-permission', page: () => const NotificationPermissionScreen()),
                GetPage(name: '/reset-password', page: () => const ResetPasswordScreen()),
                GetPage(name: '/home', page: () => const HomeScreen()),
                GetPage(name: '/feed', page: () => const FeedScreen()),
                GetPage(name: '/training', page: () => const TrainingScreen()),
                GetPage(name: '/measure-baseline', page: () => const TrainingScreen()),
                GetPage(name: '/rewards', page: () => const RewardsScreen()),
                GetPage(name: '/settings', page: () => const SettingsScreen()),
                GetPage(name: '/paywall', page: () => const PaywallScreen()),
                GetPage(name: '/progress', page: () => const ProgressScreen()),
                GetPage(name: '/tutorials', page: () => const TutorialsScreen()),
                GetPage(name: '/feed-image-detail', page: () => const FeedImageDetailScreen()),
                GetPage(name: '/feed-video-detail', page: () => const FeedVideoDetailScreen()),
                GetPage(name: '/post-feed', page: () => const PostFeedScreen()),
                GetPage(name: '/your-pro-content', page: () => const ProContentScreen()),
              ],
              initialRoute: _getInitialRoute(),
            );
          }),
        ),
      );
    });
  }

  double _screenSize(size, isTablet, isLargeTablet, util) {
    double scaleFactor = 1.0;
    if (isTablet || isLargeTablet) {
      scaleFactor = 1.0;
    } else {
      scaleFactor = util.scaleText;
    }
    return size * scaleFactor;
  }

  static String _getInitialRoute() {
    try {
      if (Get.isRegistered<AuthController>()) {
        final authController = Get.find<AuthController>();
        return authController.checkAccountSync() ? '/home' : '/get-started';
      }
    } catch (e) {
      debugPrint('Error getting initial route: $e');
    }
    return '/get-started';
  }
}
