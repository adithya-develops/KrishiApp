import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main.dart';      // LangProvider, AppLocalizations
import 'crop_data.dart'; // CropData, CropTranslator

// ═══════════════════════════════════════════════════════════════════════════
//  SCIENTIFIC NAMES MAP
// ═══════════════════════════════════════════════════════════════════════════

const Map<String, String> _scientificNames = {
  // Cereals & Grains
  "Rice":          "Oryza sativa",
  "Wheat":         "Triticum aestivum",
  "Maize":         "Zea mays",
  "Barley":        "Hordeum vulgare",
  "Jowar":         "Sorghum bicolor",
  "Bajra":         "Pennisetum glaucum",
  "Millets":       "Panicum miliaceum",
  "Ragi":          "Eleusine coracana",

  // Cash Crops
  "Sugarcane":     "Saccharum officinarum",
  "Cotton":        "Gossypium hirsutum",
  "Jute":          "Corchorus olitorius",
  "Tobacco":       "Nicotiana tabacum",

  // Oilseeds & Pulses
  "Groundnut":     "Arachis hypogaea",
  "Pulses":        "Fabaceae spp.",
  "Oilseeds":      "Various spp.",

  // Plantation & Tree Crops
  "Tea":           "Camellia sinensis",
  "Coffee":        "Coffea arabica",
  "Rubber":        "Hevea brasiliensis",
  "Cashew":        "Anacardium occidentale",
  "Coconut":       "Cocos nucifera",
  "Dates":         "Phoenix dactylifera",

  // Vegetables & Roots
  "Potatoes":      "Solanum tuberosum",

  // Fruits & Spices
  "Spices":        "Various spp.",
  "Fruits":        "Various spp.",

  // Fodder
  "Berseem":       "Trifolium alexandrinum",
};

/// Returns the scientific name for a given English crop name, or null.
String? _getScientificName(String cropEnglishName) {
  // Direct match first
  if (_scientificNames.containsKey(cropEnglishName)) {
    return _scientificNames[cropEnglishName];
  }
  // Partial match (e.g. "Salt-tolerant wheat varieties")
  for (final key in _scientificNames.keys) {
    if (cropEnglishName.toLowerCase().contains(key.toLowerCase())) {
      return _scientificNames[key];
    }
  }
  return null;
}

// ═══════════════════════════════════════════════════════════════════════════
//  BEST CROPS WIDGET
// ═══════════════════════════════════════════════════════════════════════════

class BestCropsWidget extends StatefulWidget {
  final String cropsString;
  final String soilType;

  const BestCropsWidget({
    super.key,
    required this.cropsString,
    required this.soilType,
  });

  @override
  State<BestCropsWidget> createState() => _BestCropsWidgetState();
}

