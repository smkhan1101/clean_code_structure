import 'package:get/get.dart';
import '../../data/repository/training_repo.dart';
import '../../data/repository/training_repo_interface.dart';
import '../service/training_service.dart';
import '../service/training_service_impl.dart';
import '../../presentation/controller/training_controller.dart';

class TrainingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrainingRepo>(() => TrainingRepoImpl());
    Get.lazyPut<TrainingService>(() => TrainingServiceImpl(trainingRepo: Get.find<TrainingRepo>()));
    Get.lazyPut<TrainingController>(() => TrainingController(trainingService: Get.find<TrainingService>()));
  }
}

