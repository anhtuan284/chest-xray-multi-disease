import 'package:flutter/material.dart';

// Enum for size options
enum ButtonSize { small, medium, large }

class ModernButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final ButtonSize size;
  final Color color;
  final TextStyle textStyle;
  final VoidCallback? onPressed;
  final double borderRadius;
  final bool shadow;
  final double iconSize;

  const ModernButton({
    Key? key,
    required this.text,
    this.icon,
    this.size = ButtonSize.small,
    required this.color,
    required this.textStyle,
    required this.onPressed,
    this.borderRadius = 12.0,
    this.shadow = true,
    this.iconSize = 24.0,
  }) : super(key: key);

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton> {
  // Pressing state for animation
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Size configuration based on the enum
    double width = 0;
    double height = 0;

    switch (widget.size) {
      case ButtonSize.small:
        width = 120;
        height = 30;
        break;
      case ButtonSize.medium:
        width = 180;
        height = 50;
        break;
      case ButtonSize.large:
        width = 250;
        height = 60;
        break;
    }

    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        width: width,
        height: height,
        transform: _isPressed ? Matrix4.translationValues(0, 2, 0) : null,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: widget.shadow && !_isPressed
              ? [
                  BoxShadow(
                    color: widget.color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: widget.iconSize,
                  color: widget.textStyle.color,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                widget.text,
                style: widget.textStyle.copyWith(
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A text button styled in the neobrutal design language
class NeobrutalismTextButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;
  final double iconSize;
  final MainAxisAlignment alignment;
  final TextDecoration? decoration;
  final Color? textColor;

  const NeobrutalismTextButton({
    Key? key,
    required this.text,
    this.icon,
    this.textStyle,
    required this.onPressed,
    this.iconSize = 18.0,
    this.alignment = MainAxisAlignment.center,
    this.decoration,
    this.textColor,
  }) : super(key: key);

  @override
  State<NeobrutalismTextButton> createState() => _NeobrutalismTextButtonState();
}

class _NeobrutalismTextButtonState extends State<NeobrutalismTextButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Get default text style with theme colors
    final defaultTextStyle = TextStyle(
      fontFamily: 'AnonymousPro',
      color: widget.textColor ?? Theme.of(context).colorScheme.onPrimary,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );

    // Merge with provided textStyle if any
    final effectiveTextStyle = widget.textStyle?.copyWith(
          color: widget.textStyle?.color ?? defaultTextStyle.color,
        ) ??
        defaultTextStyle;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          // Create subtle visual feedback when pressed
          transform: _isPressed ? Matrix4.translationValues(1, 1, 0) : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: widget.alignment,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: widget.iconSize,
                  color: _getIconColor(effectiveTextStyle.color!),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                widget.text,
                style: effectiveTextStyle.copyWith(
                  color: _getTextColor(effectiveTextStyle.color!),
                  decoration: _isHovered || _isPressed
                      ? widget.decoration ?? TextDecoration.underline
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTextColor(Color baseColor) {
    if (_isPressed) {
      return baseColor.withAlpha(178);
    }
    return baseColor;
  }

  Color _getIconColor(Color baseColor) {
    if (_isPressed) {
      return baseColor.withAlpha(178);
    }
    return baseColor;
  }
}

/// A small icon button with neo-brutalist styling
class NeobrutalismIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color color;
  final Color? iconColor;
  final double size;
  final double iconSize;
  final double borderRadius;
  final double shadowOffset;

  const NeobrutalismIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.color,
    this.iconColor = Colors.black,
    this.size = 32,
    this.iconSize = 16,
    this.borderRadius = 6,
    this.shadowOffset = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(shadowOffset, shadowOffset),
            blurRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(icon, size: iconSize, color: iconColor),
          ),
        ),
      ),
    );
  }
}
