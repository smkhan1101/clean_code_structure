import 'package:startup_repo/imports.dart';
import '../controller/settings_controller.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/loading.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      init: Get.find<SettingsController>(),
      builder: (controller) {
        if (controller.isLoading) {
          return Scaffold(body: Center(child: Loading()));
        }

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              'Preferences'.tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomNavBar(context, 4),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(25.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.email,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                        ),
                      ),
                      if (!controller.isProPlan) ...[
                        SizedBox(height: 16.h),
                        Divider(
                          color: Colors.grey[700],
                          height: 1,
                        ),
                        SizedBox(height: 16.h),
                        GestureDetector(
                          onTap: () => Get.toNamed('/paywall'),
                          child: Text(
                            'Upgrade to the Pro Plan'.tr,
                            style: TextStyle(
                              color: const Color(0xFF20CD26),
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 25.sp),
                Text(
                  'permissions'.tr.toUpperCase(),
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.sp),
                _buildSettingsCard([
                  _buildTappableSettingItem(
                    'notifications'.tr,
                    controller.notifications,
                    ['Allow', 'Don\'t Allow'],
                    (value) => controller.updateSetting('notifications', value),
                  ),
                ]),
                SizedBox(height: 25.sp),
                Text(
                  'training'.tr.toUpperCase(),
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.sp),
                _buildSettingsCard([
                  _buildTappableSettingItem(
                    'shaft_length'.tr,
                    controller.shaft,
                    ['None', 'White 45"', 'Blue 44"', 'Green 41"', 'Orange 38"'],
                    (value) => controller.updateSetting('shaft', value),
                  ),
                  Divider(color: Colors.grey[800], height: 1),
                  _buildTappableSettingItem(
                    'radar'.tr,
                    controller.radar,
                    ['RypRadar', 'Other speed radar', 'No radar'],
                    (value) => controller.updateSetting('radar', value),
                  ),
                  Divider(color: Colors.grey[800], height: 1),
                  _buildTappableSettingItem(
                    'units'.tr,
                    controller.unit,
                    ['Yards/MPH', 'Meters/KPH', 'Yards/MPS', 'Meters/MPH'],
                    (value) => controller.updateSetting('unit', value),
                  ),
                  if (controller.isNotDay1) ...[
                    Divider(color: Colors.grey[800], height: 1),
                    GestureDetector(
                      onTap: () {
                        showConfirmationDialog(
                          title: 'reset_to_level'.tr,
                          subtitle: 'reset_confirmation'.tr,
                          actionText: 'confirm'.tr,
                          onAccept: () => controller.resetToLevel1Day1(),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        child: Text(
                          'reset_to_level'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ]),
                SizedBox(height: 25.sp),
                Text(
                  'help'.tr.toUpperCase(),
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.sp),
                _buildSettingsCard([
                  GestureDetector(
                    onTap: controller.rateApp,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Rate this app'.tr,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: const Color(0xFF20CD26),
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Divider(color: Colors.grey[700], height: 1),
                  ),
                  GestureDetector(
                    onTap: controller.contactUs,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Contact us'.tr,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: const Color(0xFF20CD26),
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ]),
                SizedBox(height: 25.sp),
                Text(
                  'account'.tr.toUpperCase(),
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.sp),
                _buildSettingsCard([
                  GestureDetector(
                    onTap: () {
                      showConfirmationDialog(
                        title: 'sign_out'.tr,
                        subtitle: 'sign_out_confirmation'.tr,
                        actionText: 'sign_out'.tr,
                        onAccept: () => controller.signOut(),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sign out'.tr,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: const Color(0xFF20CD26),
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Divider(color: Colors.grey[700], height: 1),
                  ),
                  GestureDetector(
                    onTap: () {
                      final passwordController = TextEditingController();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('delete_account'.tr),
                          content: CustomTextField(
                            controller: passwordController,
                            hintText: 'password'.tr,
                            obscureText: true,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text('cancel'.tr),
                            ),
                            TextButton(
                              onPressed: () {
                                controller.deleteAccount(passwordController.text);
                                Get.back();
                              },
                              child: Text('delete'.tr, style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Delete account'.tr,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: const Color(0xFFEE1606),
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTappableSettingItem(
    String title,
    String value,
    List<String> options,
    Function(String) onChanged,
  ) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: Get.context!,
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          builder: (context) => Container(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 20.h),
                ...options.map((option) => ListTile(
                      title: Text(
                        option,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                      onTap: () {
                        onChanged(option);
                        Get.back();
                      },
                      selected: option == value,
                      selectedTileColor: Colors.grey[800],
                    )),
              ],
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 20.sp,
                ),
              ],
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
