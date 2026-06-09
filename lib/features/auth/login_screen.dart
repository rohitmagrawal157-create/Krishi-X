// ============================================================
//  lib/features/auth/login_screen.dart
// ============================================================

import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/services/user_auth_service.dart';
import 'package:krishix/l10n/app_localizations.dart';

// ─────────────────────────────────────────────────────────────
// 1 · STYLES
// ─────────────────────────────────────────────────────────────

abstract final class _S {
  static const double hPad        = 24;
  static const double fieldRadius = 14;
  static const double fieldH      = 62;
  static const double btnH        = 60;
  static const Color  green       = AppColors.bannerGreen;

  static const double logoTopMargin = 40;

  static const title = TextStyle(
    fontSize: 32, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, height: 1.2,
  );
  static const subtitle = TextStyle(
    fontSize: 17, color: AppColors.textSecondary, height: 1.4,
  );
  static const label = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );
  static const input = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  static const btn = TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
  static final hint = TextStyle(fontSize: 18, color: Colors.grey.shade400);

  static const String logo = 'assets/images/final_krishix_logo2.png';
}

// ─────────────────────────────────────────────────────────────
// 2 · PHONE INPUT FORMATTER
// ─────────────────────────────────────────────────────────────

class _PhoneFmt extends TextInputFormatter {
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

String? _phoneValidator(String? value, AppLocalizations l10n) {
  final d = UserAuthService.normalizePhone(value ?? '');
  if (d.isEmpty) return l10n.phoneRequired;
  if (d.length != 10) return l10n.phoneInvalid;
  return null;
}

// ─────────────────────────────────────────────────────────────
// 3 · SHARED WIDGETS
// ─────────────────────────────────────────────────────────────

class _Logo extends StatelessWidget {
  const _Logo();
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width.clamp(280.0, 420.0) * 0.68;
    return Center(
      child: Image.asset(
        _S.logo,
        width: w,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) {
          return Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _S.green.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.agriculture, size: 48, color: _S.green),
              ),
              const SizedBox(height: 8),
              const Text('KRISHIX', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _S.green)),
            ],
          );
        },
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({this.showTagline = true, this.step});
  final bool showTagline;
  final int? step;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: _S.logoTopMargin),
        const _Logo(),
        if (showTagline)
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Text(
              l10n.farmersTagline,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
          ),
        if (step != null) ...[
          const SizedBox(height: 16),
          _StepDots(current: step!),
        ],
      ],
    );
  }
}

