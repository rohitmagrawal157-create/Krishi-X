import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/constants/app_spacing.dart';

abstract final class AppTheme {
  /// Noto Sans Devanagari is now the PRIMARY font (covers Hindi and
  /// Marathi natively, and renders Latin text fine too), with Noto Sans
  /// and Noto Sans Gujarati as fallback for anything it doesn't cover.
  ///
  /// IMPORTANT: You must go through `GoogleFonts.notoSansXxx()` and read
  /// back its `.fontFamily` — you cannot just drop the font *name* as a
  /// raw string into `fontFamily` / `fontFamilyFallback`. Doing that skips
  /// google_fonts' loading/registration step entirely, so Flutter never
  /// actually fetches the font and text silently falls back to the
  /// platform default (or renders as tofu boxes) instead of Noto Sans.
  ///
  /// Order matters in the fallback list: Flutter walks it left-to-right
  /// and uses the first font that has a glyph for each character.
  static List<String> get _fallback => [
        // Gujarati script.
        GoogleFonts.notoSansGujarati().fontFamily!,
        // Broad Noto Sans catch-all — picks up any character, symbol, or
        // punctuation that Noto Sans Devanagari doesn't include, before
        // finally dropping to the OS default sans-serif.
        GoogleFonts.notoSans().fontFamily!,
        'sans-serif',
      ];

  static TextStyle _notoSans({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.notoSansDevanagari(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    ).copyWith(
      // Attach the fallback per-style too, so any widget that reads an
      // individual TextStyle (rather than the Theme's top-level
      // fontFamilyFallback) still resolves correctly. Applied via
      // copyWith rather than as a GoogleFonts(...) named parameter, since
      // older google_fonts versions don't expose fontFamilyFallback on
      // the font functions themselves — but TextStyle always supports it.
      fontFamilyFallback: _fallback,
    );
  }

  /// Noto Sans Gujarati — "The Modern Standard."
  ///
  /// Use this for any text you KNOW is Gujarati (e.g. Gujarati-locale
  /// screens, hardcoded Gujarati labels like "જમીન ભાડે").
  ///
  /// Noto Sans Gujarati is a free, open-source sans-serif typeface
  /// developed by Google, designed to stay visually harmonious across
  /// multiple languages while avoiding the "tofu" (blank box) effect for
  /// unsupported glyphs. Its clean lines, uniform stroke thickness, and
  /// high legibility make it well suited to digital interfaces, mobile
  /// apps, and professional-grade UI — which is exactly why it's used
  /// here instead of leaning on Devanagari-first fallback.
  ///
  /// Why this exists separately from `_notoSans` / the automatic
  /// `fontFamilyFallback` chain: when the primary font is Noto Sans
  /// Devanagari and Gujarati text is rendered through fallback, Flutter's
  /// text shaper can pick glyphs per-character across the two fonts
  /// instead of letting one font's shaping engine handle the whole
  /// conjunct — this is what causes broken/garbled ligatures (stray
  /// matras, malformed conjuncts) like in the JCB/tractor rental labels
  /// screenshot. Setting Noto Sans Gujarati as the *primary* font for
  /// this text style (not just a fallback candidate) forces its shaping
  /// engine to own the whole string, which renders conjuncts correctly.
  static TextStyle gujarati({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.notoSansGujarati(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    ).copyWith(
      // Still keep a safe catch-all for any stray non-Gujarati character
      // (e.g. an English brand name inside an otherwise Gujarati label),
      // but Noto Sans Gujarati itself stays first/authoritative so its
      // own conjuncts are never split across fonts.
      fontFamilyFallback: [
        GoogleFonts.notoSans().fontFamily!,
        'sans-serif',
      ],
    );
  }

  static ThemeData light() {
    final notoSansDevanagariFamily = GoogleFonts.notoSansDevanagari().fontFamily;
    final fallback = _fallback;

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: notoSansDevanagariFamily,
      fontFamilyFallback: fallback,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        primary: AppColors.primaryGreen,
        secondary: AppColors.accentGold,
        surface: AppColors.sunnySurface,
        error: AppColors.errorRed,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );

    // GoogleFonts.notoSansDevanagariTextTheme() only sets fontFamily on
    // each style, not fontFamilyFallback, so we merge the fallback back
    // in on the base text theme before layering our own overrides on top.
    final notoSansTextTheme =
        GoogleFonts.notoSansDevanagariTextTheme(base.textTheme)
            .apply(fontFamilyFallback: fallback);

    final textTheme = notoSansTextTheme.copyWith(
      displayLarge: _notoSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.15,
      ),
      displayMedium: _notoSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
      ),
      displaySmall: _notoSans(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.2,
      ),
      headlineLarge: _notoSans(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
      ),
      headlineMedium: _notoSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
      ),
      headlineSmall: _notoSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.25,
      ),
      titleLarge: _notoSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.25,
      ),
      titleMedium: _notoSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      ),
      titleSmall: _notoSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      ),
      bodyLarge: _notoSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.4,
      ),
      bodyMedium: _notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.4,
      ),
      bodySmall: _notoSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.35,
      ),
      labelLarge: _notoSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.2,
      ),
      labelMedium: _notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.2,
      ),
      labelSmall: _notoSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.2,
      ),
    );

    return base.copyWith(
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: _notoSans(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        toolbarTextStyle: _notoSans(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        iconTheme: const IconThemeData(size: 28),
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2.5),
        ),
        hintStyle: _notoSans(fontSize: 15, color: Colors.grey.shade600),
        labelStyle: _notoSans(fontSize: 14, color: AppColors.textSecondary),
        errorStyle: _notoSans(fontSize: 12, color: AppColors.errorRed),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(AppSpacing.minTouchTarget),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: _notoSans(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: _notoSans(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: _notoSans(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedLabelStyle: _notoSans(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: _notoSans(fontSize: 11, fontWeight: FontWeight.w500),
      ),
      navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return _notoSans(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          );
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: _notoSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      dialogTheme: DialogTheme(
        titleTextStyle: _notoSans(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        contentTextStyle: _notoSans(
          fontSize: 14,
          color: AppColors.textSecondary,
          height: 1.4,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        iconSize: 32,
        sizeConstraints: BoxConstraints(minHeight: 60, minWidth: 60),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.white,
        elevation: 8,
      ),
    );
  }
}