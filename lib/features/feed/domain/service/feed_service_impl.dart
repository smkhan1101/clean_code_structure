import '../../data/model/post_model.dart';
import '../../data/repository/feed_repo_interface.dart';
import 'feed_service.dart';

class FeedServiceImpl implements FeedService {
  final FeedRepo feedRepo;

  FeedServiceImpl({required this.feedRepo});

  @override
  Future<List<PostModel>> getFeedForUser(List<String> postIds) async {
    return await feedRepo.getFeedForUser(postIds);
  }

  @override
  Future<void> sendPost(String text, String attachmentPath, List<String> postIds) async {
    await feedRepo.sendPost(text, attachmentPath, postIds);
  }

  @override
  Future<void> deletePost(String postId, String? attachmentPath, List<String> allPostIds) async {
    await feedRepo.deletePost(postId, attachmentPath, allPostIds);
  }

  @override
  Future<String> uploadFile(String filePath) async {
    return await feedRepo.uploadFile(filePath);
  }

  @override
  Future<void> deleteFile(String path) async {
    await feedRepo.deleteFile(path);
  }
}

