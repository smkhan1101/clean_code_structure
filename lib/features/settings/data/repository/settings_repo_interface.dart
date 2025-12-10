abstract class SettingsRepo {
  Future<Map<String, dynamic>> getUserSettings();
  Future<void> updateUserSettings(Map<String, dynamic> settings);
  Future<void> deleteAccount(String password);
  Future<void> resetToLevel1Day1();
}

