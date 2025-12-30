import '../model/exercise_data.dart';

abstract class TrainingRepo {
  Future<List<ExerciseData>> getTrainingExercises(int level, int day);
  Future<List<ExerciseData>> getBaselineExercises();
  Future<void> saveTrainingStep(int step);
  Future<int> getSavedStep();
  Future<Map<String, dynamic>> getBaselineData();
  Future<Map<String, dynamic>> getProtocolData(int level, int day);
  Future<void> updateTimeline(int level, int day);
  Future<Map<String, dynamic>> getUnfinishedTraining();
  Future<void> saveUnfinishedTraining(Map<String, dynamic> trainingData);
  Future<void> clearUnfinishedTraining();
  Future<void> updateBaseline(int value, {bool isOriginal = false});
  Future<void> updateBaselineValue(double value, {bool isOriginal = false});
  Future<Map<String, dynamic>> getTrainingConstants();
  Future<Map<String, dynamic>> getUserData();
  Future<void> setRadarOption(String option);
}

