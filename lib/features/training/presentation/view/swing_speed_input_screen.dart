import 'package:startup_repo/imports.dart';
import '../controller/training_controller.dart';
import 'package:flutter/services.dart';

class SwingSpeedInputScreen extends StatefulWidget {
  const SwingSpeedInputScreen({super.key});

  @override
  State<SwingSpeedInputScreen> createState() => _SwingSpeedInputScreenState();
}

class _SwingSpeedInputScreenState extends State<SwingSpeedInputScreen> {
  late TextEditingController _textController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrainingController>(
      builder: (controller) {
        // Sync text controller with controller state
        if (_textController.text != controller.currentSwingSpeed) {
          _textController.text = controller.currentSwingSpeed;
        }

        return Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF237537),
                  Color(0xFF33C558),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SWING',
                        style: TextStyle(
                          fontSize: 60.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Hidden TextField for keyboard
                          Opacity(
                            opacity: 0,
                            child: SizedBox(
                              width: 1,
                              height: 1,
                              child: TextField(
                                controller: _textController,
                                focusNode: _focusNode,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                style: const TextStyle(fontSize: 1),
                                showCursor: false,
                                cursorColor: Colors.transparent,
                                onChanged: (value) {
                                  // Sync with controller - clear and rebuild
                                  final current = controller.currentSwingSpeed;
                                  if (value != current) {
                                    // Clear existing
                                    while (controller.currentSwingSpeed.isNotEmpty) {
                                      controller.removeSwingSpeedDigit();
                                    }
                                    // Add new digits
                                    for (var char in value.split('')) {
                                      controller.addSwingSpeedDigit(char);
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _focusNode.requestFocus();
                            },
                            child: Text(
                              controller.currentSwingSpeed.isEmpty || controller.currentSwingSpeed == '0'
                                  ? '0'
                                  : controller.currentSwingSpeed,
                              style: TextStyle(
                                fontSize: 64.sp,
                                fontWeight: FontWeight.bold,
                                color: (controller.currentSwingSpeed.isEmpty ||
                                        controller.currentSwingSpeed == '0')
                                    ? Colors.grey[500]
                                    : Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Text(
                              controller.speedUnit,
                              style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 60.h),
                      // Confirm button
                      GestureDetector(
                        onTap: () {
                          _focusNode.unfocus();
                          controller.confirmSwingSpeed();
                        },
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF81C784),
                            decoration: TextDecoration.underline,
                            decorationColor: const Color(0xFF81C784),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
