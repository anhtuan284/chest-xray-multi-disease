import 'package:fe_flutter/src/core/widgets/elements/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/route_paths.dart';
import '../controllers/tutorial_controller.dart';
import '../models/feature_slide.dart';
import '../presentation/widgets/feature_slide_widget.dart';

class TutorialScreen extends ConsumerStatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends ConsumerState<TutorialScreen> {
  final CarouselSliderController _sliderController = CarouselSliderController();
  int _currentPage = 0;
  late List<FeatureSlide> _slides;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _slides = [
      FeatureSlide((b) => b
        ..title = "Welcome to ChestXray AI"
        ..description = "Streamline your workflow with AI-powered tools"
        ..icon = Icons.medical_services
        ..color = Theme.of(context).colorScheme.primary),
      FeatureSlide((b) => b
        ..title = "Search Medical Records"
        ..description = "Quickly find and access chest X-ray documents"
        ..icon = Icons.search
        ..color = Theme.of(context).colorScheme.secondary),
      FeatureSlide((b) => b
        ..title = "Predict Diseases"
        ..description =
            "Leverage AI to analyze chest X-rays and predict potential diseases"
        ..icon = Icons.insights
        ..color = Theme.of(context).colorScheme.tertiary),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CarouselSlider(
                controller: _sliderController,
                slideTransform: FadeTransform(fade: 0.3),
                unlimitedMode: false,
                enableAutoSlider: false,
                autoSliderTransitionTime: const Duration(milliseconds: 800),
                autoSliderDelay: const Duration(seconds: 5),
                slideIndicator: CircularSlideIndicator(
                  padding: const EdgeInsets.only(bottom: 12),
                  currentIndicatorColor: Theme.of(context).colorScheme.primary,
                  indicatorBackgroundColor: Colors.grey.withOpacity(0.3),
                  indicatorRadius: 4,
                ),
                onSlideChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: _slides
                    .map((slide) => FeatureSlideWidget(slide: slide))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 250, // Slightly wider for better proportion
                    child: _currentPage < _slides.length - 1
                        ? ModernButton(
                            text: "Next",
                            icon: Icons.arrow_forward,
                            size: ButtonSize.large,
                            color: Theme.of(context).colorScheme.secondary,
                            textStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            onPressed: () {
                              _sliderController.nextPage();
                            },
                            borderRadius: 12.0,
                            shadow: true,
                            iconSize: 20.0,
                          )
                        : ModernButton(
                            text: "Get Started",
                            icon: Icons.check_circle_outline,
                            size: ButtonSize.large,
                            color: Theme.of(context).colorScheme.primary,
                            textStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            onPressed: () => _completeTutorial(),
                            borderRadius: 12.0,
                            shadow: true,
                            iconSize: 20.0,
                          ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => _skipTutorial(),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.6), // More subtle color
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AnonymousPro',
                          fontWeight: FontWeight.bold),
                    )
                        .animate(key: ValueKey('skip-$_currentPage'))
                        .fadeIn(duration: 400.ms, curve: Curves.easeInOut),
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms, curve: Curves.easeIn),
            ),
          ],
        ),
      ),
    );
  }

  void _skipTutorial() async {
    await ref.read(tutorialControllerProvider).markTutorialAsSkipped();
    if (mounted) {
      context.go(RoutePaths.home);
    }
  }

  void _completeTutorial() async {
    await ref.read(tutorialControllerProvider).markTutorialAsCompleted();
    if (mounted) {
      context.go(RoutePaths.home);
    }
  }
}

// Simplified transform for a clean, minimal transition
class FadeTransform extends SlideTransform {
  final double fade;

  FadeTransform({
    this.fade = 0.2,
  });

  @override
  Widget transform(BuildContext context, Widget child, int index,
      int? realIndex, double offset, int itemCount) {
    // Calculate the absolute offset (distance from center)
    final double absOffset = offset.abs();

    // Calculate opacity based on offset
    final double opacity = 1.0 - (absOffset * fade).clamp(0.0, 1.0);

    return Opacity(
      opacity: opacity,
      child: child,
    );
  }
}
