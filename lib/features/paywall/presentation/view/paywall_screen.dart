import 'dart:ui';
import 'package:startup_repo/imports.dart';
import '../../../../core/widgets/sign_in_button.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(10.w),
                      child: IconButton(
                        icon: Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: Colors.grey[500],
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
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 180.h,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 0.h, bottom: 20.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 20.h),
                                child: Transform.translate(
                                  offset: Offset(0, -4.h),
                                  child: const Text(
                                    "Get the most out of your\ntraining with our Pro Plan",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                              _feature("Speed train Levels 1–8"),
                              _feature(
                                  "Receive a free lesson from our award winning instructors (\$99 VALUE)"),
                              _feature("Participate in Group speed challenges with winning incentives"),
                              _feature("Access to exclusive Long Drive Exercises"),
                              _feature("Access to specialized Fitness Packages"),
                              _feature("Discount offers with partnered golf brands"),
                              SizedBox(height: 0.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 24.w,
                                    height: 24.w,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF4CAF50),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  const Expanded(
                                    child: Text(
                                      "JUST Rs 13,900/YEAR\n(-50% OFF)",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 10.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SignInButton(
                            onPressed: () {},
                            text: "Start 3-day free trial",
                            isValid: true,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            height: 65.h,
                            icon: const Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(height: 25.h),
                          const Text(
                            "You will be charged automatically after the trial ends.\nThe plan can be cancelled at any time.",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Padding(
                      padding: EdgeInsets.only(left: 25.w, right: 25.w, bottom: 4.h, top: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Terms of service",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.grey)),
                          SizedBox(width: 12),
                          Text("Restore",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12, decoration: TextDecoration.underline)),
                          SizedBox(width: 12),
                          Text("Redeem Code",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12, decoration: TextDecoration.underline)),
                        ],
                      ),
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

  Widget _feature(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.check,
            color: const Color(0xFF4CAF50),
            size: 20.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
