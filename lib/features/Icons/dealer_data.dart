import 'package:flutter/material.dart';
import 'package:krishix/l10n/app_localizations.dart';

enum DealerCategory { all, fertilizer, seeds, machinery, pesticide }

class AgriDealer {
  const AgriDealer({
    required this.name,
    required this.category,
    required this.rating,
    required this.ratingCount,
    required this.location,
    required this.phone,
    required this.imagePath,
    required this.yearsInBusiness,
    required this.galleryImages,
    required this.services,
    required this.productCategories,
    this.isVerified = false,
    this.isTopRated = false,
    this.isTopSearch = false,
    this.highlight,
    this.priceHint,
    this.productsLink,
    this.servesAlso,
    this.about,
    this.openUntil = '8:00 pm',
  });

  final String name;
  final DealerCategory category;
  final double rating;
  final int ratingCount;
  final String location;
  final String phone;
  final String imagePath;
  final int yearsInBusiness;
  final List<String> galleryImages;
  final List<String> services;
  /// Product lines this dealer stocks (shown on detail screen).
  final List<DealerCategory> productCategories;
  final bool isVerified;
  final bool isTopRated;
  final bool isTopSearch;
  final String? highlight;
  final String? priceHint;
  final String? productsLink;
  final String? servesAlso;
  final String? about;
  final String openUntil;
}

/// Play Store link for share messages.
const krishiXAppLink =
    'https://play.google.com/store/apps/details?id=in.krishix.krishix';

String buildDealerShareText(AppLocalizations l10n, AgriDealer dealer) {
  final products = dealer.productCategories
      .map((c) => localizedDealerCategory(l10n, c))
      .join(', ');
  final quantity = '${dealer.productCategories.length}';
  return '${dealer.name}\n'
      '${l10n.shareProductLabel}: $products\n'
      '${l10n.shareLocationLabel}: ${dealer.location}\n'
      '${l10n.shareQuantityLabel}: $quantity\n\n'
      '${l10n.shareAppDownload}: $krishiXAppLink';
}

String localizedDealerCategory(AppLocalizations l10n, DealerCategory c) {
  switch (c) {
    case DealerCategory.all:
      return l10n.filterAll;
    case DealerCategory.fertilizer:
      return l10n.dealerCatFertilizer;
    case DealerCategory.seeds:
      return l10n.dealerCatSeeds;
    case DealerCategory.machinery:
      return l10n.dealerCatMachinery;
    case DealerCategory.pesticide:
      return l10n.dealerCatPesticides;
  }
}

/// English fallback for non-UI contexts.
String dealerCategoryLabel(DealerCategory c) {
  switch (c) {
    case DealerCategory.all:
      return 'All';
    case DealerCategory.fertilizer:
      return 'Fertilizer';
    case DealerCategory.seeds:
      return 'Seeds';
    case DealerCategory.machinery:
      return 'Machinery';
    case DealerCategory.pesticide:
      return 'Pesticides';
  }
}

IconData dealerCategoryIcon(DealerCategory c) {
  switch (c) {
    case DealerCategory.all:
      return Icons.storefront_rounded;
    case DealerCategory.fertilizer:
      return Icons.grass_rounded;
    case DealerCategory.seeds:
      return Icons.eco_rounded;
    case DealerCategory.machinery:
      return Icons.agriculture_rounded;
    case DealerCategory.pesticide:
      return Icons.science_rounded;
  }
}

/// Verified non-empty asset paths only (empty files on disk are excluded).
List<String> defaultGalleryFor(DealerCategory category) {
  switch (category) {
    case DealerCategory.fertilizer:
      return const [
        'assets/images/seeds1.jpeg',
        'assets/images/seeds2.jpeg',
        'assets/images/seed.jpeg',
        'assets/images/mango.jpeg',
      ];
    case DealerCategory.seeds:
      return const [
        'assets/images/seeds1.jpeg',
        'assets/images/seeds2.jpeg',
        'assets/images/seed.jpeg',
        'assets/images/fruits.jpeg',
      ];
    case DealerCategory.machinery:
      return const [
        'assets/images/machine1.jpeg',
        'assets/images/machine2.jpeg',
        'assets/images/tractor1.webp',
        'assets/images/jcb1.jpeg',
      ];
    case DealerCategory.pesticide:
      return const [
        'assets/images/veg1.jpeg',
        'assets/images/veg2.jpeg',
        'assets/images/pets.jpeg',
        'assets/images/mango.jpeg',
      ];
    case DealerCategory.all:
      return const [
        'assets/images/seeds1.jpeg',
        'assets/images/machine1.jpeg',
        'assets/images/veg1.jpeg',
      ];
  }
}

/// Best image for list/card hero — uses gallery first valid entry.
String dealerHeroImage(AgriDealer dealer) {
  if (dealer.galleryImages.isNotEmpty) return dealer.galleryImages.first;
  return dealer.imagePath;
}

/// Category chips shown in the filter row (excludes "All" duplicate issues).
const dealerFilterCategories = <DealerCategory>[
  DealerCategory.all,
  DealerCategory.fertilizer,
  DealerCategory.seeds,
  DealerCategory.machinery,
  DealerCategory.pesticide,
];

