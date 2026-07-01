// lib/features/home/nearby.dart
import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/core/models/user_location.dart';
import 'package:krishix/features/browse/browse_screen.dart';
import 'package:krishix/features/listings/listing_detail_screen.dart';
import 'package:krishix/l10n/app_localizations.dart';

// ─────────────────────────────────────────────────────────────
// IMAGE POOL
// ─────────────────────────────────────────────────────────────
const Map<ListingCategory, List<String>> _nearbyImages = {
  ListingCategory.livestock: ['assets/images/cow1.jpeg',  'assets/images/cow2.jpeg'],
  ListingCategory.land:      ['assets/images/land1.jpeg', 'assets/images/land2.jpeg'],
  ListingCategory.tractors:  ['assets/images/tractor1.webp','assets/images/tractor2.webp','assets/images/machine1.jpeg','assets/images/jcb1.jpeg'],
  ListingCategory.rental:    ['assets/images/rent2.jpeg', 'assets/images/jcb1.jpeg',   'assets/images/machine1.jpeg'],
  ListingCategory.crops:     ['assets/images/mango.jpeg', 'assets/images/veg1.jpeg',   'assets/images/veg2.jpeg','assets/images/banana.jpeg','assets/images/seeds1.jpeg'],
};

const List<String> _nearbyFallback = [
  'assets/images/seeds1.jpeg',
  'assets/images/mango.jpeg',
  'assets/images/veg1.jpeg',
];

String _assetFor(ListingCategory cat, int index) {
  final pool = _nearbyImages[cat] ?? _nearbyFallback;
  return pool[index % pool.length];
}

// ─────────────────────────────────────────────────────────────
// PRICE FORMATTER
// ─────────────────────────────────────────────────────────────
String _fmtPrice(int price) {
  final s = price.toString();
  if (s.length <= 3) return '₹$s';
  final last = s.substring(s.length - 3);
  final rest = s.substring(0, s.length - 3);
  final buf = StringBuffer();
  for (var i = 0; i < rest.length; i++) {
    if (i > 0 && (rest.length - i) % 2 == 0) buf.write(',');
    buf.write(rest[i]);
  }
  return '₹${buf.toString()},$last';
}

// ─────────────────────────────────────────────────────────────
// NEARBY SECTION — light-green rounded container,
// 2-column grid, no horizontal scroll
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
  final UserLocation?    userLocation;

  @override
  Widget build(BuildContext context) {
    if (nearby.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 18, 14, 0),
        child: Container(
          decoration: BoxDecoration(
            color:        const Color(0xFFEDF7ED),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryGreen.withOpacity(0.22),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ── Header ────────────────────────────────────
              SizedBox(
                height: 48,
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
                          builder: (_) =>
                              BrowseScreen(userLocation: userLocation),
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

              // ── 2-column grid ─────────────────────────────
              _NearbyGrid(
                listings:     nearby,
                l10n:         l10n,
                onTap: (listing) => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ListingDetailScreen(
                      listing:      listing,
                      userLocation: userLocation,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// NEARBY GRID — pairs listings into rows of 2
// ─────────────────────────────────────────────────────────────
class _NearbyGrid extends StatelessWidget {
  const _NearbyGrid({
    required this.listings,
    required this.l10n,
    required this.onTap,
  });

  final List<Listing>        listings;
  final AppLocalizations     l10n;
  final ValueChanged<Listing> onTap;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    for (var i = 0; i < listings.length; i += 2) {
      final left  = listings[i];
      final right = (i + 1 < listings.length) ? listings[i + 1] : null;

      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _NearbyCard(
                listing: left,
                imgIdx:  i,
                l10n:    l10n,
                onTap:   () => onTap(left),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: right != null
                  ? _NearbyCard(
                      listing: right,
                      imgIdx:  i + 1,
                      l10n:    l10n,
                      onTap:   () => onTap(right),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );

      if (i + 2 < listings.length) {
        rows.add(const SizedBox(height: 10));
      }
    }

    return Column(children: rows);
  }
}

// ─────────────────────────────────────────────────────────────
// NEARBY CARD — white card inside green container
// ─────────────────────────────────────────────────────────────
class _NearbyCard extends StatelessWidget {
  const _NearbyCard({
    required this.listing,
    required this.imgIdx,
    required this.l10n,
    required this.onTap,
  });

  final Listing          listing;
  final int              imgIdx;
  final AppLocalizations l10n;
  final VoidCallback     onTap;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color:      Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset:     const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [

            // ── Image ──────────────────────────────────────
            AspectRatio(
              aspectRatio: 4 / 3,
              child: ColoredBox(
                color: const Color(0xFFF3F7F0),
                child: Image.asset(
                  _assetFor(listing.category, imgIdx),
                  fit:           BoxFit.cover,
                  filterQuality: FilterQuality.medium,
                  errorBuilder: (_, __, ___) =>
                      const ColoredBox(color: Color(0xFFF3F7F0)),
                ),
              ),
            ),

            // ── Info ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 7, 8, 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  // Price
                  Text(
                    _fmtPrice(listing.price),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize:   14,
                      fontWeight: FontWeight.w900,
                      color:      AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 3),

                  // Title
                  Text(
                    listing.displayTitle(l10n),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize:   12,
                      fontWeight: FontWeight.w700,
                      color:      AppColors.textPrimary,
                      height:     1.25,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 12, color: Colors.grey.shade600),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          listing.shortLocation,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize:   10,
                            fontWeight: FontWeight.w600,
                            color:      Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Verified
                  if (listing.isVerified) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.verified_rounded,
                            size: 12, color: Color(0xFFF57C00)),
                        const SizedBox(width: 3),
                        Text(
                          l10n.verifiedSeller,
                          style: const TextStyle(
                            fontSize:   10,
                            fontWeight: FontWeight.w800,
                            color:      Color(0xFFF57C00),
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