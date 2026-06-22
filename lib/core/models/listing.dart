// lib/core/models/listing.dart

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
// ENUMS
// ─────────────────────────────────────────────────────────────
enum ListingCategory { tractors, crops, livestock, land, rental }

extension ListingCategoryX on ListingCategory {
  IconData get icon {
    switch (this) {
      case ListingCategory.tractors:  return Icons.agriculture;
      case ListingCategory.crops:     return Icons.grass;
      case ListingCategory.livestock: return Icons.pets;
      case ListingCategory.land:      return Icons.landscape;
      case ListingCategory.rental:    return Icons.handyman;
    }
  }

  Color get color {
    switch (this) {
      case ListingCategory.tractors:  return const Color(0xFF558B2F);
      case ListingCategory.crops:     return const Color(0xFF689F38);
      case ListingCategory.livestock: return const Color(0xFF6D4C41);
      case ListingCategory.land:      return const Color(0xFF0277BD);
      case ListingCategory.rental:    return const Color(0xFFF57C00);
    }
  }
}

enum ListingType     { sell, rent }
enum ListingPriceSort { newest, lowToHigh, highToLow, nearest }

// ─────────────────────────────────────────────────────────────
// LISTING MODEL
// ─────────────────────────────────────────────────────────────
@immutable
class Listing {
  const Listing({
    required this.id,
    required this.title,
    required this.titleHi,
    required this.price,
    required this.location,
    required this.category,
    required this.type,
    required this.isVerified,
    required this.sellerName,
    required this.imageEmoji,
    required this.description,
    required this.descriptionHi,
    this.titleMr,
    this.titleGu,
    this.descriptionMr,
    this.descriptionGu,
    this.distanceKm,
    // ── Seller identity ───────────────────────────────────
    this.sellerId,
    this.sellerPhone,
    this.sellerMemberSince,
    this.viewCount,
    this.likeCount,
    this.postedOn,
    // ── Tractor-specific ─────────────────────────────────
    this.brand,
    this.condition,
    this.year,
    this.hoursUsed,
    this.horsePower,
    this.fuelType,
    // ── Crops-specific ───────────────────────────────────
    this.quantity,
    this.grade,
    this.harvestDate,
    this.unit,
    // ── Livestock-specific ───────────────────────────────
    this.breed,
    this.age,
    this.milkYieldLitres,
    this.animalColor,
    // ── Land-specific ────────────────────────────────────
    this.areaAcres,
    this.soilType,
    this.waterSource,
    this.landDeed,
    // ── Rental-specific ──────────────────────────────────
    this.rentalDuration,
    this.equipmentType,
    this.deliveryAvailable,
  });

  // ── Core ─────────────────────────────────────────────────
  final String          id;
  final String          title;
  final String          titleHi;
  final String?         titleMr;
  final String?         titleGu;
  final int             price;
  final String          location;
  final ListingCategory category;
  final ListingType     type;
  final bool            isVerified;
  final String          sellerName;
  final String          imageEmoji;
  final String          description;
  final String          descriptionHi;
  final String?         descriptionMr;
  final String?         descriptionGu;
  final double?         distanceKm;

  // ── Seller identity ───────────────────────────────────────
  final String?   sellerId;
  final String?   sellerPhone;
  final DateTime? sellerMemberSince;
  final int?      viewCount;
  final int?      likeCount;
  final DateTime? postedOn;

  // ── Tractors ─────────────────────────────────────────────
  final String? brand;
  final String? condition;
  final int?    year;
  final int?    hoursUsed;
  final int?    horsePower;
  final String? fuelType;

  // ── Crops ────────────────────────────────────────────────
  final double? quantity;
  final String? unit;
  final String? grade;
  final String? harvestDate;

  // ── Livestock ────────────────────────────────────────────
  final String? breed;
  final String? age;
  final double? milkYieldLitres;
  final String? animalColor;

  // ── Land ─────────────────────────────────────────────────
  final double? areaAcres;
  final String? soilType;
  final String? waterSource;
  final String? landDeed;

  // ── Rental ───────────────────────────────────────────────
  final String? rentalDuration;
  final String? equipmentType;
  final bool?   deliveryAvailable;

  // ── Computed helpers ──────────────────────────────────────
  String get formattedPrice {
    if (price >= 100000) {
      final lakhs = price / 100000;
      return '₹${lakhs.toStringAsFixed(lakhs.truncateToDouble() == lakhs ? 0 : 1)} Lakh';
    }
    if (price >= 1000) return '₹${(price / 1000).toStringAsFixed(0)}K';
    return '₹$price';
  }

  /// e.g. "Jan 2026"
  String get postedOnLabel {
    if (postedOn == null) return 'Recently';
    return _monthYear(postedOn!);
  }

