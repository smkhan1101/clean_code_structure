import '../model/user_model.dart';

abstract class AuthRepo {
  Future<UserModel?> login(String email, String password);
  Future<UserModel?> register(String email, String password);
  Future<void> sendResetPasswordLink(String email);
  Future<bool> checkAccount();
  Future<void> logout();
  UserModel? getCurrentUser();
  Future<void> saveUserDetails({
    required String userId,
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required String gender,
    required String handedness,
    required String handicap,
    required String shaft,
    required String units,
    required int currentLevel,
    required int currentDay,
    DateTime? lastRewardsUpdate,
    String? fcmToken,
    List<Map<String, dynamic>>? baselineInputs,
  });
}

