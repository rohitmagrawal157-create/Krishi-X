import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:krishix/core/data/app_locations.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/core/models/user_location.dart';
import 'package:krishix/core/services/location_search_service.dart';

abstract final class LocationService {
  static Future<LocationPermission>? _permissionFlow;
  static var _requestedPermissionThisSession = false;

  static const _cities = <({String name, String state, double lat, double lng})>[
    (name: 'Aurangabad', state: 'Maharashtra', lat: 19.8762, lng: 75.3433),
    (name: 'Paithan', state: 'Chhatrapati Sambhajinagar, Maharashtra', lat: 19.4757, lng: 75.3858),
    (name: 'Vaijapur', state: 'Chhatrapati Sambhajinagar, Maharashtra', lat: 19.9267, lng: 74.7275),
    (name: 'Gangapur', state: 'Chhatrapati Sambhajinagar, Maharashtra', lat: 19.6972, lng: 75.0014),
    (name: 'Sillod', state: 'Chhatrapati Sambhajinagar, Maharashtra', lat: 20.3030, lng: 75.6510),
    (name: 'Phulambri', state: 'Chhatrapati Sambhajinagar, Maharashtra', lat: 20.1036, lng: 75.4152),
    (name: 'Kannad', state: 'Chhatrapati Sambhajinagar, Maharashtra', lat: 20.2578, lng: 75.1378),
    (name: 'Nashik', state: 'Maharashtra', lat: 19.9975, lng: 73.7898),
    (name: 'Pune', state: 'Maharashtra', lat: 18.5204, lng: 73.8567),
    (name: 'Kolhapur', state: 'Maharashtra', lat: 16.7050, lng: 74.2433),
    (name: 'Nagpur', state: 'Maharashtra', lat: 21.1458, lng: 79.0882),
    (name: 'Indore', state: 'Madhya Pradesh', lat: 22.7196, lng: 75.8577),
    (name: 'Meerut', state: 'Uttar Pradesh', lat: 28.9845, lng: 77.7064),
    (name: 'Ludhiana', state: 'Punjab', lat: 30.9010, lng: 75.8573),
  ];

  static const _streamSettings = LocationSettings(
    accuracy: LocationAccuracy.medium,
    distanceFilter: 100,
  );

  static Future<bool> isServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();

  static Future<LocationPermission> checkPermission() =>
      Geolocator.checkPermission();

  static Future<LocationPermission> refreshPermission() async {
    return Geolocator.checkPermission();
  }

  static Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();

  static Future<LocationPermission> ensurePermission() async {
    final activeRequest = _permissionFlow;
    if (activeRequest != null) return activeRequest;
    if (_requestedPermissionThisSession) {
      return Geolocator.checkPermission();
    }

    _requestedPermissionThisSession = true;
    final request = _requestPermissionOnce();
    _permissionFlow = request;
    try {
      return await request;
    } finally {
      _permissionFlow = null;
    }
  }

