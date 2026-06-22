// lib/features/shell/main_shell.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/models/user_location.dart';
import 'package:krishix/core/services/location_service.dart';
import 'package:krishix/core/widgets/app_drawer.dart';
import 'package:krishix/features/home/home_screen.dart';
import 'package:krishix/features/icons/my_ads_screen.dart';
import 'package:krishix/features/icons/dealer_screen.dart';
import 'package:krishix/features/post/post_listing_screen.dart';
import 'package:krishix/features/icons/chat_screen.dart';
import 'package:krishix/l10n/app_localizations.dart';

// ─────────────────────────────────────────────────────────────
// TAB INDEX MAP
//   0 → Home
//   1 → My Ads
//   2 → (FAB center slot — no screen)
//   3 → Chats
//   4 → Dealers
//
// IndexedStack uses a compacted list [Home, MyAds, Chats, Dealers]
// mapped via _stackIndex(tabIndex).
// ─────────────────────────────────────────────────────────────

int _stackIndex(int tabIndex) {
  // tab 2 is the FAB slot — never called
  // tab 0→0, 1→1, 3→2, 4→3
  if (tabIndex <= 1) return tabIndex;
  if (tabIndex == 3) return 2;
  if (tabIndex == 4) return 3;
  return 0;
}

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.locale,
    required this.onLocaleChanged,
    required this.loggedInPhone,
    required this.onVerifiedPhone,
    required this.onLogout,
  });

  final Locale               locale;
  final ValueChanged<Locale> onLocaleChanged;
  final String?              loggedInPhone;
  final ValueChanged<String> onVerifiedPhone;
  final VoidCallback         onLogout;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with WidgetsBindingObserver {
  var _selectedIndex = 0;
  UserLocation _userLocation = UserLocation.defaultLocation;
  StreamSubscription<UserLocation>? _locationSub;
  var _isFetchingLocation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshLocation(startStream: true);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _locationSub?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _resumeLocationAfterSettings();
    }
  }

  Future<void> _resumeLocationAfterSettings() async {
    final permission = await LocationService.refreshPermission();
    if (!mounted) return;
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      await _refreshLocation(startStream: true);
    }
  }

  Future<void> _refreshLocation({bool startStream = false}) async {
    if (_isFetchingLocation || !mounted) return;
    setState(() => _isFetchingLocation = true);

    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _userLocation = UserLocation(
        displayName: l10n.loading,
        permissionGranted: false,
      );
    });

    final permission = await LocationService.ensurePermission();
    if (!mounted) return;

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        _userLocation = UserLocation.defaultLocation;
        _isFetchingLocation = false;
      });
      return;
    }

    final location = await LocationService.fetchCurrentLocation();
    if (!mounted) return;

    setState(() {
      _userLocation = location;
      _isFetchingLocation = false;
    });

    if (!location.permissionGranted) {
      final permission = await LocationService.checkPermission();
      final serviceEnabled = await LocationService.isServiceEnabled();
      if (!mounted) return;

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.locationPermissionDenied),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Settings',
              onPressed: LocationService.openAppSettings,
            ),
          ),
        );
      } else if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.locationPermissionDenied),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Turn on location services to use your location.'),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Settings',
              onPressed: LocationService.openLocationSettings,
            ),
          ),
        );
      }
      return;
    }

    if (startStream) {
      _locationSub?.cancel();
      _locationSub = LocationService.watchPosition().listen((updated) {
        if (!mounted) return;
        setState(() => _userLocation = updated);
      });
    }
  }

  void _onTabSelected(int index) {
    // Tab 2 is the FAB notch — ignore
    if (index == 2) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: AppDrawer(
        locale:          widget.locale,
        onLocaleChanged: widget.onLocaleChanged,
        loggedInPhone:   widget.loggedInPhone,
        onPhoneChanged:  widget.onVerifiedPhone,
        onHomeTap:       () => setState(() => _selectedIndex = 0),
        onBrowseTap:     () => setState(() => _selectedIndex = 1),
        onProfileTap:    () => setState(() => _selectedIndex = 4),
        onLogout:        widget.onLogout,
      ),
      body: Builder(
        builder: (scaffoldContext) {
          final openDrawer = () => Scaffold.of(scaffoldContext).openDrawer();

          // ── Compacted screen list: indices 0–3 ──────────────
          final screens = [
            // 0 → Home
            HomeScreen(
              onMenuTap:     openDrawer,
              userLocation:  _userLocation,
              onLocationTap: _refreshLocation,
            ),
            // 1 → My Ads
            MyAdsScreen(userLocation: _userLocation),
            // 2 → Chats
            ChatScreen(),
            // 3 → Dealers
            DealerScreen(userLocation: _userLocation),
          ];

          return IndexedStack(
            index:    _stackIndex(_selectedIndex),
            children: screens,
          );
        },
      ),

      // ── FAB ────────────────────────────────────────────────
      floatingActionButton: _SellFab(
        label:     l10n.sell,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const PostListingScreen(),
            ),
          );
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      // ── Bottom nav ─────────────────────────────────────────
      bottomNavigationBar: _KrishixNavBar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
        l10n:          l10n,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Sell FAB — circular with orange gradient + glow
