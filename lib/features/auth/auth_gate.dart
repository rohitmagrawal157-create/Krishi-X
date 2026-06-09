import 'dart:math';

import 'package:flutter/material.dart';
import 'package:krishix/core/services/user_auth_service.dart';
import 'package:krishix/features/auth/login_screen.dart';
import 'package:krishix/features/auth/otp_verification_screen.dart';
import 'package:krishix/features/onboarding/language_selection_screen.dart';

enum _AuthStep { login, otp, language }

/// Phone -> OTP -> Language -> Home
class AuthGate extends StatefulWidget {
  const AuthGate({
    super.key,
    required this.locale,
    required this.onLocaleChanged,
    required this.onAuthenticated,
  });

  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<String> onAuthenticated;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  var _step = _AuthStep.login;
  String? _phone;
  String? _expectedOtp;

  String _generateOtp() => (Random().nextInt(900000) + 100000).toString();

  void _openOtp(String phone) {
    setState(() {
      _phone = UserAuthService.normalizePhone(phone);
      _expectedOtp = _generateOtp();
      _step = _AuthStep.otp;
    });
  }

  void _openLanguage() {
    setState(() => _step = _AuthStep.language);
  }

  Future<void> _finishLanguage(Locale locale) async {
    widget.onLocaleChanged(locale);
    final phone = _phone!;
    await UserAuthService.registerUser(phone: phone, fullName: 'Farmer');
    await UserAuthService.saveSession(phone);
    if (!mounted) return;
    widget.onAuthenticated(phone);
  }

  @override
  Widget build(BuildContext context) {
    switch (_step) {
      case _AuthStep.login:
        return LoginScreen(
          step: 1,
          onProceedToOtp: _openOtp,
        );
      case _AuthStep.otp:
        return OtpVerificationScreen(
          phoneNumber: '+91 $_phone',
          rawPhoneNumber: _phone!,
          expectedOtp: _expectedOtp!,
          step: 2,
          onVerified: (_) async => _openLanguage(),
          onBack: () => setState(() => _step = _AuthStep.login),
        );
      case _AuthStep.language:
        return LanguageSelectionRoute(
          initialLocale: widget.locale,
          step: 3,
          onLocaleChanged: widget.onLocaleChanged,
          onBack: () => setState(() => _step = _AuthStep.otp),
          onComplete: _finishLanguage,
        );
    }
  }
}
