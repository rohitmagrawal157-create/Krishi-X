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
      case 'hi': return 'हिंदी';
      case 'mr': return 'मराठी';
      case 'gu': return 'ગુજરાતી';
      case 'en':
      default:   return 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n    = AppLocalizations.of(context)!;
    final locales = AppLocalizations.supportedLocales;

    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.82,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // ── Header ─────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
              color: AppColors.primaryGreen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ✅ Krishix logo image — no text name below
                  Image.asset(
                    'assets/images/krishix_logo.png',
                    height: 56,
                    fit: BoxFit.contain,
                    alignment: Alignment.centerLeft,
                    errorBuilder: (_, __, ___) {
                      // Fallback: white text logo if asset missing
                      return const Text(
                        'KrishiX',
                        style: TextStyle(
                          color:      Colors.white,
                          fontSize:   28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // Tagline
                  Text(
                    l10n.tagline,
                    style: TextStyle(
                      color:    Colors.white.withOpacity(0.92),
                      fontSize: 15,
                    ),
                  ),

                  // Phone (if logged in)
                  if (loggedInPhone != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.phone_iphone,
                            size: 16,
                            color: Colors.white.withOpacity(0.8)),
                        const SizedBox(width: 6),
                        Text(
                          '+91 $loggedInPhone',
                          style: const TextStyle(
                            color:      Colors.white,
                            fontSize:   16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // ── Menu items ─────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.sm),
                children: [
                  _DrawerTile(
                    icon:  Icons.favorite_border,
                    label: l10n.savedItems,
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.comingSoon)),
                      );
                    },
                  ),
                  _DrawerTile(
                    icon:  Icons.help_outline,
                    label: l10n.helpSupport,
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.comingSoon)),
                      );
                    },
                  ),

                  const Divider(height: 28),

                  // ── Language section ──────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      l10n.language,
                      style: const TextStyle(
                        fontSize:   18,
                        fontWeight: FontWeight.w700,
                        color:      AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing:    10,
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
                                fontSize:   16,
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

            // ── Logout button ───────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: SizedBox(
                height: AppSpacing.minTouchTarget,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    onLogout();
                  },
                  icon:  const Icon(Icons.logout, size: 24),
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

// ─────────────────────────────────────────────────────────────
// Drawer tile
// ─────────────────────────────────────────────────────────────
class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.fontSize = 17,
  });

  final IconData icon;
  final String   label;
  final VoidCallback onTap;
  final double   fontSize;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 28, color: AppColors.primaryGreen),
      title: Text(
        label,
        style: TextStyle(
          fontSize:   fontSize,
          fontWeight: FontWeight.w600,
          color:      AppColors.textPrimary,
        ),
      ),
      minVerticalPadding: 14,
      onTap: onTap,
    );
  }
}