import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../models/feature_slide.dart';

class FeatureSlideWidget extends StatelessWidget {
  final FeatureSlide slide;

  const FeatureSlideWidget({
    Key? key,
    required this.slide,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (slide.customWidget != null) ...[
            slide.customWidget!,
          ] else ...[
            _buildIcon(context),
            const SizedBox(height: 40),
            _buildTitle(context),
            const SizedBox(height: 16),
            _buildDescription(context),
            if (slide.imagePath != null) ...[
              const SizedBox(height: 24),
              _buildImage(),
            ],
          ],
        ],
      ).animate().fadeIn(duration: 300.ms),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: slide.color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        slide.icon,
        size: 80,
        color: slide.color,
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(),
        )
        .fadeIn(duration: 600.ms)
        .scale(
          delay: 200.ms,
          duration: 800.ms,
          curve: Curves.elasticOut,
          begin: const Offset(0.8, 0.8),
        )
        .shimmer(
          delay: 1000.ms,
          duration: 1800.ms,
          color: Colors.white.withOpacity(0.2),
        );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      slide.title,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
      textAlign: TextAlign.center,
    )
        .animate()
        .fadeIn(
          delay: 300.ms,
          duration: 500.ms,
        )
        .slideY(
          begin: 0.2,
          end: 0,
          curve: Curves.easeOutCubic,
          duration: 500.ms,
        );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      slide.description,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
          ),
      textAlign: TextAlign.center,
    )
        .animate()
        .fadeIn(
          delay: 400.ms,
          duration: 500.ms,
        )
        .slideY(
          begin: 0.2,
          end: 0,
          curve: Curves.easeOutCubic,
          duration: 500.ms,
        );
  }

  Widget _buildImage() {
    if (slide.imagePath == null) return const SizedBox.shrink();

    return Image.asset(
      slide.imagePath!,
      fit: BoxFit.contain,
      height: 200,
    )
        .animate()
        .fadeIn(
          delay: 500.ms,
          duration: 500.ms,
        )
        .scale(
          delay: 500.ms,
          duration: 500.ms,
          begin: const Offset(0.8, 0.8),
        );
  }
}
