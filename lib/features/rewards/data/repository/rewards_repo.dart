import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/reward_model.dart';
import 'rewards_repo_interface.dart';

class RewardsRepoImpl implements RewardsRepo {
  RewardsRepoImpl();

  @override
  Future<List<RewardModel>> getRewards() async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('rewards')
          .get();
      
      return query.docs.map((doc) {
        final data = doc.data();
        return RewardModel.fromJson(data);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<String>> getUserRewards() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return [];
      
      final query = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('rewards')
          .get();
      
      return query.docs.map((doc) => doc.id).toList();
    } catch (e) {
      return [];
    }
  }
}

