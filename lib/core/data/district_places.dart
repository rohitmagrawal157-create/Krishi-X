// lib/core/data/district_places.dart
//
// Talukas, towns & villages per district — instant offline browse.
// Districts without a static list still load from the live map API.

import 'package:krishix/core/data/app_locations.dart';

abstract final class DistrictPlaces {
  static List<AppLocation> forDistrict(AppLocation district) {
    final key = _key(district.state, district.name);
    final names = _places[key];
    if (names == null || names.isEmpty) return [];

    return names
        .map(
          (name) => AppLocation(
            name: name,
            district: district.name,
            state: district.state,
            placeType: _placeType(name, district.name),
          ),
        )
        .toList();
  }

  static bool hasStaticPlaces(String state, String district) =>
      (_places[_key(state, district)]?.length ?? 0) > 0;

  static String _key(String state, String district) =>
      '${state.trim().toLowerCase()}|${district.trim().toLowerCase()}';

  static String _placeType(String name, String district) {
    if (name.toLowerCase() == district.toLowerCase()) return 'city';
    return 'village';
  }

  static const _places = <String, List<String>>{
    'maharashtra|chhatrapati sambhajinagar': [
      'Aurangabad',
      'Gangapur',
      'Kannad',
      'Khuldabad',
      'Paithan',
      'Phulambri',
      'Sillod',
      'Soegaon',
      'Vaijapur',
    ],
    'maharashtra|pune': [
      'Pune',
      'Baramati',
      'Bhor',
      'Daund',
      'Haveli',
      'Indapur',
      'Junnar',
      'Khed',
      'Maval',
      'Mulshi',
      'Purandar',
      'Shirur',
      'Velhe',
    ],
    'maharashtra|nashik': [
      'Nashik',
      'Baglan',
      'Chandwad',
      'Deola',
      'Dindori',
      'Igatpuri',
      'Kalwan',
      'Malegaon',
      'Nandgaon',
      'Niphad',
      'Peint',
      'Sinnar',
      'Surgana',
      'Trimbakeshwar',
      'Yeola',
    ],
    'maharashtra|nagpur': [
      'Nagpur',
      'Hingna',
      'Kamptee',
      'Katol',
      'Kuhi',
      'Mouda',
      'Narkhed',
      'Parseoni',
      'Ramtek',
      'Saoner',
      'Umred',
    ],
    'maharashtra|kolhapur': [
      'Kolhapur',
      'Ajra',
      'Bhudargad',
      'Chandgad',
      'Gadhinglaj',
      'Hatkanangle',
      'Kagal',
      'Karvir',
      'Panhala',
      'Radhanagari',
      'Shahuwadi',
      'Shirol',
    ],
    'maharashtra|mumbai city': [
      'Colaba',
      'Fort',
      'Byculla',
      'Dadar',
      'Worli',
      'Mumbai City',
    ],
    'maharashtra|mumbai suburban': [
      'Andheri',
      'Borivali',
      'Kurla',
      'Mulund',
      'Thane West',
      'Mumbai Suburban',
    ],
    'maharashtra|thane': [
      'Thane',
      'Ambarnath',
      'Bhiwandi',
      'Kalyan',
      'Murbad',
      'Palghar',
      'Shahapur',
      'Ulhasnagar',
      'Vasai',
    ],
    'maharashtra|ahilyanagar': [
      'Ahilyanagar',
      'Akole',
      'Jamkhed',
      'Karjat',
      'Kopargaon',
      'Nevasa',
      'Parner',
      'Pathardi',
      'Rahata',
      'Rahuri',
      'Sangamner',
      'Shevgaon',
      'Shrigonda',
      'Shrirampur',
    ],
  };
}
