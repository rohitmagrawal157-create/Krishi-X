// ============================================================
//  lib/krishix_app.dart
//
//  CHANGES FROM PREVIOUS VERSION:
//  1. SplashScreen replaces the plain CircularProgressIndicator
//     during bootstrap. Both _isBootstrapping AND _splashDone
//     must be true before we show AuthGate / MainShell.
//  2. AnimatedSwitcher wraps all three states (splash, auth,
//     shell) for smooth cross-fade transitions.
//  3. All existing logic (_restoreSession, _setLocale,
//     _onAuthenticated, _logout) is completely unchanged.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/services/user_auth_service.dart';
import 'package:krishix/core/theme/app_theme.dart';
import 'package:krishix/features/auth/auth_gate.dart';
import 'package:krishix/features/shell/main_shell.dart';
import 'package:krishix/features/auth/splash_screen.dart';
import 'package:krishix/l10n/app_localizations.dart';

class KrishiXApp extends StatefulWidget {
  const KrishiXApp({super.key});

  @override
  State<KrishiXApp> createState() => _KrishiXAppState();
}

class _KrishiXAppState extends State<KrishiXApp> {
  late Locale _locale;
  String? _loggedInPhone;

  // True while UserAuthService.getLoggedInPhone() is in flight
  var _isBootstrapping = true;

  // True once SplashScreen calls onDone
  // (the splash runs its animation concurrently with bootstrap)
  var _splashDone = false;

  // ── Init ─────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    // Transparent status bar — earthy green icons
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor:          Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness:     Brightness.light,
      ),
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Resolve locale exactly as before
    final device    = WidgetsBinding.instance.platformDispatcher.locale;
    const supported = AppLocalizations.supportedLocales;
    _locale = supported.any((l) => l.languageCode == device.languageCode)
        ? supported.firstWhere((l) => l.languageCode == device.languageCode)
        : const Locale('hi');

    _restoreSession();
  }

  // ── Session restore (unchanged) ───────────────────────────

  Future<void> _restoreSession() async {
    try {
      final phone = await UserAuthService.getLoggedInPhone();
      if (!mounted) return;
      setState(() {
        _loggedInPhone   = phone;
        _isBootstrapping = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isBootstrapping = false);
    }
  }

  // ── Splash callback ──────────────────────────────────────

  /// Called by SplashScreen when its animation sequence finishes.
  /// If bootstrap already completed we move on immediately;
  /// otherwise we wait — _buildHome() handles the gate.
  void _onSplashDone() {
    if (!mounted) return;
    setState(() => _splashDone = true);
  }

  // ── Auth callbacks (unchanged) ────────────────────────────

  void _setLocale(Locale locale) => setState(() => _locale = locale);

  void _onAuthenticated(String phone) =>
      setState(() => _loggedInPhone = phone);

  Future<void> _logout() async {
    await UserAuthService.clearSession();
    if (!mounted) return;
    setState(() => _loggedInPhone = null);
  }

  // ── Screen selector ──────────────────────────────────────

  Widget _buildHome() {
    // Show splash until BOTH conditions are true:
    //   • splash animation has completed  (_splashDone)
    //   • session restore has completed   (!_isBootstrapping)
    //
    // This means if bootstrap finishes before the animation,
    // we wait for the animation. If animation finishes first,
    // we wait for bootstrap. Either way: no flash, no jank.
    final readyToNavigate = _splashDone && !_isBootstrapping;

    if (!readyToNavigate) {
      return SplashScreen(
        key: const ValueKey('splash'),
        onDone: _onSplashDone,
      );
    }

    if (_loggedInPhone == null) {
      return AuthGate(
        key: const ValueKey('auth'),
        locale:           _locale,
        onLocaleChanged:  _setLocale,
        onAuthenticated:  _onAuthenticated,
      );
    }

    return MainShell(
      key: const ValueKey('shell'),
      locale:          _locale,
      onLocaleChanged: _setLocale,
      loggedInPhone:   _loggedInPhone,
      onVerifiedPhone: _onAuthenticated,
      onLogout:        _logout,
    );
  }

  // ── Build ─────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KrishiX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales:       AppLocalizations.supportedLocales,
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          // Splash exit → auth/shell: pure cross-fade
          // Auth → shell (post-login): fade + tiny upward slide
          final isPostLogin = child.key == const ValueKey('shell');
          if (isPostLogin) {
            final slide = Tween<Offset>(
              begin: const Offset(0, 0.03),
              end:   Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: slide, child: child),
            );
          }
          return FadeTransition(opacity: animation, child: child);
        },
        child: _buildHome(),
      ),
    );
  }
}
