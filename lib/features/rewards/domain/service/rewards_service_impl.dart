import '../../data/model/reward_model.dart';
import '../../data/repository/rewards_repo_interface.dart';
import 'rewards_service.dart';

class RewardsServiceImpl implements RewardsService {
  final RewardsRepo rewardsRepo;

  RewardsServiceImpl({required this.rewardsRepo});

  @override
  Future<List<RewardModel>> getRewards() async {
    return await rewardsRepo.getRewards();
  }

  @override
  Future<List<String>> getUserRewards() async {
    return await rewardsRepo.getUserRewards();
  }
}

