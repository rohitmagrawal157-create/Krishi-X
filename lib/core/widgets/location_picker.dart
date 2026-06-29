// lib/core/widgets/location_picker.dart
//
// Google-style location picker:
//   • Live search — any city / village / taluka in India (OpenStreetMap)
//   • Browse all 36 states & UTs → dynamic places in that state
//   • GPS, popular shortcuts, recent locations

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/data/app_locations.dart';
import 'package:krishix/core/data/india_districts.dart';
import 'package:krishix/core/data/india_states.dart';
import 'package:krishix/core/models/user_location.dart';
import 'package:krishix/core/services/location_search_service.dart';
import 'package:krishix/core/services/recent_locations_store.dart';

const Color _kGreen = AppColors.primaryGreen;

Future<UserLocation?> openLocationPicker(
  BuildContext context, {
  AppLocation? current,
  Future<UserLocation?> Function()? onUseMyLocation,
  Color accentColor = _kGreen,
  bool fullScreen = true,
}) {
  if (fullScreen) {
    return Navigator.of(context).push<UserLocation>(
      MaterialPageRoute(
        builder: (_) => LocationPickerScreen(
          initial: current,
          accentColor: accentColor,
          onUseMyLocation: onUseMyLocation,
        ),
      ),
    );
  }
  return showModalBottomSheet<UserLocation>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => LocationPickerScreen(
      initial: current,
      accentColor: accentColor,
      onUseMyLocation: onUseMyLocation,
      embedded: true,
    ),
  );
}

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({
    super.key,
    this.initial,
    this.accentColor = _kGreen,
    this.onUseMyLocation,
    this.embedded = false,
  });

  final AppLocation? initial;
  final Color accentColor;
  final Future<UserLocation?> Function()? onUseMyLocation;
  final bool embedded;

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  String _query = '';
  String? _browseState;
  AppLocation? _browseCity;
  List<AppLocation> _results = [];
  List<AppLocation> _catalogResults = [];
  List<AppLocation> _recent = [];
  bool _loading = false;
  bool _loadingGPS = false;
  String? _error;

  bool get _isSearching => _query.isNotEmpty;

  bool get _isBrowsingDistricts =>
      _browseState != null && _browseCity == null && !_isSearching;

  bool get _isBrowsingVillages =>
      _browseState != null && _browseCity != null && !_isSearching;

  bool get _usesDistrictList =>
      _browseState != null && IndiaDistricts.hasDistricts(_browseState!);

  @override
  void initState() {
    super.initState();
    _loadRecent();
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadRecent() async {
    final recent = await RecentLocationsStore.load();
    if (mounted) setState(() => _recent = recent);
  }

  void _onSearchChanged() {
    final q = _searchCtrl.text.trim();
    setState(() => _query = q);
    _debounce?.cancel();

    if (q.isEmpty) {
      setState(() {
        _results = _catalogResults;
        _loading = false;
        _error = null;
      });
      return;
    }

    // Instant prefix filter — works from the first letter.
    final local = _localMatches(q);
    setState(() {
      _results = local;
      _loading = q.length >= 2;
      _error = local.isEmpty && q.length < 2
          ? 'Keep typing to search…'
          : null;
    });

    if (q.length < 2) return;

    _debounce = Timer(const Duration(milliseconds: 350), () => _runSearch(q));
  }

  /// Local matches: browse list + shortcuts (popular, recent, states).
  List<AppLocation> _localMatches(String q) {
    if (_browseCity != null || _browseState != null) {
      return LocationSearchService.filterAndRank(_catalogResults, q);
    }
    return LocationSearchService.filterAndRank(_homeSearchPool(), q);
  }

  List<AppLocation> _homeSearchPool() {
    final pool = <AppLocation>[
      ...kPopularLocations,
      ..._recent,
      ...IndiaDistricts.allDistricts(),
    ];
    for (final state in IndiaStates.all) {
      pool.add(AppLocation(name: state, district: state, state: state, placeType: 'state'));
    }
    return pool;
  }

  Future<void> _runSearch(String q) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final local = _localMatches(q);
    final apiResults = await LocationSearchService.search(
      q,
      stateFilter: _browseState,
      cityContext: _browseCity,
    );

    if (!mounted || _searchCtrl.text.trim() != q) return;

    final merged = LocationSearchService.mergeAndRank([local, apiResults], q);
    setState(() {
      _results = merged;
      _loading = false;
      _error = merged.isEmpty
          ? 'No places found. Try full name or district.'
          : null;
    });
  }

  Future<void> _loadStateCities(String state) async {
    setState(() {
      _browseState = state;
      _browseCity = null;
      _loading = true;
      _error = null;
      _results = [];
      _catalogResults = [];
      _query = '';
      _searchCtrl.clear();
    });
    final results = await LocationSearchService.districtsInState(state);
    if (!mounted || _browseState != state) return;
    final sorted = [...results]..sort((a, b) => a.name.compareTo(b.name));
    setState(() {
      _catalogResults = sorted;
      _results = sorted;
      _loading = false;
      _error = sorted.isEmpty
          ? 'No districts found. Use search above.'
          : null;
    });
  }

  Future<void> _loadDistrictPlaces(AppLocation district) async {
    setState(() {
      if (district.state.isNotEmpty) _browseState = district.state;
      _browseCity = district;
      _loading = true;
      _error = null;
      _results = [];
      _catalogResults = [];
      _query = '';
      _searchCtrl.clear();
    });
    final results = await LocationSearchService.placesInDistrict(district);
    if (!mounted || _browseCity?.name != district.name) return;
    final sorted = [...results]..sort((a, b) => a.name.compareTo(b.name));
    setState(() {
      _catalogResults = sorted;
      _results = sorted;
      _loading = false;
      _error = sorted.isEmpty
          ? 'No places listed. You can select ${district.name} directly.'
          : null;
    });
  }

  bool _isState(AppLocation loc) => loc.placeType == 'state';

  bool _isVillageLike(AppLocation loc) {
    const villageTypes = {'village', 'hamlet', 'suburb', 'locality'};
    final type = loc.placeType?.toLowerCase();
    if (type != null && villageTypes.contains(type)) return true;
    if (_browseCity != null && !_isCityLike(loc)) return true;
    if (type == 'city' || type == 'town' || type == 'municipality') {
      return false;
    }
    if (loc.isBrowsable) return false;
    return loc.name.toLowerCase().trim() !=
        loc.district.toLowerCase().trim();
  }

  bool _isCityLike(AppLocation loc) {
    if (_isState(loc)) return false;
    if (_isVillageLike(loc)) return false;
    if (loc.placeType == 'district') return true;
    return true;
  }

  /// State → districts → villages drill-down, or direct select for villages.
  void _onLocationTap(AppLocation loc) {
    if (_isState(loc)) {
      _loadStateCities(loc.name);
      return;
    }
    if (_isVillageLike(loc)) {
      _select(loc, scope: LocationScope.village);
      return;
    }
    if (_isCityLike(loc)) {
      _loadDistrictPlaces(loc);
      return;
    }
    _select(loc);
  }

  void _onCityTap(AppLocation city) => _onLocationTap(city);

  void _selectPlaceInDistrict(AppLocation place, AppLocation district) {
    final scope = place.name.toLowerCase().trim() ==
            district.name.toLowerCase().trim()
        ? LocationScope.city
        : LocationScope.village;
    _select(place, scope: scope);
  }

  Future<void> _select(AppLocation loc, {LocationScope? scope}) async {
    await RecentLocationsStore.save(loc);
    if (!mounted) return;
    Navigator.of(context).pop(
      UserLocation.fromAppLocation(loc, scope: scope),
    );
  }

  Future<void> _useGps() async {
    if (widget.onUseMyLocation == null) return;
    setState(() => _loadingGPS = true);
    try {
      final result = await widget.onUseMyLocation!();
      if (result != null && mounted) {
        Navigator.of(context).pop(result);
      }
    } finally {
      if (mounted) setState(() => _loadingGPS = false);
    }
  }

  void _goBack() {
    if (_browseCity != null) {
      final state = _browseState!;
      setState(() {
        _browseCity = null;
        _results = [];
        _error = null;
      });
      _loadStateCities(state);
    } else if (_browseState != null) {
      setState(() {
        _browseState = null;
        _browseCity = null;
        _catalogResults = [];
        _results = [];
        _error = null;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  String get _appBarTitle {
    if (_browseCity != null) return _browseCity!.name;
    if (_browseState != null) return _browseState!;
    return 'Select Location';
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor;
    final body = Column(
      children: [
        _SearchHeader(
          accent: accent,
          controller: _searchCtrl,
          browseState: _browseState,
          browseCity: _browseCity,
          loadingGPS: _loadingGPS,
          onUseGps: widget.onUseMyLocation != null ? _useGps : null,
        ),
        if (_browseState != null)
          _BrowseBreadcrumb(
            state: _browseState!,
            city: _browseCity,
            accent: accent,
            onStateTap: () {
              if (_browseCity != null) {
                setState(() => _browseCity = null);
                _loadStateCities(_browseState!);
              }
            },
            onClear: _goBack,
          ),
        Expanded(child: _buildContent(accent)),
      ],
    );

    if (widget.embedded) {
      return Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.94,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(child: body),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            (_browseState != null)
                ? Icons.arrow_back_ios_new_rounded
                : Icons.close_rounded,
            size: 20,
          ),
          onPressed: _goBack,
        ),
        title: Text(
          _appBarTitle,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
        ),
      ),
      body: body,
    );
  }

  Widget _buildContent(Color accent) {
    if (_loading && _results.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: _kGreen));
    }

    // Search results (from 1st character — instant local, then API at 2+)
    if (_isSearching) {
      if (_error != null && _results.isEmpty && !_loading) {
        return _EmptyState(message: _error!, query: _query);
      }
      return Column(
        children: [
          if (_loading)
            LinearProgressIndicator(
              minHeight: 2,
              color: accent,
              backgroundColor: accent.withOpacity(0.12),
            ),
          Expanded(
            child: _LocationList(
              locations: _results,
              accent: accent,
              selected: widget.initial,
              query: _query,
              onSelect: _onLocationTap,
              grouped: _browseState == null && _browseCity == null,
            ),
          ),
        ],
      );
    }

    // State → districts / cities list
    if (_isBrowsingDistricts) {
      if (_error != null && _results.isEmpty) {
        return _EmptyState(
          message: _error!,
          query: _query,
          icon: Icons.map_outlined,
        );
      }
      final sectionLabel = _usesDistrictList
          ? '${IndiaDistricts.countFor(_browseState!)} DISTRICTS OF ${_browseState!.toUpperCase()}'
          : 'CITIES & TOWNS IN ${_browseState!.toUpperCase()}';
      return ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _SectionTitle(sectionLabel, accent),
          _SelectStateTile(
            state: _browseState!,
            accent: accent,
            onTap: () => _select(
              AppLocation(
                name: _browseState!,
                district: _browseState!,
                state: _browseState!,
                placeType: 'state',
              ),
              scope: LocationScope.state,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              _usesDistrictList
                  ? 'Tap any district to see its villages & talukas'
                  : 'Tap any city to open its villages & towns',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ),
          ..._results.map(
            (district) => _BrowseTile(
              title: district.name,
              subtitle: _usesDistrictList
                  ? 'View villages & talukas →'
                  : (district.district.isNotEmpty &&
                          district.district != district.name
                      ? '${district.district} · View villages'
                      : 'View villages & towns'),
              accent: accent,
              icon: _usesDistrictList
                  ? Icons.map_outlined
                  : Icons.location_city_outlined,
              onTap: () => _onCityTap(district),
            ),
          ),
        ],
      );
    }

    // District → villages / talukas list
    if (_isBrowsingVillages) {
      final district = _browseCity!;
      return ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _SectionTitle(
            'VILLAGES & TALUKAS IN ${district.name.toUpperCase()}',
            accent,
          ),
          _SelectDistrictTile(
            district: district,
            accent: accent,
            onTap: () => _select(district, scope: LocationScope.city),
          ),
          if (_results.isNotEmpty) ...[
            _SectionTitle('ALL PLACES', accent),
            ..._results.map(
              (v) => _LocationTile(
                loc: v,
                accent: accent,
                selected: widget.initial?.full == v.full,
                onTap: () => _selectPlaceInDistrict(v, district),
                showChevron: false,
              ),
            ),
          ] else if (_error != null)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            ),
        ],
      );
    }

    // Home — recent, popular, states
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        if (_recent.isNotEmpty) ...[
          _SectionTitle('RECENT', accent),
          ..._recent.map(
            (l) => _LocationTile(
              loc: l,
              accent: accent,
              selected: widget.initial?.full == l.full,
              onTap: () => _select(l),
            ),
          ),
          const Divider(height: 24),
        ],
        _SectionTitle('POPULAR', accent),
        _PopularChips(
          accent: accent,
          selected: widget.initial,
          onSelect: _select,
        ),
        const SizedBox(height: 8),
        _SectionTitle('BROWSE BY STATE', accent),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Text(
            'All states → districts → villages',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ),
        ...IndiaStates.all.map(
          (state) => _BrowseTile(
            title: state,
            subtitle: 'Districts → Villages',
            accent: accent,
            icon: Icons.map_outlined,
            onTap: () => _loadStateCities(state),
          ),
        ),
      ],
    );
  }
}

