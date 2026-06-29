// lib/core/data/listing_feed.dart

import 'package:krishix/core/data/mock_listings.dart';
import 'package:krishix/core/data/subcategories.dart';
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
    ListingPriceSort priceSort = ListingPriceSort.newest,
    ListingType? listingType,
    int? minPrice,
    int? maxPrice,
    List<String> detailKeywords = const [],
  }) {
    final query = searchQuery.trim().toLowerCase();
    final detailTerms = detailKeywords
        .map((term) => term.trim().toLowerCase().replaceAll('_', ' '))
        .where((term) => term.isNotEmpty)
        .toList();
    final pool = List<Listing>.generate(180, (i) => _fromTemplate(i));
    final locatedPool = LocationService.withDistances(pool, userLocation);

    var filtered = locatedPool.where((listing) {
      if (category != null && listing.category != category) return false;
      if (verifiedOnly && !listing.isVerified) return false;
      if (listingType != null && listing.type != listingType) return false;
      if (minPrice != null && listing.price < minPrice) return false;
      if (maxPrice != null && listing.price > maxPrice) return false;
      if (nearbyOnly && userLocation != null) {
        if (!LocationService.isNearby(listing.location, userLocation)) {
          return false;
        }
      }
      if (detailTerms.isNotEmpty) {
        final haystack =
            '${listing.title} ${listing.titleHi} ${listing.description} '
            '${listing.descriptionHi} ${listing.equipmentType ?? ''}'
                .toLowerCase();
        if (!detailTerms.any(haystack.contains)) return false;
      }
      if (query.isNotEmpty) {
        final haystack =
            '${listing.title} ${listing.titleHi} ${listing.location} ${listing.sellerName}'
                .toLowerCase();
        if (!haystack.contains(query)) return false;
      }
      return true;
    }).toList();

    if (userLocation != null && !nearbyOnly) {
      filtered = _applyLocationScope(filtered, userLocation);
    }

    if (userLocation != null &&
        priceSort == ListingPriceSort.newest &&
        !nearbyOnly) {
      filtered.sort(
        (a, b) => (a.distanceKm ?? double.infinity)
            .compareTo(b.distanceKm ?? double.infinity),
      );
    }

    switch (priceSort) {
      case ListingPriceSort.newest:
        break;
      case ListingPriceSort.lowToHigh:
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ListingPriceSort.highToLow:
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ListingPriceSort.nearest:
        filtered.sort(
          (a, b) => (a.distanceKm ?? double.infinity)
              .compareTo(b.distanceKm ?? double.infinity),
        );
        break;
    }

    final start = page * pageSize;
    if (start >= filtered.length) return const [];
    return filtered.skip(start).take(pageSize).toList();
  }

  /// Village → city → state hierarchy; if nothing matches, show all sorted by distance.
  static List<Listing> _applyLocationScope(
    List<Listing> listings,
    UserLocation user,
  ) {
    var scope = user.scope;
    while (true) {
      final matched = listings
          .where(
            (l) => LocationService.listingMatchesAtScope(
              l.location,
              user,
              scope,
            ),
          )
          .toList();
      if (matched.isNotEmpty) return matched;
      if (scope == LocationScope.state) return listings;
      scope = LocationService.broadenScope(scope);
    }
  }

  static List<Listing> nearbyPreview(UserLocation userLocation,
      {int count = 6}) {
    final pool = List<Listing>.generate(180, (i) => _fromTemplate(i));
    final locatedPool = LocationService.withDistances(pool, userLocation);

    final nearby = locatedPool
        .where((l) => LocationService.isNearby(l.location, userLocation))
        .toList()
      ..sort(
        (a, b) => (a.distanceKm ?? double.infinity)
            .compareTo(b.distanceKm ?? double.infinity),
      );

    if (nearby.length >= count) return nearby.take(count).toList();
    return locatedPool.take(count).toList();
  }

  static Listing _fromTemplate(int index) {
    final base      = _templates[index % _templates.length];
    final variant   = index ~/ _templates.length;
    final priceBump = (variant % 5) * 5000;
    final distance  = 2 + (index % 48) * 1.7;

    return Listing(
      id:            '${base.id}-$index',
      title:         variant == 0 ? base.title   : '${base.title} (#${variant + 1})',
      titleHi:       variant == 0 ? base.titleHi : '${base.titleHi} (#${variant + 1})',
      titleMr:       base.titleMr != null
                       ? (variant == 0 ? base.titleMr : '${base.titleMr} (#${variant + 1})')
                       : null,
      titleGu:       base.titleGu != null
                       ? (variant == 0 ? base.titleGu : '${base.titleGu} (#${variant + 1})')
                       : null,
      price:         base.price + priceBump,
      location:      base.location,
      category:      base.category,
      type:          base.type,
      isVerified:    index % 3 != 0,
      sellerName:    base.sellerName,
      sellerId:      base.sellerId,
      sellerPhone:   base.sellerPhone,
      sellerMemberSince: base.sellerMemberSince,
      viewCount:     (base.viewCount ?? 80) + index * 3,
      likeCount:     (base.likeCount ?? 8) + index,
      postedOn:      base.postedOn,
      imageEmoji:    base.imageEmoji,
      description:   base.description,
      descriptionHi: base.descriptionHi,
      descriptionMr: base.descriptionMr,
      descriptionGu: base.descriptionGu,
      distanceKm:    double.parse(distance.toStringAsFixed(1)),
      // Tractors
      brand:      base.brand,
      condition:  base.condition,
      year:       base.year,
      hoursUsed:  base.hoursUsed,
      horsePower: base.horsePower,
      fuelType:   base.fuelType,
      // Crops
      quantity:    base.quantity,
      unit:        base.unit,
      grade:       base.grade,
      harvestDate: base.harvestDate,
      // Livestock
      breed:           base.breed,
      age:             base.age,
      milkYieldLitres: base.milkYieldLitres,
      animalColor:     base.animalColor,
      // Land
      areaAcres:   base.areaAcres,
      soilType:    base.soilType,
      waterSource: base.waterSource,
      landDeed:    base.landDeed,
      // Rental
      equipmentType:     base.equipmentType,
      rentalDuration:    base.rentalDuration,
      deliveryAvailable: base.deliveryAvailable,
    );
  }

  static final List<Listing> _templates = [
    ...MockListings.all,
    ..._subcategoryTemplates(),
  ];

  static List<Listing> _subcategoryTemplates() {
    final listings = <Listing>[];
    var index = 0;

    for (final entry in kCategoryDetails.entries) {
      final detail   = entry.value;
      final category = detail.listingCategory;
      if (category == null) continue;

      for (final group in detail.groups) {
        for (final item in group.items) {
          final title  = _titleFromKey(item.labelKey);
          final type   = _typeForSection(entry.key, category);
          final price  = _basePriceFor(category, entry.key, index);
          final fields = _fieldsFor(category, entry.key, title, index, type, price);

          listings.add(
            Listing(
              id:            'subcategory-${entry.key}-${item.labelKey}-$index',
              title:         title,
              titleHi:       title,
              price:         price,
              location:      _locationFor(index),
              category:      category,
              type:          type,
              isVerified:    index % 4 != 0,
              sellerName:    _sellerFor(index),
              sellerId:      _sellerIdFor(index),
              sellerPhone:   _phoneFor(index),
              sellerMemberSince: DateTime(2026, (index % 6) + 1, 1),
              viewCount:     70 + (index * 11) % 190,
              likeCount:     6 + (index * 5) % 42,
              postedOn:      DateTime(2026, (index % 6) + 1, 8 + index % 18),
              imageEmoji:    detail.emoji,
              description:   fields['description'] as String,
              descriptionHi: fields['description'] as String,
              distanceKm:    double.parse((3 + (index % 40) * 1.3).toStringAsFixed(1)),
              // Tractors
              brand:      fields['brand']      as String?,
              condition:  fields['condition']  as String?,
              year:       fields['year']       as int?,
              hoursUsed:  fields['hoursUsed']  as int?,
              horsePower: fields['horsePower'] as int?,
              fuelType:   fields['fuelType']   as String?,
              // Crops
              quantity:    fields['quantity']    as double?,
              unit:        fields['unit']        as String?,
              grade:       fields['grade']       as String?,
              harvestDate: fields['harvestDate'] as String?,
              // Livestock
              breed:           fields['breed']           as String?,
              age:             fields['age']             as String?,
              milkYieldLitres: fields['milkYieldLitres'] as double?,
              animalColor:     fields['animalColor']     as String?,
              // Land
              areaAcres:   fields['areaAcres']   as double?,
              soilType:    fields['soilType']     as String?,
              waterSource: fields['waterSource']  as String?,
              landDeed:    fields['landDeed']     as String?,
              // Rental
              equipmentType:     fields['equipmentType']     as String?,
              rentalDuration:    fields['rentalDuration']    as String?,
              deliveryAvailable: fields['deliveryAvailable'] as bool?,
            ),
          );
          index++;
        }
      }
    }

    return listings;
  }

  static Map<String, dynamic> _fieldsFor(
    ListingCategory category,
    String sectionId,
    String title,
    int index,
    ListingType type,
    int price,
  ) {
    switch (category) {
      case ListingCategory.tractors:
        final brands     = ['Mahindra', 'Swaraj', 'John Deere', 'Sonalika', 'TAFE', 'Eicher'];
        final conditions = ['Used', 'Used', 'New', 'Used', 'Refurbished'];
        final hpList     = [35, 40, 45, 50, 55, 60, 65, 75];
        final yearList   = [2017, 2018, 2019, 2020, 2021, 2022];
        final brand      = brands[index % brands.length];
        final isRental   = type == ListingType.rent;
        final hp         = hpList[index % hpList.length];
        return {
          'brand':       brand,
          'condition':   isRental ? 'Good' : conditions[index % conditions.length],
          'year':        yearList[index % yearList.length],
          'hoursUsed':   isRental ? null : 1000 + (index % 10) * 400,
          'horsePower':  hp,
          'fuelType':    'Diesel',
          'description': isRental
              ? '$title available for rent. $brand tractor, $hp HP. Delivery negotiable.'
              : '$title by $brand. ${conditions[index % conditions.length]} condition, $hp HP diesel engine. Well maintained.',
        };

      case ListingCategory.crops:
        final units    = ['Quintal', 'Quintal', 'kg', 'Ton', 'Quintal'];
        final grades   = ['Grade A', 'Grade B', 'Grade A', 'Premium', 'Standard'];
        final harvests = ['This week', 'Last week', 'June 2026', 'July 2026', 'Fresh harvest'];
        final qtys     = [10.0, 20.0, 50.0, 100.0, 5.0, 200.0];
        final unit     = units[index % units.length];
        final qty      = qtys[index % qtys.length];
        final grade    = grades[index % grades.length];
        final harvest  = harvests[index % harvests.length];
        return {
          'quantity':    qty,
          'unit':        unit,
          'grade':       grade,
          'harvestDate': harvest,
          'description': '$title — $grade quality, ${qty.toInt()} $unit available. '
              'Harvested $harvest. Ready for immediate pickup or delivery.',
        };

      case ListingCategory.livestock:
        final breeds     = ['Murrah', 'HF Cross', 'Gir', 'Sahiwal', 'Jersey Cross', 'Deoni'];
        final ages       = ['1.5 years', '2 years', '3 years', '4 years', '5 years'];
        final colors     = ['Black', 'Brown', 'White', 'Black & White', 'Grey'];
        final milkYields = [8.0, 10.0, 12.0, 15.0, 6.0, 18.0];
        final breed      = breeds[index % breeds.length];
        final age        = ages[index % ages.length];
        final milk       = milkYields[index % milkYields.length];
        final color      = colors[index % colors.length];
        return {
          'breed':           breed,
          'age':             age,
          'milkYieldLitres': milk,
          'animalColor':     color,
          'description':     '$title ($breed), $age old, ${milk.toInt()}L daily milk yield. '
              'Vaccinated and healthy. $color coloured.',
        };

      case ListingCategory.land:
        final soils   = ['Black Soil', 'Red Soil', 'Alluvial', 'Sandy Loam', 'Clay'];
        final waters  = ['Canal', 'Borewell', 'River', 'Rainwater', 'Well'];
        final deeds   = ['Clear Title', '7/12 Available', 'Registered', 'Clear Title', 'NA Plot'];
        final areas   = [1.0, 1.5, 2.0, 2.5, 3.0, 5.0, 0.5];
        final isLease = sectionId.contains('lease') || type == ListingType.rent;
        final area    = areas[index % areas.length];
        final soil    = soils[index % soils.length];
        final water   = waters[index % waters.length];
        final deed    = deeds[index % deeds.length];
        return {
          'areaAcres':   area,
          'soilType':    soil,
          'waterSource': water,
          'landDeed':    deed,
          'description': isLease
              ? '${area.toStringAsFixed(1)} acre farm available for lease. $soil, $water irrigation. $deed.'
              : '${area.toStringAsFixed(1)} acre agricultural land for sale. $soil with $water source. $deed. Road access available.',
        };

      case ListingCategory.rental:
        final durations = ['Daily', 'Weekly', 'Monthly', 'Daily', 'Weekly'];
        final duration  = durations[index % durations.length];
        final delivery  = index % 3 != 0;
        final isTractorRental =
            sectionId == CategorySectionId.tractorRental ||
            sectionId == CategorySectionId.rentals;
        final equipment = isTractorRental ? 'Tractor' : title;
        return {
          'equipmentType':     equipment,
          'rentalDuration':    duration,
          'deliveryAvailable': delivery,
          'description':       '$equipment available for rent on $duration basis. '
              '${delivery ? 'Delivery available within 25 km.' : 'Self pickup only.'} '
              'Contact for availability.',
        };
    }
  }

  static ListingType _typeForSection(String sectionId, ListingCategory category) {
    if (category == ListingCategory.rental ||
        sectionId == CategorySectionId.agricultureLandLease) {
      return ListingType.rent;
    }
    return ListingType.sell;
  }

  static int _basePriceFor(
    ListingCategory category,
    String sectionId,
    int index,
  ) {
    switch (category) {
      case ListingCategory.tractors:
        return sectionId.contains('rental') || sectionId.contains('rent')
            ? 1800 + (index % 6) * 450
            : 250000 + (index % 8) * 55000;
      case ListingCategory.crops:
        return 1200 + (index % 12) * 850;
      case ListingCategory.livestock:
        return 18000 + (index % 9) * 9000;
      case ListingCategory.land:
        return sectionId == CategorySectionId.agricultureLandLease
            ? 12000 + (index % 8) * 3500
            : 900000 + (index % 8) * 350000;
      case ListingCategory.rental:
        return 900 + (index % 8) * 550;
    }
  }

  static String _titleFromKey(String key) {
    return key
        .split('_')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  static String _locationFor(int index) {
    const locations = [
      'Paithan, Chhatrapati Sambhajinagar, Maharashtra',
      'Vaijapur, Chhatrapati Sambhajinagar, Maharashtra',
      'Gangapur, Chhatrapati Sambhajinagar, Maharashtra',
      'Sillod, Chhatrapati Sambhajinagar, Maharashtra',
      'Kannad, Chhatrapati Sambhajinagar, Maharashtra',
      'Phulambri, Chhatrapati Sambhajinagar, Maharashtra',
      'Aurangabad, Chhatrapati Sambhajinagar, Maharashtra',
      'Pune, Pune, Maharashtra',
      'Baramati, Pune, Maharashtra',
      'Mumbai, Mumbai, Maharashtra',
      'Nagpur, Nagpur, Maharashtra',
      'Nashik, Nashik, Maharashtra',
      'Kolhapur, Kolhapur, Maharashtra',
    ];
    return locations[index % locations.length];
  }

  static String _sellerFor(int index) {
    const sellers = [
      'Ramesh Patil',
      'Sunita Devi',
      'Vikram Singh',
      'Anil Jadhav',
      'Krishi Seva Kendra',
    ];
    return sellers[index % sellers.length];
  }

  static String _sellerIdFor(int index) {
    const ids = [
      'seller_ramesh_patil',
      'seller_sunita_devi',
      'seller_vikram_singh',
      'seller_anil_jadhav',
      'seller_krishi_seva_kendra',
    ];
    return ids[index % ids.length];
  }

  static String _phoneFor(int index) {
    const phones = [
      '+91 98765 43210',
      '+91 97654 32109',
      '+91 96543 21098',
      '+91 95432 10987',
      '+91 94321 09876',
    ];
    return phones[index % phones.length];
  }
}
