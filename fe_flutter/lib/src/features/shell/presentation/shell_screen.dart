import 'package:flutter/material.dart';

import '../../navigation/presentation/bottom_nav.dart';

class ShellScreen extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const ShellScreen({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNav(currentIndex: currentIndex),
    );
  }
}
