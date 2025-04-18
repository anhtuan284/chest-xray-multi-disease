import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TutorialStep {
  final String title;
  final String description;
  final Offset position;
  final Size size;

  TutorialStep({
    required this.title,
    required this.description,
    required this.position,
    required this.size,
  });
}

class InteractiveTutorial extends ConsumerStatefulWidget {
  final List<TutorialStep> steps;
  final VoidCallback onComplete;
  final VoidCallback onSkip;

  const InteractiveTutorial({
    Key? key,
    required this.steps,
    required this.onComplete,
    required this.onSkip,
  }) : super(key: key);

  @override
  ConsumerState<InteractiveTutorial> createState() =>
      _InteractiveTutorialState();
}

class _InteractiveTutorialState extends ConsumerState<InteractiveTutorial> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    if (_currentStep >= widget.steps.length) {
      return const SizedBox.shrink();
    }

    final step = widget.steps[_currentStep];
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Semi-transparent overlay
        GestureDetector(
          onTap: () {}, // Prevent taps from passing through
          child: Container(
            width: screenSize.width,
            height: screenSize.height,
            color: Colors.black54,
          ),
        ),

        // Cutout for the highlighted element
        Positioned(
          left: step.position.dx,
          top: step.position.dy,
          child: GestureDetector(
            onTap: () {}, // Prevent taps from passing through
            child: Container(
              width: step.size.width,
              height: step.size.height,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 0,
                  ),
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Tutorial text
        Positioned(
          left: 20,
          right: 20,
          bottom: 100,
          child: Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    step.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ).animate().fadeIn(duration: 300.ms),
                  const SizedBox(height: 8),
                  Text(
                    step.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ).animate().fadeIn(delay: 200.ms, duration: 300.ms),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: widget.onSkip,
                        child: const Text("Skip Tutorial"),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentStep < widget.steps.length - 1) {
                              setState(() {
                                _currentStep++;
                              });
                            } else {
                              widget.onComplete();
                            }
                          },
                          child: Text(
                            _currentStep < widget.steps.length - 1
                                ? "Next"
                                : "Finish",
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
    );
  }
}
