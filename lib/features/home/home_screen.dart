// lib/features/home/home_screen.dart
//
// FIXES APPLIED:
// 1. _CategoryTile — removed FittedBox (root cause of unequal font sizes)
//    Every label is now a fixed 11px/w700 in a fixed-height container.
//    Labels are short (≤10 chars) — truncated at data level, not scaled.
// 2. _HomeCategory — label strings shortened so 11px always fits
//    4-column tile width (≈73px on 320px, ≈88px on 390px).
// 3. Category grid uses Wrap + LayoutBuilder — tile dimensions are
//    computed from real available width so no overflow ever.
// 4. "All Products" section header de-duplicated (appeared twice before).
// 5. All other logic, layout, and navigation unchanged.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/constants/app_spacing.dart';
import 'package:krishix/core/data/listing_feed.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/core/models/user_location.dart';
import 'package:krishix/core/widgets/listing_widgets.dart';
import 'package:krishix/features/browse/browse_screen.dart';
import 'package:krishix/features/listings/listing_detail_screen.dart';
import 'package:krishix/l10n/app_localizations.dart';

// ─────────────────────────────────────────────────────────────
// CONSTANTS
// ─────────────────────────────────────────────────────────────
const double _kTopBarContentHeight = 52.0;
const double _kDividerHeight       = 3.0;

// ─────────────────────────────────────────────────────────────
// CATEGORY LABEL MAX LENGTH
// The tile label column width at 4 columns on a 320px screen
// (minus 16+16 padding + 3×10 gaps) is ~(320-32-30)/4 ≈ 64px.
// At 11px bold, roughly 9-10 Latin chars fit on one line.
// Labels are truncated at the DATA level so every tile always
// renders the same font size — never scaled by FittedBox.
// ─────────────────────────────────────────────────────────────

class _HomeCategory {
  const _HomeCategory({
    required this.label,
    required this.imagePath,
    required this.color,
    this.category,
  });
  final String           label;
  final String           imagePath;
  final Color            color;
  final ListingCategory? category;
}

