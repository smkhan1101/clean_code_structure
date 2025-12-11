import 'dart:ui';
import 'package:startup_repo/imports.dart';
import '../controller/paywall_controller.dart';
import '../../../../core/widgets/loading.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaywallController>(
      init: Get.find<PaywallController>(),
      builder: (controller) {
        if (controller.isLoading) {
          return Scaffold(body: Center(child: Loading()));
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.35,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      Images.closeupImg,
                      fit: BoxFit.cover,
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Container(
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                    SafeArea(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: IconButton(
                            icon: Container(
                              width: 36.w,
                              height: 36.w,
                              decoration: BoxDecoration(
                                color: Colors.grey[700],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                            onPressed: () => Get.back(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                  ),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(25.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 8.h),
                            Text(
                              'Get the most out of your training with our Pro Plan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 24.h),
                            _buildFeatureItem('Speed train Levels 1-8'),
                            SizedBox(height: 12.h),
                            _buildFeatureItem(
                                'Receive a free lesson from our award winning instructors (\$99 VALUE)'),
                            SizedBox(height: 12.h),
                            _buildFeatureItem(
                                'Participate in Group speed challenges with winning incentives'),
                            SizedBox(height: 12.h),
                            _buildFeatureItem('Access to exclusive Long Drive Exercises'),
                            SizedBox(height: 12.h),
                            _buildFeatureItem('Access to specialized Fitness Packages'),
                            SizedBox(height: 12.h),
                            _buildFeatureItem('Discount offers with partnered golf brands'),
                            SizedBox(height: 24.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: const Color(0xFF4CAF50),
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'JUST Rs 13,900/YEAR (-50% OFF)',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 32.h),
                            Container(
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
                                onPressed: () {
                                  if (controller.plans.isNotEmpty) {
                                    controller.purchaseSubscription(controller.plans.first['id']);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  elevation: 0,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 18.h),
                                  minimumSize: Size(double.infinity, 50.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.lock,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Start 3-day free trial',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'You will be charged automatically after the trial ends.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'The plan can be cancelled at any time.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 24.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildFooterLink('Terms of service', () {}),
                                SizedBox(width: 16.w),
                                _buildFooterLink('Restore', () => controller.restorePurchases()),
                                SizedBox(width: 16.w),
                                _buildFooterLink('Redeem Code', () {}),
                              ],
                            ),
                            SizedBox(height: 20.h),
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

  Widget _buildFeatureItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle,
          color: const Color(0xFF4CAF50),
          size: 20.sp,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLink(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 12.sp,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white.withOpacity(0.7),
        ),
      ),
    );
  }
}
