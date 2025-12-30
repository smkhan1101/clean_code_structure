import '../../data/model/day_protocol.dart';
import '../../data/model/swing_fix.dart';
import '../../data/repository/tutorials_repo_interface.dart';
import 'tutorials_service.dart';

class TutorialsServiceImpl implements TutorialsService {
  final TutorialsRepo tutorialsRepo;

  TutorialsServiceImpl({required this.tutorialsRepo});

  @override
  Future<List<DayProtocol>> getProtocols() async {
    return await tutorialsRepo.getProtocols();
  }

  @override
  Future<List<SwingFix>> getSwingFixes() async {
    return await tutorialsRepo.getSwingFixes();
  }

  @override
  Future<String> getWarmUpVideoId() async {
    return await tutorialsRepo.getWarmUpVideoId();
  }
}


