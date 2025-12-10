import 'package:startup_repo/imports.dart';
import '../../../../features/home/presentation/controller/home_controller.dart';

class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({super.key});

  @override
  State<TutorialsScreen> createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends State<TutorialsScreen> {
  int selectedMain = 0;
  int selectedLevel = 0;

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('tutorials'.tr),
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
                        selectedMain = 0;
                        selectedLevel = 0;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.sp),
                      decoration: BoxDecoration(
                        color: selectedMain == 0 ? primaryColor : Get.theme.cardColor,
                        borderRadius: BorderRadius.circular(8.sp),
                      ),
                      child: Text(
                        'training_protocols'.tr,
                        textAlign: TextAlign.center,
                        style: context.font14.copyWith(
                          color: selectedMain == 0 ? Colors.white : Get.theme.colorScheme.surface,
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
                        selectedMain = 1;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.sp),
                      decoration: BoxDecoration(
                        color: selectedMain == 1 ? primaryColor : Get.theme.cardColor,
                        borderRadius: BorderRadius.circular(8.sp),
                      ),
                      child: Text(
                        'swing_file'.tr,
                        textAlign: TextAlign.center,
                        style: context.font14.copyWith(
                          color: selectedMain == 1 ? Colors.white : Get.theme.colorScheme.surface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (selectedMain == 0)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Row(
                children: List.generate(4, (index) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedLevel = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.sp),
                        padding: EdgeInsets.symmetric(vertical: 8.sp),
                        decoration: BoxDecoration(
                          color: selectedLevel == index ? primaryColor : Get.theme.cardColor,
                          borderRadius: BorderRadius.circular(8.sp),
                        ),
                        child: Text(
                          'level${index + 1}'.tr,
                          textAlign: TextAlign.center,
                          style: context.font12.copyWith(
                            color: selectedLevel == index ? Colors.white : Get.theme.colorScheme.surface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          SizedBox(height: 16.sp),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20.sp),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.only(bottom: 12.sp),
                  child: ListTile(
                    title: Text(
                      'tutorial_item_${index + 1}'.tr,
                      style: context.font16.copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'tutorial_description'.tr,
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

