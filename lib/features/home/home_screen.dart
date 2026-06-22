// lib/features/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/constants/app_spacing.dart';
import 'package:krishix/core/data/listing_feed.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/core/models/user_location.dart';
import 'package:krishix/features/browse/browse_screen.dart';
import 'package:krishix/features/home/all_products.dart';
import 'package:krishix/features/home/nearby.dart';
import 'package:krishix/l10n/app_localizations.dart';
import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/features/category/category_detail_screen.dart';
import 'package:krishix/features/category/tractor_picker_screen.dart';
import 'package:krishix/features/wishlist/wishlist_screen.dart';

const double _kTopBarContentHeight = 52.0;
const double _kDividerHeight       = 3.0;

enum _CategoryFilter { buy, rent, services }

class _HomeCategory {
  const _HomeCategory({
    required this.label,
    required this.imagePath,
    required this.color,
    required this.sectionId,
    required this.filter,
  });
  final String          label;
  final String          imagePath;
  final Color           color;
  final String          sectionId;
  final _CategoryFilter filter;
}

String _tr(String key, String locale) {
  switch (key) {
    case 'buy':
      if (locale == 'hi') return 'खरीदें';
      if (locale == 'mr') return 'खरेदी करा';
      if (locale == 'gu') return 'ખરીદો';
      return 'Buy';
    case 'rent':
      if (locale == 'hi') return 'किराया';
      if (locale == 'mr') return 'भाड्याने घ्या';
      if (locale == 'gu') return 'ભાડે લો';
      return 'Rent';
    case 'services':
      if (locale == 'hi') return 'सेवाएं';
      if (locale == 'mr') return 'सेवा';
      if (locale == 'gu') return 'સેવાઓ';
      return 'Services';
    case 'services_coming_soon':
      if (locale == 'hi') return 'सेवाएं जल्द आ रही हैं';
      if (locale == 'mr') return 'सेवा लवकरच येत आहेत';
      if (locale == 'gu') return 'સેવાઓ ટૂંક સમયમાં આવે છે';
      return 'Services Coming Soon';
    case 'services_coming_soon_subtitle':
      if (locale == 'hi') return 'हम आपके लिए कृषि सेवाएं लाने पर काम कर रहे हैं। जुड़े रहें!';
      if (locale == 'mr') return 'आम्ही तुमच्यासाठी शेती सेवा आणण्यावर काम करत आहोत. लक्ष ठेवा!';
      if (locale == 'gu') return 'અમે તમારા માટે ખેતી સેવાઓ લાવવા પર કામ કરી રહ્યા છીએ. જોડાયેલા રહો!';
      return 'We are working hard to bring farming services to you. Stay tuned!';
    case 'lease_land':
      if (locale == 'hi') return 'जमीन किराये पर';
      if (locale == 'mr') return 'जमीन भाड्याने';
      if (locale == 'gu') return 'જમીન ભાડે';
      return 'Lease Land';
    case 'tractor_rental':
      if (locale == 'hi') return 'ट्रैक्टर किराया';
      if (locale == 'mr') return 'ट्रॅक्टर भाडे';
      if (locale == 'gu') return 'ટ્રેક્ટર ભાડે';
      return 'Tractor Rental';
    case 'farm_machinery_rent':
      if (locale == 'hi') return 'कृषि यंत्र किराया';
      if (locale == 'mr') return 'शेती यंत्र भाडे';
      if (locale == 'gu') return 'ખેત મશીન ભાડે';
      return 'Farm Machinery';
    case 'jcb_rental':
      if (locale == 'hi') return 'JCB किराया';
      if (locale == 'mr') return 'JCB भाडे';
      if (locale == 'gu') return 'JCB ભાડે';
      return 'JCB Rental';
    case 'all_buy':
      if (locale == 'hi') return 'सभी खरीद श्रेणियां';
      if (locale == 'mr') return 'सर्व खरेदी श्रेणी';
      if (locale == 'gu') return 'બધી ખरीद શ્રેणीઓ';
      return 'All Buy Categories';
    case 'all_rent':
      if (locale == 'hi') return 'सभी किराया श्रेणियां';
      if (locale == 'mr') return 'सर्व भाडे श्रेणी';
      if (locale == 'gu') return 'બधી ભાડે શ્રેणीઓ';
      return 'All Rent Categories';
    default:
      return key;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.onMenuTap,
    required this.userLocation,
    this.onLocationTap,
  });

  final VoidCallback  onMenuTap;
  final UserLocation  userLocation;
  final Future<void> Function()? onLocationTap;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final _items            = <Listing>[];
  var   _page             = 0;
  var   _isLoadingMore    = false;
  var   _hasMore          = true;
  var   _activeFilter     = _CategoryFilter.buy;
  List<Listing> _nearbyItems = [];

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
    _loadNearby();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userLocation.displayName !=
            widget.userLocation.displayName ||
        oldWidget.userLocation.latitude != widget.userLocation.latitude ||
        oldWidget.userLocation.longitude != widget.userLocation.longitude) {
      _resetAndReload();
      _loadNearby();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _resetAndReload() {
    setState(() { _page = 0; _items.clear(); _hasMore = true; });
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
        _page, userLocation: widget.userLocation);
    if (!mounted) return;
    setState(() {
      _items.addAll(batch);
      _page++;
      _isLoadingMore = false;
      _hasMore       = batch.length == ListingFeed.pageSize;
    });
  }

  Future<void> _loadNearby() async {
    final nearby = ListingFeed.nearbyPreview(widget.userLocation, count: 6);
    setState(() => _nearbyItems = nearby);
  }

  List<_HomeCategory> _allCategories(AppLocalizations l10n) {
    final loc = l10n.localeName;
    return [
      _HomeCategory(
        label: l10n.cropsAndGrains, imagePath: 'assets/sub_ctg/KrishiX_App-31.jpg',
        color: const Color(0xFF689F38), sectionId: CategorySectionId.cropsAndGrains,
        filter: _CategoryFilter.buy,
      ),
      _HomeCategory(
        label: l10n.fruitsAndVegetables, imagePath: 'assets/sub_ctg/KrishiX_App-47.jpg',
        color: const Color(0xFF7CB342), sectionId: CategorySectionId.fruitsVeg,
        filter: _CategoryFilter.buy,
      ),
      _HomeCategory(
        label: l10n.categoryLivestock, imagePath: 'assets/sub_ctg/KrishiX_App-54.jpg',
        color: const Color(0xFF8D6E63), sectionId: CategorySectionId.livestock,
        filter: _CategoryFilter.buy,
      ),
      _HomeCategory(
        label: l10n.categoryLand, imagePath: 'assets/sub_ctg/KrishiX_App-65.jpg',
        color: const Color(0xFF0277BD), sectionId: CategorySectionId.agricultureLandSale,
        filter: _CategoryFilter.buy,
      ),
      _HomeCategory(
        label: l10n.seeds, imagePath: 'assets/sub_ctg/KrishiX_App-71.jpg',
        color: AppColors.textPrimary, sectionId: CategorySectionId.seedsAndPlants,
        filter: _CategoryFilter.buy,
      ),
      _HomeCategory(
        label: l10n.categoryMachinery, imagePath: 'assets/sub_ctg/KrishiX_App-21.jpg',
        color: const Color(0xFF6D4C41), sectionId: CategorySectionId.farmMachinery,
        filter: _CategoryFilter.buy,
      ),
      _HomeCategory(
        label: l10n.tractors, imagePath: 'assets/sub_ctg/KrishiX_App-17.jpg',
        color: const Color(0xFF558B2F), sectionId: CategorySectionId.tractors,
        filter: _CategoryFilter.buy,
      ),
      _HomeCategory(
        label: _tr('lease_land', loc), imagePath: 'assets/sub_ctg/KrishiX_App-65.jpg',
        color: const Color(0xFF0277BD), sectionId: CategorySectionId.agricultureLandLease,
        filter: _CategoryFilter.rent,
      ),
      _HomeCategory(
        label: _tr('tractor_rental', loc), imagePath: 'assets/sub_ctg/KrishiX_App-17.jpg',
        color: const Color(0xFF558B2F), sectionId: CategorySectionId.tractorRental,
        filter: _CategoryFilter.rent,
      ),
      _HomeCategory(
        label: _tr('farm_machinery_rent', loc), imagePath: 'assets/sub_ctg/KrishiX_App-21.jpg',
        color: const Color(0xFF6D4C41), sectionId: CategorySectionId.farmMachineryRent,
        filter: _CategoryFilter.rent,
      ),
      _HomeCategory(
        label: _tr('jcb_rental', loc), imagePath: 'assets/sub_ctg/KrishiX_App-23.jpg',
        color: const Color(0xFFF57C00), sectionId: CategorySectionId.jcbRental,
        filter: _CategoryFilter.rent,
      ),
    ];
  }

  void _openBrowse(BuildContext context, {ListingCategory? category}) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => BrowseScreen(
        initialCategory: category,
        userLocation:    widget.userLocation,
      ),
    ));
  }

  void _openCategoryDetail(BuildContext context, String sectionId) {
    if (sectionId == CategorySectionId.tractors) {
      Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => TractorPickerScreen(userLocation: widget.userLocation),
      ));
      return;
    }
    if (sectionId == CategorySectionId.tractorRental) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BrowseScreen(
            initialCategory: ListingCategory.rental,
            initialListingType: ListingType.rent,
            initialDetailLabel: 'Tractor Rental',
            initialDetailKeywords: const ['tractor'],
            userLocation: widget.userLocation,
          ),
        ),
      );
      return;
    }
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => CategoryDetailScreen(
        sectionId:    sectionId,
        userLocation: widget.userLocation,
      ),
    ));
  }

  void _openBannerPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => const _BannerDetailPage(),
    ));
  }

  void _showAllCategoriesSheet(BuildContext context) {
    final l10n    = AppLocalizations.of(context)!;
    final loc     = l10n.localeName;
    final allCats = _allCategories(l10n);
    final sheetCats = allCats.where((c) => c.filter == _activeFilter).toList();
    final title = _activeFilter == _CategoryFilter.buy
        ? _tr('all_buy', loc) : _tr('all_rent', loc);

    showModalBottomSheet<void>(
      context:            context,
      isScrollControlled: true,
      backgroundColor:    Colors.transparent,
      builder: (sheetCtx) => DraggableScrollableSheet(
        initialChildSize: 0.62,
        minChildSize:     0.45,
        maxChildSize:     0.92,
        expand:           false,
        builder: (_, scrollCtrl) => Container(
          decoration: const BoxDecoration(
            color:        Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(title,
                      style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(sheetCtx),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.close,
                            size: 18, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Divider(color: Colors.grey.shade200, height: 1),
              const SizedBox(height: 4),
              Flexible(
                child: GridView.builder(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, mainAxisSpacing: 16,
                    crossAxisSpacing: 10, childAspectRatio: 0.78,
                  ),
                  itemCount: sheetCats.length,
                  itemBuilder: (_, i) {
                    final cat = sheetCats[i];
                    return _SheetCategoryTile(
                      label: cat.label, imagePath: cat.imagePath,
                      color: cat.color,
                      onTap: () {
                        Navigator.pop(sheetCtx);
                        _openCategoryDetail(context, cat.sectionId);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n    = AppLocalizations.of(context)!;
    final loc     = l10n.localeName;
    final allCats = _allCategories(l10n);
    final filtered = allCats.where((c) => c.filter == _activeFilter).toList();
    final statusH  = MediaQuery.of(context).padding.top;

    return ColoredBox(
      color: Colors.white,
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
              onLocationTap:     widget.onLocationTap,
              onNotificationTap: () {},
              onWishlistTap:     () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const WishlistScreen(),
                  ),
                );
              },
            ),
          ),

          // ── Search bar ───────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: GestureDetector(
                onTap: () => _openBrowse(context),
                child: Container(
                  height:  52,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color:        Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey.shade600, size: 26),
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

          // ── Buy / Rent / Services filter chips ───────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _FilterChip(
                    label:  _tr('buy', loc),
                    active: _activeFilter == _CategoryFilter.buy,
                    color:  const Color(0xFF2E7D32),
                    onTap:  () => setState(() => _activeFilter = _CategoryFilter.buy),
                  ),
                  const SizedBox(width: 10),
                  _FilterChip(
                    label:  _tr('rent', loc),
                    active: _activeFilter == _CategoryFilter.rent,
                    color:  const Color(0xFFF57C00),
                    onTap:  () => setState(() => _activeFilter = _CategoryFilter.rent),
                  ),
                  const SizedBox(width: 10),
                  _FilterChip(
                    label:  _tr('services', loc),
                    active: _activeFilter == _CategoryFilter.services,
                    color:  const Color(0xFF0277BD),
                    onTap:  () => setState(() => _activeFilter = _CategoryFilter.services),
                  ),
                ],
              ),
            ),
          ),

          // ── Category grid OR coming soon ─────────────────
          SliverToBoxAdapter(
            child: _activeFilter == _CategoryFilter.services
                ? _ComingSoonCard(locale: loc)
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            const cols      = 4;
                            const hGap      = 6.0;
                            const totalGaps = (cols - 1) * hGap;
                            final tileW     = (constraints.maxWidth - totalGaps) / cols;
                            final imgSize   = tileW;
                            const labelH    = 32.0;
                            final tileH     = imgSize + labelH;

                            return Wrap(
                              spacing:    hGap,
                              runSpacing: 6,
                              children: filtered.map((item) => SizedBox(
                                width:  tileW,
                                height: tileH,
                                child: _CategoryTile(
                                  label:   item.label,
                                  imgPath: item.imagePath,
                                  color:   item.color,
                                  imgSize: imgSize,
                                  labelH:  labelH,
                                  onTap: () => _openCategoryDetail(
                                      context, item.sectionId),
                                ),
                              )).toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _showAllCategoriesSheet(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 5),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF9800), Color(0xFFF44336)],
                                begin:  Alignment.centerLeft,
                                end:    Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color:      const Color(0xFFF57C00).withOpacity(0.28),
                                  blurRadius: 6,
                                  offset:     const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              l10n.seeAll,
                              style: const TextStyle(
                                color:         Colors.white,
                                fontSize:      11,
                                fontWeight:    FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
          ),

          // ── Nearby section ────────────────────────────────
          // NearbySection(
          //   nearby:       _nearbyItems,
          //   l10n:         l10n,
          //   userLocation: widget.userLocation,
          // ),

          // ── All products feed ────────────────────────────
          AllProductsSection(
            items:         _items,
            isLoadingMore: _isLoadingMore,
            l10n:          l10n,
            userLocation:  widget.userLocation,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PINNED GREEN TOP BAR — with wishlist + notification icons
// ═══════════════════════════════════════════════════════════════
class _GreenTopBarDelegate extends SliverPersistentHeaderDelegate {
  _GreenTopBarDelegate({
    required this.statusBarHeight,
    required this.contentHeight,
    required this.dividerHeight,
    required this.locationName,
    required this.onMenuTap,
    this.onLocationTap,
    required this.onNotificationTap,
    required this.onWishlistTap,
  });

  final double       statusBarHeight;
  final double       contentHeight;
  final double       dividerHeight;
  final String       locationName;
  final VoidCallback onMenuTap;
  final Future<void> Function()? onLocationTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onWishlistTap;

  double get _totalHeight => statusBarHeight + contentHeight + dividerHeight;

  @override double get minExtent => _totalHeight;
  @override double get maxExtent => _totalHeight;

  @override
  bool shouldRebuild(covariant _GreenTopBarDelegate old) =>
      old.locationName    != locationName ||
      old.statusBarHeight != statusBarHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
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

                    // ── Menu ─────────────────────────────────
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap:        onMenuTap,
                        borderRadius: BorderRadius.circular(12),
                        child: const SizedBox(
                          width: 52, height: 52,
                          child: Icon(Icons.menu, size: 28, color: Colors.white),
                        ),
                      ),
                    ),

                    // ── Location (tap to refresh) ─────────────
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onLocationTap,
                          borderRadius: BorderRadius.circular(12),
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              if (onLocationTap != null) ...[
                                const SizedBox(width: 2),
                                Icon(
                                  Icons.my_location_rounded,
                                  color: Colors.white.withOpacity(0.85),
                                  size: 16,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ── Wishlist ──────────────────────────────
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap:        onWishlistTap,
                        borderRadius: BorderRadius.circular(12),
                        child: const SizedBox(
                          width: 48, height: 52,
                          child: Icon(Icons.favorite_border_rounded,
                              size: 26, color: Colors.white),
                        ),
                      ),
                    ),

                    // ── Notification ──────────────────────────
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap:        onNotificationTap,
                        borderRadius: BorderRadius.circular(12),
                        child: const SizedBox(
                          width: 48, height: 52,
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
// COMING SOON CARD
// ═══════════════════════════════════════════════════════════════
class _ComingSoonCard extends StatelessWidget {
  const _ComingSoonCard({required this.locale});
  final String locale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Container(
        width:   double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        decoration: BoxDecoration(
          color:        const Color(0xFFF0F9F0),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryGreen.withOpacity(0.18)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.construction_rounded,
                size: 52, color: AppColors.primaryGreen.withOpacity(0.6)),
            const SizedBox(height: 14),
            Text(
              _tr('services_coming_soon', locale),
              style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.w800,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _tr('services_coming_soon_subtitle', locale),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13, color: Colors.grey.shade600, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// FILTER CHIP
// ═══════════════════════════════════════════════════════════════
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });
  final String       label;
  final bool         active;
  final Color        color;
  final VoidCallback onTap;

  static const Color _activeColor = Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve:    Curves.easeOut,
        padding:  const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        decoration: BoxDecoration(
          color:        active ? _activeColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? _activeColor : Colors.grey.shade400,
            width: active ? 2.0 : 1.5,
          ),
          boxShadow: active
              ? [BoxShadow(
                  color:      _activeColor.withOpacity(0.28),
                  blurRadius: 8, offset: const Offset(0, 3),
                )]
              : [BoxShadow(
                  color:      Colors.black.withOpacity(0.04),
                  blurRadius: 3, offset: const Offset(0, 1),
                )],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize:      13,
            fontWeight:    FontWeight.w700,
            letterSpacing: 0.2,
            color: active ? Colors.white : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HOME BANNER
// ═══════════════════════════════════════════════════════════════
class _HomeBanner extends StatelessWidget {
  const _HomeBanner({required this.l10n, required this.onBannerTap});
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
              fit: BoxFit.cover, alignment: Alignment.center,
              errorBuilder: (_, __, ___) =>
                  Container(color: AppColors.bannerGreen),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.bannerTractorTitle,
                    style: const TextStyle(
                      color: Colors.white, fontSize: AppTextSize.title,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(l10n.bannerTractorSubtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: AppTextSize.body,
                    ),
                  ),
                  const Spacer(),
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      onTap: onBannerTap,
                      borderRadius: BorderRadius.circular(24),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 11),
                        child: Text(l10n.searchNow,
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF0),
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        title: Text(l10n.bannerTractorTitle,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.agriculture, size: 80, color: AppColors.primaryGreen),
            const SizedBox(height: 16),
            Text(l10n.comingSoon,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600,
                color: AppColors.primaryGreen,
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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize:       MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: imgSize, height: imgSize,
              color: const Color(0xFFEDF7ED),
              child: Image.asset(
                imgPath,
                width: imgSize, height: imgSize,
                fit:           BoxFit.cover,
                filterQuality: FilterQuality.medium,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.image_not_supported_outlined,
                  color: color, size: imgSize * 0.4,
                ),
              ),
            ),
          ),
          SizedBox(
            height: labelH,
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines:  2,
                overflow:  TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize:   10.5,
                  fontWeight: FontWeight.w700,
                  height:     1.2,
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
// SHEET CATEGORY TILE
// ═══════════════════════════════════════════════════════════════
class _SheetCategoryTile extends StatelessWidget {
  const _SheetCategoryTile({
    required this.label,
    required this.imagePath,
    required this.color,
    required this.onTap,
  });
  final String       label;
  final String       imagePath;
  final Color        color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize:       MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color:        const Color(0xFFEDF7ED),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.primaryGreen.withOpacity(0.22)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.asset(
                  imagePath,
                  fit:           BoxFit.cover,
                  filterQuality: FilterQuality.medium,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.image_not_supported_outlined,
                    color: color, size: 24,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines:  2,
            overflow:  TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10, fontWeight: FontWeight.w700,
              height: 1.3, color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
