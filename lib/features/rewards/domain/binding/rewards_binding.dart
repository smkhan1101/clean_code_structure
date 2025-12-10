import 'package:get/get.dart';
import '../../data/repository/rewards_repo.dart';
import '../../data/repository/rewards_repo_interface.dart';
import '../service/rewards_service.dart';
import '../service/rewards_service_impl.dart';
import '../../presentation/controller/rewards_controller.dart';

class RewardsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RewardsRepo>(() => RewardsRepoImpl());
    Get.lazyPut<RewardsService>(() => RewardsServiceImpl(rewardsRepo: Get.find<RewardsRepo>()));
    Get.lazyPut<RewardsController>(() => RewardsController(rewardsService: Get.find<RewardsService>()));
  }
}

