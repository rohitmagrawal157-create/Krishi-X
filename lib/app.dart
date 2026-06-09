import 'package:flutter/material.dart';
import 'package:krishix/core/services/user_auth_service.dart';
import 'package:krishix/core/theme/app_theme.dart';
import 'package:krishix/features/auth/auth_gate.dart';
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

  @override
  void initState() {
    super.initState();
    final device = WidgetsBinding.instance.platformDispatcher.locale;
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
        _loggedInPhone = phone;
        _isBootstrapping = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isBootstrapping = false);
    }
  }

  void _setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  void _onAuthenticated(String phone) {
    setState(() => _loggedInPhone = phone);
  }

  Future<void> _logout() async {
    await UserAuthService.clearSession();
    if (!mounted) return;
    setState(() => _loggedInPhone = null);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KrishiX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: _isBootstrapping
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : _loggedInPhone == null
              ? AuthGate(
                  locale: _locale,
                  onLocaleChanged: _setLocale,
                  onAuthenticated: _onAuthenticated,
                )
              : MainShell(
                  locale: _locale,
                  onLocaleChanged: _setLocale,
                  loggedInPhone: _loggedInPhone,
                  onVerifiedPhone: _onAuthenticated,
                  onLogout: _logout,
                ),
    );
  }
}
