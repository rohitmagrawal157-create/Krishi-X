// lib/features/home/all_products.dart
import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/constants/app_spacing.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/core/models/user_location.dart';
import 'package:krishix/features/listings/listing_detail_screen.dart';
import 'package:krishix/l10n/app_localizations.dart';

const Color _kOrange = Color(0xFFFF6B00);

const Map<ListingCategory, List<String>> _categoryImages = {
  ListingCategory.livestock: ['assets/images/cow1.jpeg', 'assets/images/cow2.jpeg'],
  ListingCategory.land:      ['assets/images/land1.jpeg', 'assets/images/land2.jpeg'],
  ListingCategory.tractors:  ['assets/images/tractor1.webp', 'assets/images/tractor2.webp', 'assets/images/machine1.jpeg', 'assets/images/machine2.jpeg', 'assets/images/jcb1.jpeg'],
  ListingCategory.rental:    ['assets/images/rent2.jpeg', 'assets/images/jcb1.jpeg', 'assets/images/machine1.jpeg'],
  ListingCategory.crops:     ['assets/images/mango.jpeg', 'assets/images/veg1.jpeg', 'assets/images/veg2.jpeg', 'assets/images/banana.jpeg', 'assets/images/seeds1.jpeg', 'assets/images/seeds2.jpeg'],
};

const List<String> _fallback = [
  'assets/images/seeds1.jpeg',
  'assets/images/seeds2.jpeg',
  'assets/images/mango.jpeg',
  'assets/images/veg1.jpeg',
];

String _imgFor(ListingCategory cat, int idx) {
  final pool = _categoryImages[cat] ?? _fallback;
  return pool[idx % pool.length];
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
    required this.items,
    required this.isLoadingMore,
    required this.l10n,
    this.userLocation,
  });

  final List<Listing>    items;
  final bool             isLoadingMore;
  final AppLocalizations l10n;
  final UserLocation?    userLocation;

  static const List<int>    _adAfterRows  = [2, 4, 7];
  static const List<String> _bannerAssets = [
    'assets/images/ads1.jpeg',
    'assets/images/ads2.jpeg',
    'assets/images/ads2.jpeg',
  ];

  List<_FeedRow> _buildFeedRows() {
    final rows     = <_FeedRow>[];
    var   adsPlaced = 0;
    var   rowCount  = 0;

    for (var i = 0; i < items.length; i += 2) {
      final left  = items[i];
      final right = (i + 1 < items.length) ? items[i + 1] : null;
      rows.add(_FeedRow.products(left, right, i, i + 1));
      rowCount++;

      if (adsPlaced < _adAfterRows.length &&
          adsPlaced < 3 &&
          rowCount == _adAfterRows[adsPlaced] &&
          i + 2 < items.length) {
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

        // ── Section header ──────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Text(
              l10n.allProducts,
              style: const TextStyle(
                fontSize:   AppTextSize.title,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),

        // ── 2-column grid rows ───────────────────────────
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
                leftImgIdx:   row.leftImgIdx,
                rightImgIdx:  row.rightImgIdx,
                userLocation: userLocation,
              );
            },
          ),
        ),

        // ── Loading spinner ──────────────────────────────
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
                      style:
                          const TextStyle(fontSize: AppTextSize.body)),
                ],
              ),
            ),
          ),

        // ── Bottom spacer ────────────────────────────────
        const SliverToBoxAdapter(child: SizedBox(height: 110)),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// FEED ROW MODEL
// ═══════════════════════════════════════════════════════════════
class _FeedRow {
  const _FeedRow.products(Listing l, Listing? r, int li, int ri)
      : left        = l,
        right       = r,
        leftImgIdx  = li,
        rightImgIdx = ri,
        adImagePath = null,
        isAd        = false;

  const _FeedRow.ad(String path)
      : left        = null,
        right       = null,
        leftImgIdx  = 0,
        rightImgIdx = 0,
        adImagePath = path,
        isAd        = true;

  final Listing? left;
  final Listing? right;
  final int      leftImgIdx;
  final int      rightImgIdx;
  final String?  adImagePath;
  final bool     isAd;
}

// ═══════════════════════════════════════════════════════════════
// PRODUCT GRID ROW
// ═══════════════════════════════════════════════════════════════
class _ProductGridRow extends StatelessWidget {
  const _ProductGridRow({
    required this.left,
    this.right,
    required this.leftImgIdx,
    required this.rightImgIdx,
    this.userLocation,
  });

  final Listing       left;
  final Listing?      right;
  final int           leftImgIdx;
  final int           rightImgIdx;
  final UserLocation? userLocation;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _ProductCard(
            listing:      left,
            imgIdx:       leftImgIdx,
            userLocation: userLocation,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: right != null
              ? _ProductCard(
                  listing:      right!,
                  imgIdx:       rightImgIdx,
                  userLocation: userLocation,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PRODUCT CARD — tappable → opens ListingDetailScreen
// ═══════════════════════════════════════════════════════════════
class _ProductCard extends StatefulWidget {
  const _ProductCard({
    required this.listing,
    required this.imgIdx,
    this.userLocation,
  });
  final Listing       listing;
  final int           imgIdx;
  final UserLocation? userLocation;

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _saved = false;

  void _openDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ListingDetailScreen(
          listing:      widget.listing,
          userLocation: widget.userLocation,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return GestureDetector(
      onTap: () => _openDetail(context), // ← tap anywhere on card
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

            // ── Image + heart ────────────────────────────
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(
                    color: Colors.grey.shade100,
                    child: Image.asset(
                      _imgFor(widget.listing.category, widget.imgIdx),
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: double.infinity,
                      filterQuality: FilterQuality.medium,
                      errorBuilder: (_, __, ___) =>
                          ColoredBox(color: Colors.grey.shade100),
                    ),
                  ),

                  // ── Heart — stops tap propagation ───────
                  Positioned(
                    top:   6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () {
                        // stop propagation to card tap
                        setState(() => _saved = !_saved);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width:  32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color:      Colors.black
                                  .withOpacity(0.12),
                              blurRadius: 4,
                              offset:     const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Icon(
                          _saved
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size:  18,
                          color: _saved
                              ? Colors.red
                              : Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize:       MainAxisSize.min,
                children: [

                  // Price
                  Text(
                    _formatPrice(widget.listing.price),
                    style: const TextStyle(
                      fontSize:   14,
                      fontWeight: FontWeight.w800,
                      color:      AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 3),

                  // Title
                  Text(
                    widget.listing.localizedTitle(locale),
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

                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size:  12,
                          color: Colors.grey.shade500),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          widget.listing.distanceKm != null
                              ? '${widget.listing.location}  •  '
                                '${widget.listing.distanceKm!.toStringAsFixed(1)} km'
                              : widget.listing.location,
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

                  // Verified
                  if (widget.listing.isVerified) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.verified_rounded,
                            size: 12, color: _kOrange),
                        const SizedBox(width: 3),
                        Text(
                          'Verified',
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

// ═══════════════════════════════════════════════════════════════
// PROMOTIONAL BANNER CARD
// ═══════════════════════════════════════════════════════════════
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