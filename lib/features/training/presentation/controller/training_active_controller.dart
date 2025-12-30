import 'dart:async';
import 'package:get/get.dart';
import '../../../../imports.dart';
import '../../data/model/exercise_data.dart';
import '../../domain/service/training_service.dart';
import '../../../home/presentation/controller/home_controller.dart';
import 'swing_sheet_controller.dart';

class TrainingActiveController extends GetxController {
  final TrainingService trainingService;

  TrainingActiveController({required this.trainingService});

  Timer? _timer;
  int _secondsPlayed = 0;
  String _clockString = '0:00';
  String get clockString => _clockString;

  Timer? _nextSwingTimer;
  int _nextSwingCountdown = 15;
  String _nextSwingCountdownString = '0:00';
  bool _nextSwingTimerPaused = false;
  String get nextSwingCountdownString => _nextSwingCountdownString;
  bool get nextSwingTimerPaused => _nextSwingTimerPaused;

  bool _swingSequenceActive = false;
  bool get swingSequenceActive => _swingSequenceActive;

  bool _swingSheetPresented = false;
  bool get swingSheetPresented => _swingSheetPresented;

  bool _notifyWeightSwitch = false;
  bool _notifySideSwitch = false;
  bool _notifyExerciseSwitch = false;
  bool get notifyExerciseSwitch => _notifyExerciseSwitch;

  List<ExerciseData> _dayProtocol = [];
  ExerciseData? _currentAction;
  ExerciseData? get currentAction => _currentAction;
  int _currentSwingNo = 0;

  bool _trainingCompleted = false;
  bool get trainingCompleted => _trainingCompleted;

  double _trainingProgressPercentage = 0.0;
  double get trainingProgressPercentage => _trainingProgressPercentage;

  List<double> _baselineSpeeds = [];
  List<double> get baselineSpeeds => _baselineSpeeds;

  double get newBaseline {
    if (_baselineSpeeds.isEmpty) return 0.0;
    return _baselineSpeeds.reduce((a, b) => a + b) / _baselineSpeeds.length;
  }

  String get nextSwingNotification {
    if (_notifyExerciseSwitch) {
      return 'NEXT EXERCISE';
    } else if (_notifyWeightSwitch) {
      return 'ADD ONE WEIGHT';
    } else if (_notifySideSwitch) {
      return 'SWITCH SIDES';
    }
    return 'PREPARE TO SWING';
  }

  int get nextSwingCountdownSeconds {
    if (_notifyWeightSwitch) return 30;
    if (_notifySideSwitch) return 20;
    return 15;
  }

  String _speedUnit = 'MPH';
  String get speedUnit => _speedUnit;

  @override
  void onInit() {
    super.onInit();
    _launchTimer();
    _initializeTraining();
  }

  Future<void> _initializeTraining() async {
    await _loadUnfinishedTraining();
    if (_currentAction == null) {
      await _setUpTraining();
    }
    update();
  }

  @override
  void onClose() {
    _timer?.cancel();
    _nextSwingTimer?.cancel();
    super.onClose();
  }

