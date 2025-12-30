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

  double get newBaseline {
    if (_speedInputs.isEmpty) return 0.0;
    return _speedInputs.reduce((a, b) => a + b) / _speedInputs.length;
  }

  String? _baselineVideoId;
  String? get baselineVideoId => _baselineVideoId;

  String _speedUnit = 'MPH';
  String get speedUnit => _speedUnit;

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

  void startSwingSequence() {
    _startSwing();
    Future.delayed(const Duration(seconds: 1), () {
      _swingSequenceActive = true;
      update();
    });
  }

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

