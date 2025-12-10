import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'settings_repo_interface.dart';

class SettingsRepoImpl implements SettingsRepo {
  SettingsRepoImpl();

  @override
  Future<Map<String, dynamic>> getUserSettings() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return {};
      
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      return doc.data() ?? {};
    } catch (e) {
      return {};
    }
  }

  @override
  Future<void> updateUserSettings(Map<String, dynamic> settings) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');
      
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(settings);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount(String password) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');
      
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      
      await user.reauthenticateWithCredential(credential);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();
      await user.delete();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetToLevel1Day1() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');
      
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'currentLevel': 1,
        'currentDay': 1,
      });
    } catch (e) {
      rethrow;
    }
  }
}

