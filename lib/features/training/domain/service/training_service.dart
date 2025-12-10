import '../../data/model/exercise_data.dart';

abstract class TrainingService {
  Future<List<ExerciseData>> getTrainingExercises(int level, int day);
  Future<List<ExerciseData>> getBaselineExercises();
  Future<void> saveTrainingStep(int step);
  Future<int> getSavedStep();
  Future<void> updateBaseline(int value);
  Future<Map<String, dynamic>> getBaselineData();
}

