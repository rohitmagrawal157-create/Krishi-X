// lib/core/data/india_districts.dart
//
// Official districts per state — used for State → District browse.
// Villages/talukas come from district_places.dart + live API fallback.

import 'package:krishix/core/data/app_locations.dart';

abstract final class IndiaDistricts {
  static List<AppLocation> forState(String state) {
    final names = _byState[state.trim()];
    if (names == null || names.isEmpty) return [];
    return names
        .map(
          (d) => AppLocation(
            name: d,
            district: d,
            state: state,
            placeType: 'district',
          ),
        )
        .toList();
  }

  static bool hasDistricts(String state) =>
      (_byState[state.trim()]?.length ?? 0) > 0;

  static int countFor(String state) => _byState[state.trim()]?.length ?? 0;

  /// All districts flattened — for instant search matching.
  static List<AppLocation> allDistricts() {
    final out = <AppLocation>[];
    for (final entry in _byState.entries) {
      out.addAll(forState(entry.key));
    }
    return out;
  }

  static const _byState = <String, List<String>>{
    'Maharashtra': [
      'Ahilyanagar',
      'Akola',
      'Amravati',
      'Beed',
      'Bhandara',
      'Buldhana',
      'Chandrapur',
      'Chhatrapati Sambhajinagar',
      'Dharashiv',
      'Dhule',
      'Gadchiroli',
      'Gondia',
      'Hingoli',
      'Jalgaon',
      'Jalna',
      'Kolhapur',
      'Latur',
      'Mumbai City',
      'Mumbai Suburban',
      'Nagpur',
      'Nanded',
      'Nandurbar',
      'Nashik',
      'Palghar',
      'Parbhani',
      'Pune',
      'Raigad',
      'Ratnagiri',
      'Sangli',
      'Satara',
      'Sindhudurg',
      'Solapur',
      'Thane',
      'Wardha',
      'Washim',
      'Yavatmal',
    ],
  };
}
