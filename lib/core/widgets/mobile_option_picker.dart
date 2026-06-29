import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';

/// Opens a bottom-sheet option picker tuned for mobile touch targets.
Future<T?> showMobileOptionPicker<T>({
  required BuildContext context,
  required String title,
  required List<T> options,
  required String Function(T option) labelFor,
  T? selected,
  Color accentColor = AppColors.primaryGreen,
}) async {
  if (options.isEmpty) return null;

  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => _MobileOptionSheet<T>(
      title: title,
      options: options,
      labelFor: labelFor,
      selected: selected,
      accentColor: accentColor,
    ),
  );
}

/// Convenience for plain [String] option lists.
Future<String?> showMobileStringPicker({
  required BuildContext context,
  required String title,
  required List<String> options,
  String? selected,
  Color accentColor = AppColors.primaryGreen,
}) {
  return showMobileOptionPicker<String>(
    context: context,
    title: title,
    options: options,
    labelFor: (v) => v,
    selected: selected,
    accentColor: accentColor,
  );
}

/// Tappable pill that opens [showMobileOptionPicker].
class MobileOptionTrigger extends StatelessWidget {
  const MobileOptionTrigger({
    super.key,
    required this.label,
    required this.onTap,
    this.accentColor = AppColors.primaryGreen,
    this.height = 52,
    this.minWidth = 88,
    this.compact = false,
  });

  final String label;
  final VoidCallback onTap;
  final Color accentColor;
  final double height;
  final double minWidth;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final radius = compact ? 8.0 : 12.0;
    final fontSize = compact ? 12.0 : 13.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: minWidth, minHeight: height),
          child: Ink(
            height: height,
            padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.07),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: accentColor.withOpacity(0.28)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: compact ? 18 : 20,
                  color: accentColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileOptionSheet<T> extends StatelessWidget {
  const _MobileOptionSheet({
    required this.title,
    required this.options,
    required this.labelFor,
    required this.selected,
    required this.accentColor,
  });

  final String title;
  final List<T> options;
  final String Function(T option) labelFor;
  final T? selected;
  final Color accentColor;

  static const _itemHeight = 56.0;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    final maxH = MediaQuery.of(context).size.height * 0.75;
    final wantH = 88 + options.length * _itemHeight + bottom;
    final sheetH = wantH.clamp(220.0, maxH);

    return Container(
      height: sheetH,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(height: 1, color: Colors.grey.shade200),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 6),
              itemCount: options.length,
              itemBuilder: (ctx, i) {
                final option = options[i];
                final isSelected = option == selected;
                final label = labelFor(option);

                return Material(
                  color: isSelected
                      ? accentColor.withOpacity(0.06)
                      : Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.pop(ctx, option),
                    child: SizedBox(
                      height: _itemHeight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  color: isSelected
                                      ? accentColor
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              child: isSelected
                                  ? Container(
                                      key: const ValueKey('chk'),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: accentColor,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.check_rounded,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const SizedBox(
                                      key: ValueKey('emp'),
                                      width: 24,
                                      height: 24,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: bottom),
        ],
      ),
    );
  }
}