class LocationPickerField extends StatefulWidget {
  const LocationPickerField({
    super.key,
    required this.controller,
    required this.accentColor,
    this.onUseMyLocation,
    this.validator,
    this.useFullScreen = false,
  });

  final TextEditingController controller;
  final Color accentColor;
  final Future<UserLocation?> Function()? onUseMyLocation;
  final String? Function(String?)? validator;
  final bool useFullScreen;

  @override
  State<LocationPickerField> createState() => _LocationPickerFieldState();
}

class _LocationPickerFieldState extends State<LocationPickerField> {
  AppLocation? get _current {
    final text = widget.controller.text.trim();
    if (text.isEmpty) return null;
    return AppLocationCatalog.findByFull(text);
  }

  Future<void> _open() async {
    final result = await openLocationPicker(
      context,
      current: _current,
      accentColor: widget.accentColor,
      onUseMyLocation: widget.onUseMyLocation,
      fullScreen: widget.useFullScreen,
    );
    if (result != null && mounted) {
      widget.controller.text = result.displayName;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _open,
      child: AbsorbPointer(
        child: TextFormField(
          controller: widget.controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'Search any city, village or district in India',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            prefixIcon: Icon(
              Icons.location_on_outlined,
              color: widget.accentColor,
              size: 20,
            ),
            suffixIcon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey.shade500,
              size: 22,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: widget.accentColor, width: 2),
            ),
          ),
          validator: widget.validator,
        ),
      ),
    );
  }
}

