// ============================================================
//  lib/features/auth/login_screen.dart
//
//  UPDATED: OTP changed from 6-digit to 4-digit
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
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  static const subtitle = TextStyle(
    fontSize: 17,
    color: AppColors.textSecondary,
    height: 1.4,
  );
  static const label = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );
  static const input = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
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
    TextEditingValue old,
    TextEditingValue next,
  ) {
    final d   = next.text.replaceAll(RegExp(r'\D'), '');
    final lim = d.length > 10 ? d.substring(0, 10) : d;
    final buf = StringBuffer();
    for (var i = 0; i < lim.length; i++) {
      if (i == 2 || i == 6) buf.write(' ');
      buf.write(lim[i]);
    }
    final s = buf.toString();
    return TextEditingValue(
      text: s,
      selection: TextSelection.collapsed(offset: s.length),
    );
  }
}

String? _phoneValidator(String? value, AppLocalizations l10n) {
  final d = UserAuthService.normalizePhone(value ?? '');
  if (d.isEmpty) return l10n.phoneRequired;
  if (d.length != 10) return l10n.phoneInvalid;
  return null;
}

// ─────────────────────────────────────────────────────────────
// 3 · LOGO
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
                child: const Icon(
                  Icons.agriculture,
                  size: 48,
                  color: _S.green,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'KRISHIX',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: _S.green,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 4 · BRAND HEADER + STEP DOTS
// ─────────────────────────────────────────────────────────────

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
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
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
        final isCur  = i == current - 1;
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
// 5 · LANDSCAPE FOOTER  (pinned, keyboard-safe)
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

// Approximate rendered height of the bottom landscape image.
const double _kLandscapeH = 120.0;

// ─────────────────────────────────────────────────────────────
// 6 · _SCAFFOLD
// ─────────────────────────────────────────────────────────────

class _Scaffold extends StatelessWidget {
  const _Scaffold({
    required this.body,
    this.footer,
    this.showBack      = false,
    this.onBack,
    this.showBrand     = true,
    this.showLandscape = true,
    this.step,
  });

  final Widget        body;
  final Widget?       footer;
  final bool          showBack;
  final VoidCallback? onBack;
  final bool          showBrand;
  final bool          showLandscape;
  final int?          step;

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final hasKeyboard    = keyboardHeight > 0;

    final imageReserve =
        showLandscape && !hasKeyboard ? _kLandscapeH : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFDF8),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [

              // ── LAYER 1: scrollable form content ─────────
              Positioned.fill(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showBack)
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, size: 26),
                            color: AppColors.textPrimary,
                            onPressed: onBack,
                          ),
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

              // ── LAYER 2: landscape image pinned at bottom ─
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
// 7 · ARROW BUTTON
// ─────────────────────────────────────────────────────────────

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String        label;
  final VoidCallback? onPressed;
  final bool          isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _S.btnH,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _S.green,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFA5D6A7),
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
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

// ─────────────────────────────────────────────────────────────
// 8 · TRUST BADGE
// ─────────────────────────────────────────────────────────────

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

// ─────────────────────────────────────────────────────────────
// 9 · FIELD LABEL
// ─────────────────────────────────────────────────────────────

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

// ─────────────────────────────────────────────────────────────
// 10 · PHONE ICON FIELD
// ─────────────────────────────────────────────────────────────

class _PhoneIconField extends StatefulWidget {
  const _PhoneIconField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.validator,
  });

  final TextEditingController        controller;
  final String                       hintText;
  final ValueChanged<String>         onChanged;
  final String? Function(String?)?   validator;

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
// 11 · OTP ROW  — 4-digit
//
// CHANGED from 6 to 4:
//   • count = 4
//   • box sizing divisor adjusted for 4 boxes (wider boxes)
//   • backspace boundary: index > 0 still correct (generic)
// ─────────────────────────────────────────────────────────────

class _OtpRow extends StatefulWidget {
  const _OtpRow({
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
  });

  final List<TextEditingController>            controllers;
  final List<FocusNode>                        focusNodes;
  final void Function(int index, String value) onChanged;

  @override
  State<_OtpRow> createState() => _OtpRowState();
}

