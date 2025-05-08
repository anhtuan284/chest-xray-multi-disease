import 'dart:io' show Platform if (dart.library.html) 'dart:html'; // Conditional import

import 'package:fe_flutter/src/features/navigation/controllers/navigation_controller.dart';
import 'package:fe_flutter/src/routing/route_paths.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

bool get isIOSPlatform {
  if (kIsWeb) return false;

  try {
    return Platform.isIOS;
  } catch (e) {
    return false;
  }
}

class BottomNav extends ConsumerWidget {
  final int currentIndex;

  const BottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    ref.read(navigationController.notifier);
    final bool useSafeArea = isIOSPlatform;

    Widget buildNavigationBar() {
      return Container(
        height: useSafeArea ? 100 : 72,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: theme.primaryColor,
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Patients',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(width: 24, height: 24),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              activeIcon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_outlined),
              activeIcon: Icon(Icons.folder),
              label: 'Documents',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                context.go(RoutePaths.home);
                break;
              case 1:
                context.go(RoutePaths.patients);
                break;
              case 3:
                context.go(RoutePaths.chat);
                break;
              case 4:
                context.go(RoutePaths.documents);
                break;
            }
          },
        ),
      );
    }

    Widget buildFloatingActionButton() {
      return FloatingActionButton(
        onPressed: () {
          context.go(RoutePaths.prediction);
        },
        backgroundColor: theme.primaryColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add_a_photo, color: Colors.white),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        buildNavigationBar(),
        Positioned(
          left: 0,
          right: 0,
          top: -15,
          child: Center(child: buildFloatingActionButton()),
        ),
      ],
    );
  }
}