// ── Shared widgets ───────────────────────────────────────────

class _SearchHeader extends StatefulWidget {
  const _SearchHeader({
    required this.accent,
    required this.controller,
    required this.browseState,
    required this.browseCity,
    required this.loadingGPS,
    this.onUseGps,
  });

  final Color accent;
  final TextEditingController controller;
  final String? browseState;
  final AppLocation? browseCity;
  final bool loadingGPS;
  final VoidCallback? onUseGps;

  @override
  State<_SearchHeader> createState() => _SearchHeaderState();
}

class _SearchHeaderState extends State<_SearchHeader> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    String hint = 'Search village, city, district or state in India…';
    if (widget.browseCity != null) {
      hint = 'Search villages & talukas in ${widget.browseCity!.name}…';
    } else if (widget.browseState != null) {
      hint = 'Search districts in ${widget.browseState}…';
    }

    return Container(
      color: widget.accent,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: widget.controller,
            autofocus: false,
            style: const TextStyle(fontSize: 14),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              prefixIcon: const Icon(Icons.search_rounded, color: _kGreen, size: 20),
              suffixIcon: widget.controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: widget.controller.clear,
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          if (widget.onUseGps != null) ...[
            const SizedBox(height: 10),
            _GpsRow(
              accent: widget.accent,
              loading: widget.loadingGPS,
              onTap: widget.onUseGps!,
              onDarkBg: true,
            ),
          ],
        ],
      ),
    );
  }
}