class _OtpRowState extends State<_OtpRow> {
  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.focusNodes.length; i++) {
      final index = i;
      final fn    = widget.focusNodes[i];

      fn.addListener(_onFocusChange);

      fn.onKeyEvent = (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace &&
            widget.controllers[index].text.isEmpty &&
            index > 0) {
          widget.focusNodes[index - 1].requestFocus();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      };
    }
  }

  @override
  void dispose() {
    for (final fn in widget.focusNodes) {
      fn.removeListener(_onFocusChange);
      fn.onKeyEvent = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // ── Sizing — 4 boxes ─────────────────────────────────
        const int    count    = 4; // ← CHANGED from 6
        const double gap      = 14.0;
        final double boxW     = (constraints.maxWidth - gap * (count - 1)) / count;
        final double boxH     = boxW * 1.18;
        final double radius   = boxW * 0.20;
        final double fontSize = boxW * 0.44;

        final double vPad = ((boxH - fontSize * 1.25) / 2).clamp(0.0, boxH);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(count, (i) {
            final isFocused = widget.focusNodes[i].hasFocus;
            final isFilled  = widget.controllers[i].text.isNotEmpty;

            return Padding(
              padding: EdgeInsets.only(right: i < count - 1 ? gap : 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOut,
                width:  boxW,
                height: boxH,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(
                    color: isFocused
                        ? _S.green
                        : isFilled
                            ? Colors.grey.shade500
                            : Colors.grey.shade300,
                    width: isFocused ? 2.0 : 1.5,
                  ),
                  boxShadow: isFocused
                      ? [
                          BoxShadow(
                            color: _S.green.withOpacity(0.16),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius - 0.5),
                  child: TextField(
                    controller: widget.controllers[i],
                    focusNode:  widget.focusNodes[i],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    maxLength: 1,
                    cursorColor: _S.green,
                    cursorWidth: 1.5,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1),
                    ],
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: vPad),
                    ),
                    onChanged: (v) {
                      setState(() {});
                      widget.onChanged(i, v);
                    },
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 12 · LOGIN SCREEN
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
  var   _loading = false;

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
    final l10n  = AppLocalizations.of(context)!;
    final valid = UserAuthService.normalizePhone(_ctrl.text).length == 10;

    return _Scaffold(
      step: widget.step,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.welcomeBack,
              textAlign: TextAlign.center,
              style: _S.title,
            ),
            const SizedBox(height: 28),
            Text(
              l10n.loginToContinue,
              textAlign: TextAlign.center,
              style: _S.subtitle,
            ),
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
// 13 · OTP VERIFICATION SCREEN  — 4-digit
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

  final String                        phoneNumber;
  final String                        rawPhoneNumber;
  final String                        expectedOtp;
  final Future<void> Function(String) onVerified;
  final VoidCallback                  onBack;
  final int                           step;

  @override
  State<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  // ── CHANGED: 4 controllers and focus nodes (was 6) ──────
  final _ctrls = List.generate(4, (_) => TextEditingController());
  final _fns   = List.generate(4, (_) => FocusNode());

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
      const Duration(milliseconds: 100),
      () { if (mounted) _fns[0].requestFocus(); },
    );
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
    // ── CHANGED: boundary is now 3 (index of last box in 4-digit OTP)
    if (v.length == 1 && i < 3) _fns[i + 1].requestFocus();
    if (v.isEmpty && i > 0) _fns[i - 1].requestFocus();
    setState(() {});
    // Auto-verify when all 4 digits are entered
    if (_ctrls.every((c) => c.text.length == 1) && !_loading) _verify();
  }

  String get _entered => _ctrls.map((c) => c.text).join();

  Future<void> _verify() async {
    // ── CHANGED: guard checks for 4 digits (was 6)
    if (_verified || _loading || _entered.length != 4) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    if (_entered != _otp) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.invalidOtp),
          backgroundColor: Colors.red,
        ),
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
      // ── CHANGED: generate a 4-digit OTP (was 6-digit)
      _otp = (Random().nextInt(9000) + 1000).toString();
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
      showBack:      true,
      onBack:        widget.onBack,
      step:          widget.step,
      showBrand:     false,
      footer:        const _TrustBadge(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // SMS icon
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

          // Title
          Text(
            l10n.verifyYourMobile,
            textAlign: TextAlign.center,
            style: _S.title.copyWith(fontSize: 28),
          ),
          const SizedBox(height: 10),

          // Subtitle
          Text(
            l10n.otpSentTo,
            textAlign: TextAlign.center,
            style: _S.subtitle,
          ),
          const SizedBox(height: 6),

          // Phone number
          Text(
            widget.phoneNumber,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _S.green,
            ),
          ),

          // Debug OTP hint (only in debug builds)
          if (kDebugMode) ...[
            const SizedBox(height: 8),
            Text(
              'Demo OTP: $_otp',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                fontFamily: 'monospace',
              ),
            ),
          ],
          const SizedBox(height: 28),

          // ── OTP BOXES (4-digit) ───────────────────────────
          _OtpRow(
            controllers: _ctrls,
            focusNodes:  _fns,
            onChanged:   _onChanged,
          ),

          const SizedBox(height: 22),

          // ── Resend row ────────────────────────────────────
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
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 28),

          // ── Verify button ─────────────────────────────────
          // ── CHANGED: checks for 4 digits (was 6)
          _ArrowButton(
            label: l10n.verifyAndContinue,
            isLoading: _loading || _verified,
            onPressed:
                _entered.length == 4 && !_verified ? _verify : null,
          ),
        ],
      ),
    );
  }
}