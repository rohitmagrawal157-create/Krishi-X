import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_spacing.dart';
import 'package:krishix/core/services/user_auth_service.dart';
import 'package:krishix/core/widgets/language_toggle.dart';
import 'package:krishix/features/profile/profile_login_flow.dart';
import 'package:krishix/l10n/app_localizations.dart';

typedef LocaleChanged = void Function(Locale locale);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.locale,
    required this.onLocaleChanged,
    required this.loggedInPhone,
    required this.onVerifiedPhone,
    required this.onLogout,
  });

  final Locale locale;
  final LocaleChanged onLocaleChanged;
  final String? loggedInPhone;
  final ValueChanged<String> onVerifiedPhone;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final phoneMasked = loggedInPhone == null
        ? null
        : _maskPhone(loggedInPhone!);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.15),
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  loggedInPhone == null ? l10n.loginRegister : l10n.loggedInAs,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                if (loggedInPhone == null) ...[
                  Text(
                    l10n.phoneLoginHint,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ProfileLoginFlow(
                              onVerified: onVerifiedPhone,
                            ),
                          ),
                        );
                      },
                      child: Text(l10n.continueButton),
                    ),
                  ),
                ] else ...[
                  FutureBuilder<RegisteredUser?>(
                    future: UserAuthService.findUser(loggedInPhone!),
                    builder: (context, snapshot) {
                      final name = snapshot.data?.fullName;
                      if (name != null && name.isNotEmpty) {
                        return Column(
                          children: [
                            Text(
                              name,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  Text(
                    phoneMasked!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: onLogout,
                      child: Text(l10n.logout),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.language, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        LanguageToggle(locale: locale, onChanged: onLocaleChanged),
        const SizedBox(height: AppSpacing.lg),
        _ProfileTile(
          icon: Icons.inventory_2_outlined,
          title: l10n.myListings,
          onTap: () => _showComingSoon(context, l10n),
        ),
        _ProfileTile(
          icon: Icons.favorite_border,
          title: l10n.savedItems,
          onTap: () => _showComingSoon(context, l10n),
        ),
        _ProfileTile(
          icon: Icons.help_outline,
          title: l10n.helpSupport,
          onTap: () => _showComingSoon(context, l10n),
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context, AppLocalizations l10n) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.comingSoon)),
    );
  }

  String _maskPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) return digits;
    final first2 = digits.substring(0, 2);
    final last2 = digits.substring(digits.length - 2);
    return '$first2••••••$last2';
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(icon, size: 28),
        title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
        trailing: const Icon(Icons.chevron_right),
        minVerticalPadding: AppSpacing.md,
        onTap: onTap,
      ),
    );
  }
}
