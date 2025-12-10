import '../../data/repository/settings_repo_interface.dart';
import 'settings_service.dart';

class SettingsServiceImpl implements SettingsService {
  final SettingsRepo settingsRepo;

  SettingsServiceImpl({required this.settingsRepo});

  @override
  Future<Map<String, dynamic>> getUserSettings() async {
    return await settingsRepo.getUserSettings();
  }

  @override
  Future<void> updateUserSettings(Map<String, dynamic> settings) async {
    await settingsRepo.updateUserSettings(settings);
  }

  @override
  Future<void> deleteAccount(String password) async {
    await settingsRepo.deleteAccount(password);
  }

  @override
  Future<void> resetToLevel1Day1() async {
    await settingsRepo.resetToLevel1Day1();
  }
}

