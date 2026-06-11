import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/models/user_location.dart';
import 'package:krishix/core/services/location_service.dart';
import 'package:krishix/core/widgets/app_drawer.dart';
import 'package:krishix/features/browse/browse_screen.dart';
import 'package:krishix/features/home/home_screen.dart';
import 'package:krishix/features/icons/my_ads_screen.dart';
import 'package:krishix/features/icons/dealer_screen.dart';
import 'package:krishix/features/post/post_listing_screen.dart';
import 'package:krishix/features/profile/profile_screen.dart';
import 'package:krishix/features/icons/chat_screen.dart';
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

  void _onTabSelected(int index) {
    if (index == 2) return;
    setState(() => _selectedIndex = index);
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
        onProfileTap: () => setState(() => _selectedIndex = 4),
        onLogout: widget.onLogout,
      ),
      body: Builder(
        builder: (scaffoldContext) {
          final openDrawer = () => Scaffold.of(scaffoldContext).openDrawer();

          final screens = [
            HomeScreen(
              onMenuTap: openDrawer,
              userLocation: _userLocation,
            ),
            MyAdsScreen(userLocation: _userLocation),
            DealerScreen(userLocation: _userLocation),
            ChatScreen(),
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

      // ✅ Sell FAB — rounded square, half above nav bar
      floatingActionButton: _SellFab(
        label: l10n.sell,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const PostListingScreen(),
            ),
          );
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: _KrishixNavBar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
        l10n: l10n,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ✅ Sell FAB — matches the image exactly
// ─────────────────────────────────────────────
class _SellFab extends StatelessWidget {
  const _SellFab({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,   // ✅ no fixed SizedBox — grows naturally
        children: [
          // ── Rounded square icon ──
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE87400),
                  Color(0xFF1A7A00),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),

          const SizedBox(height: 4),

          // ── Label pill ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF1A6B00),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.8,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// ─────────────────────────────────────────────
// ✅ Bottom Nav Bar
// ─────────────────────────────────────────────
class _KrishixNavBar extends StatelessWidget {
  const _KrishixNavBar({
    required this.selectedIndex,
    required this.onTabSelected,
    required this.l10n,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 68,
      color: Colors.white,
      elevation: 12,
      shadowColor: Colors.black26,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            label: l10n.home,
            selected: selectedIndex == 0,
            onTap: () => onTabSelected(0),
          ),
          _NavItem(
            icon: Icons.list_alt_outlined,
            label: l10n.myAds,
            selected: selectedIndex == 1,
            onTap: () => onTabSelected(1),
          ),
          const SizedBox(width: 72),
          _NavItem(
            icon: Icons.chat_bubble_outline_rounded,
            label: l10n.chats,
            selected: selectedIndex == 3,
            badge: '99+',
            onTap: () => onTabSelected(3),
          ),
          _NavItem(
            icon: Icons.storefront_outlined,
            label: l10n.dealer,
            selected: selectedIndex == 2,
            onTap: () => onTabSelected(2),
          ),
        ],
      ),
    );
  }
}


// ─────────────────────────────────────────────
// Nav Item
// ─────────────────────────────────────────────
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
    final color = selected ? AppColors.primaryGreen : const Color(0xFF757575);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 64,
        height: 56, // ✅ explicit — prevents unbounded height inside BottomAppBar
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 24), // ✅ was 28 — reduced to fit
                if (badge != null)
                  Positioned(
                    right: -10,
                    top: -5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2), // ✅ was 3 — tightened
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // ✅ safety net for long labels
            ),
          ],
        ),
      ),
    );
  }
}