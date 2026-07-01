import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/models/user_location.dart';
import 'package:krishix/features/icons/dealer_data.dart';
import 'package:krishix/l10n/app_localizations.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

const Color _kGreen  = AppColors.primaryGreen;
const Color _kOrange = Color(0xFFF57C00);
const Color _kWhatsApp = Color(0xFF25D366);

const LinearGradient _kOrangeGrad = LinearGradient(
  colors: [Color(0xFFFF8C00), Color(0xFFFF6B00)],
  begin:  Alignment.topLeft,
  end:    Alignment.bottomRight,
);

const _kGalleryHeight = 196.0;

Widget _dealerAssetImage(
  String path, {
  BoxFit fit = BoxFit.cover,
}) {
  return Image.asset(
    path,
    fit: fit,
    errorBuilder: (_, __, ___) => ColoredBox(
      color: _kGreen.withOpacity(0.10),
      child: const Center(
        child: Icon(Icons.image_not_supported_outlined,
            color: _kGreen, size: 32),
      ),
    ),
  );
}

void _openDealerGallery(BuildContext context, List<String> images, int index) {
  if (images.isEmpty) return;
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => _DealerFullScreenGallery(
        images:       images,
        initialIndex: index.clamp(0, images.length - 1),
      ),
    ),
  );
}

class _DealerFullScreenGallery extends StatefulWidget {
  const _DealerFullScreenGallery({
    required this.images,
    required this.initialIndex,
  });

  final List<String> images;
  final int          initialIndex;

  @override
  State<_DealerFullScreenGallery> createState() =>
      _DealerFullScreenGalleryState();
}

