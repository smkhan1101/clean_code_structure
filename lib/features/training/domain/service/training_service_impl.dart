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
  Future<void> updateBaseline(int value) async {
    await trainingRepo.updateBaseline(value);
  }

  @override
  Future<Map<String, dynamic>> getBaselineData() async {
    return await trainingRepo.getBaselineData();
  }
}

