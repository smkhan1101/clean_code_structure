import 'package:startup_repo/imports.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: _buildBottomNavBar(context, 3),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 60.h),
            Padding(
              padding: EdgeInsets.only(left: 20.sp),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Rewards'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.h),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20.sp,
                  mainAxisSpacing: 20.h,
                  childAspectRatio: 0.8,
                ),
                itemCount: _rewards.length,
                itemBuilder: (context, index) {
                  final reward = _rewards[index];
                  return _buildRewardItem(reward, context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardItem(RewardItem reward, BuildContext context) {
    final isActive = reward.isAvailable;
    return GestureDetector(
      onTap: () => _showRewardModal(context, reward),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 90.sp,
            height: 90.sp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[900],
              border: Border.all(
                color: isActive ? const Color(0xFF4CAF50) : Colors.grey[600]!,
                width: 4.sp,
              ),
            ),
            child: Center(
              child: reward.icon == Icons.bar_chart
                  ? _buildBarChartIcon(
                      size: 55.sp,
                      color: isActive ? const Color(0xFF4CAF50) : Colors.grey[400]!,
                    )
                  : Icon(
                      reward.icon,
                      size: 55.sp,
                      color: isActive ? const Color(0xFF4CAF50) : Colors.grey[400],
                    ),
            ),
          ),
          SizedBox(height: 10.sp),
          if (reward.title.isNotEmpty)
            Text(
              reward.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  void _showRewardModal(BuildContext context, RewardItem reward) {
    final isActive = reward.isAvailable;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.r),
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(24.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Center(
                    child: Container(
                      width: 150.sp,
                      height: 150.sp,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[900],
                        border: Border.all(
                          color: isActive ? const Color(0xFF4CAF50) : Colors.grey[600]!,
                          width: 4.sp,
                        ),
                      ),
                      child: Center(
                        child: reward.icon == Icons.bar_chart
                            ? _buildBarChartIcon(
                                size: 80.sp,
                                color: isActive ? const Color(0xFF4CAF50) : Colors.grey[400]!,
                              )
                            : Icon(
                                reward.icon,
                                size: 80.sp,
                                color: isActive ? const Color(0xFF4CAF50) : Colors.grey[400],
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  if (reward.title.isNotEmpty)
                    Center(
                      child: Text(
                        reward.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  SizedBox(height: 12.h),
                  if (reward.description.isNotEmpty)
                    Center(
                      child: Text(
                        reward.description,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    height: 56.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ElevatedButton(
                      onPressed: isActive
                          ? () {
                              Get.back();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Share',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16.h,
              right: 16.sp,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 40.sp,
                  height: 40.sp,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF4CAF50),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChartIcon({required double size, required Color color}) {
    final barWidth = size * 0.15;
    final spacing = size * 0.15;
    final maxHeight = size * 0.8;
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: barWidth,
              height: maxHeight * 0.5,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(barWidth / 2),
              ),
            ),
            SizedBox(width: spacing),
            Container(
              width: barWidth,
              height: maxHeight * 0.75,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(barWidth / 2),
              ),
            ),
            SizedBox(width: spacing),
            Container(
              width: barWidth,
              height: maxHeight,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(barWidth / 2),
              ),
            ),
          ],
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

class RewardItem {
  final IconData icon;
  final String title;
  final String description;
  final bool isAvailable;

  RewardItem({
    required this.icon,
    required this.title,
    required this.description,
    this.isAvailable = false,
  });
}

final List<RewardItem> _rewards = [
  RewardItem(
    icon: Icons.flag,
    title: 'First Workout',
    description: 'Complete Day 1 training',
    isAvailable: true,
  ),
  RewardItem(
    icon: Icons.bar_chart,
    title: 'Level 1',
    description: 'Reach Level 1',
    isAvailable: false,
  ),
  RewardItem(
    icon: Icons.bar_chart,
    title: 'Level 2',
    description: 'Reach Level 2',
    isAvailable: false,
  ),
  RewardItem(
    icon: Icons.bar_chart,
    title: 'Level 3',
    description: 'Reach Level 3',
    isAvailable: false,
  ),
  RewardItem(
    icon: Icons.bar_chart,
    title: 'Level 4',
    description: 'Reach Level 4',
    isAvailable: false,
  ),
  RewardItem(
    icon: Icons.bar_chart,
    title: 'Level 5',
    description: 'Reach Level 5',
    isAvailable: false,
  ),
  RewardItem(
    icon: Icons.bar_chart,
    title: 'Level 6',
    description: 'Reach Level 6',
    isAvailable: false,
  ),
  RewardItem(
    icon: Icons.bar_chart,
    title: 'Level 7',
    description: 'Reach Level 7',
    isAvailable: false,
  ),
  RewardItem(
    icon: Icons.bar_chart,
    title: 'Level 8',
    description: 'Reach Level 8',
    isAvailable: false,
  ),
  RewardItem(
    icon: Iconsax.award,
    title: '',
    description: '',
    isAvailable: false,
  ),
  RewardItem(
    icon: Iconsax.award,
    title: '',
    description: '',
    isAvailable: false,
  ),
  RewardItem(
    icon: Icons.trending_up,
    title: '',
    description: '',
    isAvailable: false,
  ),
];
