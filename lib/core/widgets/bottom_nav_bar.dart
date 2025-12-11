import 'package:startup_repo/imports.dart';

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
            icon: Icon(Iconsax.home),
            activeIcon: Icon(Iconsax.home),
            label: 'home'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.document),
            activeIcon: Icon(Iconsax.document),
            label: 'feed'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.chart),
            activeIcon: Icon(Iconsax.chart),
            label: 'progress'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.award),
            activeIcon: Icon(Iconsax.award),
            label: 'rewards'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.user),
            activeIcon: Icon(Iconsax.user),
            label: 'account'.tr,
          ),
        ],
      ),
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
