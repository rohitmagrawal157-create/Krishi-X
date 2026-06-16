// lib/features/drawer/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/constants/app_spacing.dart';
import 'package:krishix/l10n/app_localizations.dart';
import 'package:krishix/features/profile/edit_profile_screen.dart';
import 'package:krishix/features/advertise/advertise_screen.dart';
const Color _kOrange = Color(0xFFFF6B00);

class AppDrawer extends StatefulWidget {
  const AppDrawer({
    super.key,
    required this.locale,
    required this.onLocaleChanged,
    required this.onHomeTap,
    required this.onBrowseTap,
    required this.onProfileTap,
    required this.onLogout,
    this.loggedInPhone,
    this.userName,
  });

  final Locale               locale;
  final ValueChanged<Locale> onLocaleChanged;
  final VoidCallback         onHomeTap;
  final VoidCallback         onBrowseTap;
  final VoidCallback         onProfileTap;
  final VoidCallback         onLogout;
  final String?              loggedInPhone;
  final String?              userName;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late String _displayName;
  late String _phone;

  String get _localizedAppName {
    switch (widget.locale.languageCode) {
      case 'hi': return 'कृषिX';
      case 'mr': return 'कृषिX';
      case 'gu': return 'કૃષિX';
      default:   return 'KrishiX';
    }
  }

  @override
  void initState() {
    super.initState();
    _displayName = (widget.userName?.trim().isNotEmpty == true)
        ? widget.userName! : 'User';
    _phone = widget.loggedInPhone ?? '';
  }

  @override
  void didUpdateWidget(AppDrawer old) {
    super.didUpdateWidget(old);
    if (widget.userName != old.userName) {
      _displayName = (widget.userName?.trim().isNotEmpty == true)
          ? widget.userName! : 'User';
    }
    if (widget.loggedInPhone != old.loggedInPhone) {
      _phone = widget.loggedInPhone ?? '';
    }
  }

  String _langLabel(Locale loc) {
    switch (loc.languageCode) {
      case 'hi': return 'हिंदी';
      case 'mr': return 'मराठी';
      case 'gu': return 'ગુજરાતી';
      default:   return 'English';
    }
  }

  List<Locale> _orderedLocales(List<Locale> all) {
    const order = ['en', 'hi', 'mr', 'gu'];
    final sorted = <Locale>[];
    for (final code in order) {
      final match = all.where((l) => l.languageCode == code);
      if (match.isNotEmpty) sorted.add(match.first);
    }
    for (final l in all) {
      if (!order.contains(l.languageCode)) sorted.add(l);
    }
    return sorted;
  }

  void _showComingSoon(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Coming soon!'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _shareApp(BuildContext context) {
    Navigator.pop(context);
    Share.share(
      'Join me on $_localizedAppName – Trusted Rural Commerce!\n'
      'Download: https://play.google.com/store/apps/details?id=in.krishix.krishix',
      subject: '$_localizedAppName – Trusted Rural Commerce',
    );
  }

