import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/features/auth/widgets/auth_screen_layout.dart';
import 'package:krishix/l10n/app_localizations.dart';

class AuthBrandHeader extends StatelessWidget {
  const AuthBrandHeader({super.key, this.showTagline = true});

  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        const AuthLogo(),
        if (showTagline) ...[
          const SizedBox(height: 4),
          Text(
            l10n.farmersTagline,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

class AuthStepIndicator extends StatelessWidget {
  const AuthStepIndicator({
    super.key,
    required this.current,
    this.total = 3,
  });

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final active = index < current;
        final isCurrent = index == current - 1;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isCurrent ? 28 : 10,
          height: 8,
          decoration: BoxDecoration(
            color: active ? AuthStyles.buttonGreen : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}

class AuthLandscapeFooter extends StatelessWidget {
  const AuthLandscapeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      width: double.infinity,
      child: CustomPaint(
        painter: _LandscapePainter(),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Icon(Icons.agriculture, color: Color(0xFF2E7D32), size: 36),
              Icon(Icons.home_work_outlined, color: Color(0xFF388E3C), size: 32),
              Icon(Icons.park_outlined, color: Color(0xFF43A047), size: 38),
            ],
          ),
        ),
      ),
    );
  }
}

class _LandscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backHill = Paint()..color = const Color(0xFFE8F5E9);
    final midHill = Paint()..color = const Color(0xFFC8E6C9);
    final frontHill = Paint()..color = const Color(0xFFA5D6A7);

    final back = Path()
      ..moveTo(0, size.height * 0.55)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.35,
        size.width * 0.5,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.65,
        size.width,
        size.height * 0.45,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final mid = Path()
      ..moveTo(0, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.52,
        size.width * 0.7,
        size.height * 0.68,
      )
      ..lineTo(size.width, size.height * 0.6)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final front = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.82)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.68,
        size.width,
        size.height * 0.78,
      )
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(back, backHill);
    canvas.drawPath(mid, midHill);
    canvas.drawPath(front, frontHill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AuthFlowScaffold extends StatelessWidget {
  const AuthFlowScaffold({
    super.key,
    required this.body,
    this.footer,
    this.showBackButton = false,
    this.onBack,
    this.showBrandHeader = true,
    this.showLandscape = true,
    this.step,
  });

  final Widget body;
  final Widget? footer;
  final bool showBackButton;
  final VoidCallback? onBack;
  final bool showBrandHeader;
  final bool showLandscape;
  final int? step;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFDF8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showBackButton)
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
                padding: const EdgeInsets.symmetric(
                  horizontal: AuthStyles.horizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showBrandHeader) const AuthBrandHeader(),
                    if (step != null) ...[
                      const SizedBox(height: 16),
                      AuthStepIndicator(current: step!),
                    ],
                    const SizedBox(height: 20),
                    body,
                    if (footer != null) ...[
                      const SizedBox(height: 20),
                      footer!,
                    ],
                  ],
                ),
              ),
            ),
            if (showLandscape) const AuthLandscapeFooter(),
          ],
        ),
      ),
    );
  }
}

class AuthArrowButton extends StatelessWidget {
  const AuthArrowButton({
    super.key,
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
      height: AuthStyles.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AuthStyles.buttonGreen,
          disabledBackgroundColor: AuthStyles.buttonGreen.withOpacity(0.45),
          foregroundColor: Colors.white,
          elevation: 0,
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
                  Text(label, style: AuthStyles.buttonStyle),
                  const Spacer(),
                  const Icon(Icons.arrow_forward, size: 22),
                ],
              ),
      ),
    );
  }
}

class AuthTrustBadge extends StatelessWidget {
  const AuthTrustBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.verified_user, color: AuthStyles.buttonGreen, size: 18),
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

class AuthPhoneIconField extends StatefulWidget {
  const AuthPhoneIconField({
    super.key,
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
  State<AuthPhoneIconField> createState() => _AuthPhoneIconFieldState();
}

class _AuthPhoneIconFieldState extends State<AuthPhoneIconField> {
  final _focusNode = FocusNode();
  var _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() => _focused = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: AuthStyles.fieldHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _focused ? AuthStyles.buttonGreen : Colors.grey.shade300,
          width: _focused ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(Icons.phone_outlined, color: Colors.grey.shade500, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.phone,
              style: AuthStyles.inputStyle,
              inputFormatters: [IndianPhoneInputFormatter()],
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AuthStyles.hintStyle,
                border: InputBorder.none,
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
