import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/models/user_location.dart';
import 'package:krishix/core/services/location_service.dart';
import 'package:krishix/core/widgets/app_drawer.dart';
import 'package:krishix/features/browse/browse_screen.dart';
import 'package:krishix/features/home/home_screen.dart';
import 'package:krishix/features/post/post_listing_screen.dart';
import 'package:krishix/features/profile/profile_screen.dart';
import 'package:krishix/l10n/app_localizations.dart';

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.locale,
    required this.onLocaleChanged,
    required this.loggedInPhone,
    required this.onVerifiedPhone,
    required this.onLogout,
  });

  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;
  final String? loggedInPhone;
  final ValueChanged<String> onVerifiedPhone;
  final VoidCallback onLogout;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  var _selectedIndex = 0;
  UserLocation _userLocation = UserLocation.defaultLocation;
  var _askedLocation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _promptLocationIfNeeded();
    });
  }

  void _onTabSelected(int index) {
    if (index == 2) return;
    setState(() => _selectedIndex = index > 2 ? index - 1 : index);
  }

  int get _navIndex {
    if (_selectedIndex >= 2) return _selectedIndex + 1;
    return _selectedIndex;
  }

  // Future<void> _promptLocationIfNeeded() async {
  //   if (_askedLocation || !mounted) return;
  //   _askedLocation = true;

  //   final l10n = AppLocalizations.of(context)!;
  //   final allow = await showDialog<bool>(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: Text(l10n.allowLocationTitle),
  //       content: Text(
  //         l10n.allowLocationMessage,
  //         style: const TextStyle(fontSize: 17),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(ctx, false),
  //           child: Text(l10n.cancel),
  //         ),
  //         ElevatedButton(
  //           onPressed: () => Navigator.pop(ctx, true),
  //           child: Text(l10n.useCurrentLocation),
  //         ),
  //       ],
  //     ),
  //   );

  //   // if (allow == true) {
  //   //   await _refreshLocation();
  //   // }
  // }

  // Future<void> _refreshLocation() async {
  //   final location = await LocationService.fetchCurrentLocation();
  //   if (mounted) {
  //     setState(() => _userLocation = location);
  //   }
  // }

  void _showComingSoon(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: AppDrawer(
        locale: widget.locale,
        onLocaleChanged: widget.onLocaleChanged,
        loggedInPhone: widget.loggedInPhone,
        onHomeTap: () => setState(() => _selectedIndex = 0),
        onBrowseTap: () => setState(() => _selectedIndex = 1),
        onProfileTap: () => setState(() => _selectedIndex = 2),
        onLogout: widget.onLogout,
      ),
      body: Builder(
        builder: (scaffoldContext) {
          final openDrawer = () => Scaffold.of(scaffoldContext).openDrawer();

          final screens = [
            HomeScreen(
              onMenuTap: openDrawer,
                userLocation: _userLocation,
                // onLocationTap: _refreshLocation,
              ),
            BrowseScreen(userLocation: _userLocation),
            ProfileScreen(
              locale: widget.locale,
              onLocaleChanged: widget.onLocaleChanged,
              loggedInPhone: widget.loggedInPhone,
              onVerifiedPhone: widget.onVerifiedPhone,
              onLogout: widget.onLogout,
            ),
          ];

          return IndexedStack(
            index: _selectedIndex,
            children: screens,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const PostListingScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primaryGreen,
        elevation: 6,
        child: const Icon(Icons.add, color: Colors.white, size: 34),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 76,
        color: Colors.white,
        elevation: 10,
        shadowColor: Colors.black26,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home,
              label: l10n.home,
              selected: _navIndex == 0,
              onTap: () => _onTabSelected(0),
            ),
            _NavItem(
              icon: Icons.search,
              label: l10n.browse,
              selected: _navIndex == 1,
              onTap: () => _onTabSelected(1),
            ),
            SizedBox(
              width: 64,
              child: Text(
                l10n.postAd,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _NavItem(
              icon: Icons.chat_bubble_outline,
              label: l10n.chat,
              selected: false,
              badge: '99+',
              onTap: () => _showComingSoon(l10n.comingSoon),
            ),
            _NavItem(
              icon: Icons.person_outline,
              label: l10n.profile,
              selected: _navIndex == 4,
              onTap: () => _onTabSelected(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primaryGreen : AppColors.textPrimary;

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 68,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 30),
                if (badge != null)
                  Positioned(
                    right: -12,
                    top: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: color,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
