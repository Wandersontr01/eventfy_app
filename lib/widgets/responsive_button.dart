import 'package:flutter/material.dart';

class ResponsiveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? icon;
  final bool isPrimary;

  const ResponsiveButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = MediaQuery.of(context).textScaleFactor;
    final isSmall = screenWidth < 400;

    final buttonStyle = isPrimary
        ? TextButton.styleFrom(
            backgroundColor: const Color(0xFFFF6D00),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: isSmall ? 14 * scale : 16 * scale,
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E1E1E),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            textStyle: TextStyle(
              fontSize: isSmall ? 14 * scale : 16 * scale,
            ),
          );

    final child = icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: isSmall ? 18 : 20),
              const SizedBox(width: 8),
              Text(text),
            ],
          )
        : Text(text);

    return isPrimary
        ? TextButton(onPressed: onPressed, style: buttonStyle, child: child)
        : ElevatedButton(onPressed: onPressed, style: buttonStyle, child: child);
  }
}
