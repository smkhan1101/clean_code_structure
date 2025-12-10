import '../../data/repository/paywall_repo_interface.dart';
import 'paywall_service.dart';

class PaywallServiceImpl implements PaywallService {
  final PaywallRepo paywallRepo;

  PaywallServiceImpl({required this.paywallRepo});

  @override
  Future<List<Map<String, dynamic>>> getSubscriptionPlans() async {
    return await paywallRepo.getSubscriptionPlans();
  }

  @override
  Future<void> purchaseSubscription(String productId) async {
    await paywallRepo.purchaseSubscription(productId);
  }

  @override
  Future<bool> restorePurchases() async {
    return await paywallRepo.restorePurchases();
  }

  @override
  Future<bool> isProActive() async {
    return await paywallRepo.isProActive();
  }
}

