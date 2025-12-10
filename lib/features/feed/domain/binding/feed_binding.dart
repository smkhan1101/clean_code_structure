import 'package:get/get.dart';
import '../../data/repository/feed_repo.dart';
import '../../data/repository/feed_repo_interface.dart';
import '../service/feed_service.dart';
import '../service/feed_service_impl.dart';
import '../../presentation/controller/feed_controller.dart';

class FeedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedRepo>(() => FeedRepoImpl());
    Get.lazyPut<FeedService>(() => FeedServiceImpl(feedRepo: Get.find<FeedRepo>()));
    Get.lazyPut<FeedController>(() => FeedController(feedService: Get.find<FeedService>()));
  }
}

