import 'dart:async';
import 'package:get/get.dart';
import '../../../../imports.dart';
import '../../data/model/exercise_data.dart';
import '../../domain/service/training_service.dart';

class TrainingController extends GetxController implements GetxService {
  final TrainingService trainingService;

  TrainingController({required this.trainingService});

  static TrainingController get find => Get.find<TrainingController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ExerciseData> _trainingExercises = [];
  List<ExerciseData> get trainingExercises => _trainingExercises;

  int _currentStep = 0;
  int get currentStep => _currentStep;

  int _savedStep = 0;
  int get savedStep => _savedStep;

  bool _showTimer = false;
  bool get showTimer => _showTimer;

  bool _showTrainingDetails = false;
  bool get showTrainingDetails => _showTrainingDetails;

  bool _inputBaselineView = false;
  bool get inputBaselineView => _inputBaselineView;

  bool _showSwingCount = false;
  bool get showSwingCount => _showSwingCount;

  bool _showSwingSpeedInput = false;
  bool get showSwingSpeedInput => _showSwingSpeedInput;

  int _currentSwingNumber = 1;
  int get currentSwingNumber => _currentSwingNumber;

  String _currentSwingSpeed = '';
  String get currentSwingSpeed => _currentSwingSpeed;

  bool _trainingFinishView = false;
  bool get trainingFinishView => _trainingFinishView;

  bool _isPaused = false;
  bool get isPaused => _isPaused;

  int _pauseValue = -1;
  int get pauseValue => _pauseValue;

  double _progress = 0.0;
  double get progress => _progress;

  List<int> _baselineInputs = [];
  List<int> get baselineInputs => _baselineInputs;

  int _baselineCompleted = 0;
  int get baselineCompleted => _baselineCompleted;

  bool _baselineExists = false;
  bool get baselineExists => _baselineExists;

  String _speedUnit = 'MPH';
  String get speedUnit => _speedUnit;

  String _distanceUnit = 'YDS';
  String get distanceUnit => _distanceUnit;

  int _currentLevel = 1;
  int get currentLevel => _currentLevel;

  int _currentDay = 1;
  int get currentDay => _currentDay;

  Timer? _timer;
  int _currentTime = 0;
  int get currentTime => _currentTime;

  @override
  void onInit() {
    super.onInit();
    loadTrainingData();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> loadTrainingData() async {
    _isLoading = true;
    update();

    try {
      _savedStep = await trainingService.getSavedStep();
      final baselineData = await trainingService.getBaselineData();
      _baselineExists = baselineData.containsKey('currentBaseline');
      _speedUnit = baselineData['speedUnit'] ?? 'MPH';
      _distanceUnit = baselineData['distanceUnit'] ?? 'YDS';

      if (_baselineExists) {
        _trainingExercises = await trainingService.getTrainingExercises(_currentLevel, _currentDay);
      } else {
        _trainingExercises = await trainingService.getBaselineExercises();
      }

      if (_savedStep > 0 && _trainingExercises.isNotEmpty) {
        _currentStep = _savedStep;
      }
    } catch (e) {
      showToast('error_loading_training'.tr);
    }

    _isLoading = false;
    update();
  }

  void startTraining() {
    _showTrainingDetails = true;
    _showTimer = false;
    _trainingFinishView = false;
    _inputBaselineView = false;
    _currentStep = 0;
    _progress = 0.0;
    update();
  }

  void nextStep() {
    if (_currentStep < _trainingExercises.length - 1) {
      _currentStep++;
      _progress = (_currentStep / _trainingExercises.length) * 100;
      _showTrainingDetails = true;
      _showTimer = false;
      update();
    }
  }

  void startTimer(int seconds) {
    _currentTime = seconds;
    _showTimer = true;
    _showTrainingDetails = false;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentTime > 0 && !_isPaused) {
        _currentTime--;
        update();
      } else if (_currentTime == 0) {
        timer.cancel();
        _showTimer = false;
        update();
      }
    });
    update();
  }

  void pauseResume() {
    _isPaused = !_isPaused;
    _pauseValue = _currentTime;
    update();
  }

  void showInputBaseline() {
    _showTimer = false;
    _showTrainingDetails = false;
    _inputBaselineView = true;
    _showSwingCount = false;
    _showSwingSpeedInput = false;
    update();
  }

  void showSwingCountScreen(int swingNumber) {
    _currentSwingNumber = swingNumber;
    _showSwingCount = true;
    _showTimer = false;
    _showTrainingDetails = false;
    _inputBaselineView = false;
    _showSwingSpeedInput = false;
    update();
    // Auto navigate to speed input after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      if (_showSwingCount) {
        showSwingSpeedInputScreen();
      }
    });
  }

  void showSwingSpeedInputScreen() {
    _currentSwingSpeed = '';
    _showSwingSpeedInput = true;
    _showSwingCount = false;
    _showTimer = false;
    _showTrainingDetails = false;
    _inputBaselineView = false;
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
    final speed = int.tryParse(_currentSwingSpeed);
    if (speed != null && speed > 0) {
      addBaselineInput(speed);
      _currentSwingNumber++;
      if (_currentSwingNumber <= 5) {
        showSwingCountScreen(_currentSwingNumber);
      } else {
        _showSwingSpeedInput = false;
        _showSwingCount = false;
        update();
      }
    }
  }

  void addBaselineInput(int value) {
    _baselineInputs.add(value);
    if (_baselineInputs.length >= 5) {
      _baselineCompleted = (_baselineInputs.reduce((a, b) => a + b) / _baselineInputs.length).round();
      _showTrainingDetails = false;
      _inputBaselineView = false;
      _trainingFinishView = true;
      _progress = 100.0;
      updateBaseline(_baselineCompleted);
    } else {
      _showTrainingDetails = true;
      _inputBaselineView = false;
    }
    _currentStep++;
    _progress = (_currentStep / _trainingExercises.length) * 100;
    update();
  }

  Future<void> updateBaseline(int value) async {
    try {
      await trainingService.updateBaseline(value);
    } catch (e) {
      showToast('error_updating_baseline'.tr);
    }
  }

  Future<void> saveStep() async {
    try {
      await trainingService.saveTrainingStep(_currentStep);
    } catch (e) {
      showToast('error_saving_step'.tr);
    }
  }

  void quitTraining() {
    saveStep();
    _timer?.cancel();
    Get.back();
  }

  void finishTraining() {
    _timer?.cancel();
    _showTimer = false;
    _showTrainingDetails = false;
    _trainingFinishView = true;
    update();
  }

  ExerciseData? getCurrentExercise() {
    if (_currentStep < _trainingExercises.length) {
      return _trainingExercises[_currentStep];
    }
    return null;
  }
}

