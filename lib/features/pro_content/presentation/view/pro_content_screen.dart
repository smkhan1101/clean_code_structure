import 'package:startup_repo/imports.dart';

class ProContentScreen extends StatefulWidget {
  const ProContentScreen({super.key});

  @override
  State<ProContentScreen> createState() => _ProContentScreenState();
}

class _ProContentScreenState extends State<ProContentScreen> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('premium_tutorials'.tr),
        leading: IconButton(
          icon: Icon(Iconsax.close_circle),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20.sp),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTab = 0;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.sp),
                      decoration: BoxDecoration(
                        color: selectedTab == 0 ? primaryColor : Get.theme.cardColor,
                        borderRadius: BorderRadius.circular(8.sp),
                      ),
                      child: Text(
                        'long_drive_exercise'.tr,
                        textAlign: TextAlign.center,
                        style: context.font14.copyWith(
                          color: selectedTab == 0 ? Colors.white : Get.theme.colorScheme.surface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.sp),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTab = 1;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.sp),
                      decoration: BoxDecoration(
                        color: selectedTab == 1 ? primaryColor : Get.theme.cardColor,
                        borderRadius: BorderRadius.circular(8.sp),
                      ),
                      child: Text(
                        'fitness_packages'.tr,
                        textAlign: TextAlign.center,
                        style: context.font14.copyWith(
                          color: selectedTab == 1 ? Colors.white : Get.theme.colorScheme.surface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20.sp),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.only(bottom: 12.sp),
                  child: ListTile(
                    title: Text(
                      'premium_content_${index + 1}'.tr,
                      style: context.font16.copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'premium_description'.tr,
                      style: context.font14,
                    ),
                    trailing: Icon(Iconsax.play),
                    onTap: () {
                      // TODO: Open video player
                      showToast('video_player_coming_soon'.tr);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