class _BrowseBreadcrumb extends StatelessWidget {
  const _BrowseBreadcrumb({
    required this.state,
    required this.accent,
    required this.onClear,
    this.city,
    this.onStateTap,
  });

  final String state;
  final AppLocation? city;
  final Color accent;
  final VoidCallback onClear;
  final VoidCallback? onStateTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: accent.withOpacity(0.08),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(Icons.account_tree_outlined, size: 16, color: accent),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4,
              children: [
                GestureDetector(
                  onTap: onStateTap,
                  child: Text(
                    state,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: city != null ? accent.withOpacity(0.7) : accent,
                      decoration: city != null ? TextDecoration.underline : null,
                    ),
                  ),
                ),
                if (city != null) ...[
                  Icon(Icons.chevron_right_rounded,
                      size: 16, color: Colors.grey.shade400),
                  Text(
                    city!.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: accent,
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded,
                      size: 16, color: Colors.grey.shade400),
                  Text(
                    'Places',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: onClear,
            child: Text(
              'Back',
              style: TextStyle(
                fontSize: 12,
                color: accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectStateTile extends StatelessWidget {
  const _SelectStateTile({
    required this.state,
    required this.accent,
    required this.onTap,
  });

  final String state;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: accent.withOpacity(0.06),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: accent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.map_outlined, color: Colors.white, size: 20),
      ),
      title: Text(
        'All of $state',
        style: TextStyle(fontWeight: FontWeight.w800, color: accent),
      ),
      subtitle: Text(
        'Show listings from every district in this state',
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      trailing: Icon(Icons.touch_app_rounded, color: accent, size: 20),
      onTap: onTap,
    );
  }
}

class _SelectDistrictTile extends StatelessWidget {
  const _SelectDistrictTile({
    required this.district,
    required this.accent,
    required this.onTap,
  });

  final AppLocation district;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: accent.withOpacity(0.06),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: accent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.check_circle_outline_rounded,
            color: Colors.white, size: 20),
      ),
      title: Text(
        'All of ${district.name}',
        style: TextStyle(fontWeight: FontWeight.w800, color: accent),
      ),
      subtitle: Text(
        'Show listings from every village in this district',
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      trailing: Icon(Icons.touch_app_rounded, color: accent, size: 20),
      onTap: onTap,
    );
  }
}

