import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../imports.dart';
import '../../../home/presentation/controller/home_controller.dart';

class SwingSheetController extends GetxController {
  int _countDown = 5;
  String _countDownString = '5';
  String get countDownString => _countDownString;

  bool _requiresInput = false;
  bool get requiresInput => _requiresInput;

  bool _presentInputField = false;
  bool get presentInputField => _presentInputField;

  final TextEditingController inputController = TextEditingController();
  String _input = '';
  String get input => _input;

  Timer? _mainTimer;
  int _cooldownSeconds = 2;

  String _speedUnit = 'MPH';
  String get speedUnit => _speedUnit;

  bool get confirmActionAllowed {
    final speed = validatedInput;
    return speed != null;
  }

  int? get validatedInput {
    final intInput = int.tryParse(_input);
    if (intInput == null) return null;
    if (intInput >= 20 && intInput <= 200) {
      return intInput;
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    _loadSpeedUnit();
  }

  @override
  void onClose() {
    _mainTimer?.cancel();
    inputController.dispose();
    super.onClose();
  }

  Future<void> _loadSpeedUnit() async {
    try {
      final homeController = Get.find<HomeController>();
      final userStats = homeController.userStats;
      _speedUnit = userStats['speedUnit'] ?? 'MPH';
      update();
    } catch (e) {
      _speedUnit = 'MPH';
    }
  }

  bool _isTimerBased = false;
  bool get isTimerBased => _isTimerBased;
  int? _timerDuration;
  
  void load(bool requiresInput, {bool isTimerBased = false, int? timerDuration}) {
    _requiresInput = requiresInput;
    _isTimerBased = isTimerBased;
    _timerDuration = timerDuration;
    
    if (isTimerBased && timerDuration != null) {
      // Timer-based exercise
      _countDown = timerDuration;
      _countDownString = '$_countDown';
    } else {
      // Swing-based exercise (5 second countdown)
      _countDown = 5;
      _countDownString = '5';
    }
    
    _presentInputField = false;
    _sequenceFinished = false;
    _hasCalledComplete = false;
    _input = '';
    inputController.clear();
    update();
  }

  void beginCountdown() {
    _launchTimer();
  }

  void _launchTimer() {
    _mainTimer?.cancel();
    _mainTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isTimerBased) {
        // Timer-based exercise: countdown from duration to 0
        _countDown--;
        if (_countDown > 0) {
          _countDownString = '$_countDown';
        } else if (_countDown == 0) {
          _countDownString = '0';
          timer.cancel();
          _timerFinishedAction();
        }
      } else {
        // Swing-based exercise: 5, 4, 3, 2, 1, SWING
        _countDown--;
        if (_countDown > 0) {
          _countDownString = '$_countDown';
        } else if (_countDown == 0) {
          _countDownString = 'SWING';
        } else if (_countDown <= -_cooldownSeconds) {
          timer.cancel();
          _timerFinishedAction();
        }
      }
      update();
    });
  }

  void _timerFinishedAction() {
    if (_requiresInput) {
      _presentInputField = true;
      update();
    } else {
      // Auto complete if no input required - don't close, let parent handle
      _sequenceFinished = true;
      update();
    }
  }

  bool _sequenceFinished = false;
  bool get sequenceFinished => _sequenceFinished;
  bool _hasCalledComplete = false;
  bool get hasCalledComplete => _hasCalledComplete;
  
  void markCompleteCalled() {
    _hasCalledComplete = true;
  }

  void updateInput(String value) {
    _input = value;
    update();
  }

  void confirm() {
    _sequenceFinished = true;
    update();
  }

  void reset() {
    if (_isTimerBased && _timerDuration != null) {
      _countDown = _timerDuration!;
      _countDownString = '$_countDown';
    } else {
      _countDown = 5;
      _countDownString = '5';
    }
    _presentInputField = false;
    _sequenceFinished = false;
    _hasCalledComplete = false;
    _input = '';
    inputController.clear();
    _mainTimer?.cancel();
    _isTimerBased = false;
    _timerDuration = null;
    update();
  }

  void invalidateTimers() {
    _mainTimer?.cancel();
  }
}

