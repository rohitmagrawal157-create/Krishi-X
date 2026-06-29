// lib/core/data/app_locations.dart
//
// Location model + shortcuts. Full India coverage comes from
// LocationSearchService (OpenStreetMap Nominatim live search).

class AppLocation {
  const AppLocation({
    required this.name,
    required this.district,
    required this.state,
    this.latitude,
    this.longitude,
    this.placeType,
  });

  final String name;
  final String district;
  final String state;
  final double? latitude;
  final double? longitude;

  /// Nominatim place type: city, town, village, hamlet, etc.
  final String? placeType;

  /// Major city/town/district — tap to open villages inside it.
  bool get isBrowsable {
    if (placeType == 'district') return true;
    const browsable = {'city', 'town', 'administrative', 'municipality'};
    if (placeType != null && browsable.contains(placeType!.toLowerCase())) {
      return true;
    }
    return name == district;
  }

  String get display => district.isNotEmpty && district != name
      ? '$name, $district'
      : (state.isNotEmpty ? '$name, $state' : name);

  String get full => state.isNotEmpty
      ? '$name, $district, $state'.replaceAll(', ,', ', ').replaceAll(RegExp(r',\s*$'), '')
      : display;

  String get headerLabel {
    const abbr = {
      'Maharashtra': 'MH',
      'Madhya Pradesh': 'MP',
      'Uttar Pradesh': 'UP',
      'Punjab': 'PB',
      'Haryana': 'HR',
      'Rajasthan': 'RJ',
      'Gujarat': 'GJ',
      'Karnataka': 'KA',
      'Tamil Nadu': 'TN',
      'Telangana': 'TS',
      'West Bengal': 'WB',
      'Bihar': 'BR',
      'Odisha': 'OD',
      'Kerala': 'KL',
      'Assam': 'AS',
      'Delhi': 'DL',
    };
    final s = abbr[state] ?? (state.length <= 3 ? state : state.split(' ').map((w) => w.isNotEmpty ? w[0] : '').join());
    return s.isEmpty ? name : '$name, $s';
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'district': district,
        'state': state,
        'latitude': latitude,
        'longitude': longitude,
        'placeType': placeType,
      };

  factory AppLocation.fromJson(Map<String, dynamic> json) => AppLocation(
        name: json['name'] as String? ?? '',
        district: json['district'] as String? ?? '',
        state: json['state'] as String? ?? '',
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        placeType: json['placeType'] as String?,
      );

  static ({String name, String district, String state}) parse(String raw) {
    final parts = raw
        .split(',')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.length >= 3) {
      return (
        name: parts[0],
        district: parts[1],
        state: parts.sublist(2).join(', '),
      );
    }
    if (parts.length == 2) {
      return (name: parts[0], district: parts[0], state: parts[1]);
    }
    return (
      name: parts.isEmpty ? raw : parts[0],
      district: parts.isEmpty ? raw : parts[0],
      state: '',
    );
  }

  factory AppLocation.parseString(String raw) {
    final p = parse(raw);
    return AppLocation(name: p.name, district: p.district, state: p.state);
  }
}

/// Quick-access popular cities (shortcuts only — not the full catalogue).
const kPopularLocations = <AppLocation>[
  AppLocation(
    name: 'Aurangabad',
    district: 'Chhatrapati Sambhajinagar',
    state: 'Maharashtra',
    latitude: 19.8762,
    longitude: 75.3433,
    placeType: 'city',
  ),
  AppLocation(
    name: 'Paithan',
    district: 'Chhatrapati Sambhajinagar',
    state: 'Maharashtra',
    latitude: 19.4757,
    longitude: 75.3858,
    placeType: 'village',
  ),
  AppLocation(
    name: 'Pune',
    district: 'Pune',
    state: 'Maharashtra',
    latitude: 18.5204,
    longitude: 73.8567,
    placeType: 'city',
  ),
  AppLocation(
    name: 'Mumbai',
    district: 'Mumbai',
    state: 'Maharashtra',
    latitude: 19.0760,
    longitude: 72.8777,
    placeType: 'city',
  ),
  AppLocation(
    name: 'Nagpur',
    district: 'Nagpur',
    state: 'Maharashtra',
    latitude: 21.1458,
    longitude: 79.0882,
    placeType: 'city',
  ),
  AppLocation(
    name: 'Delhi',
    district: 'Delhi',
    state: 'Delhi',
    latitude: 28.6139,
    longitude: 77.2090,
    placeType: 'city',
  ),
];

abstract final class AppLocationCatalog {
  static AppLocation? findByFull(String full) {
    final n = full.trim().toLowerCase();
    for (final l in kPopularLocations) {
      if (l.full.toLowerCase() == n || l.display.toLowerCase() == n) return l;
    }
    return AppLocation.parseString(full);
  }

  static Map<String, List<AppLocation>> groupedByState(List<AppLocation> list) {
    final map = <String, List<AppLocation>>{};
    for (final loc in list) {
      final key = loc.state.isNotEmpty ? loc.state : 'India';
      (map[key] ??= []).add(loc);
    }
    return map;
  }
}
