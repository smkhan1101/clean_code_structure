import '../model/day_protocol.dart';
import '../model/swing_fix.dart';

abstract class TutorialsRepo {
  Future<List<DayProtocol>> getProtocols();
  Future<List<SwingFix>>                                   getSwingFixes();
  Future<String> getWarmUpVideoId();
}


