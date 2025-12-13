import 'package:audioplayers/audioplayers.dart';
import 'package:startup_repo/imports.dart';
import '../controller/training_controller.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _previousCountdownValue;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSoundEffect(int countdownValue) async {
    try {
      if (countdownValue <= 5 && countdownValue > 0) {
        final soundFile = countdownValue == 5 ? 'sounds/long_sound.mp3' : 'sounds/small_sound.mp3';

        await _audioPlayer.stop();
        await _audioPlayer.play(AssetSource(soundFile));
      }
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrainingController>(
      builder: (controller) {
        final currentValue = controller.countdownValue;

        if (_previousCountdownValue == null) {
          _previousCountdownValue = currentValue;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _playSoundEffect(currentValue);
          });
        } else if (_previousCountdownValue != currentValue) {
          _playSoundEffect(currentValue);
          _previousCountdownValue = currentValue;
        }

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF237537),
                  Color(0xFF33C558),
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Text(
                  '$currentValue',
                  style: TextStyle(
                    fontSize: 50.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
