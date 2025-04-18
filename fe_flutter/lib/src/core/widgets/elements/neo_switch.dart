import 'package:flutter/material.dart';

class NeobrutalismSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;

  const NeobrutalismSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.activeColor,
    required this.inactiveColor,
  }) : super(key: key);

  @override
  State<NeobrutalismSwitch> createState() => _NeobrutalismSwitchState();
}

class _NeobrutalismSwitchState extends State<NeobrutalismSwitch> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onChanged(!widget.value);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 60,
        height: 32,
        transform: _isPressed ? Matrix4.translationValues(2, 2, 0) : null,
        decoration: BoxDecoration(
          color: widget.value ? widget.activeColor : widget.inactiveColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2B2B2B), width: 2),
          boxShadow: _isPressed
              ? null
              : [
                  const BoxShadow(
                    color: Color(0xFF2B2B2B),
                    offset: Offset(4, 4),
                  ),
                ],
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 150),
              left: widget.value ? 30 : 2,
              top: 2,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF2B2B2B),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
