// lib/features/home/nearby.dart
//
// Light-green outer box containing header + 6 horizontally
// scrollable white cards. Scroll works properly because:
//  • The outer Container has a FIXED intrinsic height
//    (no unbounded vertical constraints passed to ListView).
//  • ListView is given an explicit height via SizedBox.
//  • clipBehavior on the Container is Clip.hardEdge so cards
//    are clipped at the rounded border — no visual bleed.
//  • The horizontal ListView itself uses Clip.none so card
//    shadows are never cut off inside the scroll view.

import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/features/browse/browse_screen.dart';
import 'package:krishix/features/listings/listing_detail_screen.dart';
import 'package:krishix/l10n/app_localizations.dart';

// ─────────────────────────────────────────────────────────────
// LAYOUT CONSTANTS
// Photo height is the only hard value. Info height is derived
// at runtime so the card Column never overflows regardless of
// device pixel rounding or font scaling.
//
// CARD WIDTH REDUCED: 150 -> 130 (smaller, tighter horizontal
// cards). Card height trimmed accordingly since the distance
// row was removed.
// ─────────────────────────────────────────────────────────────
const double _kHeaderH    = 44.0;
const double _kPhotoH     = 96.0;   // image area
const double _kCardW      = 130.0;
const double _kCardGap    = 10.0;
const double _kCardRadius = 12.0;
const double _kListVPad   = 10.0;
// Card height: photo + price row + title (2 lines)
const double _kCardH      = 170.0;
// Container: header + top-pad + card + bottom-pad
const double _kContainerH = _kHeaderH + _kListVPad + _kCardH + _kListVPad;

// ─────────────────────────────────────────────────────────────
// PRICE FORMATTING — Indian comma format, e.g. ₹4,50,000
// No "K" / "Lakh" abbreviations — full digit display.
// ─────────────────────────────────────────────────────────────
String _formatPrice(int price) {
  final str = price.toString();
  if (str.length <= 3) return '₹$str';

  final lastThree = str.substring(str.length - 3);
  final rest = str.substring(0, str.length - 3);

  final buffer = StringBuffer();
  for (var i = 0; i < rest.length; i++) {
    final posFromEnd = rest.length - i;
    buffer.write(rest[i]);
    if (posFromEnd > 1 && posFromEnd % 2 == 1) {
      buffer.write(',');
    }
  }

  return '₹$buffer,$lastThree';
}

// ─────────────────────────────────────────────────────────────
// NEARBY SECTION  — returns a SliverToBoxAdapter
// ─────────────────────────────────────────────────────────────

class NearbySection extends StatelessWidget {
  const NearbySection({
    super.key,
    required this.nearby,
    required this.l10n,
    this.userLocation,
  });

  final List<Listing>    nearby;
  final AppLocalizations l10n;
  final dynamic          userLocation;

