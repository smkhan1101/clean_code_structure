import 'package:startup_repo/imports.dart';
import '../controller/feed_controller.dart';
import '../../data/model/post_model.dart';
import '../../../../core/widgets/loading.dart';
import '../../../../core/design/app_padding.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedController>(
      init: Get.find<FeedController>(),
      builder: (controller) {
        return Scaffold(
          bottomNavigationBar: _buildBottomNavBar(context, 1),
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 15.sp),
                    _buildHeader(controller, context),
                    Expanded(
                      child: _buildFeedList(controller, context),
                    ),
                  ],
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
                                  style: context.font18.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
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
          ),
        );
      },
    );
  }

  Widget _buildHeader(FeedController controller, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 15.sp),
      child: Row(
        children: [
          Text(
            'feed_title'.tr,
            style: context.font30.copyWith(
              fontWeight: FontWeight.bold,
              color: Get.theme.colorScheme.surface,
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: controller.showPostSheet,
            child: Container(
              width: 40.sp,
              height: 40.sp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor,
              ),
              child: Icon(
                Iconsax.add,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedList(FeedController controller, BuildContext context) {
    if (controller.isLoading) {
      return Center(child: Loading());
    }

    if (controller.posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.document,
              size: 64.sp,
              color: Get.theme.colorScheme.onSecondary,
            ),
            SizedBox(height: 16.sp),
            Text(
              'no_posts_yet'.tr,
              style: context.font16.copyWith(
                color: Get.theme.colorScheme.onSecondary,
              ),
            ),
            SizedBox(height: 8.sp),
            Text(
              'create_your_first_post'.tr,
              style: context.font14.copyWith(
                color: Get.theme.colorScheme.onSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      reverse: true,
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      itemCount: controller.posts.length + 1,
      itemBuilder: (context, index) {
        if (index == controller.posts.length) {
          return _buildWelcomeItem(context);
        }
        return _buildPostItem(controller.posts[index], controller, context);
      },
    );
  }

  Widget _buildPostItem(PostModel post, FeedController controller, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: primaryColor,
              child: Icon(Iconsax.user, color: Colors.white),
            ),
            title: Text(
              'you'.tr,
              style: context.font14.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              post.formattedTime,
              style: context.font12,
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text('delete'.tr),
                  onTap: () => controller.deletePost(post.id ?? ''),
                ),
              ],
            ),
          ),
          if (post.text != null && post.text!.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Text(
                post.text!,
                style: context.font14,
              ),
            ),
            SizedBox(height: 8.sp),
          ],
          if (post.type == StorageItemType.image && post.filePath != null)
            GestureDetector(
              onTap: () => controller.onImageTap(post.filePath!),
              child: Container(
                width: double.infinity,
                height: 200.sp,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(post.filePath!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          else if (post.type == StorageItemType.video && post.videoUrl != null)
            GestureDetector(
              onTap: () => controller.onVideoTap(post.videoUrl!),
              child: Container(
                width: double.infinity,
                height: 200.sp,
                color: Colors.black,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Iconsax.video,
                      size: 48.sp,
                      color: Colors.white,
                    ),
                    Positioned(
                      bottom: 8.sp,
                      right: 8.sp,
                      child: Container(
                        padding: EdgeInsets.all(4.sp),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(4.sp),
                        ),
                        child: Icon(
                          Iconsax.play,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(height: 8.sp),
        ],
      ),
    );
  }

  Widget _buildWelcomeItem(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.sp),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: primaryColor,
          child: Icon(Iconsax.user, color: Colors.white),
        ),
        title: Text(
          'welcomeFeed'.tr,
          style: context.font14.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'coach_message'.tr,
          style: context.font12,
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

