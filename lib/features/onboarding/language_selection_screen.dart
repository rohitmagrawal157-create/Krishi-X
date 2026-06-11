// lib/features/onboarding/language_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/l10n/app_localizations.dart';

// ─────────────────────────────────────────────────────────────
// Constants
// ─────────────────────────────────────────────────────────────

abstract final class _C {
  static const Color  green      = AppColors.bannerGreen;
  static const Color  greenLight = Color(0xFFE8F5E9);
  static const double chipRadius = 14.0;
  static const double gap        = 12.0;
}

// ─────────────────────────────────────────────────────────────
// Language data
// ─────────────────────────────────────────────────────────────

class _Lang {
  const _Lang({
    required this.locale,
    required this.native,
    required this.greeting,
  });
  final Locale locale;
  final String native;
  final String greeting;
}

const List<_Lang> _kLanguages = [
  _Lang(locale: Locale('hi'), native: 'हिंदी',    greeting: 'नमस्ते'),
  _Lang(locale: Locale('mr'), native: 'मराठी',    greeting: 'नमस्कार'),
  _Lang(locale: Locale('en'), native: 'English',  greeting: 'Hello'),
  _Lang(locale: Locale('gu'), native: 'ગુજરાતી', greeting: 'નમસ્તે'),
];

// ─────────────────────────────────────────────────────────────
// Route wrapper
// ─────────────────────────────────────────────────────────────

class LanguageSelectionRoute extends StatefulWidget {
  const LanguageSelectionRoute({
    super.key,
    required this.initialLocale,
    required this.onLocaleChanged,
    required this.onComplete,
    this.onBack,
    this.step = 3,
  });

  final Locale               initialLocale;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<Locale> onComplete;
  final VoidCallback?        onBack;
  final int                  step;

  @override
  State<LanguageSelectionRoute> createState() =>
      _LanguageSelectionRouteState();
}

