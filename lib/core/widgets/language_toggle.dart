import 'package:flutter/material.dart';
import 'package:krishix/l10n/app_localizations.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({
    super.key,
    required this.locale,
    required this.onChanged,
  });

  final Locale locale;
  final ValueChanged<Locale> onChanged;

  String _labelFor(AppLocalizations l10n, Locale locale) {
    switch (locale.languageCode) {
      case 'hi':
        return l10n.hindi;
      case 'mr':
        return l10n.marathi;
      case 'gu':
        return l10n.gujarati;
      case 'en':
      default:
        return l10n.english;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final supported = AppLocalizations.supportedLocales;

    return DropdownButtonFormField<Locale>(
      value: supported.any((l) => l.languageCode == locale.languageCode)
          ? supported.firstWhere((l) => l.languageCode == locale.languageCode)
          : const Locale('hi'),
      items: supported
          .map(
            (loc) => DropdownMenuItem<Locale>(
              value: loc,
              child: Text(_labelFor(l10n, loc)),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
