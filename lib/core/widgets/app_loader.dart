import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppLoader extends StatelessWidget {
  final double size;
  final bool showBackground;
  final Color loaderColor;

  const AppLoader({
    super.key,
    this.size = 120,
      this.loaderColor = Colors.white,
    this.showBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    // final loader = Lottie.asset(
    //   'assets/images/loader.json',
    //   width: size,
    //   height: size,
    //   repeat: true,
    //   fit: BoxFit.contain,

    // );
    final loader = Lottie.asset(
  'assets/images/loader.json',
  width: size,
  height: size,
  repeat: true,
  fit: BoxFit.contain,
  delegates: LottieDelegates(
    values: [
      ValueDelegate.color(
        const ['**'], //  all layers
        value: Colors.white,
      ),
    ],
  ),
);


    return Center(
      child: showBackground
          ? Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: loaderColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: loader,
            )
          : loader,
    );
  }
}
