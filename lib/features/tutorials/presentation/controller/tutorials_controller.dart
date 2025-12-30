import 'package:get/get.dart';
import '../../data/model/day_protocol.dart';
import '../../data/model/exercise.dart';
import '../../data/model/swing_fix.dart';
import '../../domain/service/tutorials_service.dart';

enum SectionOption { trainingProtocols, swingFixes }

class TutorialsController extends GetxController implements GetxService {
  final TutorialsService tutorialsService;

  TutorialsController({required this.tutorialsService});

  static TutorialsController get find => Get.find<TutorialsController>();

  List<DayProtocol> _protocols = [];
  List<DayProtocol> get protocols => _protocols;

  List<SwingFix> _swingFixes = [];
  List<SwingFix> get swingFixes => _swingFixes;

  int _selectedLevel = 1;
  int get selectedLevel => _selectedLevel;

  SectionOption _selectedSection = SectionOption.trainingProtocols;
  SectionOption get selectedSection => _selectedSection;

  Exercise? _selectedExercise;
  Exercise? get selectedExercise => _selectedExercise;

  SwingFix? _selectedSwingFix;
  SwingFix? get selectedSwingFix => _selectedSwingFix;

  String _warmUpVideoId = 'IF0kLstvX6M';
  String get warmUpVideoId => _warmUpVideoId;

  bool _isWarmUpExpanded = false;
  bool get isWarmUpExpanded => _isWarmUpExpanded;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DayProtocol? get selectedProtocol {
    try {
      return _protocols.firstWhere(
        (p) => p.id == 'level$_selectedLevel',
      );
    } catch (e) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    _isLoading = true;
    update();

    try {
      _protocols = await tutorialsService.getProtocols();
      _swingFixes = await tutorialsService.getSwingFixes();
      _warmUpVideoId = await tutorialsService.getWarmUpVideoId();
    } catch (e) {
    }

    _isLoading = false;
    update();
  }

  void selectLevel(int level) {
    _selectedLevel = level;
    _selectedExercise = null;
    _isWarmUpExpanded = false;
    update();
  }

  void selectSection(SectionOption section) {
    _selectedSection = section;
    _selectedExercise = null;
    _selectedSwingFix = null;
    update();
  }

  void toggleExercise(Exercise exercise) {
    if (_selectedExercise?.id == exercise.id) {
      _selectedExercise = null;
    } else {
      _selectedExercise = exercise;
      _isWarmUpExpanded = false;
    }
    update();
  }

  void toggleSwingFix(SwingFix swingFix) {
    if (_selectedSwingFix?.id == swingFix.id) {
      _selectedSwingFix = null;
    } else {
      _selectedSwingFix = swingFix;
    }
    update();
  }

  void toggleWarmUp() {
    _isWarmUpExpanded = !_isWarmUpExpanded;
    if (_isWarmUpExpanded) {
      _selectedExercise = null;
    }
    update();
  }
}

