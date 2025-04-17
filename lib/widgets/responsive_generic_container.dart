
import 'package:flutter/material.dart';

class ResponsiveGenericContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double maxWidth;

  const ResponsiveGenericContainer({
    super.key,
    required this.child,
    this.padding,
    this.maxWidth = 600.0,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final constrainedWidth = screenWidth < maxWidth ? screenWidth : maxWidth;

    return Center(
      child: SingleChildScrollView(
        padding: padding ?? const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: constrainedWidth,
          ),
          child: child,
        ),
      ),
    );
  }
}
