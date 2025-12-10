# Firebase Integration Guide

This document outlines all Firebase integration points in the Flutter app and how to implement them.

## Firebase Services Used

Based on the Android app, the following Firebase services are required:

1. **Firebase Auth** - User authentication
2. **Firebase Firestore** - Database for user data, posts, training data, rewards, etc.
3. **Firebase Storage** - File storage for images and videos
4. **Firebase Messaging** - Push notifications (optional)
5. **Firebase Analytics** - Analytics (optional)
6. **Firebase Crashlytics** - Crash reporting (optional)

## Setup Steps

### 1. Add Firebase Dependencies

Uncomment and add to `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^3.13.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.3
  firebase_storage: ^12.3.2
  firebase_messaging: ^15.2.5
  firebase_analytics: ^11.3.3
  firebase_crashlytics: ^4.3.5
```

### 2. Initialize Firebase

In `main.dart`, add Firebase initialization:

```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // ... rest of initialization
}
```

### 3. Firebase Configuration Files

- Add `google-services.json` (Android) to `android/app/`
- Add `GoogleService-Info.plist` (iOS) to `ios/Runner/`

## Module-by-Module Integration

### Auth Module

**File:** `lib/features/auth/data/repository/auth_repo.dart`

**Replace TODOs with:**

```dart
import 'package:firebase_auth/firebase_auth.dart';

@override
Future<UserModel?> login(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user != null) {
      await prefs.setString(SharedKeys.token, user.uid);
      await prefs.setString(SharedKeys.userEmail, user.email ?? '');
      return UserModel(id: user.uid, email: user.email ?? '');
    }
    return null;
  } on FirebaseAuthException catch (e) {
    throw Exception(e.message ?? 'Login failed');
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
      await prefs.setString(SharedKeys.token, user.uid);
      await prefs.setString(SharedKeys.userEmail, user.email ?? '');
      // Create user document in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
        'feedPostIds': [],
        'platforms': ['Flutter'],
      });
      return UserModel(id: user.uid, email: user.email ?? '');
    }
    return null;
  } on FirebaseAuthException catch (e) {
    throw Exception(e.message ?? 'Registration failed');
  }
}

@override
Future<void> sendResetPasswordLink(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  } on FirebaseAuthException catch (e) {
    throw Exception(e.message ?? 'Password reset failed');
  }
}

@override
Future<void> logout() async {
  await prefs.remove(SharedKeys.token);
  await prefs.remove(SharedKeys.userEmail);
  await FirebaseAuth.instance.signOut();
}
```

### Feed Module

**File:** `lib/features/feed/data/repository/feed_repo.dart`

**Replace TODOs with:**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

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
      return PostModel(
        id: doc.id,
        text: data['text'] ?? '',
        date: (data['date'] as Timestamp?)?.toDate(),
        isFromCoach: data['isFromCoach'] ?? false,
        attachmentPath: (data['storagePaths'] as List?)?.firstOrNull ?? '',
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
```

### Home Module

**File:** `lib/features/home/data/repository/home_repo.dart`

**Replace TODOs with:**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

@override
Future<List<CalendarItem>> getCalendarData() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];
    
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    
    final data = userDoc.data();
    // Implement calendar data extraction from user document
    // This depends on your data structure
    return [];
  } catch (e) {
    return [];
  }
}

@override
Future<bool> isBaselineExists() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    
    final data = userDoc.data();
    return data?['baseline'] != null;
  } catch (e) {
    return false;
  }
}

@override
Future<int> getCurrentDay() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;
    
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    
    return userDoc.data()?['currentDay'] ?? 0;
  } catch (e) {
    return 0;
  }
}

@override
Future<int> getCurrentLevel() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 1;
    
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    
    return userDoc.data()?['currentLevel'] ?? 1;
  } catch (e) {
    return 1;
  }
}
```

### Training Module

**File:** `lib/features/training/data/repository/training_repo.dart`

**Replace TODOs with:**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

@override
Future<List<ExerciseData>> getExercises(int level, int day) async {
  try {
    final query = await FirebaseFirestore.instance
        .collection('exercises')
        .where('level', isEqualTo: level)
        .where('day', isEqualTo: day)
        .get();
    
    return query.docs.map((doc) {
      final data = doc.data();
      return ExerciseData.fromJson(data);
    }).toList();
  } catch (e) {
    return [];
  }
}

@override
Future<void> saveStep(String stepId, Map<String, dynamic> stepData) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');
    
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('steps')
        .doc(stepId)
        .set(stepData, SetOptions(merge: true));
  } catch (e) {
    rethrow;
  }
}
```

### Rewards Module

**File:** `lib/features/rewards/data/repository/rewards_repo.dart`

**Replace TODOs with:**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

@override
Future<List<RewardModel>> getRewards() async {
  try {
    final query = await FirebaseFirestore.instance
        .collection('rewards')
        .get();
    
    return query.docs.map((doc) {
      final data = doc.data();
      return RewardModel.fromJson(data);
    }).toList();
  } catch (e) {
    return [];
  }
}

@override
Future<List<RewardModel>> getUserRewards() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];
    
    final query = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('rewards')
        .get();
    
    return query.docs.map((doc) {
      final data = doc.data();
      return RewardModel.fromJson(data);
    }).toList();
  } catch (e) {
    return [];
  }
}
```

### Settings Module

**File:** `lib/features/settings/data/repository/settings_repo.dart`

**Replace TODOs with:**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
```

## Firestore Collections Structure

Based on the Android app, here's the expected Firestore structure:

```
users/
  {userId}/
    email: string
    createdAt: timestamp
    feedPostIds: string[]
    currentLevel: number
    currentDay: number
    baseline: object
    platforms: string[]
    steps/
      {stepId}/
        ...step data
    rewards/
      {rewardId}/
        ...reward data

posts/
  {postId}/
    date: timestamp
    isFromCoach: boolean
    text: string
    storagePaths: string[]

exercises/
  {exerciseId}/
    level: number
    day: number
    ...exercise data

rewards/
  {rewardId}/
    ...reward data
```

## Testing Firebase Integration

1. **Test Authentication:**
   - Create test accounts
   - Test login/logout
   - Test password reset

2. **Test Firestore:**
   - Verify data reads/writes
   - Check real-time listeners
   - Test offline persistence

3. **Test Storage:**
   - Upload images/videos
   - Download files
   - Delete files

## Security Rules

Ensure Firebase Security Rules are properly configured:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /posts/{postId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    match /exercises/{exerciseId} {
      allow read: if request.auth != null;
    }
    match /rewards/{rewardId} {
      allow read: if request.auth != null;
    }
  }
}
```

## Notes

- All Firebase operations should handle errors gracefully
- Use `FieldValue.serverTimestamp()` for timestamps
- Implement offline persistence for better UX
- Consider using Firestore listeners for real-time updates
- Handle authentication state changes properly

