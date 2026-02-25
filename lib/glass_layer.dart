// lib/glass_layer.dart
import 'dart:ui';
import 'package:flutter/material.dart';

class GlassLayer extends StatelessWidget {
  final double blur;
  final double opacity;
  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final Color baseColor; // Added for more control

  const GlassLayer({
    super.key,
    this.blur = 10,
    this.opacity = 0.1,
    required this.child,
    this.borderRadius,
    this.baseColor = Colors.white, // Default to white
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius?? BorderRadius.circular(0), // Use provided or default
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: baseColor.withOpacity(opacity), // Use baseColor with opacity
            borderRadius: borderRadius,
          ),
          child: child,
        ),
      ),
    );
  }
}