import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_model.dart';
import 'auth_repo_interface.dart';

class AuthRepoImpl implements AuthRepo {
  AuthRepoImpl();

  @override
  Future<UserModel?> login(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        
        if (!userDoc.exists) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'email': user.email,
            'createdAt': FieldValue.serverTimestamp(),
            'feedPostIds': [],
            'platforms': ['Flutter'],
            'currentLevel': 1,
            'currentDay': 0,
          }, SetOptions(merge: true));
        }
        
        return UserModel(id: user.uid, email: user.email ?? '');
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login failed');
    } catch (e) {
      if (e.toString().contains('No Firebase App')) {
        throw Exception('Firebase not configured. Please add google-services.json file.');
      }
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> register(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),
          'feedPostIds': [],
          'platforms': ['Flutter'],
          'currentLevel': 1,
          'currentDay': 0,
        }, SetOptions(merge: true));
        
        return UserModel(id: user.uid, email: user.email ?? '');
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Registration failed');
    } catch (e) {
      if (e.toString().contains('No Firebase App')) {
        throw Exception('Firebase not configured. Please add google-services.json file.');
      }
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> sendResetPasswordLink(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Password reset failed');
    } catch (e) {
      if (e.toString().contains('No Firebase App')) {
        throw Exception('Firebase not configured. Please add google-services.json file.');
      }
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  @override
  Future<bool> checkAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        return userDoc.exists;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  UserModel? getCurrentUser() {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return UserModel(id: user.uid, email: user.email ?? '');
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveUserDetails({
    required String userId,
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required String gender,
    required String handType,
    required String handicap,
    required String shaftLength,
    required String preferredUnit,
    required int currentLevel,
    required int currentDay,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'firstName': firstName,
        'lastName': lastName,
        'dateOfBirth': Timestamp.fromDate(dateOfBirth),
        'gender': gender,
        'handType': handType,
        'handicap': handicap,
        'shaftLength': shaftLength,
        'preferredUnit': preferredUnit,
        'currentLevel': currentLevel,
        'currentDay': currentDay,
      });
    } catch (e) {
      throw Exception('Failed to save user details: ${e.toString()}');
    }
  }
}