class _DealerFullScreenGalleryState extends State<_DealerFullScreenGallery> {
  late int            _current;
  late PageController _ctrl;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _ctrl    = PageController(initialPage: widget.initialIndex);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor:          Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            pageController: _ctrl,
            itemCount:      widget.images.length,
            onPageChanged:  (i) => setState(() => _current = i),
            scrollPhysics:  const BouncingScrollPhysics(),
            backgroundDecoration:
                const BoxDecoration(color: Colors.black),
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: AssetImage(widget.images[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3.0,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: 'dealer_img_$index'),
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.broken_image_rounded,
                      color: Colors.white54, size: 60),
                ),
              );
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width:  38,
                        height: 38,
                        decoration: BoxDecoration(
                          color:        Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(19),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.20)),
                        ),
                        child: const Icon(Icons.close_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color:        Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.20)),
                      ),
                      child: Text(
                        '${_current + 1} / ${widget.images.length}',
                        style: const TextStyle(
                          color:      Colors.white,
                          fontSize:   13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width:  i == _current ? 22 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: i == _current
                        ? Colors.white
                        : Colors.white.withOpacity(0.40),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 56,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Pinch to zoom  •  Swipe to browse',
                style: TextStyle(
                  color:    Colors.white.withOpacity(0.50),
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DealerDetailScreen extends StatefulWidget {
  const DealerDetailScreen({
    super.key,
    required this.dealer,
    required this.userLocation,
  });

  final AgriDealer   dealer;
  final UserLocation userLocation;

  @override
  State<DealerDetailScreen> createState() => _DealerDetailScreenState();
}

class _DealerDetailScreenState extends State<DealerDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  int _galleryIndex = 0;
  bool _hoursExpanded = false;

  AgriDealer get _d => widget.dealer;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _call() async {
    final uri = Uri.parse('tel:${_d.phone.replaceAll(RegExp(r'\s+'), '')}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _whatsapp() async {
    final digits = _d.phone.replaceAll(RegExp(r'\D'), '');
    final num = digits.length > 10 ? digits.substring(digits.length - 10) : digits;
    final uri = Uri.parse('https://wa.me/91$num');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _share() {
    final l10n = AppLocalizations.of(context)!;
    Share.share(buildDealerShareText(l10n, _d));
  }

  void _openGallery(int index) {
    _openDealerGallery(context, _d.galleryImages, index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation:       0.5,
        shadowColor:     Colors.black.withOpacity(0.08),
        leading: IconButton(
          icon: Container(
            width:  36,
            height: 36,
            decoration: BoxDecoration(
              shape:  BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 22),
            onPressed: _share,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: _BottomActions(
        onCall:     _call,
        onWhatsApp: _whatsapp,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverToBoxAdapter(child: _DealerHeader(dealer: _d)),
          SliverToBoxAdapter(
            child: _QuickActionsRow(
              onCall:     _call,
              onWhatsApp: _whatsapp,
            ),
          ),
          SliverToBoxAdapter(
            child: _GallerySection(
              images:        _d.galleryImages,
              selectedIndex: _galleryIndex,
              serviceCount:  _d.services.length,
              onSelect:      (i) => setState(() => _galleryIndex = i),
              onOpenGallery: _openGallery,
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarHeader(
              tabController: _tabs,
              onTap: (i) => _tabs.animateTo(i),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabs,
          children: [
            _OverviewTab(
              dealer:         _d,
              userLocation:   widget.userLocation,
              hoursExpanded:  _hoursExpanded,
              onToggleHours:  () => setState(() => _hoursExpanded = !_hoursExpanded),
            ),
            _ProductsServicesTab(
              dealer:        _d,
              images:        _d.galleryImages,
              onOpenGallery: _openGallery,
            ),
            _PhotosTab(
              images:        _d.galleryImages,
              onOpenGallery: _openGallery,
            ),
          ],
        ),
      ),
    );
  }
}

class _DealerHeader extends StatelessWidget {
  const _DealerHeader({required this.dealer});

  final AgriDealer dealer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (dealer.isVerified)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, right: 6),
                        child: Icon(
                          Icons.thumb_up_alt_rounded,
                          size:  18,
                          color: AppColors.verifiedBlue,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        dealer.name,
                        style: const TextStyle(
                          fontSize:   20,
                          fontWeight: FontWeight.w800,
                          color:      AppColors.textPrimary,
                          height:     1.25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width:  56,
                  height: 56,
                  child: _dealerAssetImage(dealerHeroImage(dealer)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            dealer.servesAlso != null
                ? l10n.alsoServesAreas(
                    dealer.location.split(',').first.trim(),
                    dealer.servesAlso!,
                  )
                : dealer.location,
            style: TextStyle(
              fontSize:   13,
              color:      Colors.grey.shade600,
              height:     1.35,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color:        _kGreen,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(dealerCategoryIcon(dealer.category),
                        size: 12, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      localizedDealerCategory(l10n, dealer.category),
                      style: const TextStyle(
                        fontSize:   11,
                        fontWeight: FontWeight.w800,
                        color:      Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                l10n.yearsInBusiness(dealer.yearsInBusiness),
                style: TextStyle(
                  fontSize:   12,
                  fontWeight: FontWeight.w600,
                  color:      Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.check_circle_rounded, size: 16, color: _kGreen),
              const SizedBox(width: 5),
              Text(
                l10n.veryResponsive,
                style: TextStyle(
                  fontSize:   12,
                  fontWeight: FontWeight.w700,
                  color:      _kGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow({
    required this.onCall,
    required this.onWhatsApp,
  });

  final VoidCallback onCall;
  final VoidCallback onWhatsApp;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 88,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _QuickAction(
            label:  l10n.listingCall,
            icon:   Icons.call_rounded,
            color:  _kGreen,
            filled: true,
            onTap:  onCall,
          ),
          _QuickAction(
            label:  l10n.listingWhatsApp,
            icon:   Icons.chat_rounded,
            color:  _kWhatsApp,
            filled: true,
            onTap:  onWhatsApp,
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.filled = false,
    this.badge,
  });

  final String       label;
  final IconData     icon;
  final Color        color;
  final VoidCallback onTap;
  final bool         filled;
  final String?      badge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width:  52,
                  height: 52,
                  decoration: BoxDecoration(
                    color:  filled ? color : Colors.white,
                    shape:  BoxShape.circle,
                    border: filled ? null : Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color:      Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset:     const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: filled ? Colors.white : color,
                    size:  22,
                  ),
                ),
                if (badge != null)
                  Positioned(
                    top:   -4,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        gradient:     _kOrangeGrad,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          color:      Colors.white,
                          fontSize:   8,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize:   11,
                fontWeight: FontWeight.w600,
                color:      Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GallerySection extends StatelessWidget {
  const _GallerySection({
    required this.images,
    required this.selectedIndex,
    required this.serviceCount,
    required this.onSelect,
    required this.onOpenGallery,
  });

  final List<String>       images;
  final int                selectedIndex;
  final int                serviceCount;
  final ValueChanged<int>  onSelect;
  final ValueChanged<int>  onOpenGallery;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final safeIndex = selectedIndex.clamp(0, images.length - 1);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => onOpenGallery(safeIndex),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width:  double.infinity,
                height: _kGalleryHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'dealer_img_$safeIndex',
                      child: _dealerAssetImage(images[safeIndex]),
                    ),
                    Positioned(
                      left:  10,
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color:        Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.fullscreen_rounded,
                                size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              l10n.photosCount(images.length),
                              style: const TextStyle(
                                color:      Colors.white,
                                fontSize:   11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final selected = safeIndex == i;
                return GestureDetector(
                  onTap: () {
                    onSelect(i);
                    onOpenGallery(i);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width:  64,
                      height: 64,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selected ? _kGreen : Colors.grey.shade300,
                          width: selected ? 2.5 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: _dealerAssetImage(images[i]),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductsServicesTab extends StatelessWidget {
  const _ProductsServicesTab({
    required this.dealer,
    required this.images,
    required this.onOpenGallery,
  });

  final AgriDealer          dealer;
  final List<String>        images;
  final ValueChanged<int>   onOpenGallery;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        _ProductsServicesSection(
          dealer:        dealer,
          images:        images,
          onOpenGallery: onOpenGallery,
        ),
      ],
    );
  }
}

class _ProductsServicesSection extends StatelessWidget {
  const _ProductsServicesSection({
    required this.dealer,
    required this.images,
    required this.onOpenGallery,
  });

  final AgriDealer          dealer;
  final List<String>        images;
  final ValueChanged<int>   onOpenGallery;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        decoration: BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.circular(14),
          border:       Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color:      Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset:     const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.inventory_2_outlined, color: _kGreen, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.productsAndServices,
                  style: const TextStyle(
                    fontSize:   16,
                    fontWeight: FontWeight.w800,
                    color:      AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              l10n.productsLabel,
              style: TextStyle(
                fontSize:   13,
                fontWeight: FontWeight.w700,
                color:      Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: dealer.productCategories.map((cat) {
                final isPrimary = cat == dealer.category;
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient:     isPrimary ? _kOrangeGrad : null,
                    color:        isPrimary ? null : _kGreen.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isPrimary ? Colors.transparent : _kGreen.withOpacity(0.35),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        dealerCategoryIcon(cat),
                        size:  16,
                        color: isPrimary ? Colors.white : _kGreen,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        localizedDealerCategory(l10n, cat),
                        style: TextStyle(
                          fontSize:   13,
                          fontWeight: FontWeight.w700,
                          color:      isPrimary ? Colors.white : _kGreen,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            if (dealer.priceHint != null || dealer.productsLink != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.sell_outlined, size: 16, color: _kOrange),
                  const SizedBox(width: 6),
                  Text(
                    dealer.priceHint ?? dealer.productsLink ?? '',
                    style: TextStyle(
                      fontSize:   13,
                      fontWeight: FontWeight.w700,
                      color:      AppColors.verifiedBlue,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Divider(height: 1, color: Colors.grey.shade200),
            const SizedBox(height: 14),
            Text(
              l10n.servicesLabel,
              style: TextStyle(
                fontSize:   13,
                fontWeight: FontWeight.w700,
                color:      Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 10),
            ...dealer.services.map(
              (service) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width:  32,
                      height: 32,
                      decoration: BoxDecoration(
                        color:        _kGreen.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: _kGreen,
                        size:  18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        service,
                        style: const TextStyle(
                          fontSize:   14,
                          fontWeight: FontWeight.w600,
                          color:      AppColors.textPrimary,
                          height:     1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (images.isNotEmpty) ...[
              const SizedBox(height: 6),
              Divider(height: 1, color: Colors.grey.shade200),
              const SizedBox(height: 14),
              Text(
                l10n.photosTab,
                style: TextStyle(
                  fontSize:   13,
                  fontWeight: FontWeight.w700,
                  color:      Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 88,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) => GestureDetector(
                    onTap: () => onOpenGallery(i),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width:  88,
                        height: 88,
                        child: _dealerAssetImage(images[i]),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TabBarHeader extends SliverPersistentHeaderDelegate {
  _TabBarHeader({required this.tabController, required this.onTap});

  final TabController tabController;
  final ValueChanged<int> onTap;

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: Colors.white,
      elevation: overlapsContent ? 0.5 : 0,
      child: TabBar(
        controller: tabController,
        onTap: onTap,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor:       _kGreen,
        unselectedLabelColor: Colors.grey.shade600,
        indicatorColor:   _kGreen,
        indicatorWeight:  2.5,
        labelStyle: const TextStyle(
          fontSize:   13,
          fontWeight: FontWeight.w800,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize:   13,
          fontWeight: FontWeight.w600,
        ),
        tabs: [
          Tab(text: l10n.overviewTab),
          Tab(text: l10n.productsAndServices),
          Tab(text: l10n.photosTab),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarHeader oldDelegate) =>
      oldDelegate.tabController != tabController;
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.dealer,
    required this.userLocation,
    required this.hoursExpanded,
    required this.onToggleHours,
  });

  final AgriDealer   dealer;
  final UserLocation userLocation;
  final bool         hoursExpanded;
  final VoidCallback onToggleHours;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        InkWell(
          onTap: onToggleHours,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Text(
                  l10n.openNowUntil(dealer.openUntil),
                  style: const TextStyle(
                    fontSize:   14,
                    fontWeight: FontWeight.w700,
                    color:      AppColors.textPrimary,
                  ),
                ),
                Icon(
                  hoursExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
        if (hoursExpanded) ...[
          const SizedBox(height: 8),
          _HoursRow(day: 'Mon – Sat', hours: '8:00 am – ${dealer.openUntil}'),
          _HoursRow(day: 'Sunday', hours: '9:00 am – 1:00 pm'),
          const SizedBox(height: 12),
        ],
        if (dealer.about != null) ...[
          Text(
            l10n.aboutSection,
            style: const TextStyle(
              fontSize:   15,
              fontWeight: FontWeight.w800,
              color:      AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            dealer.about!,
            style: TextStyle(
              fontSize:   13,
              color:      Colors.grey.shade700,
              height:     1.5,
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (dealer.highlight != null) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.bolt_rounded, size: 18, color: _kOrange),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  dealer.highlight!,
                  style: TextStyle(
                    fontSize:   13,
                    fontWeight: FontWeight.w600,
                    color:      _kOrange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        Text(
          l10n.locationSection,
          style: const TextStyle(
            fontSize:   15,
            fontWeight: FontWeight.w800,
            color:      AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.location_on_outlined,
                size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '${dealer.location}\n${l10n.nearLocation(userLocation.displayName)}',
                style: TextStyle(
                  fontSize:   13,
                  color:      Colors.grey.shade700,
                  height:     1.45,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HoursRow extends StatelessWidget {
  const _HoursRow({required this.day, required this.hours});

  final String day;
  final String hours;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              day,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
          Text(
            hours,
            style: const TextStyle(
              fontSize:   12,
              fontWeight: FontWeight.w600,
              color:      AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotosTab extends StatelessWidget {
  const _PhotosTab({
    required this.images,
    required this.onOpenGallery,
  });

  final List<String>      images;
  final ValueChanged<int> onOpenGallery;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (images.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined,
                size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              l10n.photosTab,
              style: TextStyle(
                fontSize:   14,
                fontWeight: FontWeight.w600,
                color:      Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text(
          l10n.photosTab,
          style: const TextStyle(
            fontSize:   15,
            fontWeight: FontWeight.w800,
            color:      AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.photosCount(images.length),
          style: TextStyle(
            fontSize:   12,
            fontWeight: FontWeight.w600,
            color:      Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing:  10,
            childAspectRatio: 1,
          ),
          itemCount: images.length,
          itemBuilder: (context, i) => GestureDetector(
            onTap: () => onOpenGallery(i),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _dealerAssetImage(images[i]),
                  if (i == 0)
                    Positioned(
                      left:  0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _kGreen,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: Text(
                          l10n.postPhotoCover,
                          style: const TextStyle(
                            color:      Colors.white,
                            fontSize:   10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.onCall,
    required this.onWhatsApp,
  });

  final VoidCallback onCall;
  final VoidCallback onWhatsApp;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.12),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onCall,
                    borderRadius: BorderRadius.circular(10),
                    child: Ink(
                      height: 44,
                      decoration: BoxDecoration(
                        gradient:     _kOrangeGrad,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.call_rounded,
                              color: Colors.white, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            l10n.callNow,
                            style: const TextStyle(
                              color:      Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize:   13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Material(
                  color: _kWhatsApp,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: onWhatsApp,
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: 44,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.chat_rounded,
                              color: Colors.white, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            l10n.listingWhatsApp,
                            style: const TextStyle(
                              color:      Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize:   13,
                            ),
                          ),
                        ],
                      ),
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
