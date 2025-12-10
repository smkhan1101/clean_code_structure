import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/exercise_data.dart';
import 'training_repo_interface.dart';

class TrainingRepoImpl implements TrainingRepo {
  TrainingRepoImpl();

  @override
  Future<List<ExerciseData>> getTrainingExercises(int level, int day) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('exercises')
          .where('level', isEqualTo: level)
          .where('day', isEqualTo: day)
          .get();
      
      return query.docs.map((doc) {
        final data = doc.data();
        return ExerciseData.fromJson(data);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ExerciseData>> getBaselineExercises() async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('exercises')
          .where('isBaseline', isEqualTo: true)
          .get();
      
      return query.docs.map((doc) {
        final data = doc.data();
        return ExerciseData.fromJson(data);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveTrainingStep(int step) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');
      
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('training')
          .doc('current_step')
          .set({'step': step}, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> getSavedStep() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return 0;
      
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('training')
          .doc('current_step')
          .get();
      
      return doc.data()?['step'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> updateBaseline(int value) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');
      
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'baseline': value,
        'currentLevel': 1,
        'currentDay': 1,
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getBaselineData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return {};
      
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      final data = doc.data();
      return data?['baseline'] ?? {};
    } catch (e) {
      return {};
    }
  }
}

