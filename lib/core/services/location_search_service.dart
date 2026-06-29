// lib/core/services/location_search_service.dart
//
// Live location search for all of India via OpenStreetMap Nominatim.
// Supports: free-text search, cities in state, villages in city/district.

import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:krishix/core/data/app_locations.dart';
import 'package:krishix/core/data/district_places.dart';
import 'package:krishix/core/data/india_districts.dart';

abstract final class LocationSearchService {
  static const _baseUrl = 'https://nominatim.openstreetmap.org';
  static const _userAgent = 'KrishiX/1.0 (KrishiX agriculture marketplace app)';

  static DateTime? _lastRequest;

  static Future<void> _rateLimit() async {
    if (_lastRequest != null) {
      final gap = DateTime.now().difference(_lastRequest!);
      if (gap.inMilliseconds < 1100) {
        await Future.delayed(
          Duration(milliseconds: 1100 - gap.inMilliseconds),
        );
      }
    }
    _lastRequest = DateTime.now();
  }

  /// Score how well [loc] matches typed [query] — higher = better match.
  /// Prefix matches on name rank above partial / district matches.
  static int matchScore(AppLocation loc, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return 1;

    final name = loc.name.toLowerCase();
    final district = loc.district.toLowerCase();
    final state = loc.state.toLowerCase();
    final words = name.split(RegExp(r'\s+'));
    final type = loc.placeType?.toLowerCase() ?? '';
    var score = 0;
    if (name == q) {
      score = 100;
    } else if (name.startsWith(q)) {
      score = 95;
    } else if (words.any((w) => w.startsWith(q))) {
      score = 88;
    } else if (district.startsWith(q)) {
      score = 82;
    } else if (district.split(RegExp(r'\s+')).any((w) => w.startsWith(q))) {
      score = 78;
    } else if (name.contains(q)) {
      score = 65;
    } else if (district.contains(q)) {
      score = 55;
    } else if (state.startsWith(q)) {
      score = 45;
    } else if (state.contains(q)) {
      score = 35;
    } else if ('$name $district $state'.contains(q)) {
      score = 25;
    } else {
      return 0;
    }

    // Prefer villages & cities over state rows when names match equally.
    if (type == 'village' || type == 'hamlet') score += 3;
    if (type == 'city' || type == 'town') score += 2;
    if (type == 'state') score -= 5;
    return score;
  }

  /// Instant filter — places whose name/district starts with or contains [query].
  static List<AppLocation> filterAndRank(
    List<AppLocation> list,
    String query,
  ) {
    final q = query.trim();
    if (q.isEmpty) return list;

    final scored = <({AppLocation loc, int score})>[];
    for (final loc in list) {
      final score = matchScore(loc, q);
      if (score > 0) scored.add((loc: loc, score: score));
    }

    scored.sort((a, b) {
      final byScore = b.score.compareTo(a.score);
      if (byScore != 0) return byScore;
      return a.loc.name.compareTo(b.loc.name);
    });
    return scored.map((e) => e.loc).toList();
  }

  /// Merge local + remote results, re-ranked by how well they match [query].
  static List<AppLocation> mergeAndRank(
    List<List<AppLocation>> sources,
    String query,
  ) {
    final merged = <AppLocation>[];
    for (final list in sources) {
      merged.addAll(list);
    }
    final deduped = _dedupe(merged);
    final q = query.trim();
    if (q.isEmpty) return deduped;

    deduped.sort((a, b) {
      final scoreCmp = matchScore(b, q).compareTo(matchScore(a, q));
      if (scoreCmp != 0) return scoreCmp;
      return a.name.compareTo(b.name);
    });
    return deduped;
  }

  /// Google-style autocomplete — villages, cities & towns anywhere in India.
  static Future<List<AppLocation>> search(
    String query, {
    int limit = 35,
    String? stateFilter,
    String? districtFilter,
    AppLocation? cityContext,
  }) async {
    final q = query.trim();
    if (q.length < 2) return [];

    if (cityContext != null) {
      return searchInDistrict(q, cityContext, limit: limit);
    }
    if (stateFilter != null && stateFilter.isNotEmpty) {
      return searchInState(q, stateFilter, limit: limit);
    }

    return _searchAllIndia(q, limit: limit);
  }

