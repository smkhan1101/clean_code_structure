import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../imports.dart';
import '../../data/model/reward_model.dart';
import '../../domain/service/rewards_service.dart';

class RewardsController extends GetxController implements GetxService {
  final RewardsService rewardsService;

  RewardsController({required this.rewardsService});

  static RewardsController get find => Get.find<RewardsController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isProPlan = false;
  bool get isProPlan => _isProPlan;

  List<RewardModel> _rewardsList = [];
  List<RewardModel> get rewardsList => _rewardsList;

  @override
  void onInit() {
    super.onInit();
    loadRewards();
  }

  Future<void> loadRewards() async {
    _isLoading = true;
    update();

    try {
      final rewards = await rewardsService.getRewards();
      final userRewards = await rewardsService.getUserRewards();
      _rewardsList = rewards.map((reward) {
        return RewardModel(
          name: reward.name,
          title: reward.title,
          rule: reward.rule,
          image: reward.image,
          isAvailable: userRewards.contains(reward.name),
        );
      }).toList();
    } catch (e) {
      showToast('error_loading_rewards'.tr);
    }

    _isLoading = false;
    update();
  }

  void setIsProPlan(bool value) {
    _isProPlan = value;
    update();
  }

  Future<void> shareReward(RewardModel reward) async {
    try {
      final text = 'i_have_earned'.tr + ' ${reward.title} ' + 'rewards_ste'.tr + ' https://play.google.com/store/apps/details?id=com.rypstick.app';
      await Share.share(text);
    } catch (e) {
      showToast('error_sharing_reward'.tr);
    }
  }
}

