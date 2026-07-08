// lib/features/home/all_products.dart
import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/constants/app_spacing.dart';
import 'package:krishix/core/constants/category_images.dart';
import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/core/models/user_location.dart';
import 'package:krishix/features/listings/listing_detail_screen.dart';
import 'package:krishix/l10n/app_localizations.dart';
import 'package:krishix/l10n/l10n_lookup.dart';

const Color _kOrange = Color(0xFFFF6B00);

/// One home all-products card with a fixed product photo.
class ShowcaseProductCard {
  const ShowcaseProductCard({
    required this.listing,
    required this.imagePath,
    required this.imageIndex,
  });

  final Listing listing;
  final String  imagePath;
  final int     imageIndex;
}

/// Builds the full product catalog and serves paginated slices (infinite loop).
abstract final class AllProductsCatalog {
  static const pageSize = 8;

  static List<ShowcaseProductCard>? _cache;
  static String? _cacheLocale;

  static List<ShowcaseProductCard> fetchPage(int page, AppLocalizations l10n) {
    final catalog = _catalog(l10n);
    if (catalog.isEmpty) return const [];

    final start = (page * pageSize) % catalog.length;
    final batch = <ShowcaseProductCard>[];

    for (var i = 0; i < pageSize; i++) {
      batch.add(catalog[(start + i) % catalog.length]);
    }
    return batch;
  }

  static List<ShowcaseProductCard> _catalog(AppLocalizations l10n) {
    if (_cache != null && _cacheLocale == l10n.localeName) return _cache!;

    const locations = [
      'Paithan, Chhatrapati Sambhajinagar, Maharashtra',
      'Vaijapur, Chhatrapati Sambhajinagar, Maharashtra',
      'Gangapur, Chhatrapati Sambhajinagar, Maharashtra',
      'Sillod, Chhatrapati Sambhajinagar, Maharashtra',
      'Kannad, Chhatrapati Sambhajinagar, Maharashtra',
      'Phulambri, Chhatrapati Sambhajinagar, Maharashtra',
      'Aurangabad, Chhatrapati Sambhajinagar, Maharashtra',
      'Pune, Pune, Maharashtra',
    ];
    const sellers = [
      'Ramesh Patil',
      'Sunita Devi',
      'Vikram Singh',
      'Anil Jadhav',
      'Krishi Seva Kendra',
      'Harpreet Kaur',
    ];

    final cards    = <ShowcaseProductCard>[];
    final seenKeys = <String>{};
    var idx = 0;

    for (final entry in kCategoryDetails.entries) {
      final sectionId = entry.key;
      final detail    = entry.value;
      final category  = detail.listingCategory;
      if (category == null) continue;

      final listingType = _listingTypeFor(sectionId, category);

      for (final group in detail.groups) {
        for (final item in group.items) {
          if (item.labelKey == 'others') continue;
          if (!seenKeys.add(item.labelKey)) continue;

          final images = CategoryImages.listingImagesForKey(item.labelKey);
          if (images.isEmpty) continue;

          final title = l10nLookup(l10n, item.labelKey);
          final price = _priceFor(category, sectionId, idx);

          for (var slot = 0; slot < images.length; slot++) {
            cards.add(
              ShowcaseProductCard(
                listing: _listingFor(
                  key:       item.labelKey,
                  title:     title,
                  category:  category,
                  type:      listingType,
                  price:     price + slot * 750,
                  idx:       idx,
                  slot:      slot,
                  locations: locations,
                  sellers:   sellers,
                  emoji:     detail.emoji,
                ),
                imagePath:  images[slot],
                imageIndex: slot,
              ),
            );
            idx++;
          }
        }
      }
    }

    _cache       = cards;
    _cacheLocale = l10n.localeName;
    return cards;
  }

  static ListingType _listingTypeFor(String sectionId, ListingCategory category) {
    if (sectionId == CategorySectionId.agricultureLandLease ||
        sectionId == CategorySectionId.tractorRental ||
        sectionId == CategorySectionId.farmMachineryRent ||
        sectionId == CategorySectionId.jcbRental) {
      return ListingType.rent;
    }
    if (category == ListingCategory.rental) return ListingType.rent;
    return ListingType.sell;
  }

