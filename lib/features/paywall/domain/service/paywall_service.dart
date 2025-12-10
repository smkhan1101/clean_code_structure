abstract class PaywallService {
  Future<List<Map<String, dynamic>>> getSubscriptionPlans();
  Future<void> purchaseSubscription(String productId);
  Future<bool> restorePurchases();
  Future<bool> isProActive();
}

