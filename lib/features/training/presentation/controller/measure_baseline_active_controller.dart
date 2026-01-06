import 'dart:async';
import 'package:get/get.dart';
import '../../../../imports.dart';
import '../../domain/service/training_service.dart';
import '../../../home/presentation/controller/home_controller.dart';

class MeasureBaselineActiveController extends GetxController {
  final TrainingService trainingService;

  MeasureBaselineActiveController({required this.trainingService});

  Timer? _nextSwingTimer;
  int _nextSwingCountdown = 15;
  String _nextSwingCountdownString = '0:00';
  String get nextSwingCountdownString => _nextSwingCountdownString;

  bool _swingSequenceActive = false;
  bool get swingSequenceActive => _swingSequenceActive;

  bool _trainingCompleted = false;
  bool get trainingCompleted => _trainingCompleted;

  double _trainingProgressPercentage = 0.0;
  double get trainingProgressPercentage => _trainingProgressPercentage;

  List<double> _speedInputs = [];
  List<double> get speedInputs => _speedInputs;

  bool _swingSheetPresented = false;
  bool get swingSheetPresented => _swingSheetPresented;

  String _currentSwingSpeed = '';
  String get currentSwingSpeed => _currentSwingSpeed;
  void setSwingSpeed(String value) {
  _currentSwingSpeed = value;
  update();
}

  double get newBaseline {
    if (_speedInputs.isEmpty) return 0.0;
    return _speedInputs.reduce((a, b) => a + b) / _speedInputs.length;
  }

  String? _baselineVideoId;
  String? get baselineVideoId => _baselineVideoId;

  String _speedUnit = 'MPH';
  String get speedUnit => _speedUnit;

  // int animatedSwingSpeed = 0;

// void startSwingSpeedAnimation(int target) async {
//   animatedSwingSpeed = 0;
//   update();

//   for (int i = 1; i <= target; i++) {
//     await Future.delayed(const Duration(milliseconds: 25));
//     animatedSwingSpeed = i;
//     update();
//   }
// }
int animatedSwingSpeed = 5;

bool showCountdown = false;
bool showSwingText = false;
bool showSpeedRow = false;
void startSwingSpeedAnimation(int finalSpeed) async {
  showCountdown = true;
  showSwingText = false;
  showSpeedRow = false;

  animatedSwingSpeed = 5;
  update();

  /// 🔥 COUNTDOWN: 5 → 1
  for (int i = 5; i >= 1; i--) {
    animatedSwingSpeed = i;
    update();
    await Future.delayed(const Duration(milliseconds: 600));
  }

  /// 🔥 SHOW "SWING"
  showCountdown = false;
  showSwingText = true;
  update();

  await Future.delayed(const Duration(milliseconds: 900));

  /// 🔥 SHOW SPEED ROW
  showSwingText = false;
  showSpeedRow = true;
  animatedSwingSpeed = finalSpeed;
  update();
}

void startSwingSequence() {
  _startSwing();

  /// ✅ START ANIMATION EVEN IF SPEED NOT YET AVAILABLE
  startSwingSpeedAnimation(0);

  Future.delayed(const Duration(seconds: 1), () {
    _swingSequenceActive = true;
    update();
  });
}
bool _countdownStarted = false;
bool swingAnimationPlayed = false; 
bool countdownStarted = false;   
bool showMainUI = false;

void startInitialCountdown1() async {
  if (_countdownStarted) return;
  _countdownStarted = true;

  showCountdown = true;
  showSwingText = false;
  showMainUI = false;
  update();

  /// 5 → 0 countdown
  for (int i = 5; i >= 0; i--) {
    animatedSwingSpeed = i;
    update();
    await Future.delayed(const Duration(milliseconds: 700));
  }

  /// show SWING
  showCountdown = false;
  showSwingText = true;
  update();

  await Future.delayed(const Duration(milliseconds: 900));

  /// show main scaffold content
  showSwingText = false;
  showMainUI = true;
  update();
}
void startInitialCountdown() async {
  if (countdownStarted) return;
  countdownStarted = true;

  showCountdown = true;
  showSwingText = false;
  showMainUI = false;
  swingAnimationPlayed = false;
  String currentSwingSpeed = "0";
  update();

  // 🔹 Countdown 5 → 1
  for (int i = 5; i >= 1; i--) {
    animatedSwingSpeed = i;
    update();
    await Future.delayed(const Duration(milliseconds: 700));
  }

  // 🔹 Show SWING animation once
  showCountdown = false;
  showSwingText = true;
  update();

  await Future.delayed(const Duration(milliseconds: 900));

  // Mark SWING animation as played
  swingAnimationPlayed = true;

  // 🔹 Show main UI (0 MPH + Confirm) with static SWING
  showSwingText = false; // optional, SWING will remain in main UI
  showMainUI = true;
  currentSwingSpeed = "0";
  update();
}
void resetFlow() {
  countdownStarted = false;
  swingAnimationPlayed = false;
  showCountdown = false;
  showSwingText = false;
  showMainUI = false;
  animatedSwingSpeed = 5;
   
}


  @override
  void onInit() {
    super.onInit();
    _loadBaselineVideo();
  }

  @override
  void onClose() {
    _nextSwingTimer?.cancel();
    super.onClose();
  }

  Future<void> _loadBaselineVideo() async {
    try {
      final constants = await trainingService.getTrainingConstants();
      _baselineVideoId = constants['baselineVideoId'];
      _speedUnit = constants['speedUnit'] ?? 'MPH';
      update();
    } catch (e) {
      _baselineVideoId = null;
    }
  }

  // void startSwingSequence() {
  //   _startSwing();
  //   Future.delayed(const Duration(seconds: 1), () {
  //     _swingSequenceActive = true;
  //     update();
  //   });
  // }

  void _startSwing() {
    _swingSheetPresented = true;
    _currentSwingSpeed = '';
    update();
  }

  void finishSwing() {
    _swingSheetPresented = false;
    _swingSequenceActive = false;
    _trainingProgressPercentage = (_speedInputs.length / 5).clamp(0.0, 1.0);
    
    if (_speedInputs.length >= 5) {
      _trainingCompleted = true;
    } else {
      _countDownToNextSwing();
    }
    update();
  }

  void addSwingSpeedDigit(String digit) {
    _currentSwingSpeed += digit;
    update();
  }

  void removeSwingSpeedDigit() {
    if (_currentSwingSpeed.isNotEmpty) {
      _currentSwingSpeed = _currentSwingSpeed.substring(0, _currentSwingSpeed.length - 1);
      update();
    }
  }

  void confirmSwingSpeed() {
    final speed = double.tryParse(_currentSwingSpeed);
    if (speed != null && speed > 0) {
      _speedInputs.add(speed);
      finishSwing();
    }
  }

  void _countDownToNextSwing() {
    _nextSwingCountdown = 15;
    _nextSwingCountdownString = _timerString(_nextSwingCountdown);
    _nextSwingTimer?.cancel();
    _nextSwingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_nextSwingCountdown == 0) {
        timer.cancel();
        _swingSequenceActive = true;
        update();
      } else {
        _nextSwingCountdown--;
        _nextSwingCountdownString = _timerString(_nextSwingCountdown);
        update();
      }
    });
    update();
  }

  String _timerString(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> finishTraining() async {
    try {
      if (_speedInputs.isNotEmpty) {
        await trainingService.updateBaseline(newBaseline.toInt(), isOriginal: true);
        final homeController = Get.find<HomeController>();
        homeController.refreshData();
      }
      Get.back();
    } catch (e) {
      showToast('Error saving baseline');
    }
  }
}

