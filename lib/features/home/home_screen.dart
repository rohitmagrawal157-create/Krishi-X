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
// GREEN TOP BAR HEIGHT — used in both bar + sliver delegate
// ─────────────────────────────────────────────────────────────
const double _kTopBarContentHeight = 52.0;  // icon row height
const double _kDividerHeight       = 3.0;   // green line below bar

class _HomeCategory {
  const _HomeCategory({
    required this.label,
    required this.icon,
    required this.color,
    this.category,
  });
  final String label;
  final IconData icon;
  final Color color;
  final ListingCategory? category;
}

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
  final _items = <Listing>[];
  var _page         = 0;
  var _isLoadingMore = false;
  var _hasMore       = true;

  @override
  void initState() {
    super.initState();
    // ── Make status-bar icons white on the green top bar ──
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryGreen,       // green behind status bar
        statusBarIconBrightness: Brightness.light,    // white icons (Android)
        statusBarBrightness: Brightness.dark,         // white icons (iOS)
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
      _hasMore = batch.length == ListingFeed.pageSize;
    });
  }

  List<_HomeCategory> _categories(AppLocalizations l10n) => [
        _HomeCategory(
          label: l10n.categoryTractors.split(' ').first,
          icon: Icons.agriculture,
          color: const Color(0xFF558B2F),
          category: ListingCategory.tractors,
        ),
        _HomeCategory(
          label: l10n.categoryMachinery,
          icon: Icons.precision_manufacturing_outlined,
          color: const Color(0xFF6D4C41),
          category: ListingCategory.tractors,
        ),
        _HomeCategory(
          label: l10n.categoryCrops.split(' ').first,
          icon: Icons.grass,
          color: const Color(0xFF689F38),
          category: ListingCategory.crops,
        ),
        _HomeCategory(
          label: l10n.categoryLivestock,
          icon: Icons.pets,
          color: const Color(0xFF8D6E63),
          category: ListingCategory.livestock,
        ),
        _HomeCategory(
          label: l10n.categoryLand,
          icon: Icons.landscape,
          color: const Color(0xFF0277BD),
          category: ListingCategory.land,
        ),
        _HomeCategory(
          label: l10n.categoryRentOut,
          icon: Icons.handyman_outlined,
          color: const Color(0xFFF57C00),
          category: ListingCategory.rental,
        ),
        _HomeCategory(
          label: l10n.categoryFertilizer,
          icon: Icons.eco_outlined,
          color: const Color(0xFF7CB342),
          category: ListingCategory.crops,
        ),
        _HomeCategory(
          label: l10n.categoryOther,
          icon: Icons.add,
          color: AppColors.textPrimary,
        ),
      ];

  void _openBrowse(BuildContext context, {ListingCategory? category}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BrowseScreen(
          initialCategory: category,
          userLocation: widget.userLocation,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n       = AppLocalizations.of(context)!;
    final categories = _categories(l10n);
    final nearby     = ListingFeed.nearbyPreview(widget.userLocation);

    // ── mediaQuery values ──────────────────────────────────
    final mq         = MediaQuery.of(context);
    final statusH    = mq.padding.top;   // device-specific status bar height

    return ColoredBox(
      color: AppColors.background,
      child: CustomScrollView(
        controller: _scrollController,
        // Push content BELOW status bar ourselves — we own the top area
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [

          // ══════════════════════════════════════════════════
          // PINNED GREEN TOP BAR
          // Stays visible while scrolling, always above content
          // ══════════════════════════════════════════════════
          SliverPersistentHeader(
            pinned: true,
            delegate: _GreenTopBarDelegate(
              statusBarHeight: statusH,
              contentHeight: _kTopBarContentHeight,
              dividerHeight: _kDividerHeight,
              locationName: widget.userLocation.displayName,
              onMenuTap: widget.onMenuTap,
              onNotificationTap: () {
                // TODO: open notifications
              },
            ),
          ),

          // ── Search bar ────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: GestureDetector(
                onTap: () => _openBrowse(context),
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    border:
                        Border.all(color: Colors.grey.shade300, width: 1.5),
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
                            color: Colors.grey.shade600,
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

          // ── Banner ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _HomeBanner(
                l10n: l10n,
                onSearchNow: () =>
                    _openBrowse(context, category: ListingCategory.tractors),
              ),
            ),
          ),

          // ── Category grid ─────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            sliver: SliverGrid(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 10,
                childAspectRatio: 0.72,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = categories[index];
                  return _CategoryTile(
                    item: item,
                    onTap: () =>
                        _openBrowse(context, category: item.category),
                  );
                },
                childCount: categories.length,
              ),
            ),
          ),

          // ── Nearby ads ────────────────────────────────────
          if (nearby.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Text(
                  l10n.nearbyAds,
                  style: const TextStyle(
                    fontSize: AppTextSize.title,
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
                      locale: Localizations.localeOf(context),
                      l10n: l10n,
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

          // ── All Products ──────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Text(
                l10n.allProducts,
                style: const TextStyle(
                  fontSize: AppTextSize.title,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

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
                      width: 22,
                      height: 22,
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
// PINNED GREEN TOP BAR — SliverPersistentHeaderDelegate
// This is the KEY FIX:
//   • Extends behind the status bar using statusBarHeight
//   • Stays pinned while scrolling
//   • Green line at the bottom separates it from white content
//   • Works on all Android notch / island / punch-hole sizes
//   • Works on all iPhone notch / Dynamic Island sizes
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

  final double statusBarHeight;
  final double contentHeight;
  final double dividerHeight;
  final String locationName;
  final VoidCallback onMenuTap;
  final VoidCallback onNotificationTap;

  // Total height = status bar + icon row + divider line
  double get _totalHeight =>
      statusBarHeight + contentHeight + dividerHeight;

  @override
  double get minExtent => _totalHeight;

  @override
  double get maxExtent => _totalHeight;

  @override
  bool shouldRebuild(covariant _GreenTopBarDelegate old) =>
      old.locationName != locationName ||
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
        // ── Green area: status bar + icon row ──────────────
        Container(
          color: AppColors.primaryGreen,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Status bar spacer — exact device height
              SizedBox(height: statusBarHeight),

              // Icon row
              SizedBox(
                height: contentHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ── Menu / hamburger ───────────────────
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onMenuTap,
                        borderRadius: BorderRadius.circular(12),
                        child: const SizedBox(
                          width: 52,
                          height: 52,
                          child: Icon(
                            Icons.menu,
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    // ── Location (centred, flexible) ────────
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              locationName,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Notification bell ───────────────────
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onNotificationTap,
                        borderRadius: BorderRadius.circular(12),
                        child: const SizedBox(
                          width: 52,
                          height: 52,
                          child: Icon(
                            Icons.notifications_none,
                            size: 28,
                            color: Colors.white,
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

        // ── 3px green separator line below the bar ─────────
        Container(
          height: dividerHeight,
          color: AppColors.primaryGreen,  // same green — acts as visual base
        ),
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
    required this.onSearchNow,
  });
  final AppLocalizations l10n;
  final VoidCallback onSearchNow;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.bannerGreen, Color(0xFF34C759)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.bannerTractorTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: AppTextSize.title,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.bannerTractorSubtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: AppTextSize.body,
                  ),
                ),
                const Spacer(),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  child: InkWell(
                    onTap: onSearchNow,
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 11),
                      child: Text(
                        l10n.searchNow,
                        style: const TextStyle(
                          color: AppColors.bannerGreen,
                          fontWeight: FontWeight.w700,
                          fontSize: AppTextSize.body,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Tractor emoji — bottom right
          const Positioned(
            right: 4,
            bottom: 2,
            child: Text('🚜', style: TextStyle(fontSize: 100)),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CATEGORY TILE
// ═══════════════════════════════════════════════════════════════
class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.item, required this.onTap});
  final _HomeCategory item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Icon(item.icon, color: item.color, size: 34),
          ),
          const SizedBox(height: 8),
          Text(
            item.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: AppTextSize.caption,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// NEARBY LISTING CARD  (unchanged logic, minor layout fix)
// ═══════════════════════════════════════════════════════════════
class _NearbyListingCard extends StatelessWidget {
  const _NearbyListingCard({
    required this.listing,
    required this.locale,
    required this.l10n,
    required this.onTap,
  });

  final Listing listing;
  final Locale locale;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 272,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 3,
        shadowColor: Colors.black12,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 130,
                width: double.infinity,
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
                        fontSize: AppTextSize.body,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      listing.formattedPrice,
                      style: const TextStyle(
                        fontSize: AppTextSize.title,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    if (listing.distanceKm != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        l10n.kmAway(
                            listing.distanceKm!.toStringAsFixed(1)),
                        style: const TextStyle(
                          fontSize: AppTextSize.caption,
                          color: AppColors.primaryGreen,
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