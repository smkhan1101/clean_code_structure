import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:startup_repo/core/theme/app_theme.dart';
import 'package:startup_repo/features/auth/presentation/controller/get_started_controller.dart';
import 'package:startup_repo/core/widgets/getstarted_button.dart';
import 'package:startup_repo/imports.dart';

import '../../../../core/widgets/header_text.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GetStartedController());
    return Scaffold(
      backgroundColor: AppThemeColors.appBgColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child:   SizedBox(
          width: Get.width,
                child: Image.asset(
                 Images.getStartedImg,
                  fit: BoxFit.fill,
                  ),
              ),),

            Expanded(
              flex: 4,

              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerText('Get your swing up to'),
                    headerText('speed with Rypstick.'),
                    SizedBox(
                        height: 31.h
                    ),
                      GradientButton(
                        onPressed: controller.handleGetStarted,
                        text: 'Get started',
                      ),
                      SizedBox(height: 5.h),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: controller.handleAlreadyHaveAccount,
                          child: Text(
                            'I already have an account',
                            style: TextStyle(
                              color: AppThemeColors.whiteColor.withOpacity(0.7),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationColor: AppThemeColors.whiteColor.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          TextButton(
                            onPressed: controller.handlePrivacyPolicy,
                            child: Text(
                              'Privacy policy',
                              style: TextStyle(
                                color: AppThemeColors.whiteColor.withOpacity(0.9),
                                fontSize: 11.sp,
                                letterSpacing: 0.5,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          Text(
                            ' • ',
                            style: TextStyle(
                              color: AppThemeColors.whiteColor.withOpacity(0.9),
                              fontSize: 11.sp,
                              letterSpacing: 0.5,
                            ),
                          ),
                          TextButton(
                            onPressed: controller.handleTermsOfService,
                            child: Text(
                              'Terms of service',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 11.sp,
                                letterSpacing: 0.5,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ],

                ),
              ),
            ),
          ],
        )
        // body:  Stack(
        //   fit: StackFit.expand,
        //   children: [
        //     Positioned(
        //       top: 0,
        //       left: 0,
        //       right: 0,
        //       bottom: MediaQuery.of(context).size.height * 0.30,
        //       child: Image.asset(
        //         'assets/images/login.jpeg',
        //         fit: BoxFit.cover,
        //       ),
        //     ),
        //     Positioned(
        //       bottom: 0,
        //       left: 0,
        //       right: 0,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           color: Colors.black,
        //         ),
        //         child: SafeArea(
        //           child: SingleChildScrollView(
        //             child: Column(
        //               mainAxisSize: MainAxisSize.min,
        //               crossAxisAlignment: CrossAxisAlignment.stretch,
        //               children: [
        //                 // Padding(
        //                 //   padding: EdgeInsets.symmetric(horizontal: 25.w),
        //                 //   child: Transform.translate(
        //                 //     offset: Offset(0, -20.h),
        //                 //     child: Padding(
        //                 //       padding: EdgeInsets.only(top: 0.h, bottom: 0.h),
        //                 //       // child: Text(
        //                 //       //   'Get your swing up to speed with Rypstick.',
        //                 //       //   style: TextStyle(
        //                 //       //     color: Colors.white,
        //                 //       //     fontSize: 30.sp,
        //                 //       //     fontWeight: FontWeight.bold,
        //                 //       //     height: 1.2,
        //                 //       //   ),
        //                 //       //   textAlign: TextAlign.left,
        //                 //       // ),
        //                 //       child: headerText('Get your swing up to  speed with Rypstick.'),
        //                 //     ),
        //                 //   ),
        //                 // ),
        //
        //
        //                 Padding(
        //                   padding: EdgeInsets.symmetric(horizontal: 25.w),
        //                   child: Column(
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       headerText('Get your swing up to'),
        //                       SizedBox(height: 6,),
        //                       headerText('speed with Rypstick.'),
        //                     ],
        //                   ),
        //                 ),
        //
        //                 SizedBox(height: 12.h),
        //                 Padding(
        //                   padding: EdgeInsets.symmetric(horizontal: 25.w),
        //                   child: Column(
        //                     mainAxisSize: MainAxisSize.min,
        //                     children: [
        //                       GradientButton(
        //                         onPressed: controller.handleGetStarted,
        //                         text: 'Get started',
        //                       ),
        //                       SizedBox(height: 4.h),
        //                       TextButton(
        //                         onPressed: controller.handleAlreadyHaveAccount,
        //                         child: Text(
        //                           'I already have an account',
        //                           style: TextStyle(
        //                             color: Colors.white.withOpacity(0.6),
        //                             fontSize: 13.sp,
        //                             fontWeight: FontWeight.w900,
        //                             decoration: TextDecoration.underline,
        //                             decorationColor: Colors.white.withOpacity(0.7),
        //                           ),
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //                 SizedBox(height: 34.h),
        //                 Row(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   crossAxisAlignment: CrossAxisAlignment.baseline,
        //                   textBaseline: TextBaseline.alphabetic,
        //                   children: [
        //                     TextButton(
        //                       onPressed: controller.handlePrivacyPolicy,
        //                       child: Text(
        //                         'Privacy policy',
        //                         style: TextStyle(
        //                           color: Colors.white.withOpacity(0.7),
        //                           fontSize: 11.sp,
        //                           letterSpacing: 0.5,
        //                         ),
        //                       ),
        //                     ),
        //                     Text(
        //                       ' • ',
        //                       style: TextStyle(
        //                         color: Colors.white.withOpacity(0.7),
        //                         fontSize: 11.sp,
        //                         letterSpacing: 0.5,
        //                       ),
        //                     ),
        //                     TextButton(
        //                       onPressed: controller.handleTermsOfService,
        //                       child: Text(
        //                         'Terms of service',
        //                         style: TextStyle(
        //                           color: Colors.white.withOpacity(0.7),
        //                           fontSize: 11.sp,
        //                           letterSpacing: 0.5,
        //                         ),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        );
  }
}