class _LanguageSelectionRouteState
    extends State<LanguageSelectionRoute> {
  late Locale _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialLocale;
  }

  void _onChipTapped(Locale locale) {
    setState(() => _selected = locale);
    widget.onLocaleChanged(locale);
  }

  void _onContinue() {
    HapticFeedback.mediumImpact();
    widget.onComplete(_selected);
  }

  @override
  Widget build(BuildContext context) {
    return LanguageSelectionScreen(
      selectedLocale:   _selected,
      step:             widget.step,
      showBackButton:   widget.onBack != null,
      onBack:           widget.onBack,
      onLocaleSelected: _onChipTapped,
      onContinue:       _onContinue,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Pure UI screen — uses plain Scaffold
// ─────────────────────────────────────────────────────────────

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({
    super.key,
    required this.selectedLocale,
    required this.onLocaleSelected,
    required this.onContinue,
    this.step           = 3,
    this.showBackButton = false,
    this.onBack,
  });

  final Locale               selectedLocale;
  final ValueChanged<Locale> onLocaleSelected;
  final VoidCallback         onContinue;
  final int                  step;
  final bool                 showBackButton;
  final VoidCallback?        onBack;

  String get _stepLabel => 'Step $step of 3';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final selLang = _kLanguages.firstWhere(
      (l) => l.locale.languageCode == selectedLocale.languageCode,
      orElse: () => _kLanguages[2],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: showBackButton
          ? AppBar(
              backgroundColor: Colors.white,
              elevation:        0,
              leading: IconButton(
                icon:    const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 20),
                color:   const Color(0xFF1A2E1A),
                onPressed: onBack,
              ),
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              // ── Step indicator ──────────────────────────
              _StepIndicator(current: step, total: 3),
              const SizedBox(height: 28),

              // ── Header ──────────────────────────────────
              _Header(l10n: l10n),
              const SizedBox(height: 28),

              // ── Tap hint ────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.touch_app_outlined,
                      size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 5),
                  Text(
                    'Tap a language to select',
                    style: TextStyle(
                      fontSize:  13,
                      color:     Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ── Chip grid ───────────────────────────────
              _ChipGrid(
                languages:      _kLanguages,
                selectedLocale: selectedLocale,
                onSelected:     onLocaleSelected,
              ),
              const SizedBox(height: 24),

              // ── Continue button ──────────────────────────
              _ContinueButton(
                selectedLangName: selLang.native,
                stepLabel:        _stepLabel,
                onPressed:        onContinue,
              ),
              const SizedBox(height: 16),

              // ── Info banner ──────────────────────────────
              const _InfoBanner(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Step indicator dots
// ─────────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.current, required this.total});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final active = i + 1 == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin:   const EdgeInsets.symmetric(horizontal: 4),
          width:    active ? 24 : 8,
          height:   8,
          decoration: BoxDecoration(
            color: active
                ? _C.green
                : _C.green.withOpacity(0.25),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Continue button
// ─────────────────────────────────────────────────────────────

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({
    required this.selectedLangName,
    required this.stepLabel,
    required this.onPressed,
  });

  final String       selectedLangName;
  final String       stepLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _C.green,
          foregroundColor: Colors.white,
          elevation:       2,
          shadowColor:     _C.green.withOpacity(0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          children: [
            // Step counter pill
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color:        Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                stepLabel,
                style: const TextStyle(
                  fontSize:      11,
                  fontWeight:    FontWeight.w600,
                  color:         Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Label
            Expanded(
              child: Text(
                'Continue in $selectedLangName',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize:      15,
                  fontWeight:    FontWeight.w700,
                  color:         Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Arrow
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                color:        Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                size:  16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64, height: 64,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: _C.greenLight,
          ),
          child: const Icon(
            Icons.language_rounded,
            size: 30, color: _C.green,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          l10n.selectLanguageTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize:   26,
            fontWeight: FontWeight.w800,
            color:      Color(0xFF1A2E1A),
            height:     1.2,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          l10n.selectLanguageSubtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.5,
            color:    Colors.grey.shade600,
            height:   1.45,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Chip grid
// ─────────────────────────────────────────────────────────────

class _ChipGrid extends StatelessWidget {
  const _ChipGrid({
    required this.languages,
    required this.selectedLocale,
    required this.onSelected,
  });

  final List<_Lang>          languages;
  final Locale               selectedLocale;
  final ValueChanged<Locale> onSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const cols      = 3;
        const totalGaps = (cols - 1) * _C.gap;
        final chipW     = (constraints.maxWidth - totalGaps) / cols;

        return Wrap(
          spacing:    _C.gap,
          runSpacing: _C.gap,
          alignment:  WrapAlignment.start,
          children: _kLanguages.map((lang) {
            final sel =
                lang.locale.languageCode == selectedLocale.languageCode;
            return _LangChip(
              lang:       lang,
              isSelected: sel,
              width:      chipW,
              onTap:      () => onSelected(lang.locale),
            );
          }).toList(),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Single chip
// ─────────────────────────────────────────────────────────────

class _LangChip extends StatefulWidget {
  const _LangChip({
    required this.lang,
    required this.isSelected,
    required this.width,
    required this.onTap,
  });

  final _Lang        lang;
  final bool         isSelected;
  final double       width;
  final VoidCallback onTap;

  @override
  State<_LangChip> createState() => _LangChipState();
}

class _LangChipState extends State<_LangChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sc;
  late final Animation<double>   _scale;

  @override
  void initState() {
    super.initState();
    _sc = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _sc, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    HapticFeedback.lightImpact();
    await _sc.forward();
    await _sc.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final sel = widget.isSelected;

    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve:    Curves.easeOut,
          width:    widget.width,
          height:   70,
          decoration: BoxDecoration(
            color: sel ? _C.greenLight : Colors.white,
            borderRadius: BorderRadius.circular(_C.chipRadius),
            border: Border.all(
              color: sel ? _C.green : Colors.grey.shade300,
              width: sel ? 2.0 : 1.0,
            ),
            boxShadow: sel
                ? [BoxShadow(
                    color:      _C.green.withOpacity(0.15),
                    blurRadius: 8,
                    offset:     const Offset(0, 3),
                  )]
                : [BoxShadow(
                    color:      Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset:     const Offset(0, 2),
                  )],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize:      MainAxisSize.min,
                    children: [
                      if (sel) ...[
                        Icon(Icons.check_circle,
                            size: 14, color: _C.green),
                        const SizedBox(width: 4),
                      ],
                      Flexible(
                        child: Text(
                          widget.lang.native,
                          textAlign: TextAlign.center,
                          overflow:  TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize:   15,
                            fontWeight: FontWeight.w700,
                            color: sel
                                ? _C.green
                                : const Color(0xFF1A2E1A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.lang.greeting,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:  12,
                      fontStyle: FontStyle.italic,
                      color: sel
                          ? _C.green.withOpacity(0.75)
                          : Colors.grey.shade500,
                      height: 1.2,
                    ),
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

// ─────────────────────────────────────────────────────────────
// Info banner
// ─────────────────────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color:        const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              size: 16, color: _C.green.withOpacity(0.8)),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'You can change the language anytime from Settings.',
              style: TextStyle(
                fontSize: 13,
                color:    Colors.grey.shade700,
                height:   1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}