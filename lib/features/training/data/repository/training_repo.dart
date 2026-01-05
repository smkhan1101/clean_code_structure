import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Future<void> updateBaseline(int value, {bool isOriginal = false}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');
      
      final updateData = <String, dynamic>{
        'currentBaseline': value.toDouble(),
        'currentLevel': 1,
        'currentDay': 1,
      };
      
      if (isOriginal) {
        updateData['originalBaseline'] = value.toDouble();
      }
      
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(updateData);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateBaselineValue(double value, {bool isOriginal = false}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');
      
      final updateData = <String, dynamic>{
        'currentBaseline': value,
      };
      
      if (isOriginal) {
        updateData['originalBaseline'] = value;
      }
      
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(updateData);
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
      return {
        'currentBaseline': data?['currentBaseline'] ?? data?['baseline'] ?? 0,
        'originalBaseline': data?['originalBaseline'] ?? data?['baseline'] ?? 0,
        'speedUnit': data?['speedUnit'] ?? 'MPH',
        'distanceUnit': data?['distanceUnit'] ?? 'YDS',
      };
    } catch (e) {
      return {};
    }
  }

  @override
  Future<Map<String, dynamic>> getProtocolData(int level, int day) async {
    try {
      final docId = 'level$level';
      final protocolDoc = await FirebaseFirestore.instance
          .collection('protocol')
          .doc(docId)
          .get();
      
      if (!protocolDoc.exists) {
        return {'exercises': [], 'videoId': null};
      }
      
      final protocolData = protocolDoc.data() ?? {};
      final videoId = protocolData['videoId'] as String?;
      
      final actionsSnapshot = await FirebaseFirestore.instance
          .collection('protocol')
          .doc(docId)
          .collection('actions')
          .get();
      
      final actions = <Map<String, dynamic>>[];
      for (final actionDoc in actionsSnapshot.docs) {
        final actionData = actionDoc.data();
        actionData['id'] = actionDoc.id;
        actions.add(actionData);
      }
      
      actions.sort((a, b) {
        final aId = int.tryParse(a['id'] ?? '0') ?? 0;
        final bId = int.tryParse(b['id'] ?? '0') ?? 0;
        return aId.compareTo(bId);
      });
      
      final exerciseIds = <String>{};
      for (final action in actions) {
        final exerciseId = action['exerciseId'] as String?;
        if (exerciseId != null) {
          exerciseIds.add(exerciseId);
        }
      }
      
      final exercises = <ExerciseData>[];
      final exerciseMap = <String, ExerciseData>{};
      
      for (final exerciseId in exerciseIds) {
        try {
          final exerciseDoc = await FirebaseFirestore.instance
              .collection('exercise')
              .doc(exerciseId)
              .get();
          
          if (exerciseDoc.exists && exerciseDoc.data() != null) {
            final exercise = ExerciseData.fromJson(exerciseDoc.data()!);
            exerciseMap[exerciseId] = exercise;
            exercises.add(exercise);
          }
        } catch (e) {
          continue;
        }
      }
      
      final actionsWithExercises = <Map<String, dynamic>>[];
      for (final action in actions) {
        final exerciseId = action['exerciseId'] as String?;
        if (exerciseId != null && exerciseMap.containsKey(exerciseId)) {
          final exercise = exerciseMap[exerciseId]!;
          final actionWithExercise = Map<String, dynamic>.from(action);
          actionWithExercise['exercise'] = exercise.toJson();
          actionsWithExercises.add(actionWithExercise);
        }
      }
      
      return {
        'exercises': exercises,
        'videoId': videoId,
        'actions': actionsWithExercises,
      };
    } catch (e) {
      return {'exercises': [], 'videoId': null, 'actions': []};
    }
  }

  @override
  Future<void> updateTimeline(int level, int day) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');
      
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'currentLevel': level,
        'currentDay': day,
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getUnfinishedTraining() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return {};
      
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('training')
          .doc('progress')
          .get();
      
      return doc.data() ?? {};
    } catch (e) {
      return {};
    }
  }

  @override
  Future<void> saveUnfinishedTraining(Map<String, dynamic> trainingData) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');
      
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('training')
          .doc('progress')
          .set(trainingData, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearUnfinishedTraining() async {
    try {
      // Clear local SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('unfinished_training');
      
      // Clear Firestore training progress if user is logged in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          final progressDoc = FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('training')
              .doc('progress');
          
          // Check if document exists before deleting
          final docSnapshot = await progressDoc.get();
          if (docSnapshot.exists) {
            await progressDoc.delete();
          }
        } catch (e) {
          // Log Firestore error but don't fail if local clear succeeded
          if (kDebugMode) {
            print('Firestore clear error (non-critical): $e');
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getTrainingConstants() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('trainingConstants')
          .doc('default')
          .get();
      
      return doc.data() ?? {
        'baselineVideoId': null,
        'speedUnit': 'MPH',
      };
    } catch (e) {
      return {
        'baselineVideoId': null,
        'speedUnit': 'MPH',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return {};
      
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      final data = doc.data();
      return {
        'speedUnit': data?['speedUnit'] ?? 'MPH',
        'distanceUnit': data?['distanceUnit'] ?? 'YDS',
      };
    } catch (e) {
      return {
        'speedUnit': 'MPH',
        'distanceUnit': 'YDS',
      };
    }
  }

  @override
  Future<void> setRadarOption(String option) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');
      
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'radarOption': option,
      });
    } catch (e) {
      rethrow;
    }
  }
}