  void _launchTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsPlayed++;
      _clockString = _timerString(_secondsPlayed);
      update();
    });
  }

  String _timerString(int secondsPlayed) {
    final hoursPlayed = secondsPlayed ~/ 3600;
    final minutesPlayed = (secondsPlayed ~/ 60) - (hoursPlayed * 60);
    final adaptedSecondsPlayed = secondsPlayed - (minutesPlayed * 60) - (hoursPlayed * 3600);

    var clockString = '';
    if (hoursPlayed > 0) {
      clockString = '$hoursPlayed:';
    }
    if (minutesPlayed.toString().length < 2 && hoursPlayed > 0) {
      clockString += '0';
    }
    clockString += '$minutesPlayed:';
    if (adaptedSecondsPlayed.toString().length < 2) {
      clockString += '0';
    }
    clockString += adaptedSecondsPlayed.toString();

    return clockString;
  }

  Future<void> _loadUnfinishedTraining() async {
    try {
      final trainingData = await trainingService.getUnfinishedTraining();
      if (trainingData.isNotEmpty) {
        _baselineSpeeds = (trainingData['speedInputs'] as List<dynamic>?)
                ?.map((e) => (e as num).toDouble())
                .toList() ??
            [];
        _dayProtocol = (trainingData['exercises'] as List<dynamic>?)
                ?.map((e) => ExerciseData.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
        final currentActionIndex = trainingData['currentActionIndex'] ?? 0;
        if (currentActionIndex < _dayProtocol.length) {
          _currentAction = _dayProtocol[currentActionIndex];
        }
        _currentSwingNo = trainingData['currentSwingNo'] ?? 0;
      }
    } catch (e) {
      // Continue to setup if loading fails
    }
  }

  Future<void> _setUpTraining() async {
    try {
      final homeController = Get.find<HomeController>();
      final protocolData = await trainingService.getProtocolData(
        homeController.currentLevel,
        homeController.currentDay,
      );
      
      final actions = (protocolData['actions'] as List<dynamic>?) ?? [];
      _dayProtocol = [];
      
      for (final actionData in actions) {
        final actionMap = actionData as Map<String, dynamic>;
        final exerciseData = actionMap['exercise'] as Map<String, dynamic>?;
        if (exerciseData != null) {
          final exercise = ExerciseData.fromJson(exerciseData);
          exercise.exerciseName = exercise.exerciseName.isNotEmpty 
              ? exercise.exerciseName 
              : (exerciseData['title'] as String? ?? '');
          
          exercise.videoId = exerciseData['videoId'] as String? ?? '';
          
          // Set action-specific parameters
          final dominantValue = actionMap['dominant'] as bool?;
          exercise.dominant = dominantValue ?? false;
          exercise.weight = actionMap['weight'] as int? ?? 0;
          exercise.requiresInput = actionMap['requiresInput'] as bool? ?? false;
          exercise.allowDriver = actionMap['allowDriver'] as bool? ?? false;
          
          // Handle count and durationSeconds
          final count = actionMap['count'] as int? ?? 5;
          exercise.count = count;
          
          // Check for timer-based exercise
          final durationSeconds = actionMap['durationSeconds'] as int?;
          if (durationSeconds != null) {
            exercise.durationSeconds = durationSeconds;
            exercise.time = durationSeconds; // For timer-based exercises
          } else if (count == 0) {
            // If count is 0 but no durationSeconds, use exercise time
            exercise.time = exercise.time > 0 ? exercise.time : 0;
          } else {
            // Swing-based exercise
            exercise.time = 0;
          }
          
          _dayProtocol.add(exercise);
        }
      }
      
      if (_dayProtocol.isNotEmpty) {
        _currentAction = _dayProtocol[0];
      }
      _currentSwingNo = 0;
    } catch (e) {
      showToast('Error loading training');
    }
  }

  void startSwingSequence() {
    _startSwing();
    // Set swingSequenceActive after a delay to show countdown UI
    Future.delayed(const Duration(milliseconds: 500), () {
      _swingSequenceActive = true;
      update();
    });
  }

  void _startSwing() {
    _saveUnfinishedTraining();
    _notifyExerciseSwitch = false;
    _notifyWeightSwitch = false;
    _notifySideSwitch = false;
    _swingSequenceActive = false; // Hide countdown during swing
    _swingSheetPresented = true;
    final swingSheetController = Get.find<SwingSheetController>();
    
    // Check if timer-based exercise
    final isTimerBased = _currentAction?.count == 0 || 
                        _currentAction?.durationSeconds != null || 
                        (_currentAction?.time ?? 0) > 0;
    final timerDuration = _currentAction?.durationSeconds ?? 
                        ((_currentAction?.time ?? 0) > 0 ? _currentAction!.time : null) ?? 
                        5;
    
    swingSheetController.load(
      _currentAction?.requiresInput ?? false,
      isTimerBased: isTimerBased,
      timerDuration: isTimerBased ? timerDuration : null,
    );
    swingSheetController.beginCountdown();
    update();
  }

  void finishSwing() {
    _swingSheetPresented = false;
    _trainingProgressPercentage = _actionsCompleted / _totalActions;
    // Don't set swingSequenceActive here - it will be set when countdown starts
    update();
  }

  void prepareNextSwing() {
    if (_currentAction == null) return;
    
    // Check if we've completed all swings for current action
    final actionCount = _getActionCount(_currentAction!);
    if (_currentSwingNo >= actionCount - 1) {
      // Move to next action (this will set appropriate notification flags)
      _moveToNextAction();
    } else {
      // Same action, just another swing - increment swing number
      _currentSwingNo++;
      // Reset all notification flags for same action continuation
      _notifyWeightSwitch = false;
      _notifySideSwitch = false;
      _notifyExerciseSwitch = false;
    }
    
    _swingSequenceActive = false;
    update();
  }

  void _moveToNextAction() {
    if (_currentAction == null || _dayProtocol.isEmpty) return;

    final currentIndex = _dayProtocol.indexOf(_currentAction!);
    if (currentIndex == -1 || currentIndex >= _dayProtocol.length - 1) {
      _activeFinishTraining();
      return;
    }

    // Reset all notification flags first
    _notifyExerciseSwitch = false;
    _notifyWeightSwitch = false;
    _notifySideSwitch = false;

    final newAction = _dayProtocol[currentIndex + 1];
    
    // Check changes in priority order: Exercise > Weight > Side
    // Use exerciseName for comparison (derived from exerciseId)
    if (newAction.exerciseName != _currentAction!.exerciseName) {
      _notifyExerciseSwitch = true;
    } else if (newAction.weight != _currentAction!.weight) {
      _notifyWeightSwitch = true;
    } else if (newAction.dominant != _currentAction!.dominant) {
      _notifySideSwitch = true;
    }

    _currentAction = newAction;
    _currentSwingNo = 0;
    update();
  }

  int _getActionCount(ExerciseData action) {
    // Timer-based exercise: count = 0 OR durationSeconds exists OR time > 0
    if (action.count == 0 || action.durationSeconds != null || action.time > 0) {
      return 1; // Timer-based = 1 action
    }
    // Swing-based exercise: use count (default 5)
    return action.count > 0 ? action.count : 5;
  }

  void countDownToNextSwing({bool restart = true, int? seconds}) {
    if (restart) {
      _nextSwingCountdown = seconds ?? nextSwingCountdownSeconds;
      _nextSwingCountdownString = _timerString(_nextSwingCountdown);
      _nextSwingTimerPaused = false;
    }
    _nextSwingTimer?.cancel();
    
    // Show countdown UI
    _swingSequenceActive = true;
    update();
    
    _nextSwingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_nextSwingCountdown == 0) {
        timer.cancel();
        _swingSequenceActive = false; // Hide countdown before starting swing
        _startSwing();
      } else if (!_nextSwingTimerPaused) {
        _nextSwingCountdown--;
        _nextSwingCountdownString = _timerString(_nextSwingCountdown);
        update();
      }
    });
  }

  void toggleNextSwingTimer() {
    final isTimerActive = _nextSwingTimer?.isActive ?? false;
    
    if (isTimerActive && !_nextSwingTimerPaused) {
      // Pause the timer
      _nextSwingTimerPaused = true;
      _nextSwingTimer?.cancel();
      update();
    } else if (_nextSwingTimerPaused || !isTimerActive) {
      // Resume the timer
      _nextSwingTimerPaused = false;
      if (_nextSwingCountdown > 0) {
        _nextSwingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (_nextSwingCountdown == 0) {
            timer.cancel();
            _swingSequenceActive = false;
            _startSwing();
          } else if (!_nextSwingTimerPaused) {
            _nextSwingCountdown--;
            _nextSwingCountdownString = _timerString(_nextSwingCountdown);
            update();
          }
        });
        update();
      }
    }
  }

  void _activeFinishTraining() {
    _trainingCompleted = true;
    _swingSequenceActive = false;
    update();
  }

  void quit() {
    _saveUnfinishedTraining();
    final homeController = Get.find<HomeController>();
    homeController.refreshData();
    Get.back();
  }

  Future<void> finishTraining() async {
    _trainingCompleted = true;
    
    // Clear unfinished training
    await trainingService.clearUnfinishedTraining();
    
    // Update day progression
    final homeController = Get.find<HomeController>();
    int newDay = homeController.currentDay + 1;
    int newLevel = homeController.currentLevel;
    
    // If day exceeds 12, move to next level
    if (newDay > 12) {
      newLevel += 1;
      newDay = 1;
    }
    
    // Update timeline in Firestore
    await trainingService.updateTimeline(newLevel, newDay);
    
    // Update baseline if speeds were collected
    if (_baselineSpeeds.isNotEmpty) {
      final newBaselineValue = newBaseline;
      await trainingService.updateBaselineValue(newBaselineValue, isOriginal: false);
    }
    
    // Refresh home screen data
    homeController.refreshData();
    
    Get.back();
  }

  int get _actionsCompleted {
    if (_currentAction == null || _dayProtocol.isEmpty) return 0;
    return _dayProtocol.indexOf(_currentAction!);
  }

  int get _totalActions => _dayProtocol.length;

  String get baselineDifferenceDescription {
    final oldBaseline = Get.find<HomeController>().userStats['currentBaseline'] ?? 0.0;
    final diff = newBaseline - oldBaseline;
    final sign = diff >= 0 ? '+' : '';
    return '$sign${diff.toStringAsFixed(1)}';
  }

  void addBaselineSpeed(double speed) {
    _baselineSpeeds.add(speed);
    _saveUnfinishedTraining();
    update();
  }

  Future<void> _saveUnfinishedTraining() async {
    try {
      await trainingService.saveUnfinishedTraining({
        'speedInputs': _baselineSpeeds,
        'exercises': _dayProtocol.map((e) => e.toJson()).toList(),
        'currentActionIndex': _dayProtocol.indexOf(_currentAction ?? _dayProtocol.first),
        'currentSwingNo': _currentSwingNo,
      });
    } catch (e) {
      // Silent fail
    }
  }

  void shareWorkout() {
    // TODO: Implement share functionality
    showToast('Share functionality coming soon');
  }
}

