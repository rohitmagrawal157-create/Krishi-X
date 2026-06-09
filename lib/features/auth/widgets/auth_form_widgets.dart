import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/services/user_auth_service.dart';
import 'package:krishix/features/auth/widgets/auth_screen_layout.dart';
import 'package:krishix/l10n/app_localizations.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.step,
    this.totalSteps,
  });

  final String title;
  final String subtitle;
  final int? step;
  final int? totalSteps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AuthLogo(),
        if (step != null && totalSteps != null) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalSteps!, (index) {
              final active = index < step!;
              final current = index == step! - 1;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: current ? 28 : 10,
                height: 8,
                decoration: BoxDecoration(
                  color: active
                      ? AuthStyles.buttonGreen
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),
          ),
        ],
        const SizedBox(height: 24),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AuthStyles.titleStyle,
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AuthStyles.subtitleStyle,
        ),
        const SizedBox(height: 36),
      ],
    );
  }
}

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.validator,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  final _focusNode = FocusNode();
  var _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
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
        borderRadius: BorderRadius.circular(AuthStyles.fieldRadius),
        border: Border.all(
          color: _focused ? AuthStyles.buttonGreen : Colors.grey.shade300,
          width: _focused ? 2 : 1,
        ),
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        keyboardType: widget.keyboardType,
        textCapitalization: widget.textCapitalization,
        style: AuthStyles.inputStyle,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AuthStyles.hintStyle,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        validator: widget.validator,
        onChanged: widget.onChanged,
      ),
    );
  }
}

class AuthPhoneField extends StatefulWidget {
  const AuthPhoneField({
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
  State<AuthPhoneField> createState() => _AuthPhoneFieldState();
}

class _AuthPhoneFieldState extends State<AuthPhoneField> {
  final _focusNode = FocusNode();
  var _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
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
        borderRadius: BorderRadius.circular(AuthStyles.fieldRadius),
        border: Border.all(
          color: _focused ? AuthStyles.buttonGreen : Colors.grey.shade300,
          width: _focused ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Container(
            width: 72,
            height: double.infinity,
            alignment: Alignment.center,
            color: _focused
                ? AuthStyles.buttonGreen.withOpacity(0.08)
                : Colors.grey.shade50,
            child: Text(
              '+91',
              style: AuthStyles.inputStyle.copyWith(
                fontWeight: FontWeight.w700,
                color: _focused
                    ? AuthStyles.buttonGreen
                    : AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            width: 1,
            height: double.infinity,
            color: _focused
                ? AuthStyles.buttonGreen.withOpacity(0.35)
                : Colors.grey.shade300,
          ),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              validator: widget.validator,
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
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
            borderRadius: BorderRadius.circular(AuthStyles.fieldRadius),
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
            : Text(label, style: AuthStyles.buttonStyle),
      ),
    );
  }
}

class AuthFieldLabel extends StatelessWidget {
  const AuthFieldLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(label, style: AuthStyles.labelStyle),
    );
  }
}

class AuthOtpInputRow extends StatefulWidget {
  const AuthOtpInputRow({
    super.key,
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
  });

  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final void Function(int index, String value) onChanged;

  @override
  State<AuthOtpInputRow> createState() => _AuthOtpInputRowState();
}

class _AuthOtpInputRowState extends State<AuthOtpInputRow> {
  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.focusNodes.length; i++) {
      widget.focusNodes[i].addListener(() {
        if (widget.focusNodes[i].hasFocus) setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 10.0;
        final boxSize =
            ((constraints.maxWidth - gap * 5) / 6).clamp(48.0, 56.0);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (index) {
            final focused = widget.focusNodes[index].hasFocus;
            final filled = widget.controllers[index].text.isNotEmpty;

            return Padding(
              padding: EdgeInsets.only(right: index < 5 ? gap : 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: boxSize,
                height: boxSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(AuthStyles.fieldRadius),
                  border: Border.all(
                    color: focused
                        ? AuthStyles.buttonGreen
                        : filled
                            ? Colors.grey.shade400
                            : Colors.grey.shade300,
                    width: focused ? 2 : 1,
                  ),
                ),
                child: TextFormField(
                  controller: widget.controllers[index],
                  focusNode: widget.focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(1),
                  ],
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    setState(() {});
                    widget.onChanged(index, value);
                  },
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

String? phoneValidator(String? value, AppLocalizations l10n) {
  final digits = UserAuthService.normalizePhone(value ?? '');
  if (digits.isEmpty) return l10n.phoneRequired;
  if (digits.length != 10) return l10n.phoneInvalid;
  return null;
}
