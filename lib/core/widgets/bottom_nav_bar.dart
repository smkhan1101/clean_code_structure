import 'package:startup_repo/imports.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
        iconSize: 24.sp,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: _buildSvgIcon('assets/images/buttom nav/home.svg', Colors.grey),
            activeIcon: _buildSvgIcon('assets/images/buttom nav/home.svg', const Color(0xFF4CAF50)),
            label: 'Home'.tr,
          ),
          BottomNavigationBarItem(
            icon: _buildSvgIcon('assets/images/buttom nav/feed.svg', Colors.grey),
            activeIcon: _buildSvgIcon('assets/images/buttom nav/feed.svg', const Color(0xFF4CAF50)),
            label: 'Feed'.tr,
          ),
          BottomNavigationBarItem(
            icon: _buildSvgIcon('assets/images/buttom nav/progress.svg', Colors.grey),
            activeIcon: _buildSvgIcon('assets/images/buttom nav/progress.svg', const Color(0xFF4CAF50)),
            label: 'Progress'.tr,
          ),
          BottomNavigationBarItem(
            icon: _buildSvgIcon('assets/images/buttom nav/rewards.svg', Colors.grey),
            activeIcon: _buildSvgIcon('assets/images/buttom nav/rewards.svg', const Color(0xFF4CAF50)),
            label: 'Rewards'.tr,
          ),
          BottomNavigationBarItem(
            icon: _buildSvgIcon('assets/images/buttom nav/account.svg', Colors.grey),
            activeIcon: _buildSvgIcon('assets/images/buttom nav/account.svg', const Color(0xFF4CAF50)),
            label: 'Account'.tr,
          ),
        ],
      ),
    );
  }

  Widget _buildSvgIcon(String assetPath, Color color) {
    return SvgPicture.asset(
      assetPath,
      width: 24.sp,
      height: 24.sp,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      fit: BoxFit.contain,
    );
  }

  static void navigateToScreen(int index) {
    switch (index) {
      case 0:
        Get.offAllNamed('/home');
        break;
      case 1:
        Get.toNamed('/feed');
        break;
      case 2:
        Get.toNamed('/progress');
        break;
      case 3:
        Get.toNamed('/rewards');
        break;
      case 4:
        Get.toNamed('/settings');
        break;
    }
  }
}
