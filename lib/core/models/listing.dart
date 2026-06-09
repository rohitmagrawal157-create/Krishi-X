import 'package:flutter/material.dart';

enum ListingCategory {
  tractors,
  crops,
  livestock,
  land,
  rental,
}

extension ListingCategoryX on ListingCategory {
  IconData get icon {
    switch (this) {
      case ListingCategory.tractors:
        return Icons.agriculture;
      case ListingCategory.crops:
        return Icons.grass;
      case ListingCategory.livestock:
        return Icons.pets;
      case ListingCategory.land:
        return Icons.landscape;
      case ListingCategory.rental:
        return Icons.handyman;
    }
  }

  Color get color {
    switch (this) {
      case ListingCategory.tractors:
        return const Color(0xFF558B2F);
      case ListingCategory.crops:
        return const Color(0xFF689F38);
      case ListingCategory.livestock:
        return const Color(0xFF6D4C41);
      case ListingCategory.land:
        return const Color(0xFF0277BD);
      case ListingCategory.rental:
        return const Color(0xFFF57C00);
    }
  }
}

enum ListingType { sell, rent }

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
    this.description,
    this.descriptionHi,
    this.distanceKm,
  });

  final String id;
  final String title;
  final String titleHi;
  final int price;
  final String location;
  final ListingCategory category;
  final ListingType type;
  final bool isVerified;
  final String sellerName;
  final String imageEmoji;
  final String? description;
  final String? descriptionHi;
  final double? distanceKm;

  String localizedTitle(Locale locale) {
    return locale.languageCode == 'hi' ? titleHi : title;
  }

  String localizedDescription(Locale locale) {
    if (locale.languageCode == 'hi') {
      return descriptionHi ?? description ?? '';
    }
    return description ?? descriptionHi ?? '';
  }

  String get formattedPrice {
    if (price >= 100000) {
      final lakhs = price / 100000;
      return '₹${lakhs.toStringAsFixed(lakhs.truncateToDouble() == lakhs ? 0 : 1)} Lakh';
    }
    if (price >= 1000) {
      return '₹${(price / 1000).toStringAsFixed(0)}K';
    }
    return '₹$price';
  }
}
