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
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Iconsax.home),
          label: 'home'.tr,
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.document),
          label: 'feed'.tr,
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.chart),
          label: 'progress'.tr,
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.award),
          label: 'rewards'.tr,
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.user),
          label: 'account'.tr,
        ),
      ],
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

