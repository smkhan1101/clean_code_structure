import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../imports.dart';
import '../../domain/service/training_service.dart';

class AlternativeBaselineInputController extends GetxController {
  final TrainingService trainingService;

  AlternativeBaselineInputController({required this.trainingService});

  final TextEditingController inputController = TextEditingController();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _resultPresented = false;
  bool get resultPresented => _resultPresented;

  bool _submittedBaseline = false;
  bool get submittedBaseline => _submittedBaseline;

  double? _approximateBaseline;
  double? get approximateBaseline => _approximateBaseline;

  String _distanceUnit = 'YDS';
  String get distanceUnit => _distanceUnit;

  String _speedUnit = 'MPH';
  String get speedUnit => _speedUnit;

  @override
  void onInit() {
    super.onInit();
    _loadUnits();
    inputController.addListener(_onInputChanged);
  }

  @override
  void onClose() {
    inputController.removeListener(_onInputChanged);
    inputController.dispose();
    super.onClose();
  }

  Future<void> _loadUnits() async {
    try {
      final userData = await trainingService.getUserData();
      _distanceUnit = userData['distanceUnit'] ?? 'YDS';
      _speedUnit = userData['speedUnit'] ?? 'MPH';
      update();
    } catch (e) {
      // Use defaults
    }
  }

  void _onInputChanged() {
    final value = double.tryParse(inputController.text);
    if (value != null && value > 0) {
      _approximateBaseline = _calculateBaselineFromDistance(value);
    } else {
      _approximateBaseline = null;
    }
    update();
  }

  void updateInput(String value) {
    _onInputChanged();
  }

  double _calculateBaselineFromDistance(double distance) {
    if (_distanceUnit == 'YDS') {
      return (distance * 2.3).clamp(0, 200);
    } else {
      return (distance * 2.5).clamp(0, 200);
    }
  }

  Future<void> submitBaseline() async {
    if (_approximateBaseline == null) return;

    _isLoading = true;
    update();

    try {
      await trainingService.updateBaseline(_approximateBaseline!.toInt(), isOriginal: true);
      await trainingService.setRadarOption('noRadar');
      _submittedBaseline = true;
      _resultPresented = true;
      _isLoading = false;
      update();
    } catch (e) {
      _isLoading = false;
      showToast('Error saving baseline');
      update();
    }
  }
}

