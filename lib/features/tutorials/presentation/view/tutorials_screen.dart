import 'package:startup_repo/imports.dart';

class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({super.key});

  static void show() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TutorialsScreen(),
    );
  }

  @override
  State<TutorialsScreen> createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends State<TutorialsScreen> {
  int selectedMain = 0;
  int selectedLevel = 0;
  Set<int> expandedItems = {};

  @override
  Widget build(BuildContext context) {
    final tutorialItems = selectedMain == 0
        ? ['Warm-Up', 'Freezers', 'Lead Heel Lift', 'Baseline Test: Normal Swings']
        : ['Casting', 'Chicken Wing', 'Early Extension', 'Flat Shoulder', 'Grounded', 'Harpooner', 'Slicer'];

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 16.h),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  'Tutorials',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.sp),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMain = 0;
                          selectedLevel = 0;
                          expandedItems.clear();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.sp),
                        decoration: BoxDecoration(
                          color: selectedMain == 0 ? Colors.grey[900] : Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.sp),
                            bottomLeft: Radius.circular(8.sp),
                            topRight: selectedMain == 0 ? Radius.circular(8.sp) : Radius.zero,
                            bottomRight: selectedMain == 0 ? Radius.circular(8.sp) : Radius.zero,
                          ),
                        ),
                        child: Text(
                          'Training protocols',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMain = 1;
                          expandedItems.clear();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.sp),
                        decoration: BoxDecoration(
                          color: selectedMain == 1 ? Colors.grey[900] : Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8.sp),
                            bottomRight: Radius.circular(8.sp),
                            topLeft: selectedMain == 1 ? Radius.circular(8.sp) : Radius.zero,
                            bottomLeft: selectedMain == 1 ? Radius.circular(8.sp) : Radius.zero,
                          ),
                        ),
                        child: Text(
                          'Swing Fix Videos',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (selectedMain == 0) ...[
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.sp),
                ),
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
                          padding: EdgeInsets.symmetric(vertical: 8.sp),
                          decoration: BoxDecoration(
                            color: selectedLevel == index ? Colors.grey[900] : Colors.transparent,
                            borderRadius: BorderRadius.only(
                              topLeft: index == 0 ? Radius.circular(8.sp) : Radius.zero,
                              bottomLeft: index == 0 ? Radius.circular(8.sp) : Radius.zero,
                              topRight: index == 3 ? Radius.circular(8.sp) : Radius.zero,
                              bottomRight: index == 3 ? Radius.circular(8.sp) : Radius.zero,
                            ),
                          ),
                          child: Text(
                            'Level ${index + 1}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
          SizedBox(height: 16.sp),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 8.h),
              itemCount: tutorialItems.length,
              itemBuilder: (context, index) {
                final isExpanded = expandedItems.contains(index);
                return Container(
                  margin: EdgeInsets.only(bottom: 12.sp),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isExpanded) {
                              expandedItems.remove(index);
                            } else {
                              expandedItems.add(index);
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tutorialItems[index],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (!isExpanded) ...[
                                      SizedBox(height: 4.h),
                                      Text(
                                        'See video',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Icon(
                                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isExpanded) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Container(
                            height: 200.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 16.w,
                                  top: 16.h,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40.w,
                                        height: 40.w,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[700],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.error_outline,
                                          color: Colors.white,
                                          size: 24.sp,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'This video is unavailable',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            'Error code: 152 - 15',
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 16.h,
                                  right: 16.w,
                                  child: Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white,
                                    size: 32.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ],
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