  @override
  Widget build(BuildContext context) {
    if (nearby.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 18, 14, 0),
        child: SizedBox(
          height: _kContainerH,   // ← exact height; no intrinsic measurement
          child: Container(
            decoration: BoxDecoration(
              color:        const Color(0xFFEDF7ED),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primaryGreen.withOpacity(0.22),
                width: 1,
              ),
            ),
            // hardEdge clips cards at rounded corners
            clipBehavior: Clip.hardEdge,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                // ── Header row ─────────────────────────────────
                SizedBox(
                  height: _kHeaderH,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          l10n.nearbyAds,
                          style: const TextStyle(
                            fontSize:   15,
                            fontWeight: FontWeight.w800,
                            color:      AppColors.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => BrowseScreen(
                                userLocation: userLocation,
                              ),
                            ),
                          ),
                          child: Text(
                            'View All',
                            style: TextStyle(
                              fontSize:        13,
                              fontWeight:      FontWeight.w600,
                              color:           AppColors.primaryGreen,
                              decoration:      TextDecoration.underline,
                              decorationColor: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Horizontal scroll list ──────────────────────
                // Expanded fills remaining height = _kListVPad*2 + _kCardH
                Expanded(
                  child: ListView.separated(
                    scrollDirection:  Axis.horizontal,
                    // Clip.none → card shadows not cut off by scroll view
                    clipBehavior:     Clip.none,
                    padding: const EdgeInsets.symmetric(
                      horizontal: _kListVPad,
                      vertical:   _kListVPad,
                    ),
                    itemCount:        nearby.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: _kCardGap),
                    itemBuilder: (context, i) {
                      final listing = nearby[i];
                      return NearbyListingCard(
                        index: i,
                        listing: listing,
                        locale:  Localizations.localeOf(context),
                        l10n:    l10n,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                ListingDetailScreen(listing: listing),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// NEARBY LISTING CARD
// ─────────────────────────────────────────────────────────────

class NearbyListingCard extends StatelessWidget {
  const NearbyListingCard({
    super.key,
    required this.listing,
    required this.locale,
    required this.l10n,
    required this.onTap,
    this.index = 0,
  });

  final Listing          listing;
  final Locale           locale;
  final AppLocalizations l10n;
  final VoidCallback     onTap;
  final int              index;

  @override
  Widget build(BuildContext context) {
    final title = listing.localizedTitle(locale);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width:        _kCardW,
        height:       _kCardH,
        decoration: BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.circular(_kCardRadius),
          boxShadow: [
            BoxShadow(
              color:      Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset:     const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Photo — fixed height ───────────────────────
            SizedBox(
              width:  _kCardW,
              height: _kPhotoH,
              child:  _ListingPhoto(listing: listing, index: index),
            ),

            // ── Info — Expanded fills ALL remaining height ─
            // No hardcoded info height: Expanded absorbs any
            // sub-pixel difference from device rounding so the
            // Column never overflows.
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [

                    // ₹4,50,000 — full digits, no K/Lakh
                    Text(
                      _formatPrice(listing.price),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize:   13,
                        fontWeight: FontWeight.w800,
                        color:      Colors.green,
                        height:     1.2,
                      ),
                    ),

                    const SizedBox(height: 3),

                    // Full title — fills remaining space
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize:   11,
                          fontWeight: FontWeight.w600,
                          color:      AppColors.textPrimary.withOpacity(0.75),
                          height:     1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// LISTING PHOTO — uses real images, rotates by listing index
// ─────────────────────────────────────────────────────────────

const Map<ListingCategory, List<String>> _nearbyImages = {
  ListingCategory.livestock: [
    'assets/images/cow1.jpeg',
    'assets/images/cow2.jpeg',
  ],
  ListingCategory.land: [
    'assets/images/land1.jpeg',
    'assets/images/land2.jpeg',
  ],
  ListingCategory.tractors: [
    'assets/images/tractor1.webp',
    'assets/images/tractor2.webp',
    'assets/images/machine1.jpeg',
    'assets/images/machine2.jpeg',
    'assets/images/jcb1.jpeg',
  ],
  ListingCategory.rental: [
    'assets/images/rent2.jpeg',
    'assets/images/jcb1.jpeg',
    'assets/images/machine1.jpeg',
  ],
  ListingCategory.crops: [
    'assets/images/mango.jpeg',
    'assets/images/veg1.jpeg',
    'assets/images/veg2.jpeg',
    'assets/images/banana.jpeg',
    'assets/images/seeds1.jpeg',
    'assets/images/seeds2.jpeg',
  ],
};

const List<String> _nearbyFallback = [
  'assets/images/seeds1.jpeg',
  'assets/images/seeds2.jpeg',
  'assets/images/mango.jpeg',
  'assets/images/veg1.jpeg',
];

String _assetForCategory(ListingCategory category, [int index = 0]) {
  final pool = _nearbyImages[category] ?? _nearbyFallback;
  return pool[index % pool.length];
}

class _ListingPhoto extends StatelessWidget {
  const _ListingPhoto({required this.listing, required this.index});
  final Listing listing;
  final int     index;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _assetForCategory(listing.category, index),
      width:         _kCardW,
      height:        _kPhotoH,
      fit:           BoxFit.cover,
      filterQuality: FilterQuality.medium,
      errorBuilder: (_, __, ___) => ColoredBox(
        color: listing.category.color.withOpacity(0.12),
      ),
    );
  }
}