class _StepDots extends StatelessWidget {
  const _StepDots({required this.current, this.total = 3});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final active = i < current;
        final isCur = i == current - 1;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isCur ? 28 : 10,
          height: 8,
          decoration: BoxDecoration(
            color: active ? _S.green : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// FIXED: Landscape footer is a separate widget, used in Stack
// ─────────────────────────────────────────────────────────────

class _LandscapeFooter extends StatelessWidget {
  const _LandscapeFooter();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Image.asset(
        'assets/images/login_bottom.png',
        width: double.infinity,
        fit: BoxFit.fitWidth,
        filterQuality: FilterQuality.medium,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SCAFFOLD — Fixed bottom image via Stack + MediaQuery padding
// ─────────────────────────────────────────────────────────────
//
// Strategy:
//   • Use a Stack so the landscape image is ALWAYS pinned at the
//     physical bottom of the safe area — it never scrolls and
//     never jumps when the keyboard appears.
//   • The scroll view sits on top with enough bottom padding to
//     clear the image height. When the keyboard is open, Flutter
//     automatically adds extra inset via resizeToAvoidBottomInset,
//     so content is reachable without fighting the image.
//   • The image fades out smoothly when the keyboard rises, so it
//     doesn't visually collide with field error messages.
// ─────────────────────────────────────────────────────────────

class _LandscapeFooterHeight {
  // Approximate rendered height of the bottom landscape asset.
  // Adjust this constant if you change the image aspect ratio.
  static const double value = 120.0;
}

class _Scaffold extends StatelessWidget {
  const _Scaffold({
    required this.body,
    this.footer,
    this.showBack = false,
    this.onBack,
    this.showBrand = true,
    this.showLandscape = true,
    this.step,
  });

  final Widget body;
  final Widget? footer;
  final bool showBack;
  final VoidCallback? onBack;
  final bool showBrand;
  final bool showLandscape;
  final int? step;

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final hasKeyboard    = keyboardHeight > 0;

    // How much bottom space does the scroll view need to reserve so
    // content never hides behind the landscape image?
    final imageReserve = showLandscape && !hasKeyboard
        ? _LandscapeFooterHeight.value
        : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFDF8),
      // Let Flutter resize the body when the keyboard appears so the
      // scroll view gains the right inset automatically.
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          // ── Stack keeps the image fixed at the bottom ──────────
          child: Stack(
            children: [

              // ── 1. Scrollable content ───────────────────────────
              Positioned.fill(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Back button or top spacer
                    if (showBack)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, size: 26),
                          color: AppColors.textPrimary,
                          onPressed: onBack,
                        ),
                      )
                    else
                      const SizedBox(height: 8),

                    Expanded(
                      child: SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: EdgeInsets.fromLTRB(
                          _S.hPad,
                          0,
                          _S.hPad,
                          // Reserve space below content so it clears
                          // the landscape image when keyboard is closed.
                          imageReserve + 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (showBrand) _BrandHeader(step: step),
                            const SizedBox(height: 12),
                            body,
                            if (footer != null) ...[
                              const SizedBox(height: 20),
                              footer!,
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── 2. Landscape image — always pinned at bottom ────
              //
              // Positioned to the physical bottom of the Stack.
              // AnimatedOpacity fades it out when the keyboard is
              // visible so error text / button isn't obscured.
              // The image itself is IgnorePointer so taps fall
              // through to the content underneath.
              if (showLandscape)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AnimatedOpacity(
                    opacity: hasKeyboard ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    child: const _LandscapeFooter(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SHARED BUTTON / FIELD WIDGETS
// ─────────────────────────────────────────────────────────────

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _S.btnH,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _S.green,
          disabledBackgroundColor: _S.green.withOpacity(0.45),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label, style: _S.btn),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 22),
                ],
              ),
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  const _TrustBadge();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.verified_user, color: _S.green, size: 18),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            l10n.infoSafeWithUs,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(label, style: _S.label),
    );
  }
}

class _PhoneIconField extends StatefulWidget {
  const _PhoneIconField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.validator,
  });
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;

  @override
  State<_PhoneIconField> createState() => _PhoneIconFieldState();
}

class _PhoneIconFieldState extends State<_PhoneIconField> {
  final _fn = FocusNode();
  var _focused = false;

  @override
  void initState() {
    super.initState();
    _fn.addListener(() => setState(() => _focused = _fn.hasFocus));
  }

  @override
  void dispose() {
    _fn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: _S.fieldH,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_S.fieldRadius),
        border: Border.all(
          color: _focused ? _S.green : Colors.grey.shade300,
          width: _focused ? 2 : 1.5,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(Icons.phone_outlined, color: Colors.grey.shade500, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              focusNode: _fn,
              keyboardType: TextInputType.phone,
              style: _S.input.copyWith(fontSize: 18),
              inputFormatters: [_PhoneFmt()],
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: _S.hint.copyWith(fontSize: 16),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              validator: widget.validator,
              onChanged: widget.onChanged,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 4 · LOGIN SCREEN
// ─────────────────────────────────────────────────────────────

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.onProceedToOtp,
    this.step = 1,
  });

