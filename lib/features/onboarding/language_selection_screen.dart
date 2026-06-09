import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/features/auth/widgets/auth_decor.dart';
import 'package:krishix/features/auth/widgets/auth_screen_layout.dart';
import 'package:krishix/l10n/app_localizations.dart';

class LanguageSelectionRoute extends StatefulWidget {
  const LanguageSelectionRoute({
    super.key,
    required this.initialLocale,
    required this.onLocaleChanged,
    required this.onComplete,
    this.onBack,
    this.step = 3,
  });

  final Locale initialLocale;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<Locale> onComplete;
  final VoidCallback? onBack;
  final int step;

  @override
  State<LanguageSelectionRoute> createState() => _LanguageSelectionRouteState();
}

class _LanguageSelectionRouteState extends State<LanguageSelectionRoute> {
  late Locale _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialLocale;
  }

  @override
  Widget build(BuildContext context) {
    return LanguageSelectionScreen(
      selectedLocale: _selected,
      step: widget.step,
      showBackButton: widget.onBack != null,
      onBack: widget.onBack,
      onLocaleSelected: (locale) {
        setState(() => _selected = locale);
        widget.onLocaleChanged(locale);
      },
      onContinue: () => widget.onComplete(_selected),
    );
  }
}

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({
    super.key,
    required this.selectedLocale,
    required this.onLocaleSelected,
    required this.onContinue,
    this.step = 3,
    this.showBackButton = false,
    this.onBack,
  });

  final Locale selectedLocale;
  final ValueChanged<Locale> onLocaleSelected;
  final VoidCallback onContinue;
  final int step;
  final bool showBackButton;
  final VoidCallback? onBack;

  String _nativeLabel(Locale locale) {
    switch (locale.languageCode) {
      case 'hi':
        return 'हिंदी';
      case 'mr':
        return 'मराठी';
      case 'gu':
        return 'ગુજરાતી';
      case 'en':
      default:
        return 'English';
    }
  }

  String _englishLabel(Locale locale) {
    switch (locale.languageCode) {
      case 'hi':
        return 'Hindi';
      case 'mr':
        return 'Marathi';
      case 'gu':
        return 'Gujarati';
      case 'en':
      default:
        return 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locales = AppLocalizations.supportedLocales;

    return AuthFlowScaffold(
      showBackButton: showBackButton,
      onBack: onBack,
      step: step,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Center(
          //   child: Container(
          //     width: 88,
          //     height: 88,
          //     decoration: BoxDecoration(
          //       color: AuthStyles.buttonGreen.withOpacity(0.12),
          //       shape: BoxShape.circle,
          //     ),
          //     child: Icon(
          //       Icons.language,
          //       size: 42,
          //       color: AuthStyles.buttonGreen,
          //     ),
          //   ),
          // ),
          const SizedBox(height: 24),
          Text(
            l10n.selectLanguageTitle,
            textAlign: TextAlign.center,
            style: AuthStyles.titleStyle.copyWith(fontSize: 28),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.selectLanguageSubtitle,
            textAlign: TextAlign.center,
            style: AuthStyles.subtitleStyle,
          ),
          const SizedBox(height: 28),
          ...locales.map((locale) {
            final selected =
                locale.languageCode == selectedLocale.languageCode;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: selected
                    ? AuthStyles.buttonGreen.withOpacity(0.08)
                    : Colors.white,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: () => onLocaleSelected(locale),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected
                            ? AuthStyles.buttonGreen
                            : Colors.grey.shade300,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: selected
                              ? AuthStyles.buttonGreen
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _nativeLabel(locale),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                _englishLabel(locale),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          AuthArrowButton(
            label: l10n.confirmLanguage,
            onPressed: onContinue,
          ),
        ],
      ),
    );
  }
}
