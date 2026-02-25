import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth_service.dart';
import 'login_screen.dart' show AuthL10n, AuthLangPickerSheet, kLanguages;
import 'main.dart';

////////////////////////////////////////////////////////////
/// ACCOUNT SETUP SCREEN
////////////////////////////////////////////////////////////

class AccountSetupScreen extends StatefulWidget {
  final String phone;
  final String uid;
  final String initialLangCode;

  const AccountSetupScreen({
    super.key,
    required this.phone,
    required this.uid,
    this.initialLangCode = "en",
  });

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen>
    with TickerProviderStateMixin {

  final nameController     = TextEditingController();
  final phoneController    = TextEditingController();
  final passwordController = TextEditingController();

  DateTime? dob;
  bool loading      = false;
  bool _obscureText = true;
  late String _langCode;

  late AnimationController _entryController;
  late AnimationController _shimmerController;
  late AnimationController _floatController;
  late Animation<double> _fadeAnim;
  late Animation<Offset>  _slideAnim;
  late Animation<double>  _floatAnim;

  AuthL10n get _l => AuthL10n(_langCode);

  @override
  void initState() {
    super.initState();
    _langCode = widget.initialLangCode;
    phoneController.text = widget.phone;

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _fadeAnim = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));
    _floatAnim = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOutSine),
    );

    // Always sync with persisted language (may differ from what login passed)
    LangStorage.load().then((code) {
      if (mounted) setState(() => _langCode = code);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    _entryController.dispose();
    _shimmerController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  ////////////////////////////////////////////////////////////
  /// LANGUAGE PICKER
  ////////////////////////////////////////////////////////////

  void _openLangPicker() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.55),
      isScrollControlled: true,
      builder: (_) => AuthLangPickerSheet(
        current: _langCode,
        onChanged: (code) {
          if (mounted) setState(() => _langCode = code);
        },
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// VALIDATION
  ////////////////////////////////////////////////////////////

  bool isValidPhone(String phone) =>
      RegExp(r'^[6-9]\d{9}$').hasMatch(phone);

  ////////////////////////////////////////////////////////////
  /// DOB PICKER
  ////////////////////////////////////////////////////////////

  Future pickDOB() async {
    HapticFeedback.lightImpact();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 15)),
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 15)),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF52B3C4),
            onPrimary: Colors.white,
            surface: Color(0xFF1A3040),
            onSurface: Colors.white,
          ),
          dialogBackgroundColor: const Color(0xFF0F2027),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => dob = picked);
  }

  ////////////////////////////////////////////////////////////
  /// SIGNUP
  ////////////////////////////////////////////////////////////

  Future signup() async {
    final name     = nameController.text.trim();
    final phone    = phoneController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || phone.isEmpty || password.isEmpty || dob == null) {
      _showError(_l.t("err_empty_signup"));
      return;
    }

    final fifteenYearsAgo =
        DateTime.now().subtract(const Duration(days: 365 * 15));
    if (dob!.isAfter(fifteenYearsAgo)) {
      _showError(_l.t("err_age"));
      return;
    }

    if (!isValidPhone(phone)) {
      _showError(_l.t("err_phone"));
      return;
    }

    if (password.length < 6) {
      _showError(_l.t("err_password"));
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() => loading = true);

    final error = await AuthService.signup(
      phone: phone,
      password: password,
      name: name,
      dob: dob!.toIso8601String().split("T")[0],
    );

    setState(() => loading = false);

    if (error == null) {
      HapticFeedback.heavyImpact();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const KrishiAI()),
        (route) => false,
      );
    } else {
      _showError(error);
    }
  }

  void _showError(String message) {
    HapticFeedback.vibrate();
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) => _SetupErrorDialog(message: message, langCode: _langCode),
    );
  }

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: PremiumBackground(
        child: Stack(
          children: [
            _buildAmbientOrbs(),
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 28),
                          _buildBrand(),
                          const SizedBox(height: 36),
                          _buildFields(),
                          const SizedBox(height: 28),
                          _buildSubmitButton(),
                          const SizedBox(height: 24),
                          _buildDivider(),
                          const SizedBox(height: 24),
                          _buildBackToLogin(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// AMBIENT ORBS
  ////////////////////////////////////////////////////////////

  Widget _buildAmbientOrbs() {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, _) {
        return Stack(
          children: [
            Positioned(
              bottom: -80 + _floatAnim.value * 0.4,
              left: -60,
              child: Container(
                width: 260, height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    const Color(0xFF52B3C4).withOpacity(0.12),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),
            Positioned(
              top: 100 + _floatAnim.value * 0.6,
              right: -40,
              child: Container(
                width: 180, height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    const Color(0xFF2C7A8C).withOpacity(0.10),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  ////////////////////////////////////////////////////////////
  /// HEADER  (back ← on left, globe on right)
  ////////////////////////////////////////////////////////////

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
          child: Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.12),
                  Colors.white.withOpacity(0.04),
                ],
              ),
              border: Border.all(color: Colors.white.withOpacity(0.16)),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white.withOpacity(0.75), size: 16),
          ),
        ),

        // Globe button
        GestureDetector(
          onTap: _openLangPicker,
          child: Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.10),
              border: Border.all(color: Colors.white.withOpacity(0.20)),
            ),
            child: const Icon(Icons.language_rounded,
                color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////////
  /// BRAND
  ////////////////////////////////////////////////////////////

  Widget _buildBrand() {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _floatAnim.value * 0.3),
        child: child,
      ),
      child: Column(
        children: [
          Container(
            width: 66, height: 66,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.14),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              border: Border.all(
                  color: Colors.white.withOpacity(0.20), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF52B3C4).withOpacity(0.18),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Icon(Icons.person_add_rounded,
                color: const Color(0xFF52B3C4).withOpacity(0.90), size: 27),
          ),
          const SizedBox(height: 14),
          Text(_l.t("create_account"),
              style: GoogleFonts.dmSans(
                  fontSize: 30, fontWeight: FontWeight.w800,
                  color: Colors.white, letterSpacing: -0.9)),
          const SizedBox(height: 4),
          Text(_l.t("join_tagline"),
              style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.36),
                  fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// FIELDS
  ////////////////////////////////////////////////////////////

  Widget _buildFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Row(
            children: [
              Container(
                width: 3, height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: const Color(0xFF52B3C4).withOpacity(0.80),
                ),
              ),
              const SizedBox(width: 10),
              Text(_l.t("your_details"),
                  style: GoogleFonts.dmSans(
                      fontSize: 16, fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.80),
                      letterSpacing: -0.2)),
              const SizedBox(width: 8),
              Text(_l.t("all_required"),
                  style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.28))),
            ],
          ),
        ),
        PremiumGlassTextField(
          controller: nameController,
          labelText: _l.t("full_name"),
          icon: Icons.person_outline_rounded,
          accentColor: const Color(0xFF52B3C4),
        ),
        const SizedBox(height: 14),
        PremiumGlassTextField(
          controller: phoneController,
          labelText: _l.t("phone"),
          icon: Icons.phone_outlined,
          accentColor: const Color(0xFF52B3C4),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 14),
        PremiumGlassTextField(
          controller: passwordController,
          labelText: _l.t("password"),
          icon: Icons.lock_outline_rounded,
          accentColor: const Color(0xFF52B3C4),
          obscureText: _obscureText,
          suffixIcon: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() => _obscureText = !_obscureText);
            },
            child: Icon(
              _obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 18,
              color: Colors.white.withOpacity(0.38),
            ),
          ),
        ),
        const SizedBox(height: 14),
        _buildDobPicker(),
      ],
    );
  }

  ////////////////////////////////////////////////////////////
  /// DOB PICKER BUTTON
  ////////////////////////////////////////////////////////////

  Widget _buildDobPicker() {
    final hasDob = dob != null;
    final dobLabel = hasDob
        ? "${dob!.day.toString().padLeft(2, '0')} / "
          "${dob!.month.toString().padLeft(2, '0')} / "
          "${dob!.year}"
        : _l.t("dob");

    return GestureDetector(
      onTap: pickDOB,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(hasDob ? 0.10 : 0.06),
          border: Border.all(
            color: hasDob
                ? const Color(0xFF52B3C4).withOpacity(0.60)
                : Colors.white.withOpacity(0.18),
            width: hasDob ? 1.4 : 1.0,
          ),
          boxShadow: hasDob
              ? [
                  BoxShadow(
                    color: const Color(0xFF52B3C4).withOpacity(0.12),
                    blurRadius: 16,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(Icons.cake_outlined,
                  size: 18,
                  color: hasDob
                      ? const Color(0xFF52B3C4)
                      : Colors.white.withOpacity(0.38)),
            ),
            Expanded(
              child: Text(
                dobLabel,
                style: GoogleFonts.dmSans(
                  fontSize: 14.5,
                  fontWeight: hasDob ? FontWeight.w600 : FontWeight.w400,
                  color: hasDob
                      ? Colors.white.withOpacity(0.88)
                      : Colors.white.withOpacity(0.38),
                ),
              ),
            ),
            Icon(Icons.calendar_today_outlined,
                size: 15, color: Colors.white.withOpacity(0.25)),
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// SUBMIT BUTTON
  ////////////////////////////////////////////////////////////

  Widget _buildSubmitButton() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        final shimmer =
            (math.sin(_shimmerController.value * 2 * math.pi) + 1) / 2;
        return GestureDetector(
          onTap: loading ? null : signup,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: loading
                  ? LinearGradient(colors: [
                      Colors.white.withOpacity(0.06),
                      Colors.white.withOpacity(0.03),
                    ])
                  : LinearGradient(
                      colors: [
                        Color.lerp(const Color(0xFF2C7A8C),
                            const Color(0xFF3A8FA0), shimmer * 0.3)!,
                        const Color(0xFF1E5F70),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
              boxShadow: loading
                  ? []
                  : [
                      BoxShadow(
                        color: const Color(0xFF1E5F70).withOpacity(0.45),
                        blurRadius: 20, offset: const Offset(0, 7),
                      ),
                      BoxShadow(
                        color: const Color(0xFF52B3C4)
                            .withOpacity(0.15 + 0.10 * shimmer),
                        blurRadius: 35, offset: const Offset(0, 4),
                      ),
                    ],
              border: loading
                  ? null
                  : Border.all(
                      color:
                          Colors.white.withOpacity(0.15 + 0.08 * shimmer),
                      width: 1.0),
            ),
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.0, color: Colors.white54))
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_l.t("create_account"),
                            style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15.5, letterSpacing: 0.1)),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded,
                            color: Colors.white.withOpacity(0.80), size: 17),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  ////////////////////////////////////////////////////////////
  /// DIVIDER
  ////////////////////////////////////////////////////////////

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.transparent, Colors.white.withOpacity(0.12),
              ]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(_l.t("already_joined"),
              style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.28),
                  fontWeight: FontWeight.w400)),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.white.withOpacity(0.12), Colors.transparent,
              ]),
            ),
          ),
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////////
  /// BACK TO LOGIN
  ////////////////////////////////////////////////////////////

  Widget _buildBackToLogin() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.pop(context);
      },
      child: AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, _) {
          final shimmer =
              (math.sin(_shimmerController.value * 2 * math.pi) + 1) / 2;
          return Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white.withOpacity(0.05),
              border: Border.all(
                  color: Colors.white.withOpacity(0.08 + 0.05 * shimmer)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_l.t("have_account"),
                    style: GoogleFonts.dmSans(
                        fontSize: 13.5,
                        color: Colors.white.withOpacity(0.38))),
                const SizedBox(width: 6),
                Text(_l.t("sign_in_link"),
                    style: GoogleFonts.dmSans(
                        fontSize: 13.5,
                        color: const Color(0xFF52B3C4).withOpacity(0.90),
                        fontWeight: FontWeight.w600)),
              ],
            ),
          );
        },
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// ERROR DIALOG
////////////////////////////////////////////////////////////

