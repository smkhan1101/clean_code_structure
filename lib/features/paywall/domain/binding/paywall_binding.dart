import 'package:get/get.dart';
import '../../data/repository/paywall_repo.dart';
import '../../data/repository/paywall_repo_interface.dart';
import '../service/paywall_service.dart';
import '../service/paywall_service_impl.dart';
import '../../presentation/controller/paywall_controller.dart';

class PaywallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaywallRepo>(() => PaywallRepoImpl());
    Get.lazyPut<PaywallService>(() => PaywallServiceImpl(paywallRepo: Get.find<PaywallRepo>()));
    Get.lazyPut<PaywallController>(() => PaywallController(paywallService: Get.find<PaywallService>()));
  }
}

