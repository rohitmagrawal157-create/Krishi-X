import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/models/listing.dart';

/// Common unit lists per product category.
abstract final class PostUnits {
  static const cropsGrains = [
    'Quintal',
    'Kg',
    'Ton',
    'Man',
    'Bag',
  ];

  static const fruitsVeg = [
    'Kg',
    'Quintal',
    'Dozen',
    'Crate',
    'Box',
    'Ton',
  ];

  static const seedsPlants = [
    'grams',
    'Kg',
    'Packet',
    'Quintal',
    'Piece',
  ];

  static const landArea = [
    'Acre',
    'Hectare',
    'Guntha',
  ];

  /// Tractor HP ranges — keys match [SubcategoryGroup] in tractors buy.
  static const tractorHpRanges = [
    'under_20_hp',
    'hp_21_30',
    'hp_31_40',
    'hp_41_50',
    'hp_51_60',
    'above_60_hp',
  ];

  /// Tractor brand keys — match [SubcategoryGroup] tractor_brands items.
  static const tractorBrands = [
    'mahindra',
    'swaraj',
    'sonalika',
    'john_deere',
    'massey_ferguson',
    'powertrac',
    'others',
  ];

  /// Tractor rental price basis — keys match [l10n_lookup] hourly/daily.
  static const tractorRentalPriceBasis = [
    'hourly',
    'daily',
  ];
}

class PostFormField {
  const PostFormField({
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.suffixText,
    this.formatters,
    this.unitOptions,
    this.defaultUnit,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? suffixText;
  final List<TextInputFormatter>? formatters;
  final List<String>? unitOptions;
  final String? defaultUnit;

  bool get hasUnitPicker =>
      unitOptions != null && unitOptions!.isNotEmpty;
}

class PostFormConfig {
  const PostFormConfig({
    required this.sectionId,
    required this.displayName,
    required this.titleHint,
    required this.descHint,
    required this.listingCategory,
    required this.forcedType,
    required this.accentColor,
    required this.bgColor,
    this.icon = Icons.category_rounded,  // ← now optional with default
    this.imagePath,
    this.fields = const [],
  });

  final String sectionId;
  final String displayName;
  final String titleHint;
  final String descHint;
  final ListingCategory listingCategory;
  final ListingType forcedType;
  final Color accentColor;
  final Color bgColor;
  final IconData icon;
  final String? imagePath;
  final List<PostFormField> fields;

  bool get isRent => forcedType == ListingType.rent;
}