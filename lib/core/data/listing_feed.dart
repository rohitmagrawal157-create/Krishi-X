import 'package:krishix/core/data/mock_listings.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/core/models/user_location.dart';
import 'package:krishix/core/services/location_service.dart';

abstract final class ListingFeed {
  static const pageSize = 8;

  static List<Listing> fetchPage(
    int page, {
    String searchQuery = '',
    ListingCategory? category,
    bool verifiedOnly = false,
    UserLocation? userLocation,
    bool nearbyOnly = false,
  }) {
    final query = searchQuery.trim().toLowerCase();
    final pool = List<Listing>.generate(120, (i) => _fromTemplate(i));

    var filtered = pool.where((listing) {
      if (category != null && listing.category != category) return false;
      if (verifiedOnly && !listing.isVerified) return false;
      if (nearbyOnly && userLocation != null) {
        // if (!LocationService.isNearby(listing.location, userLocation)) {
        //   return false;
        // }
      }
      if (query.isNotEmpty) {
        final haystack =
            '${listing.title} ${listing.titleHi} ${listing.location} ${listing.sellerName}'
                .toLowerCase();
        if (!haystack.contains(query)) return false;
      }
      return true;
    }).toList();

    // if (userLocation != null && userLocation.permissionGranted) {
    //   filtered.sort((a, b) {
    //     final aNear = LocationService.isNearby(a.location, userLocation);
    //     final bNear = LocationService.isNearby(b.location, userLocation);
    //     if (aNear == bNear) {
    //       return (a.distanceKm ?? 99).compareTo(b.distanceKm ?? 99);
    //     }
    //     return aNear ? -1 : 1;
    //   });
    // }

    final start = page * pageSize;
    if (start >= filtered.length) return const [];

    return filtered.skip(start).take(pageSize).toList();
  }

  static List<Listing> nearbyPreview(UserLocation userLocation, {int count = 6}) {
    final nearby = fetchPage(
      0,
      userLocation: userLocation,
      nearbyOnly: true,
    );
    if (nearby.length >= count) return nearby.take(count).toList();
    final all = fetchPage(0, userLocation: userLocation);
    return all.take(count).toList();
  }

  static Listing _fromTemplate(int index) {
    final base = MockListings.all[index % MockListings.all.length];
    final variant = index ~/ MockListings.all.length;
    final priceBump = (variant % 5) * 5000;
    final distance = 2 + (index % 48) * 1.7;

    return Listing(
      id: '${base.id}-$index',
      title: variant == 0 ? base.title : '${base.title} (#${variant + 1})',
      titleHi: variant == 0 ? base.titleHi : '${base.titleHi} (#${variant + 1})',
      price: base.price + priceBump,
      location: base.location,
      category: base.category,
      type: base.type,
      isVerified: index % 3 != 0,
      sellerName: base.sellerName,
      imageEmoji: base.imageEmoji,
      description: base.description,
      descriptionHi: base.descriptionHi,
      distanceKm: double.parse(distance.toStringAsFixed(1)),
    );
  }
}
