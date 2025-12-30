import '../../data/model/exercise_data.dart';
import '../../data/repository/training_repo_interface.dart';
import 'training_service.dart';

class TrainingServiceImpl implements TrainingService {
  final TrainingRepo trainingRepo;

  TrainingServiceImpl({required this.trainingRepo});

  @override
  Future<List<ExerciseData>> getTrainingExercises(int level, int day) async {
    return await trainingRepo.getTrainingExercises(level, day);
  }

  @override
  Future<List<ExerciseData>> getBaselineExercises() async {
    return await trainingRepo.getBaselineExercises();
  }

  @override
  Future<void> saveTrainingStep(int step) async {
    await trainingRepo.saveTrainingStep(step);
  }

  @override
  Future<int> getSavedStep() async {
    return await trainingRepo.getSavedStep();
  }

  @override
  Future<Map<String, dynamic>> getBaselineData() async {
    return await trainingRepo.getBaselineData();
  }

  @override
  Future<Map<String, dynamic>> getProtocolData(int level, int day) async {
    return await trainingRepo.getProtocolData(level, day);
  }

  @override
  Future<void> updateTimeline(int level, int day) async {
    await trainingRepo.updateTimeline(level, day);
  }

  @override
  Future<Map<String, dynamic>> getUnfinishedTraining() async {
    return await trainingRepo.getUnfinishedTraining();
  }

  @override
  Future<void> saveUnfinishedTraining(Map<String, dynamic> trainingData) async {
    await trainingRepo.saveUnfinishedTraining(trainingData);
  }

  @override
  Future<void> clearUnfinishedTraining() async {
    await trainingRepo.clearUnfinishedTraining();
  }

  @override
  Future<void> updateBaseline(int value, {bool isOriginal = false}) async {
    await trainingRepo.updateBaseline(value, isOriginal: isOriginal);
  }

  @override
  Future<void> updateBaselineValue(double value, {bool isOriginal = false}) async {
    await trainingRepo.updateBaselineValue(value, isOriginal: isOriginal);
  }

  @override
  Future<Map<String, dynamic>> getTrainingConstants() async {
    return await trainingRepo.getTrainingConstants();
  }

  @override
  Future<Map<String, dynamic>> getUserData() async {
    return await trainingRepo.getUserData();
  }

  @override
  Future<void> setRadarOption(String option) async {
    await trainingRepo.setRadarOption(option);
  }
}

