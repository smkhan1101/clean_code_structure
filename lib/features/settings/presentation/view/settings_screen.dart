import 'package:startup_repo/imports.dart';
import '../controller/settings_controller.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();
    controller.checkAndReloadIfUserChanged();
    return GetBuilder<SettingsController>(
      init: controller,
      builder: (controller) {

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: EdgeInsets.only(bottom: 0.h, top: 40.h),
              child: Text(
                'Preferences'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomNavBar(context, 4),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(left: 20.sp, right: 20.sp, top: 55.h, bottom: 1.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF191919),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.only(left: 12.w, right: 0.w, top: 12.h, bottom: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.email,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                      if (!controller.isProPlan) ...[
                        SizedBox(height: 4.h),
                        Container(
                          margin: EdgeInsets.only(left: 0.w, right: 0.w),
                          child: Divider(color: Colors.grey[700], height: 1),
                        ),
                        SizedBox(height: 4.h),
                        GestureDetector(
                          onTap: () => Get.toNamed('/paywall'),
                          child: Text(
                            'Upgrade to the Pro Plan'.tr,
                            style: TextStyle(
                              color: const Color(0xFF4CAF50),
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 30.sp),
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Text(
                    'permissions'.tr.toUpperCase(),
                    style: TextStyle(
                      color: const Color(0xFF565656),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 8.sp),
                _buildSettingsCard([
                  _buildTappableSettingItem(
                    'Notifications'.tr,
                    controller.notifications,
                    ['Allow', 'Don\'t Allow'],
                    (value) => controller.updateSetting('notifications', value),
                  ),
                ]),
                SizedBox(height: 35.sp),
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Text(
                    'TRAINING'.tr.toUpperCase(),
                    style: TextStyle(
                      color: const Color(0xFF565656),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
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
                  Container(
                    margin: EdgeInsets.only(left: 16.w, right: 0.w),
                    child: Divider(color: Colors.grey[700], height: 1),
                  ),
                  _buildTappableSettingItem(
                    'radar'.tr,
                    controller.radar,
                    ['RypRadar', 'Other speed radar', 'No radar'],
                    (value) => controller.updateSetting('radar', value),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16.w, right: 0.w),
                    child: Divider(color: Colors.grey[700], height: 1),
                  ),
                  _buildTappableSettingItem(
                    'units'.tr,
                    controller.unit,
                    ['Yards/MPH', 'Meters/KPH', 'Yards/MPS', 'Meters/MPH'],
                    (value) => controller.updateSetting('unit', value),
                  ),
                  if (controller.isNotDay1) ...[
                    Container(
                      margin: EdgeInsets.only(left: 16.w, right: 0.w),
                      child: Divider(color: Colors.grey[700], height: 1),
                    ),
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
                SizedBox(height: 35.sp),
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Text(
                    'help'.tr.toUpperCase(),
                    style: TextStyle(
                      color: const Color(0xFF565656),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 8.sp),
                _buildSettingsCard([
                  GestureDetector(
                    onTap: controller.rateApp,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Rate this app'.tr,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: const Color(0xFF4CAF50),
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16.w, right: 0.w),
                    child: Divider(color: Colors.grey[700], height: 1),
                  ),
                  GestureDetector(
                    onTap: controller.contactUs,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Contact us'.tr,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: const Color(0xFF4CAF50),
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ]),
                SizedBox(height: 35.sp),
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Text(
                    'account'.tr.toUpperCase(),
                    style: TextStyle(
                      color: const Color(0xFF565656),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 8.sp),
                _buildSettingsCard([
                  GestureDetector(
                    onTap: () {
                      showConfirmationDialog(
                        title: 'sign_out'.tr,
                        subtitle:
                            'You\'ll have to log back in with your email and password, or create a new account.'
                                .tr,
                        actionText: 'sign_out'.tr,
                        onAccept: () => controller.signOut(),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sign out'.tr,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: const Color(0xFF4CAF50),
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16.w, right: 0.w),
                    child: Divider(color: Colors.grey[600], height: 1),
                  ),
                  GestureDetector(
                    onTap: () {
                      final passwordController = TextEditingController();
                      bool isPasswordVisible = false;
                      showDialog(
                        context: context,
                        builder: (context) => StatefulBuilder(
                          builder: (context, setState) => Dialog(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              constraints: BoxConstraints(minHeight: 400.h),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF191919),
                                    Color(0xFF252525),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(24.w),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 80.w,
                                      height: 80.w,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[700],
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12.r),
                                        child: Image.asset(
                                          Images.appLogo,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    Text(
                                      'Delete account'.tr,
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    Text(
                                      'You will permanently lose access to this account\'s training history. This cannot be undone.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 24.h),
                                    TextField(
                                      controller: passwordController,
                                      obscureText: !isPasswordVisible,
                                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                                      decoration: InputDecoration(
                                        hintText: 'password'.tr,
                                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16.sp),
                                        filled: true,
                                        fillColor: Colors.grey[800],
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.r),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.r),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.r),
                                          borderSide: BorderSide(
                                            color: const Color(0xFF4CAF50),
                                            width: 2,
                                          ),
                                        ),
                                        contentPadding:
                                            EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                            color: Colors.grey[400],
                                            size: 20.sp,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              isPasswordVisible = !isPasswordVisible;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 35.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () => Get.back(),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey[600],
                                              foregroundColor: Colors.white,
                                              padding: EdgeInsets.symmetric(vertical: 14.h),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12.r),
                                              ),
                                            ),
                                            child: Text(
                                              'cancel'.tr,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              controller.deleteAccount(passwordController.text);
                                              Get.back();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey[600],
                                              foregroundColor: const Color.fromARGB(255, 215, 17, 17),
                                              padding: EdgeInsets.symmetric(vertical: 14.h),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12.r),
                                              ),
                                            ),
                                            child: Text(
                                              'Yes, delete',
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Delete account'.tr,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 222, 22, 8),
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
        color: const Color(0xFF191919),
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
    final GlobalKey key = GlobalKey();
    return GestureDetector(
      onTap: () {
        final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
        final Offset? offset = renderBox?.localToGlobal(Offset.zero);
        final Size? size = renderBox?.size;

        showDialog(
          context: key.currentContext ?? Get.context!,
          barrierColor: Colors.black.withOpacity(0.5),
          builder: (context) => Stack(
            children: [
              Positioned(
                top: offset != null && size != null ? offset.dy : null,
                right: 10.w,
                child: IntrinsicWidth(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...options.asMap().entries.map((entry) {
                          final index = entry.key;
                          final option = entry.value;
                          final isLast = index == options.length - 1;
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  onChanged(option);
                                  Get.back();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 20.sp,
                                        child: option == value
                                            ? Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 20.sp,
                                              )
                                            : const SizedBox(),
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        option,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (!isLast)
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: Colors.grey[700],
                                ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
        key: key,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                    color: const Color(0xFF565656),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.chevron_right,
                  color: const Color(0xFF565656),
                  size: 25.sp,
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
