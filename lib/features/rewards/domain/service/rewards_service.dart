import '../../data/model/reward_model.dart';

abstract class RewardsService {
  Future<List<RewardModel>> getRewards();
  Future<List<String>> getUserRewards();
}