 Widget _gradientDivider({double height = 1.0}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 1),
    child: Container(
      height: height,
      color: const Color(0xFFE0E0E0), // light gray
    ),
  );
}

  // trailing arrow widget
  Widget get _arrow => const Icon(
    Icons.arrow_forward_ios_rounded,
    size:  16,
    color: _kOrange,
  );

  @override
  Widget build(BuildContext context) {
    final l10n    = AppLocalizations.of(context)!;
    final locales = _orderedLocales(AppLocalizations.supportedLocales);

    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.82,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // ── Header ────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end:   Alignment.bottomRight,
                  colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App name
                  Text(
                    _localizedAppName,
                    style: TextStyle(
                      color:         Colors.white.withOpacity(0.75),
                      fontSize:      12,
                      fontWeight:    FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Username + Edit
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color:      Colors.white,
                            fontSize:   26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [_kOrange, Color(0xFFFFB347)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Material(
                          color:        Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => EditProfileScreen(
                                    initialName: _displayName == 'User'
                                        ? '' : _displayName,
                                    initialPhone: _phone,
                                    onSaved: (name, phone) {
                                      setState(() {
                                        _displayName = name.isNotEmpty
                                            ? name : 'User';
                                        _phone = phone;
                                      });
                                      widget.onProfileTap();
                                    },
                                  ),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 7),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.edit,
                                      size: 14, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text(
                                    'Edit',
                                    style: TextStyle(
                                      color:      Colors.white,
                                      fontSize:   13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Text(
                    l10n.tagline,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.88),
                      fontSize: 14,
                    ),
                  ),

                  if (_phone.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.phone_iphone,
                            size: 15,
                            color: Colors.white.withOpacity(0.8)),
                        const SizedBox(width: 6),
                        Text(
                          '+91 $_phone',
                          style: const TextStyle(
                            color:      Colors.white,
                            fontSize:   15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

         // ── Menu items ────────────────────────────────
Expanded(
  child: ListView(
    padding: const EdgeInsets.symmetric(vertical: 6),
    children: [

      // 1. Get Verified — orange icon + orange label + arrow
      _DrawerTile(
        icon:       Icons.verified_outlined,
        iconColor:  _kOrange,
        labelColor: _kOrange,
        label:      l10n.getVerifiedBadge,
        trailing:   _arrow,
        onTap:      () => _showComingSoon(context),
      ),

      _gradientDivider(),

      // 2. Advertise with us — orange icon + orange label + New badge
      _DrawerTile(
        icon:       Icons.campaign_rounded,
        iconColor:  _kOrange,
        labelColor: _kOrange,
        label:      'Advertise with us',
        trailing: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_kOrange, Color(0xFFFFB347)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 10, color: Colors.white),
              SizedBox(width: 3),
              Text(
                'New',
                style: TextStyle(
                  fontSize:   11,
                  fontWeight: FontWeight.w800,
                  color:      Colors.white,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const AdvertiseScreen(),
            ),
          );
        },
      ),

      _gradientDivider(),

      // 3. Invite friends
      _DrawerTile(
        icon:      Icons.share_rounded,
        iconColor: _kOrange,
        label:     l10n.inviteFriends,
        trailing:  _arrow,
        onTap:     () => _shareApp(context),
      ),

      _gradientDivider(),

      // 4. Saved Items
      _DrawerTile(
        icon:      Icons.favorite_border,
        iconColor: _kOrange,
        label:     l10n.savedItems,
        trailing:  _arrow,
        onTap:     () => _showComingSoon(context),
      ),

      _gradientDivider(),

      // 5. Help & Support
      _DrawerTile(
        icon:      Icons.help_outline,
        iconColor: _kOrange,
        label:     l10n.helpSupport,
        trailing:  _arrow,
        onTap:     () => _showComingSoon(context),
      ),

      // ── Divider before Language ──
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          height: 1.0,
          color: const Color(0xFFE0E0E0),
        ),
      ),

      // ── Language section ──────────────────────
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: Row(
          children: [
            const Icon(Icons.language_rounded,
                size: 22, color: _kOrange),
            const SizedBox(width: 8),
            Text(
              l10n.language,
              style: const TextStyle(
                fontSize:   17,
                fontWeight: FontWeight.w700,
                color:      AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(
          spacing:    10,
          runSpacing: 10,
          children: locales.map((loc) {
            final selected =
                loc.languageCode == widget.locale.languageCode;
            return GestureDetector(
              onTap: () => widget.onLocaleChanged(loc),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: selected
                      ? const LinearGradient(
                          colors: [
                            Color(0xFF2E7D32),
                            Color(0xFF43A047),
                          ],
                        )
                      : null,
                  color: selected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selected
                        ? Colors.transparent
                        : Colors.grey.shade300,
                    width: 1.2,
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppColors.primaryGreen
                                .withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selected) ...[
                      const Icon(Icons.check_rounded,
                          size: 15, color: Colors.white),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      _langLabel(loc),
                      style: TextStyle(
                        fontSize:   15,
                        fontWeight: FontWeight.w700,
                        color: selected
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),

      const SizedBox(height: 12),
    ],
  ),
),

            // ── Logout ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: SizedBox(
                height: AppSpacing.minTouchTarget,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onLogout();
                  },
                  icon:  const Icon(Icons.logout, size: 22),
                  label: Text(
                    l10n.logout,
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.errorRed,
                    side: const BorderSide(color: AppColors.errorRed),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
    this.iconColor  = _kOrange,
    this.labelColor,
    this.fontSize   = 16,
    this.trailing,
  });

  final IconData     icon;
  final Color        iconColor;
  final Color?       labelColor;
  final String       label;
  final VoidCallback onTap;
  final double       fontSize;
  final Widget?      trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 26, color: iconColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize:   fontSize,
                  fontWeight: FontWeight.w600,
                  color:      labelColor ?? AppColors.textPrimary,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}