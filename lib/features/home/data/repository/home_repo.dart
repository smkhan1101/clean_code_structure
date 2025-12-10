import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/calendar_item.dart';
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
      
      // Extract calendar data from user document
      // Adjust based on your actual data structure
      final calendarItems = <CalendarItem>[];
      
      // Example: Create calendar items from user data
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
      final currentLevel = data?['currentLevel'] ?? 1;
      
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
}

