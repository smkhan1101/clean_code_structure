import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:startup_repo/features/home/presentation/controller/home_controller.dart';
import 'package:startup_repo/features/training/presentation/controller/measure_baseline_active_controller.dart';
import '../../../../imports.dart';
import '../../../../core/widgets/sign_in_button.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'measure_baseline_active_screen.dart';
import 'alternative_baseline_input_screen.dart';
import 'package:startup_repo/core/widgets/app_loader.dart';
 

class MeasureBaselineScreen extends StatefulWidget {
  const MeasureBaselineScreen({super.key});

  static void show() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xFF1E1E1E),
      builder: (context) => const MeasureBaselineScreen(),
    );
  }

  @override
  State<MeasureBaselineScreen> createState() => _MeasureBaselineScreenState();
}

class _MeasureBaselineScreenState extends State<MeasureBaselineScreen> {
  bool _hasWarmedUp = false;
  YoutubePlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    final videoId =
        YoutubePlayer.convertUrlToId('https://www.youtube.com/watch?v=IF0kLstvX6M') ?? 'IF0kLstvX6M';
    _videoController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _showWarmUpScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xFF1E1E1E),
      builder: (context) => _WarmUpScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.93,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                    _buildTutorialView(),
//                   GetBuilder<HomeController>(
//   builder: (controller) {
//     return _buildTutorialView(controller);
//   },
// ),

                  SizedBox(height: 20.h),
                  _buildInfoView(),
                  SizedBox(height: 20.h),
                  _buildRadarSelectionView(),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 20.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Measure your baseline',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Container(
              width: 35.w,
              height: 35.w,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF237537),
                    Color(0xFF33C258),
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
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  } 