  /// Pan-India search — villages, cities, towns & districts.
  static Future<List<AppLocation>> _searchAllIndia(
    String q, {
    int limit = 35,
  }) async {
    await _rateLimit();
    final general = await _fetch(
      queryParameters: {
        'q': '$q, India',
        'format': 'json',
        'addressdetails': '1',
        'countrycodes': 'in',
        'limit': '${limit + 10}',
        'dedupe': '1',
      },
    );

    await _rateLimit();
    final villages = await _fetch(
      queryParameters: {
        'q': '$q, India',
        'format': 'json',
        'addressdetails': '1',
        'countrycodes': 'in',
        'limit': '$limit',
        'dedupe': '1',
      },
      keepTypes: {'village', 'hamlet', 'locality', 'suburb'},
    );

    await _rateLimit();
    final villageKeyword = await _fetch(
      queryParameters: {
        'q': '$q village, India',
        'format': 'json',
        'addressdetails': '1',
        'countrycodes': 'in',
        'limit': '20',
        'dedupe': '1',
      },
      keepTypes: {'village', 'hamlet', 'locality', 'town', 'suburb'},
    );

    await _rateLimit();
    final cities = await _fetch(
      queryParameters: {
        'q': '$q, India',
        'format': 'json',
        'addressdetails': '1',
        'countrycodes': 'in',
        'limit': '20',
        'dedupe': '1',
      },
      keepTypes: {'city', 'town', 'municipality', 'administrative'},
    );

    var results = mergeAndRank([general, villages, villageKeyword, cities], q);

    if (results.length < 6) {
      await _rateLimit();
      final extra = await _fetch(
        queryParameters: {
          'q': q,
          'format': 'json',
          'addressdetails': '1',
          'countrycodes': 'in',
          'limit': '$limit',
          'dedupe': '1',
        },
      );
      results = mergeAndRank([results, extra], q);
    }

    if (results.isNotEmpty) {
      return results.take(limit).toList();
    }

    final fallback = await _fallbackGeocode('$q, India');
    return mergeAndRank([fallback], q).take(limit).toList();
  }

  /// Search cities/towns inside a state (used while browsing + typing).
  static Future<List<AppLocation>> searchInState(
    String query,
    String state, {
    int limit = 30,
  }) async {
    final q = query.trim();
    if (q.length < 2) return [];

    await _rateLimit();
    final structured = await _fetch(
      queryParameters: {
        'city': q,
        'state': state,
        'country': 'India',
        'format': 'json',
        'addressdetails': '1',
        'limit': '${limit ~/ 2}',
        'dedupe': '1',
      },
      keepTypes: {'city', 'town', 'administrative', 'municipality'},
    );

    await _rateLimit();
    final freeText = await _fetch(
      queryParameters: {
        'q': '$q, $state, India',
        'format': 'json',
        'addressdetails': '1',
        'countrycodes': 'in',
        'limit': '$limit',
        'dedupe': '1',
      },
      keepTypes: {'city', 'town', 'village', 'hamlet', 'suburb', 'locality'},
    );

    return mergeAndRank([structured, freeText], q).take(limit).toList();
  }

  /// Search villages/towns inside a city district (used while browsing + typing).
  static Future<List<AppLocation>> searchInDistrict(
    String query,
    AppLocation city, {
    int limit = 40,
  }) async {
    final q = query.trim();
    if (q.length < 2) return [];

    final district = city.district.isNotEmpty ? city.district : city.name;
    final state = city.state;

    await _rateLimit();
    final inDistrict = await _fetch(
      queryParameters: {
        'q': '$q, $district, $state, India',
        'format': 'json',
        'addressdetails': '1',
        'countrycodes': 'in',
        'limit': '$limit',
        'dedupe': '1',
      },
      keepTypes: {'village', 'hamlet', 'town', 'suburb', 'locality', 'city'},
    );

    if (inDistrict.length >= 5) {
      return mergeAndRank([inDistrict], q)
          .where((l) => l.name.toLowerCase() != city.name.toLowerCase())
          .take(limit)
          .toList();
    }

    await _rateLimit();
    final nearby = await _fetch(
      queryParameters: {
        'q': '$q near ${city.name}, $state, India',
        'format': 'json',
        'addressdetails': '1',
        'countrycodes': 'in',
        'limit': '$limit',
        'dedupe': '1',
      },
      keepTypes: {'village', 'hamlet', 'town', 'suburb', 'locality'},
    );

    return mergeAndRank([inDistrict, nearby], q)
        .where((l) => l.name.toLowerCase() != city.name.toLowerCase())
        .take(limit)
        .toList();
  }

