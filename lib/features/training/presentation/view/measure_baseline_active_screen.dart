import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../imports.dart';
import '../controller/measure_baseline_active_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MeasureBaselineActiveScreen extends StatefulWidget {
  const MeasureBaselineActiveScreen({super.key});

  static void show() {
    Get.to(() => const MeasureBaselineActiveScreen());
  }

  @override
  State<MeasureBaselineActiveScreen> createState() => _MeasureBaselineActiveScreenState();
}

class _MeasureBaselineActiveScreenState extends State<MeasureBaselineActiveScreen> {
  var controller = Get.find<MeasureBaselineActiveController>();
   @override
  void initState() {
    super.initState();

    // ✅ Only once when screen is pushed
    controller.resetFlow();             
    controller.startInitialCountdown();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MeasureBaselineActiveController>(
      init: Get.find<MeasureBaselineActiveController>(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                controller.trainingCompleted
                    ? _buildTrainingCompletedView(controller)
                    : _buildStandardView(controller),
                if (controller.swingSheetPresented)
                  _buildSwingSheet(controller),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStandardView(MeasureBaselineActiveController controller) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          _buildHeader(controller),
          const Spacer(),
          _buildActionArea(controller),
          const Spacer(),
          _buildFooter(controller),
        ],
      ),
    );
  }

  Widget _buildHeader(MeasureBaselineActiveController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Baseline Test - Normal Golf Swings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20.h),
        _buildTutorialView(controller),
      ],
    );
  }

  Widget _buildTutorialView(MeasureBaselineActiveController controller) {
    final videoId = controller.baselineVideoId;
    if (videoId == null || videoId.isEmpty) {
      return Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12.r),
        ),
      );
    }

    final youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: YoutubePlayer(
          controller: youtubeController,
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

  Widget _buildActionArea(MeasureBaselineActiveController controller) {
    return Column(
      children: [
        if (controller.swingSequenceActive) ...[
          Text(
            'PREPARE TO SWING',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [
                    Color(0xFF237537),
                    Color(0xFF33C258),
                  ],
                ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
            ),
          ),
          SizedBox(height: 15.h),
          Text(
            'Dominant, two weights or driver',
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.hourglass_empty,
                color: Colors.white,
                size: 20.sp,
              ),
              SizedBox(width: 5.w),
              Text(
                controller.nextSwingCountdownString,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
        ] else
          _buildStartButton(controller),
      ],
    );
  }

  Widget _buildStartButton(MeasureBaselineActiveController controller) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            controller.resetFlow();             
    controller.startInitialCountdown();
            controller.startSwingSequence();

          },
          child: Text(
            'START',
            style: TextStyle(
              fontSize: 60.sp,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [
                    Color(0xFF237537),
                    Color(0xFF33C258),
                  ],
                ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
            ),
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          'Press when ready',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(MeasureBaselineActiveController controller) {
    return _buildProgressLine(controller);
  }

  Widget _buildProgressLine(MeasureBaselineActiveController controller) {
    final width = MediaQuery.of(Get.context!).size.width - 40.w;
    return Stack(
      children: [
        Container(
          width: width,
          height: 30.h,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.25),
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        Container(
          width: width * controller.trainingProgressPercentage,
          height: 30.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF237537),
                Color(0xFF33C258),
              ],
            ),
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingCompletedView(MeasureBaselineActiveController controller) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Great start!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          _buildNewBaselineView(controller),
          const Spacer(),
          _buildFinishButton(controller),
        ],
      ),
    );
  }

  Widget _buildNewBaselineView(MeasureBaselineActiveController controller) {
    final newBaseline = controller.newBaseline;
    final speedUnit = controller.speedUnit;

    return Column(
      children: [
        Text(
          'Your baseline speed:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          '${newBaseline.toInt()} $speedUnit',
          style: TextStyle(
            fontSize: 60.sp,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: [
                  Color(0xFF237537),
                  Color(0xFF33C258),
                ],
              ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'You can now begin training.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildFinishButton(MeasureBaselineActiveController controller) {
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: ElevatedButton(
        onPressed: () {
          controller.finishTraining();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF237537),
                Color(0xFF33C258),
              ],
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Finish',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10.w),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwingSheet(MeasureBaselineActiveController controller) {
    return Container(
      color: Colors.black,
      child: _buildSwingSpeedInputView(controller),
    );
  } 
   
Widget _buildSwingSpeedInputView(MeasureBaselineActiveController controller) {
  // 🚀 START COUNTDOWN ON FIRST BUILD
  // Use a flag to avoid double animation on first frame
  // WidgetsBinding.instance.addPostFrameCallback((_) {
  //    controller.resetFlow();             
  // controller.startInitialCountdown();
  // //   if (!controller.countdownStarted) {
       
  // //     controller.resetFlow();             
  // // controller.startInitialCountdown();
  // //   }
  // });

  return Scaffold(
    backgroundColor: Colors.black,
    body: Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            color: const Color(0xFF4CAF50),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ✅ AnimatedSwitcher for countdown
                  if (controller.showCountdown)
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutBack,
                          ),
                          child: FadeTransition(opacity: animation, child: child),
                        );
                      },
                      child: Text(
                        controller.animatedSwingSpeed.toString(),
                        key: ValueKey(controller.animatedSwingSpeed),
                        style: TextStyle(
                          fontSize: 64.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                  // ✅ Animate SWING only once
                  if (controller.showSwingText && !controller.swingAnimationPlayed)
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Text(
                        'SWING',
                        key: const ValueKey('swing_animation'),
                        style: TextStyle(
                          fontSize: 48.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                    ),

                  // ✅ Main UI: show static SWING + 0 MPH + Confirm
                  if (controller.showMainUI)
                    Column(
                      children: [
                        // Static SWING (no animation, prevents double bounce)
                        Text(
                          'SWING',
                          style: TextStyle(
                            fontSize: 48.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 3,
                          ),
                        ),
                        SizedBox(height: 16.h),
                  Row(
  mainAxisAlignment: MainAxisAlignment.center, // center horizontal alignment
  crossAxisAlignment: CrossAxisAlignment.center, // center vertical alignment
  mainAxisSize: MainAxisSize.min, // tight row, no extra space
  children: [
    // 1️⃣ Editable TextField inside green container
    Flexible(
      child: Container(
        width: 150.w,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          // color: const Color(0xFF4CAF50), 
            //  color: Colors.amber, // green background
          borderRadius: BorderRadius.circular(12.r), 
        ),
        child: TextField(
          // controller: controller.swingSpeedController,
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: 64.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
          cursorColor: Colors.transparent,
          decoration: InputDecoration(
            hintText: '0',
            hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 64.sp,
              fontWeight: FontWeight.bold,
            ),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            fillColor: Colors.transparent,
            filled: true,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) {
            controller.setSwingSpeed(value);
          },
        ),
      ),
    ),

    // SizedBox(width: 8.w), // gap between TextField and unit text

    // 2️⃣ Unit text
    Flexible(
      child: Text(
        controller.speedUnit,
        style: TextStyle(
          // fontSize: 24.sp,
          fontSize: 30.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          
        ),
      ),
    ),
  ],
),




                        // Speed row
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             // Text(
//                             //   controller.currentSwingSpeed,
//                             //   style: TextStyle(
//                             //     fontSize: 64.sp,
//                             //     fontWeight: FontWeight.bold,
//                             //     color: Colors.white,
//                             //   ),
//                             // ),
//                            Expanded(child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//         decoration: BoxDecoration(
//           color: const Color(0xFF4CAF50), // green background
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         child: TextField(
//   // controller: controller.swingSpeedController,
//   keyboardType: TextInputType.number,
//   style: TextStyle(
//     fontSize: 64.sp,
//     fontWeight: FontWeight.bold,
//     color: Colors.white, // entered text color
//   ),
//   textAlign: TextAlign.center,
//   cursorColor: Colors.transparent, // cursor visible
//   decoration: InputDecoration(
//     hintText: '0', // placeholder
//     hintStyle: TextStyle(
//       color: Colors.white, // hint text color
//       fontSize: 64.sp,
//       fontWeight: FontWeight.bold,
//     ),
//     border: InputBorder.none,
//     enabledBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: Colors.transparent),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: Colors.transparent),
//     ),
//     disabledBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: Colors.transparent),
//     ),
//     fillColor: Colors.transparent,
//     filled: true,
//     isDense: false,
//     contentPadding: EdgeInsets.zero,
//   ),
//   onChanged: (value) { 
//     print('swing value is : $value');
//     controller.setSwingSpeed(value);
//   },
// )
// ,
// //         child: TextField(
// //     // controller: controller.swingSpeedController,
// //   keyboardType: TextInputType.number,
  
// //   style: TextStyle(
// //     fontSize: 64.sp,
// //     fontWeight: FontWeight.bold,
// //     color: Colors.white, // text visible
// //   ),
// //   textAlign: TextAlign.center,
// //   cursorColor: Colors.transparent,
  
// //   decoration: InputDecoration(
// //     border: InputBorder.none, // default border none
// //     enabledBorder: OutlineInputBorder(
// //       borderSide: BorderSide(color: Colors.transparent),
// //     ),
// //     focusedBorder: OutlineInputBorder(
// //       borderSide: BorderSide(color: Colors.transparent),
// //     ),
// //     disabledBorder: OutlineInputBorder(
// //       borderSide: BorderSide(color: Colors.transparent),
// //     ),
// //     fillColor: Colors.transparent,
// //     filled: true,
// //     isDense: true,
// //     contentPadding: EdgeInsets.zero,
// //   ),
// //   onChanged: (value) { 
// //     print('swing value is : $value');
// //       controller.setSwingSpeed(value);
// //   },
// // ),

//       ),
//       ),
//                             // SizedBox(width: 8.w),
//                             Expanded(
//                               child: Padding(
//                                 padding: EdgeInsets.only(bottom: 12.h),
//                                 child: Text(
//                                   controller.speedUnit,
//                                   style: TextStyle(
//                                     fontSize: 24.sp,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
                        SizedBox(height: 24.h),

                        // Confirm button
                        GestureDetector(
                          onTap: controller.confirmSwingSpeed,
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
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
      ],
    ),
  );
}

// Widget _buildSwingSpeedInputView(MeasureBaselineActiveController controller) {

  Widget _buildKeypadButton({
    String? text,
    IconData? icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: text != null
              ? Text(
                  text,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                )
              : Icon(
                  icon,
                  color: Colors.white,
                  size: 28.sp,
                ),
        ),
      ),
    );
  }
}

