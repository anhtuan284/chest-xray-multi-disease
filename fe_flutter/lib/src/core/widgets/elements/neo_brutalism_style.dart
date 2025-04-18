import 'package:flutter/material.dart';

class NeoBrutalismComponents {
  static BoxDecoration container({
    Color? backgroundColor,
    Color borderColor = Colors.black,
    double borderWidth = 2,
    double borderRadius = 12,
    Offset offset = const Offset(4, 4),
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: [
        BoxShadow(
          color: borderColor,
          offset: offset,
          blurRadius: 0,
        ),
      ],
    );
  }

  static AppBar appBar(BuildContext context, String title) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(
          height: 2,
          color: Colors.black,
        ),
      ),
    );
  }
}