  /// Step 1 after picking a state — official districts (static) or cities (API).
  static Future<List<AppLocation>> districtsInState(String state) async {
    final official = IndiaDistricts.forState(state);
    if (official.isNotEmpty) return official;
    return citiesInState(state);
  }

  /// Step 2 after picking a district — talukas/villages (static + API).
  static Future<List<AppLocation>> placesInDistrict(
    AppLocation district, {
    int limit = 60,
  }) async {
    final staticPlaces = DistrictPlaces.forDistrict(district);
    if (staticPlaces.isNotEmpty) return staticPlaces;

    final apiPlaces = await villagesInCity(district, limit: limit);
    if (apiPlaces.isNotEmpty) return apiPlaces;

    return [
      AppLocation(
        name: district.name,
        district: district.name,
        state: district.state,
        placeType: 'city',
      ),
    ];
  }

  /// Step 1 after picking a state — major cities & district towns (API fallback).
  static Future<List<AppLocation>> citiesInState(String state) async {
    await _rateLimit();
    final cities = await _fetch(
      queryParameters: {
        'state': state,
        'country': 'India',
        'format': 'json',
        'addressdetails': '1',
        'featuretype': 'city',
        'limit': '50',
        'dedupe': '1',
      },
    );

    await _rateLimit();
    final towns = await _fetch(
      queryParameters: {
        'state': state,
        'country': 'India',
        'format': 'json',
        'addressdetails': '1',
        'featuretype': 'town',
        'limit': '50',
        'dedupe': '1',
      },
    );

    final merged = _dedupe([...cities, ...towns]);
    if (merged.length >= 10) return merged;

    await _rateLimit();
    final textSearch = await _fetch(
      queryParameters: {
        'q': 'cities and towns in $state, India',
        'format': 'json',
        'addressdetails': '1',
        'countrycodes': 'in',
        'limit': '45',
        'dedupe': '1',
      },
      keepTypes: {'city', 'town', 'municipality', 'administrative'},
    );

    return _dedupe([...merged, ...textSearch]);
  }

  /// Step 2 after picking a city — villages, towns & hamlets in that district.
  static Future<List<AppLocation>> villagesInCity(
    AppLocation city, {
    int limit = 60,
  }) async {
    final district = city.district.isNotEmpty ? city.district : city.name;
    final state = city.state;

    await _rateLimit();
    var results = await _fetch(
      queryParameters: {
        'county': district,
        'state': state,
        'country': 'India',
        'format': 'json',
        'addressdetails': '1',
        'limit': '$limit',
        'dedupe': '1',
      },
      keepTypes: {'village', 'hamlet', 'town', 'suburb', 'locality'},
    );

    if (results.length < 8) {
      await _rateLimit();
      final extra = await _fetch(
        queryParameters: {
          'q': 'villages near ${city.name}, $district, $state, India',
          'format': 'json',
          'addressdetails': '1',
          'countrycodes': 'in',
          'limit': '$limit',
          'dedupe': '1',
        },
        keepTypes: {'village', 'hamlet', 'town', 'suburb', 'locality'},
      );
      results = _dedupe([...results, ...extra]);
    }

    results = results
        .where((l) => l.name.toLowerCase() != city.name.toLowerCase())
        .toList();

    return results;
  }