  static int _priceFor(ListingCategory category, String sectionId, int idx) {
    switch (category) {
      case ListingCategory.tractors:
        return sectionId.contains('rent')
            ? 1800 + (idx % 6) * 450
            : 250000 + (idx % 8) * 55000;
      case ListingCategory.crops:
        return 1200 + (idx % 12) * 850;
      case ListingCategory.livestock:
        return 18000 + (idx % 9) * 9000;
      case ListingCategory.land:
        return sectionId.contains('lease')
            ? 12000 + (idx % 8) * 3500
            : 900000 + (idx % 8) * 350000;
      case ListingCategory.rental:
        return 900 + (idx % 8) * 550;
    }
  }

  static Listing _listingFor({
    required String key,
    required String title,
    required ListingCategory category,
    required ListingType type,
    required int price,
    required int idx,
    required int slot,
    required List<String> locations,
    required List<String> sellers,
    required String emoji,
  }) {
    return Listing(
      id:                'home-all-$key-$slot-$idx',
      title:             title,
      titleHi:           title,
      titleKey:          key,
      price:             price,
      location:          locations[idx % locations.length],
      category:          category,
      type:              type,
      isVerified:        idx.isEven,
      sellerName:        sellers[idx % sellers.length],
      sellerId:          'seller_all_$idx',
      sellerPhone:       '+91 98765 4321${idx % 10}',
      sellerMemberSince: DateTime(2026, (idx % 6) + 1, 1),
      viewCount:         80 + idx * 13,
      likeCount:         8 + idx * 2,
      postedOn:          DateTime(2026, (idx % 6) + 1, 5 + idx % 20),
      imageEmoji:        emoji,
      description:       '$title — quality product, ready for pickup.',
      descriptionHi:     '$title — ताज़ी गुणवत्ता, उठाने के लिए तैयार।',
      distanceKm:        double.parse((2.5 + idx * 2.7).toStringAsFixed(1)),
      quantity: category == ListingCategory.crops ? 15.0 + idx * 3 : null,
      unit:     category == ListingCategory.crops ? 'Quintal' : null,
      grade:    category == ListingCategory.crops ? 'Grade A' : null,
      brand:    category == ListingCategory.tractors ? 'Mahindra' : null,
      condition: category == ListingCategory.tractors ? 'Used' : null,
      breed: category == ListingCategory.livestock ? 'Murrah' : null,
      age:   category == ListingCategory.livestock ? '3 years' : null,
      areaAcres: category == ListingCategory.land ? 1.5 + (idx % 5) : null,
      equipmentType: category == ListingCategory.rental ? title : null,
      rentalDuration: category == ListingCategory.rental ? 'Daily' : null,
    );
  }
}

String _formatPrice(num price) {
  final p = price.toInt();
  if (p <= 0) return '₹0';
  final s     = p.toString();
  if (s.length <= 3) return '₹$s';
  final last3 = s.substring(s.length - 3);
  final rest  = s.substring(0, s.length - 3);
  final buf   = StringBuffer();
  for (var i = 0; i < rest.length; i++) {
    if (i > 0 && (rest.length - i) % 2 == 0) buf.write(',');
    buf.write(rest[i]);
  }
  return '₹${buf.toString()},$last3';
}

// ═══════════════════════════════════════════════════════════════
// ALL PRODUCTS SECTION
// ═══════════════════════════════════════════════════════════════
class AllProductsSection extends StatelessWidget {
  const AllProductsSection({
    super.key,
    required this.cards,
    required this.isLoadingMore,
    required this.l10n,
    this.userLocation,
  });

  final List<ShowcaseProductCard> cards;
  final bool                      isLoadingMore;
  final AppLocalizations          l10n;
  final UserLocation?             userLocation;

  static const List<int>    _adAfterRows  = [2, 4, 7, 10, 14];
  static const List<String> _bannerAssets = [
    'assets/images/ads1.jpeg',
    'assets/images/ads2.jpeg',
    // 'assets/images/ads3.jpeg',
  ];

