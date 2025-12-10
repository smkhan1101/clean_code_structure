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
          appBar: AppBar(title: Text('preferences'.tr)),
          bottomNavigationBar: _buildBottomNavBar(context, 4),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(25.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(12.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.email,
                          style: context.font15.copyWith(
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        if (!controller.isProPlan) ...[
                          Divider(height: 24.sp),
                          GestureDetector(
                            onTap: () => Get.toNamed('/paywall'),
                            child: Text(
                              'upgrade_settings_button'.tr,
                              style: context.font15.copyWith(color: primaryColor),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25.sp),
                Text(
                  'permissions'.tr.toUpperCase(),
                  style: context.font12.copyWith(
                    color: Get.theme.colorScheme.onSecondary,
                  ),
                ),
                SizedBox(height: 8.sp),
                _buildSettingsCard([
                  _buildSettingItem(
                    'notifications'.tr,
                    controller.notifications,
                    ['Allow', 'Don\'t Allow'],
                    (value) => controller.updateSetting('notifications', value),
                  ),
                ]),
                SizedBox(height: 25.sp),
                Text(
                  'training'.tr.toUpperCase(),
                  style: context.font12.copyWith(
                    color: Get.theme.colorScheme.onSecondary,
                  ),
                ),
                SizedBox(height: 8.sp),
                _buildSettingsCard([
                  _buildSettingItem(
                    'shaft_length'.tr,
                    controller.shaft,
                    ['None', 'White 45"', 'Blue 44"', 'Green 41"', 'Orange 38"'],
                    (value) => controller.updateSetting('shaft', value),
                  ),
                  Divider(),
                  _buildSettingItem(
                    'radar'.tr,
                    controller.radar,
                    ['RypRadar', 'Other speed radar', 'No radar'],
                    (value) => controller.updateSetting('radar', value),
                  ),
                  Divider(),
                  _buildSettingItem(
                    'units'.tr,
                    controller.unit,
                    ['Yards/MPH', 'Meters/KPH', 'Yards/MPS', 'Meters/MPH'],
                    (value) => controller.updateSetting('unit', value),
                  ),
                  if (controller.isNotDay1) ...[
                    Divider(),
                    GestureDetector(
                      onTap: () {
                        showConfirmationDialog(
                          title: 'reset_to_level'.tr,
                          subtitle: 'reset_confirmation'.tr,
                          actionText: 'confirm'.tr,
                          onAccept: () => controller.resetToLevel1Day1(),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.sp),
                        child: Text(
                          'reset_to_level'.tr,
                          style: context.font15.copyWith(color: primaryColor),
                        ),
                      ),
                    ),
                  ],
                ]),
                SizedBox(height: 25.sp),
                Text(
                  'help'.tr.toUpperCase(),
                  style: context.font12.copyWith(
                    color: Get.theme.colorScheme.onSecondary,
                  ),
                ),
                SizedBox(height: 8.sp),
                _buildSettingsCard([
                  GestureDetector(
                    onTap: controller.rateApp,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.sp),
                      child: Text(
                        'rate_this_app'.tr,
                        style: context.font15.copyWith(color: primaryColor),
                      ),
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: controller.contactUs,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.sp),
                      child: Text(
                        'contact_us'.tr,
                        style: context.font15.copyWith(color: primaryColor),
                      ),
                    ),
                  ),
                ]),
                SizedBox(height: 25.sp),
                Text(
                  'account'.tr.toUpperCase(),
                  style: context.font12.copyWith(
                    color: Get.theme.colorScheme.onSecondary,
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.sp),
                      child: Text(
                        'sign_out'.tr,
                        style: context.font15.copyWith(color: primaryColor),
                      ),
                    ),
                  ),
                  Divider(),
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.sp),
                      child: Text(
                        'delete_account'.tr,
                        style: context.font15.copyWith(color: Colors.red),
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
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.sp),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildSettingItem(String title, String value, List<String> options, Function(String) onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 12.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Get.context!.font15),
          DropdownButton<String>(
            value: value,
            items: options.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
            onChanged: (newValue) {
              if (newValue != null) onChanged(newValue);
            },
          ),
        ],
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

