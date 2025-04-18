import 'package:flutter/material.dart';

/// Configuration options for customizing the appearance of the NeobrutalistNavIcon
class NeobrutalistNavIconConfig {
  /// Background color for the button (overrides default white)
  final Color backgroundColor;

  /// Color for the icon (overrides default black)
  final Color iconColor;

  /// Border radius (overrides default circle shape)
  final BorderRadiusGeometry? borderRadius;

  /// Size for the icon (overrides default size)
  final double iconSize;

  /// Constructor with default values
  const NeobrutalistNavIconConfig({
    this.backgroundColor = Colors.white,
    this.iconColor = const Color(0xFF2B2B2B),
    this.borderRadius,
    this.iconSize = 24,
  });
}

/// A navigation icon button with neobrutalism design style.
///
/// Features distinctive black borders, offset shadows, and a pressed-in animation
/// state when selected or pressed.
class NeobrutalistNavIcon extends StatefulWidget {
  /// The icon to display within the button.
  final IconData icon;

  /// Whether this icon is currently selected.
  final bool isSelected;

  /// The background color when the icon is selected.
  final Color selectedBackgroundColor;

  /// Callback when the icon is tapped.
  final VoidCallback onTap;

  /// The index of this icon in the navigation bar.
  /// Used for tracking the selected state.
  final int index;

  /// Optional custom configuration for special cases
  final NeobrutalistNavIconConfig? customConfig;

  const NeobrutalistNavIcon({
    Key? key,
    required this.icon,
    required this.isSelected,
    required this.selectedBackgroundColor,
    required this.onTap,
    required this.index,
    this.customConfig,
  }) : super(key: key);

  @override
  State<NeobrutalistNavIcon> createState() => _NeobrutalistNavIconState();
}

class _NeobrutalistNavIconState extends State<NeobrutalistNavIcon> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Shadow offset changes based on selected state, not just pressed state
    final Offset shadowOffset = widget.isSelected
        ? const Offset(2, 2)
        : (_isPressed ? const Offset(2, 2) : const Offset(4, 4));

    // Get config values or use defaults
    final config = widget.customConfig;
    final bool useCustomConfig = config != null;

    // Determine shape based on custom config
    BoxShape shape = BoxShape.circle;
    BorderRadiusGeometry? borderRadius;

    if (useCustomConfig && config.borderRadius != null) {
      shape = BoxShape.rectangle;
      borderRadius = config.borderRadius;
    }

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        // Transform is applied if either pressed or selected
        transform: (widget.isSelected || _isPressed)
            ? Matrix4.translationValues(2, 2, 0)
            : null,
        decoration: BoxDecoration(
          color: useCustomConfig
              ? config.backgroundColor
              : (widget.isSelected
                  ? widget.selectedBackgroundColor
                  : Colors.white),
          shape: shape,
          borderRadius: borderRadius,
          border: Border.all(
            color: const Color(0xFF2B2B2B),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2B2B2B),
              blurRadius: 0, // No blur for crisp neobrutalism style
              spreadRadius: 0, // No spread for neobrutalism style
              offset: shadowOffset,
            ),
          ],
        ),
        child: SizedBox(
          width: useCustomConfig ? null : 44,
          height: useCustomConfig ? null : 44,
          child: Center(
            child: Icon(
              widget.icon,
              color:
                  useCustomConfig ? config.iconColor : const Color(0xFF2B2B2B),
              size: useCustomConfig
                  ? config.iconSize
                  : (widget.isSelected ? 24 : 20),
            ),
          ),
        ),
      ),
    );
  }
}
