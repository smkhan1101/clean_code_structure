import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/calendar_item.dart';
import '../model/user_calendar_data.dart';
import '../model/calendar_entry.dart';
import 'home_repo_interface.dart';

class HomeRepoImpl implements HomeRepo {
  final SharedPreferences prefs;

  HomeRepoImpl({required this.prefs});

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
      if (data == null) return [];
      
      final calendarItems = <CalendarItem>[];
      
      if (data.containsKey('currentLevel')) {
        calendarItems.add(CalendarItem(
          text: 'Level',
          value: data['currentLevel']?.toString() ?? '1',
          progress: 0.0,
        ));
      }
      
      if (data.containsKey('currentDay')) {
        calendarItems.add(CalendarItem(
          text: 'Day',
          value: data['currentDay']?.toString() ?? '0',
          progress: 0.0,
        ));
      }
      
      return calendarItems;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> getBaselineData() async {
    try {
      // TODO: Implement Firebase Firestore baseline data retrieval
      // For now, return empty map
      return {};
    } catch (e) {
      return {};
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
      return data?['originalBaseline'] != null;
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

  @override
  Future<bool> isTrainingEnabled() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;
      
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      final data = userDoc.data();
      final currentDay = data?['currentDay'] ?? 0;
      
      // Training is enabled if user has baseline and is on day > 0
      final hasBaseline = data?['baseline'] != null;
      return hasBaseline && currentDay > 0;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isProPlan() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;
      
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      return userDoc.data()?['isPro'] ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> getUserStats() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return {};
      
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      final data = userDoc.data();
      if (data == null) return {};
      
      final currentBaseline = data['currentBaseline'] ?? data['baseline'] ?? 0.0;
      final originalBaseline = data['originalBaseline'] ?? currentBaseline;
      
      final speedDelta = currentBaseline - originalBaseline;
      final distanceDelta = (speedDelta * 2.5).toDouble();
      
      return {
        'currentBaseline': currentBaseline,
        'originalBaseline': originalBaseline,
        'speedDelta': speedDelta,
        'distanceDelta': distanceDelta,
        'speedUnit': data['speedUnit'] ?? 'MPH',
        'distanceUnit': data['distanceUnit'] ?? 'YDS',
      };
    } catch (e) {
      return {};
    }
  }

  @override
  Future<bool> hasUnfinishedTraining() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;
      
      final trainingDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('training')
          .doc('progress')
          .get();
      
      return trainingDoc.exists && trainingDoc.data() != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isTrainingLocked() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;
      
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      final data = userDoc.data();
      if (data == null) return false;
      
      final trainingLockedUntil = data['trainingLockedUntil'];
      if (trainingLockedUntil == null) return false;
      
      final lockedUntil = (trainingLockedUntil as Timestamp).toDate();
      return DateTime.now().isBefore(lockedUntil);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserCalendarData> getUserCalendarData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return UserCalendarData(entries: []);
      
      final calendarEntriesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('calendarData')
          .get();
      
      final entries = calendarEntriesSnapshot.docs.map((doc) {
        return CalendarEntry.fromJson(doc.data(), doc.id);
      }).toList();
      
      return UserCalendarData(entries: entries);
    } catch (e) {
      return UserCalendarData(entries: []);
    }
  }
}

