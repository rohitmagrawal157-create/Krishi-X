import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/core/models/user_location.dart';

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
    final displayName =
        await _resolveDisplayName(position.latitude, position.longitude);
    return UserLocation(
      displayName: displayName,
      latitude: position.latitude,
      longitude: position.longitude,
      permissionGranted: permissionGranted,
    );
  }

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
    final normalized = location.toLowerCase();
    for (final city in _cities) {
      if (normalized.contains(city.name.toLowerCase())) {
        return (lat: city.lat, lng: city.lng);
      }
    }
    return null;
  }

  static Future<({double lat, double lng})?> coordinatesForLocation(
    String location,
  ) async {
    final known = _knownCoordsForLocation(location);
    if (known != null) return known;

    try {
      final matches = await locationFromAddress(location);
      if (matches.isEmpty) return null;
      return (
        lat: matches.first.latitude,
        lng: matches.first.longitude,
      );
    } catch (_) {
      return null;
    }
  }

  static double? distanceKmTo(String listingLocation, UserLocation user) {
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

  static Listing withDistance(Listing listing, UserLocation? user) {
    if (user == null || !user.permissionGranted) return listing;
    final km = distanceKmTo(listing.location, user);
    if (km == null) return listing;
    return listing.copyWith(distanceKm: km);
  }

  static List<Listing> withDistances(
    List<Listing> listings,
    UserLocation? user,
  ) {
    if (user == null || !user.permissionGranted) return listings;
    return listings.map((l) => withDistance(l, user)).toList();
  }

  static bool isNearby(String listingLocation, UserLocation user) {
    final km = distanceKmTo(listingLocation, user);
    if (km != null) return km <= 25;
    return listingLocation.toLowerCase().contains(user.regionKey.toLowerCase()) ||
        listingLocation
            .toLowerCase()
            .contains(user.displayName.split(',').first.toLowerCase());
  }
}
