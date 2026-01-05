import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/imports.dart';
import '../controller/home_controller.dart';
import '../../data/model/home_menu.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../auth/presentation/controller/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: Get.find<HomeController>(),
      builder: (controller) {
        return GetBuilder<AuthController>(
          builder: (authController) {
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
    final hasOriginalBaseline = controller.baselineExists;

    if (!hasOriginalBaseline) {
      final videoId =
          YoutubePlayer.convertUrlToId('https://www.youtube.com/watch?v=IF0kLstvX6M') ?? 'IF0kLstvX6M';
      final youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(
              height: 200.h,
              child: _buildVideoCard(youtubeController),
            ),
            SizedBox(height: 16.h),
            Container(
              height: 1,
              color: Colors.grey[600],
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          SizedBox(
            height: 160.h,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: _buildCalendarTile(controller),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: _buildStatsTile(controller),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            height: 1,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(YoutubePlayerController youtubeController) {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: YoutubePlayer(
          controller: youtubeController,
          showVideoProgressIndicator: true,
          progressIndicatorColor: const Color(0xFF4CAF50),
          progressColors: const ProgressBarColors(
            playedColor: Color(0xFF4CAF50),
            handleColor: Color(0xFF4CAF50),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarTile(HomeController controller) {
    return GestureDetector(
      onTap: () => controller.openCalendar(),
      child: Container(
        height: 160.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF191919),
              Color(0xFF252525),
            ],
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calendar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 7.h),
            _buildCalendarPlaceholder(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarPlaceholder() {
    final daysIncluded = [
      [false, false, false, true, true, true, true],
      [true, true, true, true, true, true, true],
      [true, true, true, true, true, true, true],
      [true, true, true, true, true, true, true],
      [true, true, true, true, true, true, false],
    ];

    return Column(
      children: daysIncluded.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((value) {
            return Container(
              width: 6.w,
              height: 6.w,
              margin: EdgeInsets.all(1.5.w),
              decoration: BoxDecoration(
                color: value ? Colors.grey : Colors.grey.withOpacity(0.35),
                shape: BoxShape.circle,
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildStatsTile(HomeController controller) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/progress');
      },
      child: Container(
        height: 160.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF237537),
              Color(0xFF33C258),
            ],
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.h),
            if (controller.userStats.isNotEmpty) ...[
              Text(
                controller.speedDescription,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'SPEED: ${controller.speedDeltaDescription}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 14.sp,
                ),
              ),
              Text(
                'DIST: ${controller.distanceDeltaDescription}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 14.sp,
                ),
              ),
            ] else
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
          ],
        ),
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
    final useGradient = isFirstItem || isUpgradeItem;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        gradient: useGradient
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF237537),
                  Color(0xFF33C258),
                ],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF191919),
                  Color(0xFF252525),
                ],
              ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: menu.enabled && !(menu.isLoading) ? () => controller.onMenuTap(index) : null,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(14.w),
            child: (menu.isLoading)
                ? Center(
                    child: SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                : Row(
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
                              SizedBox(height: 0.h),
                              Text(
                                menu.description,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 18.sp,
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (menu.enabled)
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 24.sp,
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
