import 'package:startup_repo/imports.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../controller/tutorials_controller.dart';
import '../../data/model/exercise.dart';
import '../../data/model/swing_fix.dart';

class TutorialsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GetBuilder<TutorialsController>(
      init: TutorialsController.find,
      builder: (controller) {
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
                            controller.selectSection(SectionOption.trainingProtocols);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 7.sp),
                            decoration: BoxDecoration(
                              color: controller.selectedSection == SectionOption.trainingProtocols
                                  ? Colors.grey[700]
                                  : Colors.transparent,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.sp),
                                bottomLeft: Radius.circular(8.sp),
                                topRight: controller.selectedSection == SectionOption.trainingProtocols
                                    ? Radius.circular(8.sp)
                                    : Radius.zero,
                                bottomRight: controller.selectedSection == SectionOption.trainingProtocols
                                    ? Radius.circular(8.sp)
                                    : Radius.zero,
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
                            controller.selectSection(SectionOption.swingFixes);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 7.sp),
                            decoration: BoxDecoration(
                              color: controller.selectedSection == SectionOption.swingFixes
                                  ? Colors.grey[700]
                                  : Colors.transparent,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(6.sp),
                                bottomRight: Radius.circular(6.sp),
                                topLeft: controller.selectedSection == SectionOption.swingFixes
                                    ? Radius.circular(6.sp)
                                    : Radius.zero,
                                bottomLeft: controller.selectedSection == SectionOption.swingFixes
                                    ? Radius.circular(6.sp)
                                    : Radius.zero,
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
              if (controller.selectedSection == SectionOption.trainingProtocols) ...[
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8.sp),
                    ),
                    child: Row(
                      children: List.generate(8, (index) {
                        final level = index + 1;
                        final isSelected = controller.selectedLevel == level;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              controller.selectLevel(level);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 7.sp),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF333333) : Colors.transparent,
                                borderRadius: BorderRadius.circular(6.sp),
                              ),
                              child: Center(
                                child: Text(
                                  'L$level',
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
                child: controller.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF4CAF50),
                        ),
                      )
                    : _buildContent(controller),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(TutorialsController controller) {
    if (controller.selectedSection == SectionOption.trainingProtocols) {
      return _buildTrainingProtocols(controller);
    } else {
      return _buildSwingFixes(controller);
    }
  }

  Widget _buildTrainingProtocols(TutorialsController controller) {
    final selectedProtocol = controller.selectedProtocol;
    final exercises = selectedProtocol?.exercises ?? [];
    final warmUpVideoId = controller.warmUpVideoId;

    return Builder(
      builder: (context) => ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 8.h),
        itemCount: exercises.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildWarmUpTile(context, controller, warmUpVideoId);
          }
          final exercise = exercises[index - 1];
          return _buildExerciseTile(context, controller, exercise);
        },
      ),
    );
  }

  Widget _buildSwingFixes(TutorialsController controller) {
    final swingFixes = controller.swingFixes;

    return Builder(
      builder: (context) => ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 8.h),
        itemCount: swingFixes.length,
        itemBuilder: (context, index) {
          final swingFix = swingFixes[index];
          return _buildSwingFixTile(context, controller, swingFix);
        },
      ),
    );
  }

  Widget _buildWarmUpTile(BuildContext context, TutorialsController controller, String videoId) {
    final isExpanded = controller.isWarmUpExpanded;

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
              controller.toggleWarmUp();
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
                          'Warm-Up',
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
                            _openFullScreenVideo(context, videoId, 'Warm-Up');
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
  }

  Widget _buildExerciseTile(BuildContext context, TutorialsController controller, Exercise exercise) {
    final isExpanded = controller.selectedExercise?.id == exercise.id;

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
              controller.toggleExercise(exercise);
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
                          exercise.title,
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
                          initialVideoId: exercise.videoId,
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
                            _openFullScreenVideo(context, exercise.videoId, exercise.title);
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
  }

  Widget _buildSwingFixTile(BuildContext context, TutorialsController controller, SwingFix swingFix) {
    final isExpanded = controller.selectedSwingFix?.id == swingFix.id;

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
              controller.toggleSwingFix(swingFix);
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
                          swingFix.title,
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
                          initialVideoId: swingFix.videoId,
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
                            _openFullScreenVideo(context, swingFix.videoId, swingFix.title);
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
