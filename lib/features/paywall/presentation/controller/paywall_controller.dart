import 'package:get/get.dart';
import '../../../../imports.dart';
import '../../domain/service/paywall_service.dart';

class PaywallController extends GetxController implements GetxService {
  final PaywallService paywallService;

  PaywallController({required this.paywallService});

  static PaywallController get find => Get.find<PaywallController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _plans = [];
  List<Map<String, dynamic>> get plans => _plans;

  @override
  void onInit() {
    super.onInit();
    loadPlans();
  }

  Future<void> loadPlans() async {
    _isLoading = true;
    update();

    try {
      _plans = await paywallService.getSubscriptionPlans();
    } catch (e) {
      showToast('error_loading_plans'.tr);
    }

    _isLoading = false;
    update();
  }

  Future<void> purchaseSubscription(String productId) async {
    try {
      showLoading();
      await paywallService.purchaseSubscription(productId);
      hideLoading();
      showToast('subscription_purchased'.tr);
      Get.back();
    } catch (e) {
      hideLoading();
      showToast('error_purchasing_subscription'.tr);
    }
  }

  Future<void> restorePurchases() async {
    try {
      showLoading();
      final restored = await paywallService.restorePurchases();
      hideLoading();
      if (restored) {
        showToast('purchases_restored'.tr);
        Get.back();
      } else {
        showToast('no_purchases_to_restore'.tr);
      }
    } catch (e) {
      hideLoading();
      showToast('error_restoring_purchases'.tr);
    }
  }
}

