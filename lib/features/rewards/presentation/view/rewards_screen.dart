import 'dart:ui';
import 'package:startup_repo/imports.dart';
import '../controller/rewards_controller.dart';
import '../../../../core/widgets/loading.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RewardsController>(
      init: Get.find<RewardsController>(),
      builder: (controller) {
        return Scaffold(
          bottomNavigationBar: _buildBottomNavBar(context, 3),
          body: Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                      child: Text(
                        'rewards'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Expanded(
                      child: controller.isLoading
                          ? Center(child: Loading())
                          : controller.rewardsList.isEmpty
                              ? Center(
                                  child: Text(
                                    'no_rewards_available'.tr,
                                    style: context.font16,
                                  ),
                                )
                              : GridView.builder(
                                  padding: EdgeInsets.all(5.sp),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 20.sp,
                                    mainAxisSpacing: 20.sp,
                                  ),
                                  itemCount: controller.rewardsList.length,
                                  itemBuilder: (context, index) {
                                    final reward = controller.rewardsList[index];
                                    return _buildRewardItem(reward, controller, context);
                                  },
                                ),
                    ),
                  ],
                ),
              ),
              if (!controller.isProPlan)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.sp),
                          padding: EdgeInsets.all(24.sp),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'This is a Pro feature',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16.sp),
                              Text(
                                'Get the most out of your Rypstick training, at 50% off',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 24.sp),
                              Container(
                                width: double.infinity,
                                height: 56.h,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFF5CBF60),
                                      Color(0xFF4CAF50),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: ElevatedButton(
                                  onPressed: () => Get.toNamed('/paywall'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    elevation: 0,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  child: Text(
                                    'Upgrade to Pro',
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
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRewardItem(reward, RewardsController controller, BuildContext context) {
    return GestureDetector(
      onTap: () => _showRewardSheet(reward, controller, context),
      child: Column(
        children: [
          Container(
            width: 100.sp,
            height: 100.sp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: reward.isAvailable ? primaryColor : Get.theme.colorScheme.onSecondary,
                width: 4.sp,
              ),
            ),
            child: Icon(
              Iconsax.award,
              size: 48.sp,
              color: reward.isAvailable ? primaryColor : Get.theme.colorScheme.onSecondary,
            ),
          ),
          SizedBox(height: 10.sp),
          Text(
            reward.title,
            style: context.font14.copyWith(
              fontWeight: FontWeight.w600,
              color: Get.theme.colorScheme.surface,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showRewardSheet(reward, RewardsController controller, BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Get.theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.sp)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  reward.title,
                  style: context.font18.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Iconsax.close_circle),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            SizedBox(height: 20.sp),
            Container(
              width: 125.sp,
              height: 125.sp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: reward.isAvailable ? primaryColor : Get.theme.colorScheme.onSecondary,
                  width: 4.sp,
                ),
              ),
              child: Icon(
                Iconsax.award,
                size: 64.sp,
                color: reward.isAvailable ? primaryColor : Get.theme.colorScheme.onSecondary,
              ),
            ),
            SizedBox(height: 20.sp),
            Text(
              reward.rule,
              style: context.font14,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.sp),
            PrimaryButton(
              text: 'share'.tr,
              onPressed: reward.isAvailable
                  ? () {
                      controller.shareReward(reward);
                      Get.back();
                    }
                  : null,
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
