import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/imports.dart';
import '../controller/home_controller.dart';
import '../../data/model/home_menu.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: Get.find<HomeController>(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          bottomNavigationBar: _buildBottomNavBar(context),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  _buildLogo(),
                  SizedBox(height: 24.h),
                  _buildVideoPlayer(controller, context),
                  SizedBox(height: 24.h),
                  _buildMenuList(controller, context),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset(
        Images.logo,
        height: 50.h,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildVideoPlayer(HomeController controller, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Container(
            height: 200.h,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 16.w,
                  top: 16.h,
                  child: Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Video unavailable',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'This video is unavailable',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 16.h,
                  right: 16.w,
                  child: Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                    size: 32.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            height: 1,
            color: Colors.grey[800],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList(HomeController controller, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: List.generate(controller.homeMenuList.length, (index) {
          final menu = controller.homeMenuList[index];
          return _buildMenuItem(menu, index, controller, context);
        }),
      ),
    );
  }

  Widget _buildMenuItem(HomeMenu menu, int index, HomeController controller, BuildContext context) {
    final isFirstItem = index == 0;
    final isUpgradeItem =
        menu.title.toLowerCase().contains('upgrade') || menu.title.toLowerCase().contains('pro plan');
    final cardColor = (isFirstItem || isUpgradeItem) ? const Color(0xFF4CAF50) : Colors.grey[900];

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: menu.enabled ? () => controller.onMenuTap(index) : null,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menu.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (menu.description.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          menu.description,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16.sp,
                            letterSpacing: 0.0,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (menu.enabled)
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 18.sp,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return AppBottomNavBar(
      currentIndex: 0,
      onTap: AppBottomNavBar.navigateToScreen,
    );
  }
}
