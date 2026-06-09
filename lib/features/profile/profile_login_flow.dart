import 'dart:math';

import 'package:flutter/material.dart';
import 'package:krishix/core/services/user_auth_service.dart';
import 'package:krishix/features/auth/otp_verification_screen.dart';
import 'package:krishix/features/auth/login_screen.dart';

/// Lightweight login + OTP for profile (skips language step).
class ProfileLoginFlow extends StatefulWidget {
  const ProfileLoginFlow({
    super.key,
    required this.onVerified,
  });

  final ValueChanged<String> onVerified;

  @override
  State<ProfileLoginFlow> createState() => _ProfileLoginFlowState();
}

class _ProfileLoginFlowState extends State<ProfileLoginFlow> {
  String? _phone;
  String? _otp;

  String _generateOtp() => (Random().nextInt(900000) + 100000).toString();

  @override
  Widget build(BuildContext context) {
    if (_phone == null || _otp == null) {
      return LoginScreen(
        step: 1,
        onProceedToOtp: (phone) {
          setState(() {
            _phone = phone;
            _otp = _generateOtp();
          });
        },
      );
    }

    return OtpVerificationScreen(
      phoneNumber: '+91 $_phone',
      rawPhoneNumber: _phone!,
      expectedOtp: _otp!,
      onVerified: (phone) async {
        await UserAuthService.saveSession(phone);
        widget.onVerified(phone);
        if (context.mounted) Navigator.of(context).pop();
      },
      onBack: () => setState(() {
        _phone = null;
        _otp = null;
      }),
    );
  }
}
