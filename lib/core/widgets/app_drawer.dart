import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/constants/app_spacing.dart';
import 'package:krishix/l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.locale,
    required this.onLocaleChanged,
    required this.onHomeTap,
    required this.onBrowseTap,
    required this.onProfileTap,
    required this.onLogout,
    this.loggedInPhone,
  });

  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;
  final VoidCallback onHomeTap;
  final VoidCallback onBrowseTap;
  final VoidCallback onProfileTap;
  final VoidCallback onLogout;
  final String? loggedInPhone;

  String _langLabel(Locale loc) {
    switch (loc.languageCode) {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locales = AppLocalizations.supportedLocales;

    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.82,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              color: AppColors.primaryGreen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.agriculture,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.appTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.tagline,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.92),
                      fontSize: 16,
                    ),
                  ),
                  if (loggedInPhone != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '+91 $loggedInPhone',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                children: [
                  _DrawerTile(
                    icon: Icons.home,
                    label: l10n.home,
                    fontSize: 18,
                    onTap: () {
                      Navigator.pop(context);
                      onHomeTap();
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.search,
                    label: l10n.browse,
                    fontSize: 18,
                    onTap: () {
                      Navigator.pop(context);
                      onBrowseTap();
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.inventory_2_outlined,
                    label: l10n.myListings,
                    fontSize: 18,
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.comingSoon)),
                      );
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.favorite_border,
                    label: l10n.savedItems,
                    fontSize: 18,
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.comingSoon)),
                      );
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.help_outline,
                    label: l10n.helpSupport,
                    fontSize: 18,
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.comingSoon)),
                      );
                    },
                  ),
                  const Divider(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      l10n.language,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: locales.map((loc) {
                        final selected =
                            loc.languageCode == locale.languageCode;
                        return SizedBox(
                          height: 48,
                          child: ChoiceChip(
                            label: Text(
                              _langLabel(loc),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? AppColors.primaryGreen
                                    : AppColors.textPrimary,
                              ),
                            ),
                            selected: selected,
                            onSelected: (_) => onLocaleChanged(loc),
                            selectedColor:
                                AppColors.primaryGreen.withOpacity(0.15),
                            side: BorderSide(
                              color: selected
                                  ? AppColors.primaryGreen
                                  : Colors.grey.shade400,
                              width: selected ? 2 : 1,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: SizedBox(
                height: AppSpacing.minTouchTarget,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    onLogout();
                  },
                  icon: const Icon(Icons.logout, size: 24),
                  label: Text(
                    l10n.logout,
                    style: const TextStyle(fontSize: 17),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.errorRed,
                    side: const BorderSide(color: AppColors.errorRed),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.fontSize = 17,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 28, color: AppColors.primaryGreen),
      title: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      minVerticalPadding: 14,
      onTap: onTap,
    );
  }
}
