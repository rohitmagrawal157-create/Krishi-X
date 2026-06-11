// lib/krishix_app.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/services/user_auth_service.dart';
import 'package:krishix/core/theme/app_theme.dart';
import 'package:krishix/features/auth/auth_gate.dart';
import 'package:krishix/features/auth/splash_screen.dart';
import 'package:krishix/features/shell/main_shell.dart';
import 'package:krishix/l10n/app_localizations.dart';

class KrishiXApp extends StatefulWidget {
  const KrishiXApp({super.key});

  @override
  State<KrishiXApp> createState() => _KrishiXAppState();
}

class _KrishiXAppState extends State<KrishiXApp> {
  late Locale _locale;
  String? _loggedInPhone;
  var _isBootstrapping = true;
  var _splashDone      = false;

  @override
  void initState() {
    super.initState();

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

    final device    = WidgetsBinding.instance.platformDispatcher.locale;
    const supported = AppLocalizations.supportedLocales;
    _locale = supported.any((l) => l.languageCode == device.languageCode)
        ? supported.firstWhere((l) => l.languageCode == device.languageCode)
        : const Locale('hi');

    _restoreSession();
  }

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

  void _onSplashDone() {
    if (!mounted) return;
    setState(() => _splashDone = true);
  }

  void _setLocale(Locale locale) => setState(() => _locale = locale);

  void _onAuthenticated(String phone) =>
      setState(() => _loggedInPhone = phone);

  Future<void> _logout() async {
    await UserAuthService.clearSession();
    if (!mounted) return;
    setState(() => _loggedInPhone = null);
  }

  Widget _buildHome() {
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
        locale:          _locale,
        onLocaleChanged: _setLocale,
        onAuthenticated: _onAuthenticated,
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
          if (child.key == const ValueKey('shell')) {
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