const allAgriDealers = <AgriDealer>[
  AgriDealer(
    name:             'Vyankatesh Krushi Seva Kendra',
    category:         DealerCategory.fertilizer,
    rating:           4.0,
    ratingCount:      75,
    location:         'Aurangabad, Maharashtra',
    phone:            '9876543210',
    imagePath:        'assets/images/seeds1.jpeg',
    yearsInBusiness:  7,
    galleryImages:    [
      'assets/images/seeds1.jpeg',
      'assets/images/seeds2.jpeg',
      'assets/images/seed.jpeg',
      'assets/images/mango.jpeg',
    ],
    productCategories: [
      DealerCategory.fertilizer,
      DealerCategory.seeds,
      DealerCategory.pesticide,
    ],
    services:         [
      'Urea & DAP supply',
      'Soil testing kits',
      'Organic fertilizers',
      'Bulk order delivery',
    ],
    isVerified:       true,
    isTopRated:       true,
    isTopSearch:      true,
    highlight:        'High call pick up rate',
    priceHint:        'Ask for Price',
    servesAlso:       'Paithan, Jalna',
    about:
        'Trusted agri input dealer serving farmers across Marathwada with quality fertilizers, seeds, and crop advisory.',
  ),
  AgriDealer(
    name:             'Navbharat Fertilizers',
    category:         DealerCategory.fertilizer,
    rating:           4.1,
    ratingCount:      89,
    location:         'Paithan, Maharashtra',
    phone:            '9123456780',
    imagePath:        'assets/images/seeds2.jpeg',
    yearsInBusiness:  5,
    galleryImages:    [
      'assets/images/seeds2.jpeg',
      'assets/images/seeds1.jpeg',
      'assets/images/seed.jpeg',
      'assets/images/fruits.jpeg',
    ],
    productCategories: [
      DealerCategory.fertilizer,
      DealerCategory.seeds,
    ],
    services:         [
      'NPK blends',
      'Micronutrients',
      'Pesticide combo packs',
      'Seasonal crop plans',
    ],
    isVerified:       true,
    isTopRated:       true,
    highlight:        'Starts From ₹ 10/Kg',
    productsLink:     'Products Available',
    servesAlso:       'Aurangabad, Beed',
    about:
        'Wholesale & retail fertilizer dealer with competitive mandi rates and same-day dispatch for nearby villages.',
  ),
  AgriDealer(
    name:             'Shree Agro Inputs & Seeds',
    category:         DealerCategory.seeds,
    rating:           4.3,
    ratingCount:      52,
    location:         'Jalna, Maharashtra',
    phone:            '9988776655',
    imagePath:        'assets/images/seeds1.jpeg',
    yearsInBusiness:  9,
    galleryImages:    [
      'assets/images/seeds1.jpeg',
      'assets/images/seeds2.jpeg',
      'assets/images/seed.jpeg',
      'assets/images/banana.jpeg',
    ],
    productCategories: [
      DealerCategory.seeds,
      DealerCategory.fertilizer,
    ],
    services:         [
      'Hybrid seed varieties',
      'Certified wheat & pulses',
      'Germination guidance',
      'Farmer loyalty program',
    ],
    isVerified:       true,
    isTopSearch:      true,
    highlight:        'Hybrid seeds in stock',
    priceHint:        'Ask for Price',
    servesAlso:       'Aurangabad, Parbhani',
    about:
        'Premium seed distributor partnering with leading agri brands. Seasonal stock for kharif and rabi crops.',
  ),
  AgriDealer(
    name:             'Maharashtra Farm Machinery Hub',
    category:         DealerCategory.machinery,
    rating:           3.9,
    ratingCount:      34,
    location:         'Beed, Maharashtra',
    phone:            '9012345678',
    imagePath:        'assets/images/machine1.jpeg',
    yearsInBusiness:  6,
    galleryImages:    [
      'assets/images/machine1.jpeg',
      'assets/images/machine2.jpeg',
      'assets/images/tractor1.webp',
      'assets/images/jcb1.jpeg',
    ],
    productCategories: [DealerCategory.machinery],
    services:         [
      'Rotavator & cultivator parts',
      'Sprayer repair & sale',
      'Tractor attachments',
      'On-site service visits',
    ],
    isVerified:       false,
    isTopRated:       true,
    highlight:        'Rotavator & sprayer parts',
    productsLink:     'Products Available',
    servesAlso:       'Osmanabad, Latur',
    about:
        'One-stop shop for farm machinery, spare parts, and seasonal equipment rentals for small & medium farmers.',
  ),
  AgriDealer(
    name:             'Green Shield Agro Chemicals',
    category:         DealerCategory.pesticide,
    rating:           4.2,
    ratingCount:      41,
    location:         'Nashik, Maharashtra',
    phone:            '9822334455',
    imagePath:        'assets/images/veg1.jpeg',
    yearsInBusiness:  8,
    galleryImages:    [
      'assets/images/veg1.jpeg',
      'assets/images/veg2.jpeg',
      'assets/images/pets.jpeg',
      'assets/images/mango.jpeg',
    ],
    productCategories: [
      DealerCategory.pesticide,
      DealerCategory.fertilizer,
    ],
    services:         [
      'Licensed pesticide sales',
      'Crop protection plans',
      'Safety training for applicators',
      'Fruit & vegetable crop care',
    ],
    isVerified:       true,
    highlight:        'Licensed pesticide dealer',
    priceHint:        'Ask for Price',
    servesAlso:       'Chhatrapati Sambhajinagar',
    about:
        'Government-licensed agro chemical dealer specializing in fruit, vegetable, and grape crop protection.',
  ),
];
