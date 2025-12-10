import '../../data/model/user_model.dart';

abstract class AuthService {
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
    required String handType,
    required String handicap,
    required String shaftLength,
    required String preferredUnit,
    required int currentLevel,
    required int currentDay,
  });
}

