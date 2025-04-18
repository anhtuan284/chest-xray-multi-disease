import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// A loading animation widget using Lottie animations
class LottieLoadingAnimation extends StatelessWidget {
  /// The size of the animation
  final double size;
  
  /// Optional color override for the animation
  final Color? color;
  
  /// The path to the Lottie animation file
  final String animationPath;
  
  /// Whether the animation should repeat
  final bool repeat;

  const LottieLoadingAnimation({
    super.key,
    this.size = 100.0,
    this.color,
    this.animationPath = 'assets/animations/loading_animation.json',
    this.repeat = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Lottie.asset(
        animationPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        repeat: repeat,
        frameRate: FrameRate.max,
        delegates: color != null
            ? LottieDelegates(
                values: [
                  ValueDelegate.color(
                    const ['**'],
                    value: color,
                  ),
                ],
              )
            : null,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to a standard loading indicator if Lottie fails
          return SizedBox(
            width: size,
            height: size,
            child: Center(
              child: CircularProgressIndicator(
                color: color ?? Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
