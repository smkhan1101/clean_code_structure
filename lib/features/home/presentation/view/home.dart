import 'package:startup_repo/imports.dart';
import '../controller/home_controller.dart';
import '../../data/model/home_menu.dart';
import '../../../../core/widgets/loading.dart';
import '../../../../core/design/app_padding.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: Get.find<HomeController>(),
      builder: (controller) {
        return Scaffold(
          bottomNavigationBar: _buildBottomNavBar(context),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 25.sp),
                Row(
                  children: [
                    Spacer(),
                    Image.asset(
                      Images.logo,
                      height: 60.sp,
                      fit: BoxFit.contain,
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 15.sp),
                _buildCalendarView(controller, context),
                SizedBox(height: 6.sp),
                Divider(
                  height: 0.5.sp,
                  color: Get.theme.colorScheme.onSecondary,
                  indent: 15.sp,
                  endIndent: 15.sp,
                ),
                Expanded(
                  child: _buildMenuList(controller, context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarView(HomeController controller, BuildContext context) {
    if (controller.isCalendarDataLoading) {
      return Container(
        margin: EdgeInsets.all(15.sp),
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: BorderRadius.circular(15.sp),
        ),
        height: 90.sp,
        child: Center(
          child: Loading(size: 30),
        ),
      );
    }

    if (controller.calendarData.isEmpty) {
      return Container(
        margin: EdgeInsets.all(15.sp),
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: BorderRadius.circular(15.sp),
        ),
        height: 90.sp,
        child: Center(
          child: Text(
            'intro_video_placeholder'.tr,
            style: context.font14,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.all(15.sp),
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: controller.calendarData.take(4).map((item) {
          return Expanded(
            child: _buildCalendarItem(item, context),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarItem(item, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          item.text,
          style: context.font10.copyWith(
            color: Get.theme.colorScheme.onSecondary,
          ),
        ),
        SizedBox(height: 4.sp),
        Text(
          item.value,
          style: context.font14.copyWith(
            fontWeight: FontWeight.bold,
            color: Get.theme.colorScheme.surface,
          ),
        ),
        if (item.progress > 0 && item.progress < 1) ...[
          SizedBox(height: 4.sp),
          LinearProgressIndicator(
            value: item.progress,
            backgroundColor: Get.theme.colorScheme.onSecondary.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            minHeight: 2.sp,
          ),
        ],
      ],
    );
  }

  Widget _buildMenuList(HomeController controller, BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15.sp),
      itemCount: controller.homeMenuList.length,
      itemBuilder: (context, index) {
        final menu = controller.homeMenuList[index];
        return _buildMenuItem(menu, index, controller, context);
      },
    );
  }

  Widget _buildMenuItem(HomeMenu menu, int index, HomeController controller, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.sp),
      color: menu.selected ? primaryColor.withOpacity(0.1) : Get.theme.cardColor,
      child: ListTile(
        enabled: menu.enabled,
        leading: Icon(
          menu.icon,
          color: menu.enabled ? menu.iconColor : Get.theme.colorScheme.onSecondary.withOpacity(0.5),
        ),
        title: Text(
          menu.title,
          style: context.font16.copyWith(
            fontWeight: FontWeight.w600,
            color: menu.enabled ? Get.theme.colorScheme.surface : Get.theme.colorScheme.onSecondary.withOpacity(0.5),
          ),
        ),
        subtitle: menu.description.isNotEmpty
            ? Text(
                menu.description,
                style: context.font12.copyWith(
                  color: menu.enabled ? Get.theme.colorScheme.onSecondary : Get.theme.colorScheme.onSecondary.withOpacity(0.5),
                ),
              )
            : null,
        trailing: menu.enabled
            ? Icon(
                Iconsax.arrow_right_3,
                color: Get.theme.colorScheme.surface,
              )
            : null,
        onTap: menu.enabled ? () => controller.onMenuTap(index) : null,
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