  static Future<LocationPermission> _requestPermissionOnce() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission;
  }

  static Future<bool> openAppSettings() => Geolocator.openAppSettings();

  static Future<bool> openLocationSettings() =>
      Geolocator.openLocationSettings();

  static Future<UserLocation> fetchCurrentLocation({
    bool requestPermissionIfNeeded = false,
  }) async {
    final permission = requestPermissionIfNeeded
        ? await ensurePermission()
        : await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return UserLocation.defaultLocation;
    }

    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return UserLocation.defaultLocation;

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 12),
        ),
      );
      return _fromPosition(position, permissionGranted: true);
    } catch (_) {
      return UserLocation.defaultLocation;
    }
  }

  static Stream<UserLocation> watchPosition() {
    return Geolocator.getPositionStream(locationSettings: _streamSettings)
        .asyncMap(
          (position) => _fromPosition(position, permissionGranted: true),
        );
  }

  static Future<UserLocation> _fromPosition(
    Position position, {
    required bool permissionGranted,
  }) async {
    final appLoc = await LocationSearchService.fromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (appLoc != null) {
      return UserLocation.fromAppLocation(appLoc, isManual: false).copyWith(
        permissionGranted: true,
      );
    }
    return UserLocation.fromGps(
      displayName: await _resolveDisplayName(
        position.latitude,
        position.longitude,
      ),
      latitude: position.latitude,
      longitude: position.longitude,
      placeType: appLoc?.placeType,
    );
  }

  static UserLocation fromSelection(AppLocation loc) =>
      UserLocation.fromAppLocation(loc, isManual: true);

  static Future<String> _resolveDisplayName(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final locality = place.locality ??
            place.subLocality ??
            place.subAdministrativeArea ??
            place.administrativeArea;
        final state = place.administrativeArea ?? place.country;
        if (locality != null &&
            locality.isNotEmpty &&
            state != null &&
            state.isNotEmpty) {
          return '$locality, $state';
        }
        if (locality != null && locality.isNotEmpty) return locality;
      }
    } catch (_) {
      // Fall back to nearest known city.
    }

    final city = _nearestCity(lat, lng);
    return '${city.name}, ${city.state}';
  }

  static ({String name, String state}) _nearestCity(double lat, double lng) {
    var best = _cities.first;
    var bestDistance = double.infinity;

    for (final city in _cities) {
      final d = Geolocator.distanceBetween(lat, lng, city.lat, city.lng);
      if (d < bestDistance) {
        bestDistance = d;
        best = city;
      }
    }
    return (name: best.name, state: best.state);
  }

  static ({double lat, double lng})? _knownCoordsForLocation(String location) {
    final known = AppLocationCatalog.findByFull(location);
    if (known?.latitude != null && known?.longitude != null) {
      return (lat: known!.latitude!, lng: known.longitude!);
    }
    final normalized = location.toLowerCase();
    for (final city in _cities) {
      if (normalized.contains(city.name.toLowerCase())) {
        return (lat: city.lat, lng: city.lng);
      }
    }
    return null;
  }

  static Future<({double lat, double lng})?> _geocodeLocation(
    String location,
  ) async {
    final known = _knownCoordsForLocation(location);
    if (known != null) return known;
    try {
      final results = await LocationSearchService.search(location, limit: 1);
      if (results.isEmpty ||
          results.first.latitude == null ||
          results.first.longitude == null) {
        return null;
      }
      return (
        lat: results.first.latitude!,
        lng: results.first.longitude!,
      );
    } catch (_) {
      return null;
    }
  }

  static bool listingMatchesLocation(String listingLocation, UserLocation user) {
    final listing = _parseLocationString(listingLocation);
    return _matchesAtScope(listing, user, user.scope);
  }

  /// Whether a listing matches at a given scope (used for fallback broadening).
  static bool listingMatchesAtScope(
    String listingLocation,
    UserLocation user,
    LocationScope scope,
  ) =>
      _matchesAtScope(_parseLocationString(listingLocation), user, scope);

  static LocationScope broadenScope(LocationScope scope) {
    switch (scope) {
      case LocationScope.village:
        return LocationScope.city;
      case LocationScope.city:
        return LocationScope.state;
      case LocationScope.state:
        return LocationScope.state;
    }
  }

  static ({String name, String district, String state}) _parseLocationString(
    String raw,
  ) {
    final parts = raw
        .split(',')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return (name: raw.toLowerCase(), district: raw.toLowerCase(), state: '');
    }
    if (parts.length >= 3) {
      return (
        name: parts.first.toLowerCase(),
        district: parts[1].toLowerCase(),
        state: parts.sublist(2).join(', ').toLowerCase(),
      );
    }
    if (parts.length == 2) {
      return (
        name: parts.first.toLowerCase(),
        district: parts.first.toLowerCase(),
        state: parts.last.toLowerCase(),
      );
    }
    return (
      name: parts.first.toLowerCase(),
      district: parts.first.toLowerCase(),
      state: '',
    );
  }

  static bool _matchesAtScope(
    ({String name, String district, String state}) listing,
    UserLocation user,
    LocationScope scope,
  ) {
    switch (scope) {
      case LocationScope.village:
        return _namesMatch(listing.name, user.city ?? '');
      case LocationScope.city:
        return _matchesCityScope(listing, user);
      case LocationScope.state:
        return _namesMatch(listing.state, user.state ?? '');
    }
  }

  static bool _matchesCityScope(
    ({String name, String district, String state}) listing,
    UserLocation user,
  ) {
    final city = user.city?.toLowerCase() ?? '';
    final district = user.district?.toLowerCase() ?? '';

    if (district.isNotEmpty && _districtsMatch(listing.district, district)) {
      return true;
    }
    if (city.isNotEmpty &&
        (_namesMatch(listing.name, city) || _namesMatch(listing.district, city))) {
      return true;
    }
    if (user.latitude != null && user.longitude != null) {
      final km = _distanceKmToSync(
        '${listing.name}, ${listing.district}, ${listing.state}',
        user,
      );
      if (km != null && km <= 40) return true;
    }
    return false;
  }

  static String _norm(String value) => value.toLowerCase().trim();

  static bool _namesMatch(String a, String b) {
    final na = _norm(a);
    final nb = _norm(b);
    if (na.isEmpty || nb.isEmpty) return false;
    if (na == nb) return true;
    if (na.contains(nb) || nb.contains(na)) return true;
    return _areAliases(na, nb);
  }

  static bool _districtsMatch(String listingDistrict, String userDistrict) {
    if (_namesMatch(listingDistrict, userDistrict)) return true;
    for (final entry in _districtAliasGroups.entries) {
      final group = entry.value;
      if (group.contains(listingDistrict) && group.contains(userDistrict)) {
        return true;
      }
    }
    return false;
  }

  static bool _areAliases(String a, String b) {
    for (final group in _districtAliasGroups.values) {
      if (group.contains(a) && group.contains(b)) return true;
    }
    return false;
  }

  static const _districtAliasGroups = {
    'sambhajinagar': {
      'chhatrapati sambhajinagar',
      'aurangabad',
      'sambhajinagar',
    },
    'mumbai': {'mumbai', 'mumbai city', 'mumbai suburban'},
  };

  static double? _distanceKmToSync(String listingLocation, UserLocation user) {
    if (user.latitude == null || user.longitude == null) return null;
    final coords = _knownCoordsForLocation(listingLocation);
    if (coords == null) return null;
    final meters = Geolocator.distanceBetween(
      user.latitude!,
      user.longitude!,
      coords.lat,
      coords.lng,
    );
    return double.parse((meters / 1000).toStringAsFixed(1));
  }

  static Future<({double lat, double lng})?> coordinatesForLocation(
    String location,
  ) async {
    final geocoded = await _geocodeLocation(location);
    if (geocoded != null) return geocoded;

    try {
      final matches = await locationFromAddress('$location, India');
      if (matches.isEmpty) return null;
      return (lat: matches.first.latitude, lng: matches.first.longitude);
    } catch (_) {
      return null;
    }
  }

  static double? distanceKmTo(String listingLocation, UserLocation user) =>
      _distanceKmToSync(listingLocation, user);

  static Listing withDistance(Listing listing, UserLocation? user) {
    if (user == null ||
        user.latitude == null ||
        user.longitude == null) {
      return listing;
    }
    final km = _distanceKmToSync(listing.location, user);
    if (km == null) return listing;
    return listing.copyWith(distanceKm: km);
  }

  static List<Listing> withDistances(
    List<Listing> listings,
    UserLocation? user,
  ) {
    if (user == null ||
        user.latitude == null ||
        user.longitude == null) {
      return listings;
    }
    return listings.map((l) => withDistance(l, user)).toList();
  }

  static bool isNearby(String listingLocation, UserLocation user) {
    if (listingMatchesLocation(listingLocation, user)) return true;
    final km = _distanceKmToSync(listingLocation, user);
    if (km != null) return km <= 25;
    return listingLocation.toLowerCase().contains(user.regionKey.toLowerCase()) ||
        listingLocation
            .toLowerCase()
            .contains(user.displayName.split(',').first.toLowerCase());
  }
}
