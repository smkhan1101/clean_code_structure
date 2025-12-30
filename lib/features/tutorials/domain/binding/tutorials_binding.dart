import 'package:get/get.dart';
import '../../data/repository/tutorials_repo.dart';
import '../../data/repository/tutorials_repo_interface.dart';
import '../service/tutorials_service.dart';
import '../service/tutorials_service_impl.dart';
import '../../presentation/controller/tutorials_controller.dart';

class TutorialsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TutorialsRepo>(() => TutorialsRepoImpl());
    Get.lazyPut<TutorialsService>(
      () => TutorialsServiceImpl(tutorialsRepo: Get.find<TutorialsRepo>()),
    );
    Get.lazyPut<TutorialsController>(
      () => TutorialsController(tutorialsService: Get.find<TutorialsService>()),
    );
  }
}