  final void Function(String phone) onProceedToOtp;
  final int step;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _ctrl    = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _loading   = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    final phone = UserAuthService.normalizePhone(_ctrl.text);
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() => _loading = false);
    widget.onProceedToOtp(phone);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final valid = UserAuthService.normalizePhone(_ctrl.text).length == 10;

    return _Scaffold(
      step: widget.step,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.welcomeBack,
                textAlign: TextAlign.center, style: _S.title),
            const SizedBox(height: 28),
            Text(l10n.loginToContinue,
                textAlign: TextAlign.center, style: _S.subtitle),
            const SizedBox(height: 58),
            _FieldLabel(label: l10n.mobileNumber),
            const SizedBox(height: 8),
            _PhoneIconField(
              controller: _ctrl,
              hintText: l10n.enterMobileNumber,
              validator: (v) => _phoneValidator(v, l10n),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            _ArrowButton(
              label: l10n.sendOtp,
              isLoading: _loading,
              onPressed: valid ? _sendOtp : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 5 · OTP VERIFICATION SCREEN
// ─────────────────────────────────────────────────────────────

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.rawPhoneNumber,
    required this.expectedOtp,
    required this.onVerified,
    required this.onBack,
    this.step = 2,
  });

  final String phoneNumber;
  final String rawPhoneNumber;
  final String expectedOtp;
  final Future<void> Function(String phone) onVerified;
  final VoidCallback onBack;
  final int step;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _ctrls = List.generate(6, (_) => TextEditingController());
  final _fns   = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  var _secs      = 25;
  var _loading   = false;
  var _canResend = false;
  var _verified  = false;
  late String _otp;

  @override
  void initState() {
    super.initState();
    _otp = widget.expectedOtp;
    _startTimer();
    Future.delayed(
        const Duration(milliseconds: 100), () => _fns[0].requestFocus());
    for (final fn in _fns) {
      fn.addListener(() { if (mounted) setState(() {}); });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _ctrls) c.dispose();
    for (final f in _fns) f.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _secs      = 25;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (_secs > 0) {
          _secs--;
        } else {
          _canResend = true;
          t.cancel();
        }
      });
    });
  }

  void _onChanged(int i, String v) {
    if (_verified) return;
    if (v.length == 1 && i < 5) _fns[i + 1].requestFocus();
    if (v.isEmpty && i > 0)     _fns[i - 1].requestFocus();
    setState(() {});
    if (_ctrls.every((c) => c.text.length == 1) && !_loading) _verify();
  }

  String get _entered => _ctrls.map((c) => c.text).join();

  Future<void> _verify() async {
    if (_verified || _loading || _entered.length != 6) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    if (_entered != _otp) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n.invalidOtp),
            backgroundColor: Colors.red),
      );
      return;
    }
    _verified = true;
    FocusScope.of(context).unfocus();
    await widget.onVerified(widget.rawPhoneNumber);
  }

  Future<void> _resend() async {
    if (!_canResend || _verified) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _otp = (Random().nextInt(900000) + 100000).toString();
      for (final c in _ctrls) c.clear();
    });
    _startTimer();
    _fns[0].requestFocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.otpSentSuccess),
        backgroundColor: _S.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _Scaffold(
      showBack:    true,
      onBack:      widget.onBack,
      step:        widget.step,
      showBrand:   false,
      footer:      const _TrustBadge(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: _S.green.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.sms_outlined, size: 42, color: _S.green),
            ),
          ),
          const SizedBox(height: 24),
          Text(l10n.verifyYourMobile,
              textAlign: TextAlign.center,
              style: _S.title.copyWith(fontSize: 28)),
          const SizedBox(height: 10),
          Text(l10n.otpSentTo,
              textAlign: TextAlign.center, style: _S.subtitle),
          const SizedBox(height: 6),
          Text(
            widget.phoneNumber,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700, color: _S.green),
          ),
          if (kDebugMode) ...[
            const SizedBox(height: 8),
            Text(
              'Demo OTP: $_otp',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  fontFamily: 'monospace'),
            ),
          ],
          const SizedBox(height: 28),

          // OTP boxes
          LayoutBuilder(builder: (context, constraints) {
            const gap = 12.0;
            final box =
                ((constraints.maxWidth - gap * 5) / 6).clamp(48.0, 56.0);

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (i) {
                final focused = _fns[i].hasFocus;
                final filled  = _ctrls[i].text.isNotEmpty;

                return Padding(
                  padding: EdgeInsets.only(right: i < 5 ? gap : 0),
                  child: Container(
                    width: box,
                    height: box,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: focused
                            ? _S.green
                            : filled
                                ? Colors.grey.shade400
                                : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: TextFormField(
                        controller: _ctrls[i],
                        focusNode: _fns[i],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1),
                        ],
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (v) => _onChanged(i, v),
                      ),
                    ),
                  ),
                );
              }),
            );
          }),

          const SizedBox(height: 22),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${l10n.otpNotReceived} ',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
              ),
              GestureDetector(
                onTap: _canResend && !_verified ? _resend : null,
                child: Text(
                  l10n.resendOtp,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _canResend
                        ? _S.green
                        : _S.green.withOpacity(0.45),
                  ),
                ),
              ),
              if (!_canResend) ...[
                const SizedBox(width: 10),
                Text(
                  '00:${_secs.toString().padLeft(2, '0')}',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600),
                ),
              ],
            ],
          ),
          const SizedBox(height: 28),

          _ArrowButton(
            label: l10n.verifyAndContinue,
            isLoading: _loading || _verified,
            onPressed: _entered.length == 6 && !_verified ? _verify : null,
          ),
        ],
      ),
    );
  }
}