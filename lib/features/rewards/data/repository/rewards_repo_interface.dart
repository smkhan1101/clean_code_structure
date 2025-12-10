import '../model/reward_model.dart';

abstract class RewardsRepo {
  Future<List<RewardModel>> getRewards();
  Future<List<String>> getUserRewards();
}

