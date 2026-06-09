import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/constants/app_spacing.dart';
import 'package:krishix/l10n/app_localizations.dart';

/// Single lightweight screen: language + phone + OTP (no extra navigation).
class StartAuthScreen extends StatefulWidget {
  const StartAuthScreen({
    super.key,
    required this.locale,
    required this.onLocaleChanged,
    required this.onVerified,
    this.showLanguage = true,
  });

  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<String> onVerified;
  final bool showLanguage;

  @override
  State<StartAuthScreen> createState() => _StartAuthScreenState();
}

class _StartAuthScreenState extends State<StartAuthScreen> {
  final _phoneController = TextEditingController();
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  final _otpFocusNodes = List.generate(6, (_) => FocusNode());

  var _otpSent = false;
  var _isLoading = false;
  var _remainingSeconds = 25;
  var _canResend = false;
  String? _currentOtp;
  Timer? _timer;

  static const _locales = AppLocalizations.supportedLocales;

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final n in _otpFocusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  String _langLabel(Locale locale) {
    switch (locale.languageCode) {
      case 'hi':
        return 'हिंदी';
      case 'mr':
        return 'मराठी';
      case 'gu':
        return 'ગુજરાતી';
      case 'en':
      default:
        return 'EN';
    }
  }

  String _generateOtp() => (Random().nextInt(900000) + 100000).toString();

  void _startTimer() {
    _timer?.cancel();
    _remainingSeconds = 25;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _canResend = true;
          t.cancel();
        }
      });
    });
  }

  Future<void> _sendOtp() async {
    final l10n = AppLocalizations.of(context)!;
    final phone = _phoneController.text.trim();
    if (phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.phoneInvalid)),
      );
      return;
    }

    setState(() => _isLoading = true);
    // Short delay only — keeps UI responsive on low network.
    await Future.delayed(const Duration(milliseconds: 250));

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _otpSent = true;
      _currentOtp = _generateOtp();
    });
    _startTimer();
    _otpFocusNodes[0].requestFocus();
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  String get _enteredOtp => _otpControllers.map((c) => c.text).join();

  Future<void> _verifyOtp() async {
    final l10n = AppLocalizations.of(context)!;
    if (_enteredOtp.length != 6) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 200));

    if (!mounted) return;

    if (_enteredOtp != _currentOtp) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.invalidOtp)),
      );
      return;
    }

    widget.onVerified(_phoneController.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.otpVerified),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
    setState(() => _isLoading = false);
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _resendOtp() {
    if (!_canResend) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _currentOtp = _generateOtp();
      for (final c in _otpControllers) {
        c.clear();
      }
    });
    _startTimer();
    _otpFocusNodes[0].requestFocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.otpSentSuccess)),
    );
  }

  void _editPhone() {
    setState(() {
      _otpSent = false;
      _currentOtp = null;
      for (final c in _otpControllers) {
        c.clear();
      }
    });
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final phoneValid = _phoneController.text.length == 10;
    final otpComplete = _enteredOtp.length == 6;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.agriculture,
                    color: AppColors.primaryGreen,
                    size: 48,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.appTitle,
                          style: const TextStyle(
                            fontSize: AppTextSize.heading,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          l10n.tagline,
                          style: const TextStyle(
                            fontSize: AppTextSize.body,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (widget.showLanguage) ...[
                const SizedBox(height: 20),
                Text(
                  l10n.language,
                  style: const TextStyle(
                    fontSize: AppTextSize.title,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _locales.map((loc) {
                    final selected =
                        loc.languageCode == widget.locale.languageCode;
                    return ChoiceChip(
                      label: Text(
                        _langLabel(loc),
                        style: const TextStyle(
                          fontSize: AppTextSize.body,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      selected: selected,
                      onSelected: (_) => widget.onLocaleChanged(loc),
                      selectedColor:
                          AppColors.primaryGreen.withOpacity(0.15),
                      labelStyle: TextStyle(
                        color: selected
                            ? AppColors.primaryGreen
                            : AppColors.textPrimary,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w500,
                      ),
                      side: BorderSide(
                        color: selected
                            ? AppColors.primaryGreen
                            : Colors.grey.shade300,
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 24),
              Text(
                l10n.loginTitle,
                style: const TextStyle(
                  fontSize: AppTextSize.heading,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _otpSent ? l10n.otpSubtitle : l10n.loginSubtitle,
                style: const TextStyle(
                  fontSize: AppTextSize.body,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              if (!_otpSent) ...[
                Text(
                  l10n.mobileNumber,
                  style: const TextStyle(
                    fontSize: AppTextSize.body,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: const Text(
                          '+91',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: AppTextSize.body,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          style: const TextStyle(
                            fontSize: AppTextSize.body,
                            fontWeight: FontWeight.w600,
                          ),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: InputDecoration(
                            hintText: l10n.phoneHint,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: AppSpacing.minTouchTarget,
                  child: ElevatedButton(
                    onPressed: phoneValid && !_isLoading ? _sendOtp : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      disabledBackgroundColor:
                          AppColors.primaryGreen.withOpacity(0.35),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            l10n.continueText,
                            style: const TextStyle(
                              fontSize: AppTextSize.body,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ] else ...[
                Text(
                  '${l10n.otpSentTo} +91 ${_phoneController.text}',
                  style: const TextStyle(
                    fontSize: AppTextSize.body,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (kDebugMode && _currentOtp != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Demo OTP: $_currentOtp',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                    (i) => SizedBox(
                      width: 50,
                      height: 58,
                      child: TextField(
                        controller: _otpControllers[i],
                        focusNode: _otpFocusNodes[i],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1),
                        ],
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.primaryGreen,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (v) => _onOtpChanged(i, v),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _canResend ? _resendOtp : null,
                      child: Text(
                        l10n.resendOtp,
                        style: TextStyle(
                          color: _canResend
                              ? AppColors.primaryGreen
                              : AppColors.primaryGreen.withOpacity(0.45),
                          fontWeight: FontWeight.w600,
                          fontSize: AppTextSize.body,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '00:${_remainingSeconds.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: AppTextSize.body,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: AppSpacing.minTouchTarget,
                  child: ElevatedButton(
                    onPressed:
                        otpComplete && !_isLoading ? _verifyOtp : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      disabledBackgroundColor:
                          AppColors.primaryGreen.withOpacity(0.35),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            l10n.verifyOtpButton,
                            style: const TextStyle(
                              fontSize: AppTextSize.body,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: _editPhone,
                    child: Text(
                      l10n.changeNumber,
                      style: const TextStyle(
                        color: AppColors.primaryGreen,
                        fontSize: AppTextSize.body,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