class _BestCropsWidgetState extends State<BestCropsWidget>
    with SingleTickerProviderStateMixin {

  bool _expanded = false;
  String? _selectedCrop;

  late final AnimationController _ctrl;
  late final Animation<double> _expandAnim;
  late final Animation<double> _contentFade;

  static const _teal = Color(0xFF52B3C4);
  static const _duration = Duration(milliseconds: 420);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: _duration);

    _expandAnim = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    _contentFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
      reverseCurve: const Interval(0.0, 0.3, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  List<String> get _crops => widget.cropsString
      .split(',')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty && s != '--')
      .toList();

  void _toggleExpand() {
    HapticFeedback.lightImpact();
    if (_expanded) {
      _ctrl.reverse();
      setState(() {
        _expanded = false;
        _selectedCrop = null;
      });
    } else {
      _ctrl.forward();
      setState(() => _expanded = true);
    }
  }

  void _toggleCrop(String crop) {
    HapticFeedback.lightImpact();
    setState(() =>
        _selectedCrop = (_selectedCrop == crop) ? null : crop);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langCode = LangProvider.of(context).langCode;
    final crops = _crops;

    final cropListChild = _CropList(
      crops: crops,
      soilType: widget.soilType,
      selectedCrop: _selectedCrop,
      onToggle: _toggleCrop,
      langCode: langCode,
    );

    final summaryText = crops.isEmpty
        ? "--"
        : crops
            .map((c) => CropTranslator.getDisplayName(c, langCode))
            .join(", ");

    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (context, child) {
                final t = _expandAnim.value;

                final borderColor = Color.lerp(
                  Colors.white.withOpacity(0.20),
                  _teal.withOpacity(0.50),
                  t,
                )!;
                final borderWidth = 1.0 + 0.3 * t;
                final chevronColor = Color.lerp(
                  Colors.white.withOpacity(0.55),
                  _teal,
                  t,
                )!;

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.15),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                    border: Border.all(
                        color: borderColor, width: borderWidth),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ── Header ──────────────────────────────────────
                      GestureDetector(
                        onTap: _toggleExpand,
                        behavior: HitTestBehavior.translucent,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.grass_rounded,
                                size: 22,
                                color: Color.lerp(
                                  isDark
                                      ? Colors.white70
                                      : Colors.black54,
                                  _teal,
                                  t,
                                ),
                              ),
                              const SizedBox(width: 14),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      LangProvider.of(context)
                                          .l
                                          .t("best_crops"),
                                      style: GoogleFonts.dmSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: isDark
                                            ? Colors.white54
                                            : Colors.black45,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      summaryText,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                        height: 1.45,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Opacity(
                                      opacity: 1.0 - t,
                                      child: Text(
                                        "Tap to see crop details",
                                        style: GoogleFonts.dmSans(
                                          fontSize: 11,
                                          color:
                                              _teal.withOpacity(0.80),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),

                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 2),
                                child: Transform.rotate(
                                  angle: t * math.pi,
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 22,
                                    color: chevronColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ── Expandable crop list ─────────────────────────
                      ClipRect(
                        child: Align(
                          heightFactor: _expandAnim.value,
                          alignment: Alignment.topCenter,
                          child: FadeTransition(
                            opacity: _contentFade,
                            child: child,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: cropListChild,
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  CROP LIST
// ═══════════════════════════════════════════════════════════════════════════

class _CropList extends StatelessWidget {
  final List<String> crops;
  final String soilType;
  final String? selectedCrop;
  final void Function(String) onToggle;
  final String langCode;

  const _CropList({
    required this.crops,
    required this.soilType,
    required this.selectedCrop,
    required this.onToggle,
    required this.langCode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                const Color(0xFF52B3C4).withOpacity(0.40),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),

        if (crops.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Text(
              "--",
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: crops
                  .map((crop) => _CropRow(
                        cropName: crop,
                        isSelected: selectedCrop == crop,
                        soilType: soilType,
                        langCode: langCode,
                        onTap: () => onToggle(crop),
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  CROP ROW
// ═══════════════════════════════════════════════════════════════════════════

class _CropRow extends StatefulWidget {
  final String cropName;
  final bool isSelected;
  final String soilType;
  final String langCode;
  final VoidCallback onTap;

  const _CropRow({
    required this.cropName,
    required this.isSelected,
    required this.soilType,
    required this.langCode,
    required this.onTap,
  });

  @override
  State<_CropRow> createState() => _CropRowState();
}

class _CropRowState extends State<_CropRow>
    with SingleTickerProviderStateMixin {

  late final AnimationController _ctrl;
  late final Animation<double> _expandAnim;
  late final Animation<double> _contentFade;

  static const _teal = Color(0xFF52B3C4);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
      value: widget.isSelected ? 1.0 : 0.0,
    );
    _expandAnim = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _contentFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
      reverseCurve: const Interval(0.0, 0.3, curve: Curves.easeIn),
    );
  }

  @override
  void didUpdateWidget(covariant _CropRow old) {
    super.didUpdateWidget(old);
    if (widget.isSelected != old.isSelected) {
      widget.isSelected ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final details = CropData.getCropDetails(widget.cropName, widget.langCode);
    final hasDetails = details.isNotEmpty;
    final l = LangProvider.of(context).l;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final scientificName = _getScientificName(widget.cropName);

    final detailPanel = hasDetails
        ? _InlineDetailPanel(
            cropName: widget.cropName,
            details: details,
            l: l,
          )
        : null;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final t = _expandAnim.value;
        final rowColor = Color.lerp(
          Colors.white.withOpacity(0.05),
          const Color(0xFF2C7A8C).withOpacity(0.35),
          t,
        )!;
        final rowBorderColor = Color.lerp(
          Colors.white.withOpacity(0.10),
          _teal.withOpacity(0.70),
          t,
        )!;
        final rowBorderWidth = 1.0 + 0.3 * t;
        final dotColor = Color.lerp(
          Colors.white.withOpacity(0.30),
          _teal,
          t,
        )!;
        final textColor = Color.lerp(
          Colors.white.withOpacity(0.75),
          Colors.white,
          t,
        )!;
        final chevronColor = Color.lerp(
          Colors.white.withOpacity(0.40),
          _teal,
          t,
        )!;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Crop name row ──────────────────────────────────────────
            GestureDetector(
              onTap: widget.onTap,
              behavior: HitTestBehavior.translucent,
              child: Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: rowColor,
                  border: Border.all(
                      color: rowBorderColor, width: rowBorderWidth),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: dotColor,
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Common name
                          Text(
                            CropTranslator.getDisplayName(
                                widget.cropName, widget.langCode),
                            style: GoogleFonts.dmSans(
                              fontSize: 14.5,
                              fontWeight: FontWeight.lerp(
                                FontWeight.w500,
                                FontWeight.w700,
                                t,
                              ),
                              color: textColor,
                            ),
                          ),
                          // Scientific name in italics — only shown if found
                          if (scientificName != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              scientificName,
                              style: GoogleFonts.dmSans(
                                fontSize: 11.5,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w400,
                                color: _teal.withOpacity(
                                  0.55 + 0.30 * t, // brightens slightly when selected
                                ),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    if (hasDetails)
                      Transform.rotate(
                        angle: t * math.pi,
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: chevronColor,
                        ),
                      )
                    else
                      Icon(
                        Icons.info_outline_rounded,
                        size: 16,
                        color: Colors.white.withOpacity(0.25),
                      ),
                  ],
                ),
              ),
            ),

            // ── Inline detail panel ────────────────────────────────────
            if (hasDetails && detailPanel != null)
              ClipRect(
                child: Align(
                  heightFactor: _expandAnim.value,
                  alignment: Alignment.topCenter,
                  child: FadeTransition(
                    opacity: _contentFade,
                    child: child,
                  ),
                ),
              ),
          ],
        );
      },
      child: detailPanel,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  INLINE DETAIL PANEL
// ═══════════════════════════════════════════════════════════════════════════

class _InlineDetailPanel extends StatelessWidget {
  final String cropName;
  final Map<String, dynamic> details;
  final AppLocalizations l;

  const _InlineDetailPanel({
    required this.cropName,
    required this.details,
    required this.l,
  });

  @override
  Widget build(BuildContext context) {
    final langCode = LangProvider.of(context).langCode;
    final scientificName = _getScientificName(cropName);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.18),
        border: Border.all(
          color: const Color(0xFF52B3C4).withOpacity(0.20),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Crop name header with scientific name ────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.eco_rounded,
                  size: 15, color: Color(0xFF52B3C4)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CropTranslator.getDisplayName(cropName, langCode),
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF52B3C4),
                      ),
                    ),
                    if (scientificName != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        scientificName,
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF52B3C4).withOpacity(0.65),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Detail rows ──────────────────────────────────────────────
          _DetailRow(
            icon: Icons.thermostat_outlined,
            label: l.t("ideal_temperature"),
            value: details["temperature"] ?? "--",
          ),
          _DetailRow(
            icon: Icons.water_drop_outlined,
            label: l.t("water_requirements"),
            value: details["water"] ?? "--",
          ),
          _DetailRow(
            icon: Icons.wb_sunny_outlined,
            label: l.t("sunlight"),
            value: details["sunlight"] ?? "--",
          ),
          _DetailRow(
            icon: Icons.science_outlined,
            label: l.t("key_nutrients"),
            value: details["nutrients"] ?? "--",
          ),
          _DetailRow(
            icon: Icons.agriculture_outlined,
            label: l.t("fertilizer_advice"),
            value: details["fertilizer"] ?? "--",
          ),
          if ((details["notes"] as String?)?.isNotEmpty == true)
            _DetailRow(
              icon: Icons.lightbulb_outline_rounded,
              label: l.t("additional_notes"),
              value: details["notes"] ?? "--",
              isLast: true,
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  SHARED DETAIL ROW
// ═══════════════════════════════════════════════════════════════════════════

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF52B3C4).withOpacity(0.12),
            ),
            child: Icon(icon,
                size: 13,
                color: const Color(0xFF52B3C4).withOpacity(0.85)),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF52B3C4).withOpacity(0.90),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.82),
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}