  /// Reverse geocode GPS coordinates into a structured AppLocation.
  static Future<AppLocation?> fromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final marks = await placemarkFromCoordinates(latitude, longitude);
      if (marks.isEmpty) return null;
      return fromPlacemark(
        marks.first,
        latitude: latitude,
        longitude: longitude,
      );
    } catch (_) {
      return null;
    }
  }

  static AppLocation fromPlacemark(
    Placemark place, {
    double? latitude,
    double? longitude,
  }) {
    final name = _firstNonEmpty([
      place.locality,
      place.subLocality,
      place.name,
      place.subAdministrativeArea,
    ]);
    final district = _firstNonEmpty([
      place.subAdministrativeArea,
      place.locality,
      place.administrativeArea,
    ]);
    final state = _firstNonEmpty([place.administrativeArea, place.country]);

    return AppLocation(
      name: name.isNotEmpty ? name : 'Current Location',
      district: district.isNotEmpty ? district : name,
      state: state,
      latitude: latitude,
      longitude: longitude,
      placeType: 'city',
    );
  }

  static Future<List<AppLocation>> _fetch({
    required Map<String, String> queryParameters,
    Set<String>? keepTypes,
  }) async {
    final uri = Uri.parse('$_baseUrl/search').replace(
      queryParameters: queryParameters,
    );

    try {
      final response = await http.get(
        uri,
        headers: {'User-Agent': _userAgent, 'Accept-Language': 'en'},
      ).timeout(const Duration(seconds: 14));

      if (response.statusCode != 200) return [];
      final list = jsonDecode(response.body) as List<dynamic>;

      var results = list
          .map((e) => _fromNominatim(e as Map<String, dynamic>))
          .whereType<AppLocation>()
          .toList();

      if (keepTypes != null && keepTypes.isNotEmpty) {
        results = results.where((l) {
          final t = l.placeType?.toLowerCase() ?? '';
          return t.isEmpty || keepTypes.contains(t);
        }).toList();
      }

      return _dedupe(results);
    } catch (_) {
      return [];
    }
  }

  static AppLocation? _fromNominatim(Map<String, dynamic> json) {
    final address = json['address'];
    if (address is! Map<String, dynamic>) return null;

    final lat = double.tryParse('${json['lat']}');
    final lng = double.tryParse('${json['lon']}');
    final placeType = (json['type'] as String?)?.toLowerCase();

    final name = _firstNonEmpty([
      address['village'] as String?,
      address['town'] as String?,
      address['city'] as String?,
      address['suburb'] as String?,
      address['hamlet'] as String?,
      address['locality'] as String?,
      address['municipality'] as String?,
      json['name'] as String?,
      address['county'] as String?,
    ]);

    if (name.isEmpty) return null;

    final district = _firstNonEmpty([
      address['state_district'] as String?,
      address['county'] as String?,
      address['city_district'] as String?,
      address['city'] as String?,
      address['town'] as String?,
    ]);

    final state = _firstNonEmpty([address['state'] as String?]);

    return AppLocation(
      name: name,
      district: district.isNotEmpty ? district : name,
      state: state,
      latitude: lat,
      longitude: lng,
      placeType: placeType,
    );
  }

  static List<AppLocation> _dedupe(List<AppLocation> list) {
    final seen = <String>{};
    final out = <AppLocation>[];
    for (final l in list) {
      final key = '${l.name}|${l.district}|${l.state}'.toLowerCase();
      if (seen.add(key)) out.add(l);
    }
    return out;
  }

  static Future<List<AppLocation>> _fallbackGeocode(String query) async {
    try {
      final matches = await locationFromAddress(query);
      if (matches.isEmpty) return [];
      final loc = matches.first;
      final marks = await placemarkFromCoordinates(loc.latitude, loc.longitude);
      if (marks.isEmpty) {
        return [
          AppLocation(
            name: query.split(',').first.trim(),
            district: query.split(',').first.trim(),
            state: query.contains(',') ? query.split(',').last.trim() : '',
            latitude: loc.latitude,
            longitude: loc.longitude,
          ),
        ];
      }
      return [
        fromPlacemark(
          marks.first,
          latitude: loc.latitude,
          longitude: loc.longitude,
        ),
      ];
    } catch (_) {
      return [];
    }
  }

  static String _firstNonEmpty(List<String?> values) {
    for (final v in values) {
      if (v != null && v.trim().isNotEmpty) return v.trim();
    }
    return '';
  }
}
