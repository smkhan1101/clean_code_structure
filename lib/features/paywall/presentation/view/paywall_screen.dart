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
        return Scaffold(
          appBar: AppBar(
            title: Text('upgrade_to_pro'.tr),
            leading: IconButton(
              icon: Icon(Iconsax.close_circle),
              onPressed: () => Get.back(),
            ),
          ),
          body: controller.isLoading
              ? Center(child: Loading())
              : SingleChildScrollView(
                  padding: EdgeInsets.all(20.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 20.sp),
                      Text(
                        'unlock_all_features'.tr,
                        style: context.font24.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.sp),
                      Text(
                        'pro_features_description'.tr,
                        style: context.font16,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.sp),
                      ...controller.plans.map((plan) => _buildPlanCard(plan, controller, context)),
                      SizedBox(height: 24.sp),
                      TextButton(
                        onPressed: controller.restorePurchases,
                        child: Text('restore_purchases'.tr),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan, PaywallController controller, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.sp),
      child: InkWell(
        onTap: () => controller.purchaseSubscription(plan['id']),
        child: Padding(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plan['title'] ?? '',
                style: context.font18.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.sp),
              Text(
                plan['price'] ?? '',
                style: context.font20.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              if (plan['description'] != null) ...[
                SizedBox(height: 8.sp),
                Text(
                  plan['description'] ?? '',
                  style: context.font14,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

