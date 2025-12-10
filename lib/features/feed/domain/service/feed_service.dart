import '../../data/model/post_model.dart';

abstract class FeedService {
  Future<List<PostModel>> getFeedForUser(List<String> postIds);
  Future<void> sendPost(String text, String attachmentPath, List<String> postIds);
  Future<void> deletePost(String postId, String? attachmentPath, List<String> allPostIds);
  Future<String> uploadFile(String filePath);
  Future<void> deleteFile(String path);
}

