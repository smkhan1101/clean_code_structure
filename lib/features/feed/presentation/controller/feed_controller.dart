import 'package:get/get.dart';
import '../../../../imports.dart';
import '../../data/model/post_model.dart';
import '../../domain/service/feed_service.dart';

class FeedController extends GetxController implements GetxService {
  final FeedService _feedService;

  FeedController({required FeedService feedService}) : _feedService = feedService;
  
  FeedService get feedService => _feedService;

  static FeedController get find => Get.find<FeedController>();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isProPlan = false;
  bool get isProPlan => _isProPlan;

  List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  List<String> _userPostIds = [];
  List<String> get userPostIds => _userPostIds;

  @override
  void onInit() {
    super.onInit();
    loadFeed();
  }

  Future<void> loadFeed() async {
    if (_userPostIds.isEmpty) {
      _isLoading = false;
      update();
      return;
    }

    _isLoading = true;
    update();

    try {
      _posts = await feedService.getFeedForUser(_userPostIds);
      _posts.sort((a, b) {
        if (a.date == null || b.date == null) return 0;
        return b.date!.compareTo(a.date!);
      });
    } catch (e) {
      showToast('error_loading_feed'.tr);
    }

    _isLoading = false;
    update();
  }

  void setUserPostIds(List<String> postIds) {
    _userPostIds = postIds;
    loadFeed();
  }

  void setIsProPlan(bool value) {
    _isProPlan = value;
    update();
  }

  Future<void> sendPost(String text, String attachmentPath) async {
    try {
      showLoading();
      await feedService.sendPost(text, attachmentPath, _userPostIds);
      hideLoading();
      await loadFeed();
      showToast('post_created_successfully'.tr);
    } catch (e) {
      hideLoading();
      showToast('error_creating_post'.tr);
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      final post = _posts.firstWhere((p) => p.id == postId);
      showLoading();
      await feedService.deletePost(postId, post.attachmentPath, _userPostIds);
      _posts.removeWhere((p) => p.id == postId);
      _userPostIds.remove(postId);
      hideLoading();
      update();
      showToast('post_deleted_successfully'.tr);
    } catch (e) {
      hideLoading();
      showToast('error_deleting_post'.tr);
    }
  }

  void onImageTap(String imagePath) {
    Get.toNamed('/feed-image-detail', arguments: {'uri': imagePath});
  }

  void onVideoTap(String videoPath) {
    Get.toNamed('/feed-video-detail', arguments: {'uri': videoPath});
  }

  void showPostSheet() {
    if (!_isProPlan) {
      showToast('upgrade_to_pro_to_post'.tr);
      Get.toNamed('/paywall');
      return;
    }
    Get.toNamed('/post-feed');
  }
}

