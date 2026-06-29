// lib/features/shell/main_shell.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/data/app_locations.dart';
import 'package:krishix/core/models/user_location.dart';
import 'package:krishix/core/services/location_service.dart';
import 'package:krishix/core/widgets/app_drawer.dart';
import 'package:krishix/core/widgets/location_picker.dart';
import 'package:krishix/features/home/home_screen.dart';
import 'package:krishix/features/icons/my_ads_screen.dart';
import 'package:krishix/features/icons/dealer_screen.dart';
import 'package:krishix/features/post/sell_or_rent_screen.dart';   // ← new
import 'package:krishix/features/icons/chat_screen.dart';
import 'package:krishix/l10n/app_localizations.dart';

// ─────────────────────────────────────────────────────────────
// TAB INDEX MAP
//   0 → Home
//   1 → My Ads
//   2 → (FAB center slot — no screen)
//   3 → Chats
//   4 → Dealers
// ─────────────────────────────────────────────────────────────

int _stackIndex(int tabIndex) {
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
  var _selectedIndex    = 0;
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
        displayName:       l10n.loading,
        permissionGranted: false,
      );
    });

    final permission = await LocationService.ensurePermission();
    if (!mounted) return;

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        _userLocation       = UserLocation.defaultLocation;
        _isFetchingLocation = false;
      });
      return;
    }

    final location = await LocationService.fetchCurrentLocation();
    if (!mounted) return;

    setState(() {
      _userLocation       = location;
      _isFetchingLocation = false;
    });

    if (!location.permissionGranted) {
      final perm    = await LocationService.checkPermission();
      final enabled = await LocationService.isServiceEnabled();
      if (!mounted) return;

      if (perm == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.locationPermissionDenied),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
              label: 'Settings',
              onPressed: LocationService.openAppSettings),
        ));
      } else if (perm == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:  Text(l10n.locationPermissionDenied),
          behavior: SnackBarBehavior.floating,
        ));
      } else if (!enabled) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
              'Turn on location services to use your location.'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
              label: 'Settings',
              onPressed: LocationService.openLocationSettings),
        ));
      }
      return;
    }

    if (startStream && !_userLocation.isManual) {
      _locationSub?.cancel();
      _locationSub = LocationService.watchPosition().listen((updated) {
        if (!mounted || _userLocation.isManual) return;
        setState(() => _userLocation = updated);
      });
    }
  }

  Future<void> _openLocationPicker() async {
    final current = AppLocationCatalog.findByFull(_userLocation.displayName) ??
        (_userLocation.city != null
            ? AppLocation(
                name: _userLocation.city!,
                district: _userLocation.district ?? _userLocation.city!,
                state: _userLocation.state ?? 'Maharashtra',
                latitude: _userLocation.latitude,
                longitude: _userLocation.longitude,
              )
            : null);

    final selected = await openLocationPicker(
      context,
      current: current,
      onUseMyLocation: _detectGpsLocation,
    );

    if (selected != null && mounted) {
      _locationSub?.cancel();
      _locationSub = null;
      setState(() => _userLocation = selected);
    }
  }

  Future<UserLocation?> _detectGpsLocation() async {
    final permission = await LocationService.ensurePermission();
    if (!mounted) return null;
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }
    final location = await LocationService.fetchCurrentLocation();
    if (!mounted || !location.permissionGranted) return null;
    return location;
  }

  void _onTabSelected(int index) {
    if (index == 2) return; // FAB notch slot
    setState(() => _selectedIndex = index);
  }

  // ── Open Sell-or-Rent chooser ───────────────────────────
  void _onSellFabPressed() {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque:             false,
        barrierDismissible: true,
        barrierColor:       Colors.transparent,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: CurvedAnimation(
              parent: animation, curve: Curves.easeOut),
          child: const SellOrRentScreen(),
        ),
      ),
    );
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
          final openDrawer =
              () => Scaffold.of(scaffoldContext).openDrawer();

          final screens = [
            HomeScreen(
              onMenuTap:     openDrawer,
              userLocation:  _userLocation,
              onLocationTap: _openLocationPicker,
            ),
            MyAdsScreen(userLocation: _userLocation),
            const ChatScreen(),
            DealerScreen(userLocation: _userLocation),
          ];

          return IndexedStack(
            index:    _stackIndex(_selectedIndex),
            children: screens,
          );
        },
      ),

      // ── FAB ─────────────────────────────────────────────
      floatingActionButton: _SellFab(
        label:     l10n.sell,
        onPressed: _onSellFabPressed,   // ← opens chooser
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      // ── Bottom nav ──────────────────────────────────────
      bottomNavigationBar: _KrishixNavBar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
        l10n:          l10n,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Sell FAB
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
            Container(
              width:  60, height: 60,
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
          Expanded(child: _NavItem(
            icon:     Icons.home_rounded,
            label:    l10n.home,
            selected: selectedIndex == 0,
            onTap:    () => onTabSelected(0),
          )),
          Expanded(child: _NavItem(
            icon:     Icons.list_alt_outlined,
            label:    l10n.myAds,
            selected: selectedIndex == 1,
            onTap:    () => onTabSelected(1),
          )),
          const SizedBox(width: 72), // FAB gap
          Expanded(child: _NavItem(
            icon:     Icons.chat_bubble_outline_rounded,
            label:    l10n.chats,
            selected: selectedIndex == 3,
            badge:    '99+',
            onTap:    () => onTabSelected(3),
          )),
          Expanded(child: _NavItem(
            icon:     Icons.storefront_outlined,
            label:    l10n.dealers,
            selected: selectedIndex == 4,
            onTap:    () => onTabSelected(4),
          )),
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
                    right: -10, top: -5,
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
                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.w500,
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