// ─────────────────────────────────────────────────────────────
class _SellFab extends StatelessWidget {
  const _SellFab({required this.label, required this.onPressed});

  final String       label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: GestureDetector(
        onTap:    onPressed,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ── Circular FAB ──
            Container(
              width:  60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin:  Alignment.topLeft,
                  end:    Alignment.bottomRight,
                  colors: [Color(0xFFFF8C00), Color(0xFFFF6B00)],
                ),
                boxShadow: [
                  BoxShadow(
                    color:        const Color(0xFFFF6B00).withOpacity(0.55),
                    blurRadius:   16,
                    spreadRadius: 2,
                    offset:       const Offset(0, 4),
                  ),
                  BoxShadow(
                    color:      Colors.black.withOpacity(0.20),
                    blurRadius: 8,
                    offset:     const Offset(0, 6),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.add_rounded, color: Colors.white, size: 32),
              ),
            ),

            const SizedBox(height: 5),

            // ── Label pill ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF8C00), Color(0xFFFF6B00)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color:      const Color(0xFFFF6B00).withOpacity(0.35),
                    blurRadius: 6,
                    offset:     const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontSize:      10,
                  fontWeight:    FontWeight.w800,
                  color:         Colors.white,
                  letterSpacing: 1.0,
                  height:        1.1,
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
// Bottom Nav Bar
// ─────────────────────────────────────────────────────────────
class _KrishixNavBar extends StatelessWidget {
  const _KrishixNavBar({
    required this.selectedIndex,
    required this.onTabSelected,
    required this.l10n,
  });

  final int               selectedIndex;
  final ValueChanged<int> onTabSelected;
  final AppLocalizations  l10n;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height:      68,
      color:       Colors.white,
      elevation:   12,
      shadowColor: Colors.black26,
      shape:       const CircularNotchedRectangle(),
      notchMargin: 8,
      padding:     EdgeInsets.zero,
      child: Row(
        children: [
          // Tab 0 — Home
          Expanded(
            child: _NavItem(
              icon:     Icons.home_rounded,
              label:    l10n.home,
              selected: selectedIndex == 0,
              onTap:    () => onTabSelected(0),
            ),
          ),
          // Tab 1 — My Ads
          Expanded(
            child: _NavItem(
              icon:     Icons.list_alt_outlined,
              label:    l10n.myAds,
              selected: selectedIndex == 1,
              onTap:    () => onTabSelected(1),
            ),
          ),
          // Tab 2 — FAB gap (no tap target)
          const SizedBox(width: 72),
          // Tab 3 — Chats
          Expanded(
            child: _NavItem(
              icon:     Icons.chat_bubble_outline_rounded,
              label:    l10n.chats,
              selected: selectedIndex == 3,
              badge:    '99+',
              onTap:    () => onTabSelected(3),
            ),
          ),
          // Tab 4 — Dealers
          Expanded(
            child: _NavItem(
              icon:     Icons.storefront_outlined,
              label:    l10n.dealers,
              selected: selectedIndex == 4,
              onTap:    () => onTabSelected(4),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Nav Item
// ─────────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final IconData     icon;
  final String       label;
  final bool         selected;
  final VoidCallback onTap;
  final String?      badge;

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? AppColors.primaryGreen : const Color(0xFF757575);

    return InkWell(
      onTap:        onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 56,
        child: Column(
          mainAxisSize:      MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 24),
                if (badge != null)
                  Positioned(
                    right: -10,
                    top:   -5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color:        Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          color:      Colors.white,
                          fontSize:   9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                label,
                style: TextStyle(
                  fontSize:   10,
                  color:      color,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
                maxLines:  1,
                overflow:  TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
