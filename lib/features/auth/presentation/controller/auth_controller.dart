import 'package:get/get.dart';
import '../../data/model/user_model.dart';
import '../../domain/service/auth_service.dart';

class AuthController extends GetxController implements GetxService {
  final AuthService authService;

  AuthController({required this.authService});

  static AuthController get find => Get.find<AuthController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _email = '';
  String get email => _email;

  String _password = '';
  String get password => _password;

  String _resetEmail = '';
  String get resetEmail => _resetEmail;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _errorTitle = '';
  String get errorTitle => _errorTitle;

  bool _showError = false;
  bool get showError => _showError;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  String _firstName = '';
  String _lastName = '';
  DateTime? _dateOfBirth;
  String _gender = 'None';
  String _handType = 'Right-handed';
  String _handicap = '10';
  String _shaftLength = 'None';
  String _preferredUnit = 'Yards/MPH';
  bool _isTrainedBefore = false;
  bool get isTrainedBefore => _isTrainedBefore;
  int _currentLevel = 1;
  int get currentLevel => _currentLevel;
  int _currentDay = 1;
  int get currentDay => _currentDay;
  bool _isSkipped = false;
  bool get isSkipped => _isSkipped;
  bool _hasBaselineMeasurements = false;
  bool get hasBaselineMeasurements => _hasBaselineMeasurements;
  bool _notificationPermissionGranted = false;

  void setSignupDetails({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required String gender,
    required String handType,
    required String handicap,
    required String shaftLength,
    required String preferredUnit,
    required bool isTrainedBefore,
  }) {
    _firstName = firstName;
    _lastName = lastName;
    _dateOfBirth = dateOfBirth;
    _gender = gender;
    _handType = handType;
    _handicap = handicap;
    _shaftLength = shaftLength;
    _preferredUnit = preferredUnit;
    _isTrainedBefore = isTrainedBefore;
    update();
  }

  void setTrainedBeforeDetails({
    required int currentLevel,
    required int currentDay,
    required bool isSkipped,
    bool hasBaselineMeasurements = false,
  }) {
    _currentLevel = currentLevel;
    _currentDay = currentDay;
    _isSkipped = isSkipped;
    _hasBaselineMeasurements = hasBaselineMeasurements;
    update();
  }

  void setHasBaselineMeasurements(bool hasMeasurements) {
    _hasBaselineMeasurements = hasMeasurements;
    update();
  }

  void setNotificationPermission(bool granted) {
    _notificationPermissionGranted = granted;
    update();
  }

  void setEmail(String value) {
    _email = value;
    update();
  }

  void setPassword(String value) {
    _password = value;
    update();
  }

  void setResetEmail(String value) {
    _resetEmail = value;
    update();
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> login() async {
    if (!isValidEmail(_email)) {
      _showErrorDialog('Login Error', 'Please enter a valid email address');
      return;
    }

    if (_password.isEmpty || _password.length < 6) {
      _showErrorDialog('Login Error', 'Password must be at least 6 characters');
      return;
    }

    _isLoading = true;
    update();

    try {
      final user = await authService.login(_email, _password);
      if (user != null) {
        _isLoading = false;
        update();
        Get.offAllNamed('/home');
      } else {
        _showErrorDialog('Login Error', 'Invalid email or password');
      }
    } catch (e) {
      _isLoading = false;
      _showErrorDialog('Login Error', e.toString());
    }
  }

  Future<void> register() async {
    if (!isValidEmail(_email)) {
      _showErrorDialog('Could not complete sign up', 'Please enter a valid email address');
      return;
    }

    if (_password.isEmpty || _password.length < 6) {
      _showErrorDialog('Could not complete sign up', 'Password must be 6 characters or long.');
      return;
    }

    _isLoading = true;
    update();

    try {
      final user = await authService.register(_email, _password);
      if (user != null) {
        await authService.saveUserDetails(
          userId: user.id,
          firstName: _firstName,
          lastName: _lastName,
          dateOfBirth: _dateOfBirth!,
          gender: _gender,
          handType: _handType,
          handicap: _handicap,
          shaftLength: _shaftLength,
          preferredUnit: _preferredUnit,
          currentLevel: _isTrainedBefore && !_isSkipped ? _currentLevel : 1,
          currentDay: _isTrainedBefore && !_isSkipped ? _currentDay : 1,
        );
        _isLoading = false;
        update();
        Get.offAllNamed('/home');
      } else {
        _showErrorDialog('Could not complete sign up', 'Registration failed. Please try again.');
      }
    } catch (e) {
      _isLoading = false;
      String errorMessage = e.toString();
      if (errorMessage.contains('email') && errorMessage.contains('already in use')) {
        errorMessage = 'The email address is already in use by another account.';
      }
      _showErrorDialog('Could not complete sign up', errorMessage);
    }
  }

  Future<void> sendResetPasswordLink() async {
    if (!isValidEmail(_resetEmail)) {
      _showErrorDialog('Reset Password Error', 'Please enter a valid email address');
      return;
    }

    _isLoading = true;
    update();

    try {
      await authService.sendResetPasswordLink(_resetEmail);
      _isLoading = false;
      _isSuccess = true;
      _errorTitle = 'Success';
      _errorMessage = 'Password reset link has been sent to your email';
      _showError = true;
      update();
    } catch (e) {
      _isLoading = false;
      _showErrorDialog('Reset Password Error', e.toString());
    }
  }

  void dismissDialog() {
    _showError = false;
    _errorMessage = '';
    _errorTitle = '';
    _isSuccess = false;
    update();
  }

  void _showErrorDialog(String title, String message) {
    _errorTitle = title;
    _errorMessage = message;
    _showError = true;
    _isLoading = false;
    update();
  }

  void clearError() {
    _showError = false;
    _errorMessage = '';
    _errorTitle = '';
    _isSuccess = false;
    update();
  }

  Future<bool> checkAccount() async {
    return await authService.checkAccount();
  }

  bool checkAccountSync() {
    final user = authService.getCurrentUser();
    return user != null;
  }

  Future<void> logout() async {
    await authService.logout();
    Get.offAllNamed('/get-started');
  }
}
