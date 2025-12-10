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
                    SizedBox(height: 15.sp),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.sp, vertical: 15.sp),
                      child: Text(
                        'rewards'.tr,
                        style: context.font30.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.surface,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.sp),
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
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: Card(
                        margin: EdgeInsets.all(20.sp),
                        child: Padding(
                          padding: EdgeInsets.all(20.sp),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'upgrade_to_pro'.tr,
                                style: context.font18.copyWith(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16.sp),
                              PrimaryButton(
                                text: 'upgrade_now'.tr,
                                onPressed: () => Get.toNamed('/paywall'),
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

