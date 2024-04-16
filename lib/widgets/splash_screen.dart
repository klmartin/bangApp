import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashAnimation extends StatefulWidget {
  const SplashAnimation({Key? key}) : super(key: key);

  @override
  State<SplashAnimation> createState() => _SplashAnimationState();
}

class _SplashAnimationState extends State<SplashAnimation> {
  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      "assets/images/app_icon-2.jpg",
      height: 100,
    );
    Widget title = const Text(
      'BangApp',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 40,
        fontFamily: "Gilroy",
        color: Color(0xFFDDDDDD),
        height: 1,
        letterSpacing: -1,
      ),
    );
    image = image
        .animate(
          delay: 200.ms,
        )
        .fadeIn(
          duration: 600.ms,
          curve: Curves.easeOut,
        )
        .flipV(
          duration: 600.ms,
          curve: Curves.easeOut,
        );
    title = title
        .animate(delay: 800.ms, onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: 1800.ms,
          delay: 800.ms,
          color: const Color(0xFFE05A00),
          curve: Curves.easeOut,
          size: 0.1,
          colors: [
            const Color(0x00000000),
            Color(0xFFE05A00),
            Color(0xFFB00020),
            Color(0xFFE05A00),
            Color(0xFFB00020),
            Color(0xFFE05A00),
            const Color(0x00000000),
          ],
          stops: [0.2, 0.2, 0.4, 0.4, 0.6, 0.6],
        )
        .animate(
          delay: 800.ms,
        ) // this wraps the previous Animate in another Animate
        .fadeIn(duration: 800.ms, curve: Curves.easeOutQuad)
        .slide(begin: const Offset(0, 1), end: const Offset(0, 0));
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          image,
          const SizedBox(
            height: 16,
          ),
          title,
        ],
      ),
    );
  }
}
