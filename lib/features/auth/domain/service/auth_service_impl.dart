import '../../data/model/user_model.dart';
import '../../data/repository/auth_repo_interface.dart';
import 'auth_service.dart';

class AuthServiceImpl implements AuthService {
  final AuthRepo authRepo;

  AuthServiceImpl({required this.authRepo});

  @override
  Future<UserModel?> login(String email, String password) async {
    return await authRepo.login(email, password);
  }

  @override
  Future<UserModel?> register(String email, String password) async {
    return await authRepo.register(email, password);
  }

  @override
  Future<void> sendResetPasswordLink(String email) async {
    await authRepo.sendResetPasswordLink(email);
  }

  @override
  Future<bool> checkAccount() async {
    return await authRepo.checkAccount();
  }

  @override
  Future<void> logout() async {
    await authRepo.logout();
  }

  @override
  UserModel? getCurrentUser() {
    return authRepo.getCurrentUser();
  }

  @override
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
  }) async {
    await authRepo.saveUserDetails(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
      gender: gender,
      handedness: handedness,
      handicap: handicap,
      shaft: shaft,
      units: units,
      currentLevel: currentLevel,
      currentDay: currentDay,
      lastRewardsUpdate: lastRewardsUpdate,
      fcmToken: fcmToken,
      baselineInputs: baselineInputs,
    );
  }
}

