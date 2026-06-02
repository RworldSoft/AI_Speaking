import 'package:flutter/material.dart';

/// A container with rounded top corners designed to hold onboarding content.
/// It typically overlaps the bottom of the [AvatarHeader].
class BottomCardContainer extends StatelessWidget {
  /// The content to display inside the container.
  final Widget child;

  /// Optional padding for the container content.
  final EdgeInsetsGeometry padding;

  /// Optional background color, defaults to white.
  final Color? backgroundColor;

  const BottomCardContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24.0),
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
