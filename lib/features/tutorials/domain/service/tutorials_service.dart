import '../../data/model/day_protocol.dart';
import '../../data/model/swing_fix.dart';

abstract class TutorialsService {
  Future<List<DayProtocol>> getProtocols();
  Future<List<SwingFix>> getSwingFixes();
  Future<String> getWarmUpVideoId();
}


