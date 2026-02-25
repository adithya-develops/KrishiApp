import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth_service.dart';
import 'login_screen.dart';
import 'main.dart';

////////////////////////////////////////////////////////////
/// HELPERS
////////////////////////////////////////////////////////////

String formatDOB(dynamic dob) {
  if (dob == null) return "-";
  try {
    String dateString = dob.toString();
    if (dateString.contains(" ")) return dateString.split(" ")[0];
    if (dateString.contains("T")) return dateString.split("T")[0];
    return dateString;
  } catch (e) {
    return dob.toString();
  }
}

String initials(String? name) {
  if (name == null || name.trim().isEmpty) return "?";
  final parts = name.trim().split(" ");
  if (parts.length == 1) return parts[0][0].toUpperCase();
  return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
}

////////////////////////////////////////////////////////////
/// ACCOUNT SCREEN
////////////////////////////////////////////////////////////

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with TickerProviderStateMixin {

  Map<String, dynamic>? userData;
  bool loading = true;

  late AnimationController _entryController;
  late AnimationController _avatarPulse;
  late AnimationController _shimmerController;

  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _avatarPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _fadeAnim = CurvedAnimation(parent: _entryController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic));

    loadUser();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _avatarPulse.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  Future loadUser() async {
    final data = await AuthService.getUser();
    setState(() {
      userData = data;
      loading = false;
    });
    _entryController.forward();
  }

  Future logout() async {
    HapticFeedback.mediumImpact();

    // Confirm dialog
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) => _LogoutConfirmDialog(),
    );
    if (confirmed != true) return;

    await AuthService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PremiumBackground(
        child: loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white38,
                  strokeWidth: 1.5,
                ),
              )
            : FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            _buildHeader(),
                            const SizedBox(height: 32),
                            _buildProfileCard(),
                            const SizedBox(height: 20),
                            _buildLogoutButton(),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// HEADER — back arrow + title
  ////////////////////////////////////////////////////////////

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
                border: Border.all(color: Colors.white.withOpacity(0.14)),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white.withOpacity(0.75),
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            "Profile",
            style: GoogleFonts.dmSans(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// PROFILE CARD
  ////////////////////////////////////////////////////////////

  Widget _buildProfileCard() {
    final name = userData?["name"] as String? ?? "-";
    final phone = userData?["phone"] as String? ?? "-";
    final dob = formatDOB(userData?["dob"]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: AnimatedBuilder(
            animation: _shimmerController,
            builder: (context, child) {
              final angle = _shimmerController.value * 2 * math.pi;
              final borderOpacity = 0.10 + 0.06 * math.sin(angle);
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.09),
                      const Color(0xFF1B3A47).withOpacity(0.55),
                      Colors.white.withOpacity(0.04),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(borderOpacity),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.30),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: child,
              );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
              child: Column(
                children: [
                  // Avatar
                  _buildAvatar(name),
                  const SizedBox(height: 20),

                  // Name
                  Text(
                    name,
                    style: GoogleFonts.dmSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "A Proud Farmer",
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: const Color(0xFF52B3C4).withOpacity(0.85),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Divider
                  _thinDivider(),

                  const SizedBox(height: 24),

                  // Info rows
                  _infoRow(
                    icon: Icons.phone_outlined,
                    label: "Phone",
                    value: phone,
                  ),
                  const SizedBox(height: 18),
                  _infoRow(
                    icon: Icons.cake_outlined,
                    label: "Date of Birth",
                    value: dob,
                  ),

                  const SizedBox(height: 24),
                  _thinDivider(),
                  const SizedBox(height: 20),

                  // Member badge
                  _memberBadge(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// AVATAR with pulsing ring
  ////////////////////////////////////////////////////////////

  Widget _buildAvatar(String name) {
    return AnimatedBuilder(
      animation: _avatarPulse,
      builder: (context, child) {
        final pulse = _avatarPulse.value;
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulse ring
            Container(
              width: 90 + 8 * pulse,
              height: 90 + 8 * pulse,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF52B3C4).withOpacity(0.12 + 0.10 * pulse),
                  width: 1.5,
                ),
              ),
            ),
            // Inner ring
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.18),
                  width: 1.2,
                ),
              ),
            ),
            // Avatar circle
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.10),
              ),
              child: Center(
                child: Text(
                  initials(name),
                  style: GoogleFonts.dmSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withOpacity(0.90),
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  ////////////////////////////////////////////////////////////
  /// INFO ROW
  ////////////////////////////////////////////////////////////

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.07),
            border: Border.all(color: Colors.white.withOpacity(0.10)),
          ),
          child: Icon(icon, size: 16, color: Colors.white.withOpacity(0.55)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.40),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.88),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////////
  /// MEMBER BADGE
  ////////////////////////////////////////////////////////////

  Widget _memberBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white.withOpacity(0.06),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.eco_rounded,
            size: 14,
            color: const Color(0xFF52B3C4).withOpacity(0.80),
          ),
          const SizedBox(width: 8),
          Text(
            "Active Krishi Member",
            style: GoogleFonts.dmSans(
              fontSize: 12.5,
              color: Colors.white.withOpacity(0.55),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// THIN DIVIDER
  ////////////////////////////////////////////////////////////

  Widget _thinDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withOpacity(0.10),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// LOGOUT BUTTON
  ////////////////////////////////////////////////////////////

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: logout,
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withOpacity(0.05),
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout_rounded,
                size: 16,
                color: Colors.white.withOpacity(0.45),
              ),
              const SizedBox(width: 10),
              Text(
                "Sign Out",
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.50),
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// LOGOUT CONFIRM DIALOG
////////////////////////////////////////////////////////////

class _LogoutConfirmDialog extends StatefulWidget {
  @override
  State<_LogoutConfirmDialog> createState() => _LogoutConfirmDialogState();
}

class _LogoutConfirmDialogState extends State<_LogoutConfirmDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
              child: Container(
                padding: const EdgeInsets.fromLTRB(26, 30, 26, 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0F2027),
                      Color(0xFF1A3040),
                      Color(0xFF203A43),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.12),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.40),
                      blurRadius: 40,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.07),
                        border: Border.all(color: Colors.white.withOpacity(0.12)),
                      ),
                      child: Icon(
                        Icons.logout_rounded,
                        color: Colors.white.withOpacity(0.55),
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "Sign Out?",
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "You'll need to sign back in\nto access your account.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        fontSize: 13.5,
                        color: Colors.white.withOpacity(0.45),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 26),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context, false),
                            child: Container(
                              height: 46,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white.withOpacity(0.07),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.14),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.dmSans(
                                    color: Colors.white.withOpacity(0.65),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context, true),
                            child: Container(
                              height: 46,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white.withOpacity(0.10),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.20),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Sign Out",
                                  style: GoogleFonts.dmSans(
                                    color: Colors.white.withOpacity(0.85),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}