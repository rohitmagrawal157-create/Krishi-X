// lib/krishix_app.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:krishix/core/services/location_service.dart';
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
  final _navigatorKey = GlobalKey<NavigatorState>();
  late Locale _locale;
  String? _loggedInPhone;
  var _isBootstrapping = true;
  var _splashDone      = false;
  var _didRequestStartupLocation = false;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestStartupLocationPermission();
    });
  }

  Future<void> _requestStartupLocationPermission() async {
    if (_didRequestStartupLocation) return;
    _didRequestStartupLocation = true;

    // Let the first Flutter frame attach before Android presents its
    // native runtime permission sheet.
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    try {
      final permission = await LocationService.ensurePermission();
      if (!mounted || permission != LocationPermission.deniedForever) return;
      await _showLocationSettingsDialog();
    } catch (_) {
      // Permission availability is handled again when location is used.
    }
  }

  Future<void> _showLocationSettingsDialog() async {
    final context = _navigatorKey.currentContext;
    if (context == null) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.location_off_rounded,
          color: Color(0xFFF57C00),
          size: 32,
        ),
        title: const Text('Location permission required'),
        content: const Text(
          'Location access is turned off for KrishiX. Open app settings and '
          'allow location while using the app.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              LocationService.openAppSettings();
            },
            child: const Text('Open settings'),
          ),
        ],
      ),
    );
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
      navigatorKey: _navigatorKey,
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
