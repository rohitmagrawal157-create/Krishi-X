// import 'package:geolocator/geolocator.dart';
// import 'package:krishix/core/models/user_location.dart';

// abstract final class LocationService {
//   static const _cities = <({String name, String state, double lat, double lng})>[
//     (name: 'Aurangabad', state: 'Maharashtra', lat: 19.8762, lng: 75.3433),
//     (name: 'Nashik', state: 'Maharashtra', lat: 19.9975, lng: 73.7898),
//     (name: 'Pune', state: 'Maharashtra', lat: 18.5204, lng: 73.8567),
//     (name: 'Kolhapur', state: 'Maharashtra', lat: 16.7050, lng: 74.2433),
//     (name: 'Nagpur', state: 'Maharashtra', lat: 21.1458, lng: 79.0882),
//     (name: 'Indore', state: 'Madhya Pradesh', lat: 22.7196, lng: 75.8577),
//     (name: 'Meerut', state: 'Uttar Pradesh', lat: 28.9845, lng: 77.7064),
//     (name: 'Ludhiana', state: 'Punjab', lat: 30.9010, lng: 75.8573),
//   ];

//   static Future<UserLocation> fetchCurrentLocation() async {
//     final enabled = await Geolocator.isLocationServiceEnabled();
//     if (!enabled) {
//       return UserLocation.defaultLocation;
//     }

//     var permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }

//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       return UserLocation.defaultLocation;
//     }

//     try {
//       final position = await Geolocator.getCurrentPosition(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.medium,
//           timeLimit: Duration(seconds: 8),
//         ),
//       );
//       final city = _nearestCity(position.latitude, position.longitude);
//       return UserLocation(
//         displayName: '${city.name}, ${city.state}',
//         latitude: position.latitude,
//         longitude: position.longitude,
//         permissionGranted: true,
//       );
//     } catch (_) {
//       return UserLocation.defaultLocation;
//     }
//   }

//   static ({String name, String state}) _nearestCity(double lat, double lng) {
//     var best = _cities.first;
//     var bestDistance = double.infinity;

//     for (final city in _cities) {
//       final d = Geolocator.distanceBetween(lat, lng, city.lat, city.lng);
//       if (d < bestDistance) {
//         bestDistance = d;
//         best = city;
//       }
//     }
//     return (name: best.name, state: best.state);
//   }

//   static bool isNearby(String listingLocation, UserLocation user) {
//     return listingLocation.toLowerCase().contains(user.regionKey.toLowerCase()) ||
//         listingLocation.toLowerCase().contains(user.displayName.split(',').first.toLowerCase());
//   }
// }