//   Widget _buildTutorialView(HomeController controller) {
//   if (_videoController == null) {
//     return Container(
//       height: 200.h,
//       decoration: BoxDecoration(
//         color: Colors.grey[900],
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: const Center(
//         child: AppLoader(
//           size: 40,
//           loaderColor: Colors.white,
//           showBackground: false,
//         ),
//       ),
//     );
//   }

//   return Container(
//     height: 200.h,
//     decoration: BoxDecoration(
//       color: Colors.grey[900],
//       borderRadius: BorderRadius.circular(12.r),
//     ),
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(12.r),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           YoutubePlayer(
//             controller: _videoController!,
//             showVideoProgressIndicator: false, // ❌ disable default loader
//             onReady: controller.onVideoReady, // ✅ hide AppLoader
//           ),

//           /// 👇 Custom loader overlay
//           GetBuilder<HomeController>(
//             builder: (_) {
//               return controller.isVideoLoading
//                   ? Container(
//                       color: Colors.black, // hides YouTube white spinner
//                       child: const AppLoader(
//                         size: 40,
//                         loaderColor: Colors.white,
//                         showBackground: false,
//                       ),
//                     )
//                   : const SizedBox();
//             },
//           ),
//         ],
//       ),
//     ),
//   );
// }


  Widget _buildTutorialView() {
    if (_videoController == null) {
      return Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF4CAF50),
          ),
        ),
      );
    }

    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: YoutubePlayer(
          controller: _videoController!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: const Color(0xFF4CAF50),
          progressColors: const ProgressBarColors(
            playedColor: Color(0xFF4CAF50),
            handleColor: Color(0xFF4CAF50),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15.h),
        Text(
          'Once you press Start, you will be asked to swing 5 times with a Rypstick (2 weights) or your driver. Knowing your baseline speed will help track your progress as you go through training.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.sp,
            height: 1.3,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          'You will need:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15.h),
        Text(
          '1. A RypRadar or other speed measurement tool.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.sp,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          '2. A Rypstick (2 weights) or your driver.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.sp,
          ),
        ),
        SizedBox(height: 15.h),
        Text(
          'Swipe to start when you\'re ready!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildRadarSelectionView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Radar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.bluetooth,
                color: Colors.grey[400],
                size: 20.sp,
              ),
              SizedBox(width: 10.w),
              Text(
                'Not connected',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.w),
      child: Column(
        children: [
          Divider(color: Colors.grey[600], thickness: 1),
          SizedBox(height: 30.h),
          _buildWarmUpCheck(context),
          SizedBox(height: 16.h),
          _buildSlideToStartButton(context),
          SizedBox(height: 8.h),
          _buildNoRadarButton(context),
        ],
      ),
    );
  }

  Widget _buildWarmUpCheck(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF4CAF50), width: 2),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Checkbox(
            value: _hasWarmedUp,
            onChanged: (value) {
              setState(() {
                _hasWarmedUp = value ?? false;
              });
            },
            activeColor: const Color(0xFF4CAF50),
            checkColor: Colors.white,
            side: BorderSide.none,
          ),
        ),
        SizedBox(width: 18.w),
        Text(
          'I have warmed up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(width: 16.w),
        GestureDetector(
          onTap: () {
            _showWarmUpScreen(context);
          },
          child: Text(
            'See video',
            style: TextStyle(
              color: const Color(0xFF4CAF50),
              fontSize: 15.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlideToStartButton(BuildContext context) {
    return _SlideToStartButton(
      enabled: _hasWarmedUp,
      onSlideComplete: () {
        Navigator.pop(context);
        MeasureBaselineActiveScreen.show();
      },
    );
  }

  Widget _buildNoRadarButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        AlternativeBaselineInputScreen.show();
      },
      child: Container(
        height: 30.h,
        alignment: Alignment.center,
        child: Text(
          'I don\'t have a radar',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}

class _SlideToStartButton extends StatefulWidget {
  final VoidCallback onSlideComplete;
  final bool enabled;

  const _SlideToStartButton({
    required this.onSlideComplete,
    this.enabled = false,
  });

  @override
  State<_SlideToStartButton> createState() => _SlideToStartButtonState();
}

class _SlideToStartButtonState extends State<_SlideToStartButton> {
  double _dragPosition = 0.0;
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth - 30.w;
    final maxDrag = buttonWidth - 70.w;

    return Opacity(
      opacity: widget.enabled ? 1.0 : 0.5,
      child: Container(
        height: 70.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF237537),
              Color(0xFF33C258),
            ],
          ),
          borderRadius: BorderRadius.circular(60.r),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Slide to start',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            if (widget.enabled)
              Positioned(
                left: _dragPosition.clamp(0.0, maxDrag),
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (!_isCompleted && widget.enabled) {
                      setState(() {
                        _dragPosition = (_dragPosition + details.delta.dx).clamp(0.0, maxDrag);
                      
                        if (_dragPosition >= maxDrag - 5) {

                          _isCompleted = true;
                          Get.find<MeasureBaselineActiveController>()
                          
            .startSwingSequence();
                          widget.onSlideComplete();
                        } 
                      });
                    }
                  },
                  onHorizontalDragEnd: (details) { 
                    if (!_isCompleted) {
                      setState(() {
                          
                        _dragPosition = 0.0;
                      });
                    }
                  },
                  child: Container(
                    width: 70.w,
                    height: 70.w,
                    margin: EdgeInsets.all(2.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: _dragPosition >= maxDrag * 0.8
                          ? Icon(
                              Icons.check,
                              color: const Color(0xFF4CAF50),
                              size: 28.sp,
                            )
                          : Icon(
                              Icons.arrow_forward,
                              color: const Color(0xFF4CAF50),
                              size: 24.sp,
                            ),
                    ),
                  ),
                ),
              )
            else
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 70.w,
                  height: 70.w,
                  margin: EdgeInsets.all(2.h),
                  decoration: BoxDecoration(
                    color: Color(0x76BDF4BC).withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF19D00F).withOpacity(0.8),
                      size: 24.sp,
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

class _WarmUpScreen extends StatefulWidget {
  const _WarmUpScreen();

  @override
  State<_WarmUpScreen> createState() => _WarmUpScreenState();
}

class _WarmUpScreenState extends State<_WarmUpScreen> {
  YoutubePlayerController? _warmUpVideoController;

  @override
  void initState() {
    super.initState();
    _initializeWarmUpVideo();
  }

  void _initializeWarmUpVideo() {
    final videoId =
        YoutubePlayer.convertUrlToId('https://www.youtube.com/watch?v=IF0kLstvX6M') ?? 'IF0kLstvX6M';
    _warmUpVideoController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _warmUpVideoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.93,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 20.sp),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    'Warm up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWarmUpVideoPlayer(),
                  SizedBox(height: 18.h),
                  Text(
                    'Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Please complete these steps before training. A quick warmup helps prevent injuries and makes sure you gain your top speed.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    'You will need:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    'A Rypstick.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Time to complete:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Around 5 minutes.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.sp),
            child: SignInButton(
              onPressed: () => Navigator.pop(context),
              text: 'Done',
              isValid: true,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              height: 65.h,
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildWarmUpVideoPlayer() {
    if (_warmUpVideoController == null) {
      return Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
           child: AppLoader(),
          // child: const CircularProgressIndicator(
          //   color: Colors.green,
          //   strokeWidth: 3.0,
          // ),
        ),
      );
    }

    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: YoutubePlayer(
          controller: _warmUpVideoController!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: const Color(0xFF4CAF50),
          progressColors: const ProgressBarColors(
            playedColor: Color(0xFF4CAF50),
            handleColor: Color(0xFF4CAF50),
          ),
        ),
      ),
    );
  }
}