class _LocationList extends StatelessWidget {
  const _LocationList({
    required this.locations,
    required this.accent,
    required this.onSelect,
    this.selected,
    this.grouped = false,
    this.query = '',
  });

  final List<AppLocation> locations;
  final Color accent;
  final void Function(AppLocation) onSelect;
  final AppLocation? selected;
  final bool grouped;
  final String query;

  @override
  Widget build(BuildContext context) {
    if (locations.isEmpty) {
      return const SizedBox.shrink();
    }

    if (!grouped) {
      return ListView.builder(
        itemCount: locations.length,
        itemBuilder: (_, i) => _LocationTile(
          loc: locations[i],
          accent: accent,
          selected: selected?.full == locations[i].full,
          query: query,
          onTap: () => onSelect(locations[i]),
        ),
      );
    }

    final groupedMap = AppLocationCatalog.groupedByState(locations);
    final states = groupedMap.keys.toList()..sort();
    return ListView.builder(
      itemCount: states.fold<int>(0, (s, st) => s + 1 + (groupedMap[st]?.length ?? 0)),
      itemBuilder: (_, idx) {
        var cursor = 0;
        for (final state in states) {
          if (idx == cursor) {
            return _StateHeader(state: state, accent: accent);
          }
          cursor++;
          final items = groupedMap[state]!;
          if (idx < cursor + items.length) {
            final loc = items[idx - cursor];
            return _LocationTile(
              loc: loc,
              accent: accent,
              query: query,
              onTap: () => onSelect(loc),
            );
          }
          cursor += items.length;
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _GpsRow extends StatelessWidget {
  const _GpsRow({
    required this.accent,
    required this.loading,
    required this.onTap,
    this.onDarkBg = false,
  });

  final Color accent;
  final bool loading;
  final VoidCallback onTap;
  final bool onDarkBg;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: onDarkBg ? Colors.white.withOpacity(0.12) : accent.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: onDarkBg ? Colors.white24 : accent.withOpacity(0.22),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.my_location_rounded,
                color: onDarkBg ? Colors.white : accent, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Use My Current Location',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: onDarkBg ? Colors.white : accent,
                ),
              ),
            ),
            if (loading)
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: onDarkBg ? Colors.white : accent,
                ),
              )
            else
              Icon(Icons.chevron_right_rounded,
                  color: onDarkBg ? Colors.white : accent),
          ],
        ),
      ),
    );
  }
}