  List<_FeedRow> _buildFeedRows() {
    final rows      = <_FeedRow>[];
    var   adsPlaced = 0;
    var   rowCount  = 0;

    for (var i = 0; i < cards.length; i += 2) {
      final left  = cards[i];
      final right = (i + 1 < cards.length) ? cards[i + 1] : null;
      rows.add(_FeedRow.products(left, right));
      rowCount++;

      if (adsPlaced < _adAfterRows.length &&
          rowCount == _adAfterRows[adsPlaced] &&
          i + 2 < cards.length) {
        rows.add(_FeedRow.ad(
            _bannerAssets[adsPlaced % _bannerAssets.length]));
        adsPlaced++;
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final feedRows = _buildFeedRows();

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Text(
              l10n.nearbyAds,
              style: const TextStyle(
                fontSize:   AppTextSize.title,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList.separated(
            itemCount:        feedRows.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final row = feedRows[index];
              if (row.isAd) {
                return _PromoBannerCard(imagePath: row.adImagePath!);
              }
              return _ProductGridRow(
                left:         row.left!,
                right:        row.right,
                userLocation: userLocation,
              );
            },
          ),
        ),

        if (isLoadingMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 22, height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Text(l10n.loadingMore,
                      style: const TextStyle(fontSize: AppTextSize.body)),
                ],
              ),
            ),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 110)),
      ],
    );
  }
}

class _FeedRow {
  const _FeedRow.products(ShowcaseProductCard l, ShowcaseProductCard? r)
      : left        = l,
        right       = r,
        adImagePath = null,
        isAd        = false;

  const _FeedRow.ad(String path)
      : left        = null,
        right       = null,
        adImagePath = path,
        isAd        = true;

  final ShowcaseProductCard? left;
  final ShowcaseProductCard? right;
  final String?              adImagePath;
  final bool                 isAd;
}

class _ProductGridRow extends StatelessWidget {
  const _ProductGridRow({
    required this.left,
    this.right,
    this.userLocation,
  });

  final ShowcaseProductCard left;
  final ShowcaseProductCard? right;
  final UserLocation?        userLocation;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _ProductCard(card: left, userLocation: userLocation),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: right != null
              ? _ProductCard(card: right!, userLocation: userLocation)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _ProductCard extends StatefulWidget {
  const _ProductCard({required this.card, this.userLocation});
  final ShowcaseProductCard card;
  final UserLocation?       userLocation;

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _saved = false;

  void _openDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ListingDetailScreen(
          listing:      widget.card.listing,
          imageIndex:   widget.card.imageIndex,
          userLocation: widget.userLocation,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n    = AppLocalizations.of(context)!;
    final listing = widget.card.listing;

    return GestureDetector(
      onTap: () => _openDetail(context),
      child: Container(
        decoration: BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.circular(12),
          border:       Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color:      Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset:     const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize:       MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(
                    color: Colors.grey.shade100,
                    child: Image.asset(
                      widget.card.imagePath,
                      fit:           BoxFit.cover,
                      width:         double.infinity,
                      height:        double.infinity,
                      alignment:     Alignment.center,
                      filterQuality: FilterQuality.medium,
                      errorBuilder: (_, __, ___) =>
                          ColoredBox(color: Colors.grey.shade100),
                    ),
                  ),
                  Positioned(
                    top: 6, right: 6,
                    child: GestureDetector(
                      onTap: () => setState(() => _saved = !_saved),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Icon(
                          _saved
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 18,
                          color: _saved ? Colors.red : Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize:       MainAxisSize.min,
                children: [
                  Text(
                    _formatPrice(listing.price),
                    style: const TextStyle(
                      fontSize:   14,
                      fontWeight: FontWeight.w800,
                      color:      AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    listing.displayTitle(l10n),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize:   12,
                      fontWeight: FontWeight.w600,
                      color:      AppColors.textPrimary,
                      height:     1.3,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 12, color: Colors.grey.shade500),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          listing.distanceKm != null
                              ? '${listing.shortLocation}  •  '
                                '${listing.distanceKm!.toStringAsFixed(1)} km'
                              : listing.shortLocation,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color:    Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (listing.isVerified) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.verified_rounded,
                            size: 12, color: _kOrange),
                        const SizedBox(width: 3),
                        Text(
                          l10n.verifiedListingBadge,
                          style: TextStyle(
                            fontSize:   10,
                            fontWeight: FontWeight.w600,
                            color:      _kOrange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoBannerCard extends StatelessWidget {
  const _PromoBannerCard({required this.imagePath});
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        imagePath,
        width:        double.infinity,
        fit:          BoxFit.fitWidth,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      ),
    );
  }
}
