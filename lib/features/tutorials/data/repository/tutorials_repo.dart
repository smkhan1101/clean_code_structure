import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/day_protocol.dart';
import '../model/swing_fix.dart';
import '../model/exercise.dart';
import 'tutorials_repo_interface.dart';

class TutorialsRepoImpl implements TutorialsRepo {
  TutorialsRepoImpl();

  @override
  Future<List<DayProtocol>> getProtocols() async {
    try {
      final protocolsQuery = await FirebaseFirestore.instance
          .collection('protocol')
          .get();

      final allExerciseIds = <String>{};
      final protocolActionsMap = <String, List<QueryDocumentSnapshot>>{};

      for (final protocolDoc in protocolsQuery.docs) {
        final levelId = protocolDoc.id;
        final actionsQuery = await FirebaseFirestore.instance
            .collection('protocol')
            .doc(levelId)
            .collection('actions')
            .get();

        final actions = actionsQuery.docs.toList();
        actions.sort((a, b) {
          final aIndex = int.tryParse(a.id) ?? 0;
          final bIndex = int.tryParse(b.id) ?? 0;
          return aIndex.compareTo(bIndex);
        });

        protocolActionsMap[levelId] = actions;

        for (final actionDoc in actions) {
          final actionData = actionDoc.data() as Map<String, dynamic>?;
          final exerciseId = actionData?['exerciseId'] as String?;
          if (exerciseId != null && exerciseId.isNotEmpty) {
            allExerciseIds.add(exerciseId);
          }
        }
      }

      final exercisesMap = <String, Exercise>{};
      if (allExerciseIds.isNotEmpty) {
        final exerciseIdsList = allExerciseIds.toList();
        const batchSize = 10;

        for (int i = 0; i < exerciseIdsList.length; i += batchSize) {
          final batch = exerciseIdsList.skip(i).take(batchSize).toList();
          final exercisesQuery = await FirebaseFirestore.instance
              .collection('exercise')
              .where(FieldPath.documentId, whereIn: batch)
              .get();

          for (final exerciseDoc in exercisesQuery.docs) {
            final exerciseData = exerciseDoc.data();
            final title = exerciseData['title'] as String? ?? '';
            final videoId = exerciseData['videoId'] as String? ?? '';

            if (title.isNotEmpty && videoId.isNotEmpty) {
              exercisesMap[exerciseDoc.id] = Exercise(
                id: exerciseDoc.id,
                title: title,
                videoId: videoId,
              );
            }
          }
        }
      }

      final protocols = <DayProtocol>[];

      for (final protocolDoc in protocolsQuery.docs) {
        final protocolData = protocolDoc.data();
        final levelId = protocolDoc.id;
        final durationDays = protocolData['durationDays'] as int? ?? 0;
        final baselineVideoId = protocolData['videoId'] as String?;

        final actions = protocolActionsMap[levelId] ?? [];
        final exercises = <Exercise>[];
        final addedExerciseIds = <String>{};

        for (final actionDoc in actions) {
          final actionData = actionDoc.data() as Map<String, dynamic>?;
          final exerciseId = actionData?['exerciseId'] as String?;

          if (exerciseId == null || exerciseId.isEmpty) continue;
          if (addedExerciseIds.contains(exerciseId)) continue;

          final exercise = exercisesMap[exerciseId];
          if (exercise != null) {
            exercises.add(exercise);
            addedExerciseIds.add(exerciseId);
          }
        }

        if (baselineVideoId != null && baselineVideoId.isNotEmpty) {
          final baselineExists = exercises.any(
            (e) => e.videoId == baselineVideoId || 
                   e.title.toLowerCase().contains('baseline'),
          );
          if (!baselineExists) {
            exercises.add(Exercise(
              id: 'baseline',
              title: 'Baseline Test: Normal Swings',
              videoId: baselineVideoId,
            ));
          }
        }

        protocols.add(DayProtocol(
          id: levelId,
          durationDays: durationDays,
          baselineVideoId: baselineVideoId,
          exercises: exercises,
        ));
      }

      return protocols;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<SwingFix>> getSwingFixes() async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('swing-fixes')
          .orderBy('title')
          .get();

      return query.docs.map((doc) {
        final data = doc.data();
        return SwingFix(
          id: doc.id,
          title: data['title'] ?? '',
          videoId: data['videoId'] ?? '',
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<String> getWarmUpVideoId() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('config')
          .doc('warmUp')
          .get();

      if (doc.exists) {
        final data = doc.data();
        return data?['videoId'] ?? 'IF0kLstvX6M';
      }
      return 'IF0kLstvX6M';
    } catch (e) {
      return 'IF0kLstvX6M';
    }
  }
}
