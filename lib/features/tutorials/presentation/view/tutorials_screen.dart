import 'package:startup_repo/imports.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({super.key});

  static void show() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(0xFF1E1E1E),
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

  final Map<String, String> videoIds = {
    'Warm-Up': 'IF0kLstvX6M',
    'Freezers': 'IF0kLstvX6M',
    'Lead Heel Lift': 'IF0kLstvX6M',
    'Baseline Test: Normal Swings': 'IF0kLstvX6M',
    'Casting': 'IF0kLstvX6M',
    'Chicken Wing': 'IF0kLstvX6M',
    'Early Extension': 'IF0kLstvX6M',
    'Flat Shoulder': 'IF0kLstvX6M',
    'Grounded': 'IF0kLstvX6M',
    'Harpooner': 'IF0kLstvX6M',
    'Slicer': 'IF0kLstvX6M',
  };

  @override
  Widget build(BuildContext context) {
    final tutorialItems = selectedMain == 0
        ? ['Warm-Up', 'Freezers', 'Lead Heel Lift', 'Baseline Test: Normal Swings']
        : ['Casting', 'Chicken Wing', 'Early Extension', 'Flat Shoulder', 'Grounded', 'Harpooner', 'Slicer'];

    return Container(
      height: MediaQuery.of(context).size.height * 0.93,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 8.h),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Text(
                    'Tutorials',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
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
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(255, 33, 224, 84),
                            Color.fromARGB(255, 13, 89, 32),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
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
                        padding: EdgeInsets.symmetric(vertical: 7.sp),
                        decoration: BoxDecoration(
                          color: selectedMain == 0 ? Colors.grey[700] : Colors.transparent,
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
                        padding: EdgeInsets.symmetric(vertical: 7.sp),
                        decoration: BoxDecoration(
                          color: selectedMain == 1 ? Colors.grey[700] : Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6.sp),
                            bottomRight: Radius.circular(6.sp),
                            topLeft: selectedMain == 1 ? Radius.circular(6.sp) : Radius.zero,
                            bottomLeft: selectedMain == 1 ? Radius.circular(6.sp) : Radius.zero,
                          ),
                        ),
                        child: Text(
                          'Swing fix videos',
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
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8.sp),
                ),
                child: Row(
                  children: List.generate(4, (index) {
                    final isSelected = selectedLevel == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedLevel = index;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 7.sp),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF333333) : Colors.transparent,
                            borderRadius: BorderRadius.circular(6.sp),
                          ),
                          child: Center(
                            child: Text(
                              'Level ${index + 1}',
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
                    );
                  }),
                ),
              ),
            ),
          ],
          SizedBox(height: 10.sp),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 8.h),
              itemCount: tutorialItems.length,
              itemBuilder: (context, index) {
                final isExpanded = expandedItems.contains(index);
                final itemName = tutorialItems[index];
                final videoId = videoIds[itemName] ?? 'IF0kLstvX6M';

                return Container(
                  margin: EdgeInsets.only(bottom: 18.sp),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF191919),
                        Color(0xFF252525),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14.r),
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
                                      itemName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (!isExpanded) ...[
                                      SizedBox(height: 4.h),
                                      Text(
                                        'See video',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Icon(
                                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 30.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isExpanded) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          child: Container(
                            height: 200.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Stack(
                                children: [
                                  YoutubePlayer(
                                    controller: YoutubePlayerController(
                                      initialVideoId: videoId,
                                      flags: const YoutubePlayerFlags(
                                        autoPlay: false,
                                        mute: false,
                                      ),
                                    ),
                                    showVideoProgressIndicator: true,
                                    progressIndicatorColor: const Color(0xFF4CAF50),
                                    progressColors: const ProgressBarColors(
                                      playedColor: Color(0xFF4CAF50),
                                      handleColor: Color(0xFF4CAF50),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8.h,
                                    right: 8.w,
                                    child: GestureDetector(
                                      onTap: () {
                                        _openFullScreenVideo(context, videoId, itemName);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8.w),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.7),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.fullscreen,
                                          color: Colors.white,
                                          size: 20.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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

  void _openFullScreenVideo(BuildContext context, String videoId, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullScreenVideoPlayer(
          videoId: videoId,
          title: title,
        ),
      ),
    );
  }
}

class _FullScreenVideoPlayer extends StatefulWidget {
  final String videoId;
  final String title;

  const _FullScreenVideoPlayer({
    required this.videoId,
    required this.title,
  });

  @override
  State<_FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<_FullScreenVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.sp),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: const Color(0xFF4CAF50),
                  progressColors: const ProgressBarColors(
                    playedColor: Color(0xFF4CAF50),
                    handleColor: Color(0xFF4CAF50),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