  /// e.g. "Jun 2026"
  String get memberSinceLabel {
    if (sellerMemberSince != null) return _monthYear(sellerMemberSince!);
    if (postedOn != null) return _monthYear(postedOn!);
    return 'Recently';
  }

  static String _monthYear(DateTime date) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  // ── Localized helpers ─────────────────────────────────────
  String localizedTitle(Locale locale) {
    switch (locale.languageCode) {
      case 'hi': return titleHi;
      case 'mr': return titleMr ?? titleHi;
      case 'gu': return titleGu ?? titleHi;
      default:   return title;
    }
  }

  String localizedDescription(Locale locale) {
    switch (locale.languageCode) {
      case 'hi': return descriptionHi;
      case 'mr': return descriptionMr ?? descriptionHi;
      case 'gu': return descriptionGu ?? descriptionHi;
      default:   return description;
    }
  }

  // ── copyWith ──────────────────────────────────────────────
  Listing copyWith({double? distanceKm}) => Listing(
    id: id, title: title, titleHi: titleHi, titleMr: titleMr,
    titleGu: titleGu, price: price, location: location,
    category: category, type: type, isVerified: isVerified,
    sellerName: sellerName, imageEmoji: imageEmoji,
    description: description, descriptionHi: descriptionHi,
    descriptionMr: descriptionMr, descriptionGu: descriptionGu,
    distanceKm: distanceKm ?? this.distanceKm,
    sellerId: sellerId, sellerPhone: sellerPhone,
    sellerMemberSince: sellerMemberSince,
    viewCount: viewCount, likeCount: likeCount, postedOn: postedOn,
    brand: brand, condition: condition, year: year,
    hoursUsed: hoursUsed, horsePower: horsePower, fuelType: fuelType,
    quantity: quantity, unit: unit, grade: grade, harvestDate: harvestDate,
    breed: breed, age: age, milkYieldLitres: milkYieldLitres,
    animalColor: animalColor, areaAcres: areaAcres, soilType: soilType,
    waterSource: waterSource, landDeed: landDeed,
    rentalDuration: rentalDuration, equipmentType: equipmentType,
    deliveryAvailable: deliveryAvailable,
  );

  // ── Detail rows ───────────────────────────────────────────
  List<MapEntry<String, String>> detailRows() {
    final rows = <MapEntry<String, String>>[];
    switch (category) {
      case ListingCategory.tractors:
        if (brand != null)      rows.add(MapEntry('Brand', brand!));
        if (year != null)       rows.add(MapEntry('Year', '$year'));
        if (condition != null)  rows.add(MapEntry('Condition', condition!));
        if (horsePower != null) rows.add(MapEntry('Power', '$horsePower HP'));
        if (hoursUsed != null)  rows.add(MapEntry('Hours Used', '$hoursUsed hrs'));
        if (fuelType != null)   rows.add(MapEntry('Fuel Type', fuelType!));
        break;
      case ListingCategory.crops:
        if (quantity != null && unit != null) {
          final q = quantity! % 1 == 0
              ? quantity!.toInt().toString() : quantity!.toString();
          rows.add(MapEntry('Quantity', '$q $unit'));
        }
        if (grade != null)       rows.add(MapEntry('Grade', grade!));
        if (harvestDate != null) rows.add(MapEntry('Harvest', harvestDate!));
        break;
      case ListingCategory.livestock:
        if (breed != null)           rows.add(MapEntry('Breed', breed!));
        if (age != null)             rows.add(MapEntry('Age', age!));
        if (milkYieldLitres != null) rows.add(MapEntry('Milk Yield', '${milkYieldLitres!.toStringAsFixed(0)} L/day'));
        if (animalColor != null)     rows.add(MapEntry('Color', animalColor!));
        break;
      case ListingCategory.land:
        if (areaAcres != null) {
          final a = areaAcres! % 1 == 0
              ? areaAcres!.toInt().toString() : areaAcres!.toString();
          rows.add(MapEntry('Area', '$a Acres'));
        }
        if (soilType != null)    rows.add(MapEntry('Soil Type', soilType!));
        if (waterSource != null) rows.add(MapEntry('Water Source', waterSource!));
        if (landDeed != null)    rows.add(MapEntry('Legal / Deed', landDeed!));
        break;
      case ListingCategory.rental:
        if (equipmentType != null)     rows.add(MapEntry('Equipment', equipmentType!));
        if (rentalDuration != null)    rows.add(MapEntry('Rental Type', rentalDuration!));
        if (deliveryAvailable != null) rows.add(MapEntry('Delivery', deliveryAvailable! ? 'Available' : 'Self pickup'));
        break;
    }
    // rows.add(MapEntry('Location', location));
    return rows;
  }
}
