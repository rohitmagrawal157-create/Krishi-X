// ============================================================
//  lib/features/auth/widgets/auth_screen_layout.dart
//
//  Kept ONLY what language_selection_screen.dart and other
//  non-login screens still need.
//  LoginScreen / OtpVerificationScreen import login_screen.dart
//  directly and do NOT import this file at all.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/constants/app_colors.dart';

abstract final class AuthStyles {
  static const double horizontalPadding = 24;
  static const double fieldRadius       = 12;
  static const double fieldHeight       = 58;
  static const double buttonHeight      = 56;
  static const Color  buttonGreen       = AppColors.bannerGreen;

  static const titleStyle = TextStyle(
    fontSize: 32, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, height: 1.2,
  );
  static const subtitleStyle = TextStyle(
    fontSize: 17, color: AppColors.textSecondary, height: 1.4,
  );
  static const labelStyle = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );
  static const inputStyle = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  static final hintStyle = TextStyle(
    fontSize: 18, color: Colors.grey.shade400,
  );
  static const buttonStyle = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w700,
  );
  static const String logoAsset = 'assets/images/final_krishix_logo2.png';
}

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width.clamp(280.0, 420.0) * 0.62;
    return Center(
      child: Image.asset(
        AuthStyles.logoAsset,
        width: w,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}

/// Generic scaffold used by language selection and other non-auth screens.
class AuthScreenLayout extends StatelessWidget {
  const AuthScreenLayout({
    super.key,
    required this.body,
    this.footer,
    this.showBackButton = true,
    this.onBack,
  });

  final Widget       body;
  final Widget?      footer;
  final bool         showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showBackButton)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, size: 28),
                  color: AppColors.textPrimary,
                  onPressed: onBack ?? () => Navigator.maybePop(context),
                ),
              )
            else
              const SizedBox(height: 42),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AuthStyles.horizontalPadding),
                  child: body,
                ),
              ),
            ),
            if (footer != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AuthStyles.horizontalPadding, 8,
                    AuthStyles.horizontalPadding, 28),
                child: footer,
              ),
          ],
        ),
      ),
    );
  }
}

/// Formats 10-digit Indian phone as "98 7654 3210".
class IndianPhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue next) {
    final d   = next.text.replaceAll(RegExp(r'\D'), '');
    final lim = d.length > 10 ? d.substring(0, 10) : d;
    final buf = StringBuffer();
    for (var i = 0; i < lim.length; i++) {
      if (i == 2 || i == 6) buf.write(' ');
      buf.write(lim[i]);
    }
    final s = buf.toString();
    return TextEditingValue(
        text: s, selection: TextSelection.collapsed(offset: s.length));
  }
}

String digitsOnlyPhone(String value) => value.replaceAll(RegExp(r'\D'), '');