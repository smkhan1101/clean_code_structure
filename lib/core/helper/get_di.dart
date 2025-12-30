import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:startup_repo/features/theme/domain/binding/theme_binding.dart';
import 'package:startup_repo/core/utils/app_constants.dart';
import '../../features/language/domain/binding/language_binding.dart';
import '../../features/splash/domain/binding/splash_binding.dart';
import '../../features/auth/domain/binding/auth_binding.dart';
import '../../features/home/domain/binding/home_binding.dart';
import '../../features/feed/domain/binding/feed_binding.dart';
import '../../features/training/domain/binding/training_binding.dart';
import '../../features/rewards/domain/binding/rewards_binding.dart';
import '../../features/settings/domain/binding/settings_binding.dart';
import '../../features/paywall/domain/binding/paywall_binding.dart';
import '../../features/tutorials/domain/binding/tutorials_binding.dart';
import '../api/api_client_impl.dart';
import '../api/api_client.dart';
import '../../features/language/data/model/language.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  ApiClient apiClient = ApiClientImpl(prefs: Get.find(), baseUrl: AppConstants.baseUrl);
  Get.lazyPut(() => apiClient);

  List<Bindings> bindings = [
    ThemeBinding(),
    LanguageBinding(),
    SplashBinding(),
    AuthBinding(),
    HomeBinding(),
    FeedBinding(),
    TrainingBinding(),
    RewardsBinding(),
    SettingsBinding(),
    PaywallBinding(),
    TutorialsBinding(),
  ];

  for (Bindings binding in bindings) {
    binding.dependencies();
  }

  // Retrieving localized data
  return await _loadLanguages();
}

Future<Map<String, Map<String, String>>> _loadLanguages() async {
  Map<String, Map<String, String>> languages = {};

  //
  for (LanguageModel languageModel in appLanguages) {
    String jsonStringValues =
        await rootBundle.loadString('assets/languages/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
    Map<String, String> json = {};
    mappedJson.forEach((key, value) {
      json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = json;
  }
  return languages;
}
