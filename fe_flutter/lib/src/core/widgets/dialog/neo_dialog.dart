import 'package:flutter/material.dart';

class NeoBrutalismDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final Color backgroundColor;
  final Color borderColor;
  final Color shadowColor;
  final double borderWidth;
  final double borderRadius;
  final double shadowOffset;

  const NeoBrutalismDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.backgroundColor = const Color.fromARGB(255, 255, 248, 237),
    this.borderColor = Colors.black,
    this.shadowColor = Colors.black,
    this.borderWidth = 3,
    this.borderRadius = 16,
    this.shadowOffset = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.2),
                blurRadius: 15,
                offset: Offset(0, shadowOffset),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title bar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black54),
                      onPressed: () => _safelyCloseDialog(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: content,
                ),
              ),
              // Actions
              if (actions != null && actions!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: borderColor, width: borderWidth),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Safely close the dialog to avoid navigation issues
  void _safelyCloseDialog(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // Show the dialog safely
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
    Color? backgroundColor,
    Color? borderColor,
    Color? shadowColor,
    double? borderWidth,
    double? borderRadius,
    double? shadowOffset,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false, // User must explicitly close dialog
      builder: (context) => NeoBrutalismDialog(
        title: title,
        content: content,
        actions: actions,
        backgroundColor:
            backgroundColor ?? const Color.fromARGB(255, 255, 248, 237),
        borderColor: borderColor ?? Colors.black,
        shadowColor: shadowColor ?? Colors.deepPurple.shade300,
        borderWidth: borderWidth ?? 3,
        borderRadius: borderRadius ?? 16,
        shadowOffset: shadowOffset ?? 6,
      ),
    );
  }
}