class _PopularChips extends StatelessWidget {
  const _PopularChips({
    required this.accent,
    required this.onSelect,
    this.selected,
  });

  final Color accent;
  final void Function(AppLocation) onSelect;
  final AppLocation? selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: kPopularLocations.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final loc = kPopularLocations[i];
          final sel = selected?.name == loc.name;
          return GestureDetector(
            onTap: () => onSelect(loc),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: sel ? accent : accent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: sel ? accent : accent.withOpacity(0.25),
                ),
              ),
              child: Text(
                loc.name,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: sel ? Colors.white : accent,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label, this.accent);
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _BrowseTile extends StatelessWidget {
  const _BrowseTile({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
    this.icon = Icons.map_outlined,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: accent.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: accent, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300),
      onTap: onTap,
    );
  }
}

class _StateHeader extends StatelessWidget {
  const _StateHeader({required this.state, required this.accent});
  final String state;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F8F8),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Text(
        state.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: accent.withOpacity(0.7),
          letterSpacing: 0.7,
        ),
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  const _LocationTile({
    required this.loc,
    required this.accent,
    required this.onTap,
    this.selected = false,
    this.showChevron = true,
    this.query = '',
  });

  final AppLocation loc;
  final Color accent;
  final VoidCallback onTap;
  final bool selected;
  final bool showChevron;
  final String query;

  @override
  Widget build(BuildContext context) {
    final isState = loc.placeType == 'state';
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: accent.withOpacity(0.08),
        child: Icon(
          isState ? Icons.map_outlined : Icons.location_on_outlined,
          color: accent,
          size: 18,
        ),
      ),
      title: _HighlightedText(
        text: loc.name,
        query: query,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: selected ? accent : AppColors.textPrimary,
        ),
        highlightColor: accent.withOpacity(0.25),
      ),
      subtitle: Text(
        isState
            ? 'Tap to see all districts'
            : (loc.placeType == 'district'
                ? 'Tap to see villages & talukas'
                : (loc.district.isNotEmpty && loc.district != loc.name
                    ? '${loc.district}, ${loc.state}'
                    : loc.state)),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: selected
          ? Icon(Icons.check_circle_rounded, color: accent, size: 20)
          : showChevron
              ? Icon(
                  isState
                      ? Icons.location_city_outlined
                      : Icons.chevron_right_rounded,
                  color: isState ? accent.withOpacity(0.6) : Colors.grey.shade300,
                  size: isState ? 20 : null,
                )
              : Icon(Icons.check_rounded, color: accent.withOpacity(0.5), size: 20),
      onTap: onTap,
    );
  }
}

class _HighlightedText extends StatelessWidget {
  const _HighlightedText({
    required this.text,
    required this.query,
    required this.style,
    required this.highlightColor,
  });

  final String text;
  final String query;
  final TextStyle style;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    final q = query.trim();
    if (q.isEmpty) return Text(text, style: style);

    final lowerText = text.toLowerCase();
    final lowerQ = q.toLowerCase();
    final start = lowerText.indexOf(lowerQ);
    if (start < 0) return Text(text, style: style);

    return RichText(
      text: TextSpan(
        style: style,
        children: [
          if (start > 0) TextSpan(text: text.substring(0, start)),
          TextSpan(
            text: text.substring(start, start + q.length),
            style: style.copyWith(
              backgroundColor: highlightColor,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (start + q.length < text.length)
            TextSpan(text: text.substring(start + q.length)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.message,
    required this.query,
    this.icon = Icons.search_off_rounded,
  });

  final String message;
  final String query;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (query.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                'Try: "$query taluka" or district name',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
