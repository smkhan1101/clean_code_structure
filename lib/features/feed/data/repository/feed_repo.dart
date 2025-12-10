import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../model/post_model.dart';
import 'feed_repo_interface.dart';

class FeedRepoImpl implements FeedRepo {
  FeedRepoImpl();

  @override
  Future<List<PostModel>> getFeedForUser(List<String> postIds) async {
    try {
      if (postIds.isEmpty) return [];
      
      final query = await FirebaseFirestore.instance
          .collection('posts')
          .where(FieldPath.documentId, whereIn: postIds)
          .get();
      
      return query.docs.map((doc) {
        final data = doc.data();
        final timestamp = data['date'] as Timestamp?;
        final storagePaths = data['storagePaths'] as List<dynamic>?;
        
        return PostModel(
          id: doc.id,
          text: data['text'] ?? '',
          date: timestamp?.toDate(),
          isFromCoach: data['isFromCoach'] ?? false,
          attachmentPath: storagePaths?.isNotEmpty == true ? storagePaths!.first.toString() : '',
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> sendPost(String text, String attachmentPath, List<String> postIds) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');
      
      final post = {
        'date': FieldValue.serverTimestamp(),
        'isFromCoach': false,
        'text': text,
        'storagePaths': attachmentPath.isNotEmpty ? [attachmentPath] : [],
      };
      
      final docRef = await FirebaseFirestore.instance.collection('posts').add(post);
      
      // Update user's feedPostIds
      final newPostIds = [...postIds, docRef.id].toSet().toList();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'feedPostIds': newPostIds});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deletePost(String postId, String? attachmentPath, List<String> allPostIds) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');
      
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
      
      final newPostIds = allPostIds.where((id) => id != postId).toList();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'feedPostIds': newPostIds});
      
      if (attachmentPath != null && attachmentPath.isNotEmpty) {
        await deleteFile(attachmentPath);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> uploadFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File does not exist');
      }
      
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final ref = FirebaseStorage.instance.ref().child(fileName);
      
      await ref.putFile(file);
      return ref.fullPath;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteFile(String path) async {
    try {
      if (path.isEmpty) return;
      await FirebaseStorage.instance.ref().child(path).delete();
    } catch (e) {
      // Ignore errors on file deletion
    }
  }
}

