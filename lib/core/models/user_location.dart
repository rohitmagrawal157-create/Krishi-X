import 'package:krishix/core/data/app_locations.dart';

/// How precisely the user picked their location — drives listing filters.
enum LocationScope {
  /// One village / hamlet — only that place's listings.
  village,
  /// City / district — all villages & towns in that area.
  city,
  /// Whole state — all listings across the state.
  state,
}

class UserLocation {
  const UserLocation({
    required this.displayName,
    this.city,
    this.district,
    this.state,
    this.latitude,
    this.longitude,
    this.permissionGranted = false,
    this.isManual = false,
    this.scope = LocationScope.city,
    this.placeType,
  });

  final String displayName;
  final String? city;
  final String? district;
  final String? state;
  final double? latitude;
  final double? longitude;
  final bool permissionGranted;
  final bool isManual;
  final LocationScope scope;
  final String? placeType;

  static const defaultLocation = UserLocation(
    displayName: 'Aurangabad, Chhatrapati Sambhajinagar, Maharashtra',
    city: 'Aurangabad',
    district: 'Chhatrapati Sambhajinagar',
    state: 'Maharashtra',
    latitude: 19.8762,
    longitude: 75.3433,
    scope: LocationScope.city,
    placeType: 'city',
  );

  String get headerLabel {
    if (city != null && state != null) {
      return AppLocation(name: city!, district: district ?? city!, state: state!).headerLabel;
    }
    return displayName;
  }

  /// Short label for "Showing listings in …"
  String get filterLabel {
    switch (scope) {
      case LocationScope.village:
        return city ?? displayName.split(',').first;
      case LocationScope.city:
        return district?.isNotEmpty == true ? district! : (city ?? displayName);
      case LocationScope.state:
        return state ?? displayName;
    }
  }

  String get regionKey => state?.isNotEmpty == true
      ? state!
      : (displayName.split(',').length > 1 ? displayName.split(',').last.trim() : displayName);

  factory UserLocation.fromAppLocation(
    AppLocation loc, {
    bool isManual = true,
    LocationScope? scope,
  }) =>
      UserLocation(
        displayName: loc.full,
        city: loc.name,
        district: loc.district,
        state: loc.state,
        latitude: loc.latitude,
        longitude: loc.longitude,
        permissionGranted: loc.latitude != null,
        isManual: isManual,
        scope: scope ?? loc.inferSelectionScope(),
        placeType: loc.placeType,
      );

  factory UserLocation.fromGps({
    required String displayName,
    required double latitude,
    required double longitude,
    String? placeType,
  }) {
    final parsed = AppLocation.parse(displayName);
    final loc = AppLocation(
      name: parsed.name,
      district: parsed.district,
      state: parsed.state,
      placeType: placeType,
    );
    return UserLocation(
      displayName: displayName,
      city: parsed.name,
      district: parsed.district,
      state: parsed.state.isNotEmpty ? parsed.state : null,
      latitude: latitude,
      longitude: longitude,
      permissionGranted: true,
      scope: loc.inferSelectionScope(),
      placeType: placeType,
    );
  }

  UserLocation copyWith({
    String? displayName,
    String? city,
    String? district,
    String? state,
    double? latitude,
    double? longitude,
    bool? permissionGranted,
    bool? isManual,
    LocationScope? scope,
    String? placeType,
  }) =>
      UserLocation(
        displayName: displayName ?? this.displayName,
        city: city ?? this.city,
        district: district ?? this.district,
        state: state ?? this.state,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        permissionGranted: permissionGranted ?? this.permissionGranted,
        isManual: isManual ?? this.isManual,
        scope: scope ?? this.scope,
        placeType: placeType ?? this.placeType,
      );
}

/// Infer listing filter level from a picked place.
extension AppLocationSelectionScope on AppLocation {
  LocationScope inferSelectionScope() {
    if (placeType == 'state') return LocationScope.state;
    if (placeType == 'district') return LocationScope.city;
    const villages = {'village', 'hamlet', 'suburb', 'locality'};
    final type = placeType?.toLowerCase();
    if (type != null && villages.contains(type)) return LocationScope.village;
    if (type == 'city' ||
        type == 'town' ||
        type == 'municipality' ||
        isBrowsable) {
      return LocationScope.city;
    }
    if (name.toLowerCase().trim() != district.toLowerCase().trim()) {
      return LocationScope.village;
    }
    return LocationScope.city;
  }
}
