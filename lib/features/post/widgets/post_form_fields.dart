import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/widgets/mobile_option_picker.dart';

const Color kPostFormGreen = AppColors.primaryGreen;

InputDecoration postInputDecoration({
  required String hint,
  String? prefixText,
  String? suffixText,
  bool filled = true,
  Color? fillColor,
  Widget? prefixIcon,
}) {
  return InputDecoration(
    hintText:    hint,
    hintStyle:   TextStyle(color: Colors.grey.shade400, fontSize: 13),
    prefixText:  prefixText,
    suffixText:  suffixText,
    prefixStyle: const TextStyle(
      fontWeight: FontWeight.w700,
      color:      AppColors.textPrimary,
    ),
    suffixStyle: TextStyle(
      fontWeight: FontWeight.w600,
      color:      Colors.grey.shade500,
      fontSize:   13,
    ),
    prefixIcon:     prefixIcon,
    filled:         filled,
    fillColor:      fillColor ?? Colors.white,
    counterText:    '',
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:   BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:   BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:   const BorderSide(color: kPostFormGreen, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:   const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:   const BorderSide(color: Colors.red, width: 2),
    ),
  );
}

class PostFieldLabel extends StatelessWidget {
  const PostFieldLabel({super.key, required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: kPostFormGreen),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize:   13,
            fontWeight: FontWeight.w700,
            color:      AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class PostField extends StatelessWidget {
  const PostField({
    super.key,
    required this.controller,
    required this.hint,
    this.prefixText,
    this.suffixText,
    this.keyboardType,
    this.capitalization = TextCapitalization.none,
    this.formatters,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final String? prefixText;
  final String? suffixText;
  final TextInputType? keyboardType;
  final TextCapitalization capitalization;
  final List<TextInputFormatter>? formatters;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:         controller,
      keyboardType:       keyboardType,
      textCapitalization: capitalization,
      inputFormatters:    formatters,
      decoration: postInputDecoration(
        hint:       hint,
        prefixText: prefixText,
        suffixText: suffixText,
      ),
      validator: validator,
    );
  }
}

/// Full-width select field — opens a mobile bottom sheet instead of a
/// native dropdown overlay.
class PostSelectField extends FormField<String> {
  PostSelectField({
    super.key,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onChanged,
    String? Function(String?)? validator,
    Color accentColor = kPostFormGreen,
    String sheetTitle = 'Select option',
  }) : super(
          initialValue: selected,
          validator: validator,
          builder: (state) {
            final value = state.value ?? selected;

            Future<void> openPicker(BuildContext context) async {
              final picked = await showMobileStringPicker(
                context:     context,
                title:       sheetTitle,
                options:     options,
                selected:    value,
                accentColor: accentColor,
              );
              if (picked != null) {
                state.didChange(picked);
                onChanged(picked);
              }
            }

            final hasError = state.hasError;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => openPicker(state.context),
                    borderRadius: BorderRadius.circular(12),
                    child: Ink(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color:        Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: hasError
                              ? Colors.red
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontSize:   14,
                                fontWeight: FontWeight.w600,
                                color:      AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: hasError ? Colors.red : accentColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
}

/// Quantity input with a unit picker on the right (mobile bottom sheet).
class PostQuantityField extends StatelessWidget {
  const PostQuantityField({
    super.key,
    required this.controller,
    required this.hint,
    required this.units,
    required this.selectedUnit,
    required this.onUnitChanged,
    this.formatters,
    this.validator,
    this.accentColor = kPostFormGreen,
  });

  final TextEditingController controller;
  final String hint;
  final List<String> units;
  final String selectedUnit;
  final ValueChanged<String> onUnitChanged;
  final List<TextInputFormatter>? formatters;
  final String? Function(String?)? validator;
  final Color accentColor;

  Future<void> _openUnitPicker(BuildContext context) async {
    final picked = await showMobileStringPicker(
      context:     context,
      title:       'Select unit',
      options:     units,
      selected:    selectedUnit,
      accentColor: accentColor,
    );
    if (picked != null) onUnitChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            controller:      controller,
            keyboardType:    TextInputType.number,
            inputFormatters: formatters,
            validator:       validator,
            decoration: postInputDecoration(hint: hint),
          ),
        ),
        const SizedBox(width: 10),
        MobileOptionTrigger(
          label:       selectedUnit,
          accentColor: accentColor,
          onTap:       () => _openUnitPicker(context),
        ),
      ],
    );
  }
}

class PostStepDot extends StatelessWidget {
  const PostStepDot({
    super.key,
    required this.number,
    required this.active,
    required this.done,
    required this.label,
  });

  final int number;
  final bool active;
  final bool done;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width:  28,
          height: 28,
          decoration: BoxDecoration(
            color: active || done
                ? Colors.white
                : Colors.white.withOpacity(0.30),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: done
                ? Icon(Icons.check_rounded, size: 16, color: kPostFormGreen)
                : Text(
                    '$number',
                    style: TextStyle(
                      fontSize:   13,
                      fontWeight: FontWeight.w800,
                      color: active
                          ? kPostFormGreen
                          : Colors.white.withOpacity(0.60),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize:   10,
            color: active ? Colors.white : Colors.white.withOpacity(0.55),
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