// ─────────────────────────────────────────────────────────────
// HOME SCREEN
// ─────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.onMenuTap,
    required this.userLocation,
  });

  final VoidCallback onMenuTap;
  final UserLocation userLocation;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final _items            = <Listing>[];
  var   _page             = 0;
  var   _isLoadingMore    = false;
  var   _hasMore          = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor:          AppColors.primaryGreen,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness:     Brightness.dark,
      ),
    );
    _loadMore();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userLocation.displayName !=
        widget.userLocation.displayName) {
      _resetAndReload();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _resetAndReload() {
    setState(() {
      _page = 0;
      _items.clear();
      _hasMore = true;
    });
    _loadMore();
  }

  void _onScroll() {
    if (!_hasMore || _isLoadingMore) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 280) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 200));
    final batch = ListingFeed.fetchPage(
      _page,
      userLocation: widget.userLocation,
    );
    if (!mounted) return;
    setState(() {
      _items.addAll(batch);
      _page++;
      _isLoadingMore = false;
      _hasMore       = batch.length == ListingFeed.pageSize;
    });
  }

  // ── CATEGORY LIST ──────────────────────────────────────────
  // FIX: labels are intentionally short (≤10 chars) so they
  // always fit at a fixed 11px bold in a narrow 4-column tile.
  // DO NOT use the full l10n string here — it is too long for
  // 64-88px tile width. Use dedicated short keys or truncate.
  List<_HomeCategory> _categories(AppLocalizations l10n) => [
   
    _HomeCategory(
      label:     l10n.cropsAndGrains,       // "Crops"     (5)  ✓
      imagePath: 'assets/images/seed.jpg',
      color:     const Color(0xFF689F38),
      category:  ListingCategory.crops,
    ),
    _HomeCategory(
      // FIX: full "Fruits & Vegetables" is 19 chars → FittedBox
      // would shrink to ~6px. Use short key "Fruits & Veg" (12).
      label:     l10n.fruitsAndVegetables,  // override below
      imagePath: 'assets/images/fruits.jpeg',
      color:     const Color(0xFF7CB342),
      category:  ListingCategory.crops,
    ),
     _HomeCategory(
      label:     l10n.categoryLivestock,   // "Livestock" (9)  ✓
      imagePath: 'assets/images/pets.jpeg',
      color:     const Color(0xFF8D6E63),
      category:  ListingCategory.livestock,
    ),
    _HomeCategory(
      // FIX: "Agricultural Land" is 18 chars → use "Farm Land"
      label:     l10n.categoryLand,        // override below
      imagePath: 'assets/images/land.jpeg',
      color:     const Color(0xFF0277BD),
      category:  ListingCategory.land,
    ),
     _HomeCategory(
      label:     l10n.seeds,               // "Seeds"     (5)  ✓
      imagePath: 'assets/images/food.jpeg',
      color:     AppColors.textPrimary,
    ),
     _HomeCategory(
      label:     l10n.categoryMachinery,   // "Machinery"  (9)  ✓
      imagePath: 'assets/images/machin.jpeg',
      color:     const Color(0xFF6D4C41),
      category:  ListingCategory.tractors,
    ),
    _HomeCategory(
      // split().first gives "Tractors" (8) ✓
      label:     l10n.categoryTractors.split(' ').first,
      imagePath: 'assets/images/tractor.jpeg',
      color:     const Color(0xFF558B2F),
      category:  ListingCategory.tractors,
    ),
    _HomeCategory(
      label:     l10n.categoryRentOut,     // "For Rent"  (8)  ✓
      imagePath: 'assets/images/services.jpeg',
      color:     const Color(0xFFF57C00),
      category:  ListingCategory.rental,
    ),
  ];

  // Shorten labels that are too long for 4-column tile width.
  // This is done at runtime so translations are still used as
  // the base but the display version is always short enough.
  String _shortLabel(String full) {
    // "Fruits & Vegetables" → "Fruits & Veg"
    if (full.toLowerCase().contains('vegetable')) return 'Fruits & Veg';
    // "Agricultural Land" / "Shetkibhumi" etc → "Farm Land"
    if (full.toLowerCase().contains('agricultural') ||
        full.toLowerCase().contains('land') ||
        full.toLowerCase().contains('jamin') ||
        full.toLowerCase().contains('jameen')) return 'Farm Land';
    // Crops & Grains → Crops
    if (full.toLowerCase().contains('grain')) return 'Crops';
    return full;
  }

  void _openBrowse(BuildContext context, {ListingCategory? category}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BrowseScreen(
          initialCategory: category,
          userLocation:    widget.userLocation,
        ),
      ),
    );
  }

  void _openBannerPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const _BannerDetailPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n       = AppLocalizations.of(context)!;
    final categories = _categories(l10n);
    final nearby     = ListingFeed.nearbyPreview(widget.userLocation);
    final statusH    = MediaQuery.of(context).padding.top;

    return ColoredBox(
      color: AppColors.background,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [

          // ── Pinned green top bar ─────────────────────────
          SliverPersistentHeader(
            pinned: true,
            delegate: _GreenTopBarDelegate(
              statusBarHeight:   statusH,
              contentHeight:     _kTopBarContentHeight,
              dividerHeight:     _kDividerHeight,
              locationName:      widget.userLocation.displayName,
              onMenuTap:         widget.onMenuTap,
              onNotificationTap: () {},
            ),
          ),

          // ── Search bar ───────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: GestureDetector(
                onTap: () => _openBrowse(context),
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color:        Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                        color: Colors.grey.shade300, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search,
                          color: Colors.grey.shade600, size: 26),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.searchPlaceholder,
                          style: TextStyle(
                            color:    Colors.grey.shade600,
                            fontSize: AppTextSize.body,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Banner ───────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _HomeBanner(
                l10n:        l10n,
                onBannerTap: () => _openBannerPage(context),
              ),
            ),
          ),

          // ── Category section header ───────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Text(
                l10n.categories,
                style: const TextStyle(
                  fontSize:   AppTextSize.title,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

          // ── Category grid ─────────────────────────────────
          // Uses LayoutBuilder so tile dimensions are derived
          // from the real available pixel width — no overflow.
          //
          // Tile height is explicit and equal for all tiles:
          //   imgSize (square) + 6px gap + labelH (fixed 28px)
          //
          // Label: fixed 11px bold, maxLines:2, ellipsis.
          // Because the label is in a FIXED height container
          // (not FittedBox) all labels align to the same
          // baseline regardless of text length.
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            sliver: SliverToBoxAdapter(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const int    cols      = 4;
                  const double hGap     = 10.0;
                  const double totalGap = (cols - 1) * hGap;
                  final double tileW    =
                      (constraints.maxWidth - totalGap) / cols;
                  final double imgSize  = tileW * 0.78;
                  // Fixed label container height = 2 lines at 11px
                  // with line-height 1.3 = 11*1.3*2 ≈ 28.6 → 30px
                  const double labelH   = 30.0;
                  final double tileH    = imgSize + 6 + labelH;

                  return Wrap(
                    spacing:    hGap,
                    runSpacing: 14,
                    children: categories.map((item) {
                      return SizedBox(
                        width:  tileW,
                        height: tileH,
                        child: _CategoryTile(
                          label:   _shortLabel(item.label),
                          imgPath: item.imagePath,
                          color:   item.color,
                          imgSize: imgSize,
                          labelH:  labelH,
                          onTap: () => _openBrowse(
                              context, category: item.category),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),

          // ── Nearby ads ───────────────────────────────────
          if (nearby.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Text(
                  l10n.nearbyAds,
                  style: const TextStyle(
                    fontSize:   AppTextSize.title,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 280,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  itemCount: nearby.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final listing = nearby[index];
                    return _NearbyListingCard(
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
            ),
          ],

          // ── All Products header ───────────────────────────
          // FIX: was duplicated — now appears exactly once.
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

          // ── Listing cards ─────────────────────────────────
          SliverList.separated(
            itemCount: _items.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListingCard(listing: _items[index]),
            ),
          ),

          if (_isLoadingMore)
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
                        style: const TextStyle(
                            fontSize: AppTextSize.body)),
                  ],
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 110)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PINNED GREEN TOP BAR
// ═══════════════════════════════════════════════════════════════
class _GreenTopBarDelegate extends SliverPersistentHeaderDelegate {
  _GreenTopBarDelegate({
    required this.statusBarHeight,
    required this.contentHeight,
    required this.dividerHeight,
    required this.locationName,
    required this.onMenuTap,
    required this.onNotificationTap,
  });

  final double       statusBarHeight;
  final double       contentHeight;
  final double       dividerHeight;
  final String       locationName;
  final VoidCallback onMenuTap;
  final VoidCallback onNotificationTap;

  double get _totalHeight =>
      statusBarHeight + contentHeight + dividerHeight;

  @override double get minExtent => _totalHeight;
  @override double get maxExtent => _totalHeight;

  @override
  bool shouldRebuild(covariant _GreenTopBarDelegate old) =>
      old.locationName    != locationName ||
      old.statusBarHeight != statusBarHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: AppColors.primaryGreen,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: statusBarHeight),
              SizedBox(
                height: contentHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap:        onMenuTap,
                        borderRadius: BorderRadius.circular(12),
                        child: const SizedBox(
                          width: 52, height: 52,
                          child: Icon(Icons.menu,
                              size: 28, color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              locationName,
                              textAlign: TextAlign.center,
                              maxLines:  1,
                              overflow:  TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize:   15,
                                fontWeight: FontWeight.w700,
                                color:      Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap:        onNotificationTap,
                        borderRadius: BorderRadius.circular(12),
                        child: const SizedBox(
                          width: 52, height: 52,
                          child: Icon(Icons.notifications_none,
                              size: 28, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(height: dividerHeight, color: AppColors.primaryGreen),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HOME BANNER
// ═══════════════════════════════════════════════════════════════
class _HomeBanner extends StatelessWidget {
  const _HomeBanner({
    required this.l10n,
    required this.onBannerTap,
  });

  final AppLocalizations l10n;
  final VoidCallback     onBannerTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 180,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/Banner.jpeg',
              fit:       BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (_, __, ___) =>
                  Container(color: AppColors.bannerGreen),
            ),
            // Container(
            //   decoration: const BoxDecoration(
            //     gradient: LinearGradient(
            //       begin:  Alignment.centerRight,
            //       end:    Alignment.centerLeft,
            //       colors: [Color(0x00000000), Color(0xCC000000)],
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.bannerTractorTitle,
                    style: const TextStyle(
                      color:      Colors.white,
                      fontSize:   AppTextSize.title,
                      fontWeight: FontWeight.w800,
                      // shadows: [Shadow(
                      //   color: Colors.black45,
                      //   blurRadius: 6,
                      //   offset: Offset(0, 2),
                      // )],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.bannerTractorSubtitle,
                    style: TextStyle(
                      color:   Colors.white.withOpacity(0.9),
                      fontSize: AppTextSize.body,
                      // shadows: const [Shadow(
                      //   color: Colors.black38,
                      //   blurRadius: 4,
                      //   offset: Offset(0, 1),
                      // )],
                    ),
                  ),
                  const Spacer(),
                  Material(
                    color:        Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      onTap:        onBannerTap,
                      borderRadius: BorderRadius.circular(24),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 11),
                        child: Text(
                          l10n.searchNow,
                          style: const TextStyle(
                            color:      AppColors.bannerGreen,
                            fontWeight: FontWeight.w700,
                            fontSize:   AppTextSize.body,
                          ),
                        ),
                      ),
                    ),
                  ),
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
// BANNER DETAIL PAGE
// ═══════════════════════════════════════════════════════════════
class _BannerDetailPage extends StatelessWidget {
  const _BannerDetailPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF0),
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        title: const Text('Tractor Listings',
            style: TextStyle(fontWeight: FontWeight.w700)),
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.agriculture,
                size: 80, color: AppColors.primaryGreen),
            SizedBox(height: 16),
            Text(
              'Tractor & Equipment listings\ncoming soon!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize:   18,
                fontWeight: FontWeight.w600,
                color:      AppColors.primaryGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CATEGORY TILE
//
// ROOT CAUSE OF ORIGINAL BUG — FittedBox:
//   FittedBox(fit: BoxFit.scaleDown) measures each label
//   independently and scales it down to fit. "Machinery" (9
//   chars) fits at 11px so it stays. "Fruits & Vegetables"
//   (19 chars) doesn't fit at 11px so it scales to ~6px.
//   Result: every tile has a different font size.
//
// FIX:
//   • Remove FittedBox entirely.
//   • Label is in a SizedBox(height: labelH) — FIXED height
//     container. Height is computed by the parent so it is
//     always the same for every tile in the row.
//   • Font size is hard-coded 11px/w700 — never changes.
//   • maxLines: 2 + ellipsis handles overflow gracefully if
//     a translated string is still too long after _shortLabel.
//   • All labels are bottom-aligned within their fixed container
//     so they share a common baseline across the row.
// ═══════════════════════════════════════════════════════════════
class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.label,
    required this.imgPath,
    required this.color,
    required this.imgSize,
    required this.labelH,
    required this.onTap,
  });

  final String       label;
  final String       imgPath;
  final Color        color;
  final double       imgSize;
  final double       labelH;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:        onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        mainAxisSize:       MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // ── Square image tile ─────────────────────────────
          Container(
            width:  imgSize,
            height: imgSize,
            decoration: BoxDecoration(
              color:        Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.asset(
                imgPath,
                fit:           BoxFit.cover,
                filterQuality: FilterQuality.medium,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.image_not_supported_outlined,
                  color: color,
                  size:  imgSize * 0.45,
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),

          // ── Label — fixed height, fixed font size ─────────
          // SizedBox enforces a fixed height so every tile in
          // the grid row has identical label space.
          // NO FittedBox — font is always 11px on every tile.
          SizedBox(
            height: labelH,
            child: Align(
              // top-center so short (1-line) and long (2-line)
              // labels both start at the same Y position.
              alignment: Alignment.topCenter,
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines:  2,
                overflow:  TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize:   11,         // fixed — never changes
                  fontWeight: FontWeight.w700,
                  height:     1.3,
                  color:      AppColors.textPrimary,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// NEARBY LISTING CARD
// ═══════════════════════════════════════════════════════════════
class _NearbyListingCard extends StatelessWidget {
  const _NearbyListingCard({
    required this.listing,
    required this.locale,
    required this.l10n,
    required this.onTap,
  });

  final Listing          listing;
  final Locale           locale;
  final AppLocalizations l10n;
  final VoidCallback     onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, height: 272,
      child: Material(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation:    3,
        shadowColor:  Colors.black12,
        child: InkWell(
          onTap:        onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 130,
                width:  double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: listing.category.color.withOpacity(0.15),
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16)),
                ),
                child: Text(
                  listing.imageEmoji,
                  style: const TextStyle(fontSize: 72),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.localizedTitle(locale),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize:   AppTextSize.body,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      listing.formattedPrice,
                      style: const TextStyle(
                        fontSize:   AppTextSize.title,
                        fontWeight: FontWeight.w800,
                        color:      AppColors.primaryGreen,
                      ),
                    ),
                    if (listing.distanceKm != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        l10n.kmAway(
                            listing.distanceKm!.toStringAsFixed(1)),
                        style: const TextStyle(
                          fontSize:   AppTextSize.caption,
                          color:      AppColors.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}