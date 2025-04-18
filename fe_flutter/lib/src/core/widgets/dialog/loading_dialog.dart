import 'package:fe_flutter/src/core/widgets/loading_animation.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String displayText;

  const LoadingDialog({super.key, this.displayText = 'Loading...'});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LottieLoadingAnimation(
            size: 120,
          ),
          const SizedBox(height: 16),
          Text(
            displayText,
          ),
        ],
      ),
    );
  }
}