class _SetupErrorDialog extends StatefulWidget {
  final String message;
  final String langCode;
  const _SetupErrorDialog(
      {required this.message, required this.langCode});

  @override
  State<_SetupErrorDialog> createState() => _SetupErrorDialogState();
}

class _SetupErrorDialogState extends State<_SetupErrorDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 380))
      ..forward();
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AuthL10n(widget.langCode);
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
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0F2027),
                      Color(0xFF1A3040),
                      Color(0xFF203A43),
                    ],
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.40),
                        blurRadius: 40, offset: const Offset(0, 12)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.07),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.12)),
                      ),
                      child: Icon(Icons.info_outline_rounded,
                          color: Colors.white.withOpacity(0.55), size: 22),
                    ),
                    const SizedBox(height: 16),
                    Text(l.t("please_check"),
                        style: GoogleFonts.dmSans(
                            fontSize: 18, fontWeight: FontWeight.w700,
                            color: Colors.white, letterSpacing: -0.2)),
                    const SizedBox(height: 8),
                    Text(widget.message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                            fontSize: 13.5,
                            color: Colors.white.withOpacity(0.45),
                            height: 1.5)),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: double.infinity,
                        height: 46,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white.withOpacity(0.08),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.18)),
                        ),
                        child: Center(
                          child: Text(l.t("got_it"),
                              style: GoogleFonts.dmSans(
                                  color: Colors.white.withOpacity(0.80),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14)),
                        ),
                      ),
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