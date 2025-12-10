import 'package:startup_repo/imports.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('progress'.tr)),
      bottomNavigationBar: _buildBottomNavBar(context, 2),
      body: Center(
        child: Text(
          'progress_screen_coming_soon'.tr,
          style: context.font16,
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
    return AppBottomNavBar(
      currentIndex: currentIndex,
      onTap: AppBottomNavBar.navigateToScreen,
    );
  }
}

