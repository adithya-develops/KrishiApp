// lib/splash_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main.dart'; // Import main.dart to access PremiumBackground

class SplashScreen extends StatefulWidget {
  final VoidCallback onInitializationComplete; // <--- NEW PARAMETER

  const SplashScreen({super.key, required this.onInitializationComplete}); // <--- UPDATED CONSTRUCTOR

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Total animation duration
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut), // Fade in over first 70%
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2), // Start slightly below center
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic), // Slide in during last 70%
      ),
    );

    // Start animation and then call the callback
    _animationController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () { // Short delay after animation completes
        widget.onInitializationComplete(); // <--- CALL THE CALLBACK HERE
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PremiumBackground(
        child: Center(
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo part
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.grass_rounded,
                      color: const Color(0xFF52B3C4).withOpacity(0.85),
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Krishi",
                    style: GoogleFonts.dmSans(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -1.0,
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Smart farming, rooted in data",
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}