
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/core/models/user_location.dart';
import 'package:krishix/core/services/location_service.dart';
import 'package:krishix/features/listings/seller_profile_screen.dart';
import 'package:krishix/l10n/app_localizations.dart';
import 'package:carousel_slider/carousel_slider.dart';

const Color _kGreen  = AppColors.primaryGreen;
const Color _kOrange = Color(0xFFF57C00);


// Orange gradient — wishlist, dots, page counter
const LinearGradient _kOrangeGrad = LinearGradient(
  colors: [Color(0xFFFF9800), Color(0xFFF44336)],
  begin:  Alignment.topLeft,
  end:    Alignment.bottomRight,
);

const Map<ListingCategory, List<String>> _categoryImages = {
  ListingCategory.livestock: [
    'assets/images/cow1.jpeg',
    'assets/images/cow2.jpeg',
    'assets/images/cow1.jpeg',
  ],
  ListingCategory.land: [
    'assets/images/land1.jpeg',
    'assets/images/land2.jpeg',
    'assets/images/land1.jpeg',
  ],
  ListingCategory.tractors: [
    'assets/images/tractor1.webp',
    'assets/images/tractor2.webp',
    'assets/images/machine1.jpeg',
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
  ],
};

List<String> _imagesFor(ListingCategory cat) {
  return _categoryImages[cat] ?? [
    'assets/images/seeds1.jpeg',
    'assets/images/veg1.jpeg',
    'assets/images/mango.jpeg',
  ];
}

String _formatPrice(int price) {
  final v    = price.toString();
  if (v.length <= 3) return '₹$v';
  final last = v.substring(v.length - 3);
  final rest = v.substring(0, v.length - 3);
  final buf  = StringBuffer();
  for (var i = 0; i < rest.length; i++) {
    if (i > 0 && (rest.length - i) % 2 == 0) buf.write(',');
    buf.write(rest[i]);
  }
  return '₹${buf.toString()},$last';
}

String _buildShareText(Listing listing) {
  final buf = StringBuffer();
  buf.writeln('🌾 *KrishiX Listing*');
  buf.writeln();
  buf.writeln('📌 *${listing.title}*');
  buf.writeln('💰 Price: ${_formatPrice(listing.price)}'
      '${listing.rentalDuration != null ? ' / ${listing.rentalDuration!.toLowerCase()}' : ''}');
  buf.writeln('📍 ${listing.location}');
  if (listing.distanceKm != null) {
    buf.writeln('📏 ${listing.distanceKm!.toStringAsFixed(1)} km away');
  }
  buf.writeln('👤 Seller: ${listing.sellerName}'
      '${listing.isVerified ? ' ✅ Verified' : ''}');
  if (listing.sellerPhone != null) buf.writeln('📞 ${listing.sellerPhone}');
  buf.writeln();
  buf.writeln('📲 Download KrishiX to view & connect with the seller.');
  return buf.toString();
}

// ═══════════════════════════════════════════════════════════════
// FULL SCREEN GALLERY
// ═══════════════════════════════════════════════════════════════
class _FullScreenGallery extends StatefulWidget {
  const _FullScreenGallery({
    required this.images,
    required this.initialIndex,
  });
  final List<String> images;
  final int          initialIndex;

  @override
  State<_FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<_FullScreenGallery> {
  late int              _current;
  late PageController   _ctrl;

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

          // ── Zoomable gallery ──────────────────────────
          PhotoViewGallery.builder(
            pageController:  _ctrl,
            itemCount:       widget.images.length,
            onPageChanged:   (i) => setState(() => _current = i),
            scrollPhysics:   const BouncingScrollPhysics(),
            backgroundDecoration:
                const BoxDecoration(color: Colors.black),
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider:
                    AssetImage(widget.images[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3.0,
                heroAttributes: PhotoViewHeroAttributes(
                    tag: 'img_$index'),
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.broken_image_rounded,
                      color: Colors.white54, size: 60),
                ),
              );
            },
          ),

          // ── Top bar ───────────────────────────────────
          Positioned(
            top:   0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width:  38, height: 38,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(19),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.20)),
                        ),
                        child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
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

          // ── Dot indicators ────────────────────────────
          Positioned(
            bottom: 32, left: 0, right: 0,
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

          // ── Swipe hint ────────────────────────────────
          Positioned(
            bottom: 60, left: 0, right: 0,
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

// ═══════════════════════════════════════════════════════════════
// LISTING DETAIL SCREEN
// ═══════════════════════════════════════════════════════════════
class ListingDetailScreen extends StatefulWidget {
  const ListingDetailScreen({
    super.key,
    required this.listing,
    this.imageIndex = 0,
    this.userLocation,
  });
  final Listing       listing;
  final int           imageIndex;
  final UserLocation? userLocation;

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  bool _saved          = false;
  bool _isSharing      = false;
  late final PageController      _pageController;
  late final List<String>        _images;
  late final ValueNotifier<int>  _imgIdx;
  UserLocation?                  _liveLocation;
  StreamSubscription<UserLocation>? _locationSub;

  UserLocation? get _effectiveLocation =>
      _liveLocation ?? widget.userLocation;

  @override
  void initState() {
    super.initState();
    _images = _imagesFor(widget.listing.category);
    final initialPage = widget.imageIndex.clamp(0, _images.length - 1);
    _imgIdx         = ValueNotifier<int>(initialPage);
    _pageController = PageController(initialPage: initialPage);
    _liveLocation   = widget.userLocation;
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor:          Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initLocationTracking(requestIfNeeded: widget.userLocation == null ||
          !widget.userLocation!.permissionGranted);
    });
  }

  Future<void> _initLocationTracking({bool requestIfNeeded = false}) async {
    var permission = await LocationService.checkPermission();

    if (permission == LocationPermission.denied && requestIfNeeded) {
      permission = await LocationService.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final location = await LocationService.fetchCurrentLocation();
    if (!mounted) return;
    setState(() => _liveLocation = location);

    _locationSub?.cancel();
    _locationSub = LocationService.watchPosition().listen((updated) {
      if (!mounted) return;
      setState(() => _liveLocation = updated);
    });
  }

  @override
  void dispose() {
    _locationSub?.cancel();
    _pageController.dispose();
    _imgIdx.dispose();
    super.dispose();
  }

  void _onCall() {
    final phone = widget.listing.sellerPhone;
    if (phone != null && phone.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [
          const Icon(Icons.call_rounded, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Text('Calling ${widget.listing.sellerName}…'),
        ]),
        behavior:        SnackBarBehavior.floating,
        duration:        const Duration(seconds: 2),
        backgroundColor: _kGreen,
      ));
      Future.delayed(const Duration(milliseconds: 600), () async {
        final uri = Uri(scheme: 'tel',
            path: phone.replaceAll(' ', ''));
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:  Text('No phone number available.'),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  void _onChat() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content:  Text('Opening chat…'),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
    ));
  }

  Future<void> _onShare() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    try {
      await Share.share(
        _buildShareText(widget.listing),
        subject: widget.listing.title,
      );
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  void _openFullScreen(int index) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => _FullScreenGallery(
        images:       _images,
        initialIndex: index,
      ),
    ));
  }

  void _prevImage() {
    if (_imgIdx.value > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve:    Curves.easeInOut,
      );
    }
  }

  void _nextImage() {
    if (_imgIdx.value < _images.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve:    Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n    = AppLocalizations.of(context)!;
    final locale  = Localizations.localeOf(context);
    final listing = LocationService.withDistance(
      widget.listing,
      _effectiveLocation,
    );
    final hasLiveLocation =
        _effectiveLocation?.permissionGranted ?? false;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _BottomCTA(
        onCall:      _onCall,
        onChat:      _onChat,
        sellerPhone: listing.sellerPhone,
      ),
      body: CustomScrollView(
        slivers: [

          // ── Hero image slider ──────────────────────────
          SliverAppBar(
            expandedHeight:            320,
            pinned:                    true,
            backgroundColor:           _kGreen,
            foregroundColor:           Colors.white,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: _whiteIconBtn(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              // Wishlist — orange gradient (unsaved) / white + red (saved)
              IconButton(
                icon: Container(
                  width:  38, height: 38,
                  decoration: BoxDecoration(
                    gradient:     _saved ? null : _kOrangeGrad,
                    color:        _saved ? Colors.white : null,
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(
                      color: _saved
                          ? Colors.red.withOpacity(0.35)
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.favorite_rounded,
                    size:  18,
                    color: _saved ? Colors.red : Colors.white,
                  ),
                ),
                onPressed: () => setState(() => _saved = !_saved),
              ),
              // Share — white background with green icon
              IconButton(
                icon: Container(
                  width:  38, height: 38,
                  decoration: BoxDecoration(
                    color:        Colors.white,
                    borderRadius: BorderRadius.circular(19),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _isSharing
                      ? const SizedBox(
                          width: 16, height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: _kGreen))
                      : const Icon(Icons.share_rounded,
                          size: 18, color: _kGreen),
                ),
                onPressed: _isSharing ? null : _onShare,
              ),
              const SizedBox(width: 4),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _buildSlider(),
            ),
          ),

          // ── Body ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Title + Verified ─────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          listing.localizedTitle(locale),
                          style: const TextStyle(
                            fontSize:   20,
                            fontWeight: FontWeight.w800,
                            color:      AppColors.textPrimary,
                            height:     1.3,
                          ),
                        ),
                      ),
                      if (listing.isVerified) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color:        _kOrange.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: _kOrange.withOpacity(0.40)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified_rounded,
                                  size: 14, color: _kOrange),
                              const SizedBox(width: 4),
                              Text(
                                l10n.verifiedSeller,
                                style: TextStyle(
                                  fontSize:   12,
                                  fontWeight: FontWeight.w700,
                                  color:      _kOrange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── Price ────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatPrice(listing.price),
                        style: const TextStyle(
                          fontSize:   28,
                          fontWeight: FontWeight.w900,
                          color:      _kGreen,
                          height:     1.1,
                        ),
                      ),
                      if (listing.type == ListingType.rent) ...[
                        const SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            listing.rentalDuration != null
                                ? '/ ${listing.rentalDuration!.toLowerCase()}'
                                : '/ day',
                            style: TextStyle(
                              fontSize:   14,
                              fontWeight: FontWeight.w700,
                              color:      Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── Location + live distance ───────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_rounded,
                          color: _kOrange, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              listing.distanceKm != null
                                  ? '${listing.location} • '
                                    '${l10n.kmAway(listing.distanceKm!.toStringAsFixed(1))}'
                                  : listing.location,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                                height: 1.4,
                              ),
                            ),
                            if (hasLiveLocation &&
                                _effectiveLocation != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Your location: ${_effectiveLocation!.displayName}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ] else ...[
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () => _initLocationTracking(
                                  requestIfNeeded: true,
                                ),
                                child: Text(
                                  l10n.useCurrentLocation,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: _kGreen,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(height: 1),
                  const SizedBox(height: 20),

                  // ── Details ──────────────────────────
                  const _SectionTitle(text: 'Details'),
                  const SizedBox(height: 12),
                  _DetailCard(listing: listing),

                  const SizedBox(height: 20),
                  const Divider(height: 1),
                  const SizedBox(height: 20),

                  // ── Description ──────────────────────
                  const _SectionTitle(text: 'Description'),
                  const SizedBox(height: 10),
                  Text(
                    listing.localizedDescription(locale),
                    style: TextStyle(
                      fontSize: 14,
                      color:    Colors.grey.shade700,
                      height:   1.6,
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(height: 1),
                  const SizedBox(height: 20),

                  // ── Seller ───────────────────────────
                  const _SectionTitle(text: 'Posted by'),
                  const SizedBox(height: 12),
                  _SellerCard(
                    listing: listing,
                    onViewProfile: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            SellerProfileScreen(
                              listing:      listing,
                              userLocation: _effectiveLocation,
                            ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(height: 1),
                  const SizedBox(height: 20),

                  // ── Map ──────────────────────────────
                  const _SectionTitle(text: 'Ad Posted at'),
                  const SizedBox(height: 12),
                  _ListingMap(location: listing.location),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── White icon button helper ─────────────────────────────
  Widget _whiteIconBtn(IconData icon) {
    return Container(
      width:  38, height: 38,
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(19),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, size: 18, color: _kGreen),
    );
  }

  // ── Image slider ─────────────────────────────────────────
  Widget _buildSlider() {
    return Stack(
      fit: StackFit.expand,
      children: [

        // ── CarouselSlider ────────────────────────────────
        CarouselSlider.builder(
          itemCount: _images.length,
          options: CarouselOptions(
            height:               double.infinity,
            viewportFraction:     1.0,
            enableInfiniteScroll: false,
            enlargeCenterPage:    false,
            scrollPhysics:        const BouncingScrollPhysics(),
            onPageChanged: (i, _) {
              _imgIdx.value = i;
              _pageController.jumpToPage(i);
            },
          ),
          itemBuilder: (context, i, _) => GestureDetector(
            onTap: () => _openFullScreen(i),
            child: Hero(
              tag: 'img_$i',
              child: Image.asset(
                _images[i],
                fit:           BoxFit.cover,
                width:         double.infinity,
                filterQuality: FilterQuality.high,
                errorBuilder:  (_, __, ___) => Container(
                  color: const Color(0xFFF3F7F0),
                  child: Center(
                    child: Icon(Icons.image_not_supported_rounded,
                        size: 60, color: Colors.grey.shade400),
                  ),
                ),
              ),
            ),
          ),
        ),

        // ── Gradient overlay ──────────────────────────────
        IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin:  Alignment.topCenter,
                end:    Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.30),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.22),
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),
        ),

        // ── Dots + counter + zoom hint ────────────────────
        ValueListenableBuilder<int>(
          valueListenable: _imgIdx,
          builder: (context, currentIdx, _) {
            return Stack(
              fit: StackFit.expand,
              children: [

                // Tap to zoom hint
                Positioned(
                  bottom: 36, left: 0, right: 0,
                  child: IgnorePointer(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color:        Colors.black.withOpacity(0.40),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.zoom_in_rounded,
                                color: Colors.white, size: 13),
                            SizedBox(width: 4),
                            Text('Tap to zoom',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Dot indicators — active dot uses orange gradient
                Positioned(
                  bottom: 14, left: 0, right: 60,
                  child: IgnorePointer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _images.length,
                        (i) {
                          final isActive = i == currentIdx;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width:  isActive ? 22 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              gradient:     isActive ? _kOrangeGrad : null,
                              color:        isActive ? null : Colors.white.withOpacity(0.45),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Page counter — orange gradient pill, bottom-right
                Positioned(
                  bottom: 10, right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      gradient:     _kOrangeGrad,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${currentIdx + 1}/${_images.length}',
                      style: const TextStyle(
                        color:      Colors.white,
                        fontSize:   12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SELLER CARD
// ─────────────────────────────────────────────────────────────
class _SellerCard extends StatelessWidget {
  const _SellerCard({
    required this.listing,
    required this.onViewProfile,
  });
  final Listing      listing;
  final VoidCallback onViewProfile;

  @override
  Widget build(BuildContext context) {
    final initials = listing.sellerName.isNotEmpty
        ? listing.sellerName.trim().split(' ')
            .take(2).map((w) => w[0].toUpperCase()).join()
        : '?';

    return Container(
      decoration: BoxDecoration(
        color:        const Color(0xFFF8FBF8),
        borderRadius: BorderRadius.circular(14),
        border:       Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [

          // ── Avatar + name + farmer + verified ────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color:        _kGreen.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                        color: _kGreen.withOpacity(0.25), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: const TextStyle(
                        fontSize:   20,
                        fontWeight: FontWeight.w800,
                        color:      _kGreen,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Posted by',
                        style: TextStyle(
                          fontSize:   11,
                          color:      Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        listing.sellerName,
                        style: const TextStyle(
                          fontSize:   16,
                          fontWeight: FontWeight.w800,
                          color:      AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color:        _kGreen.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: _kGreen.withOpacity(0.30),
                              width: 1),
                        ),
                        child: Text(
                          'Farmer',
                          style: TextStyle(
                            fontSize:   12,
                            fontWeight: FontWeight.w700,
                            color:      _kGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (listing.isVerified)
                  Container(
                    padding:     const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:        _kOrange.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.verified_rounded,
                        color: _kOrange, size: 22),
                  ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade200),

          // ── Member since ─────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.person_outline_rounded,
                    size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 8),
                Text(
                  'Member since  ',
                  style: TextStyle(
                    fontSize:   13,
                    color:      Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  listing.memberSinceLabel,
                  style: const TextStyle(
                    fontSize:   13,
                    fontWeight: FontWeight.w800,
                    color:      AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade200),

          // ── View profile ─────────────────────────────
          InkWell(
            onTap:        onViewProfile,
            borderRadius: const BorderRadius.only(
              bottomLeft:  Radius.circular(14),
              bottomRight: Radius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Text(
                    'View Seller Profile',
                    style: TextStyle(
                      fontSize:   14,
                      fontWeight: FontWeight.w700,
                      color:      AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: Colors.grey.shade500),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// LISTING MAP
// ─────────────────────────────────────────────────────────────
class _ListingMap extends StatefulWidget {
  const _ListingMap({required this.location});

  final String location;

  @override
  State<_ListingMap> createState() => _ListingMapState();
}

class _ListingMapState extends State<_ListingMap> {
  late Future<({double lat, double lng})?> _coordinates;
  var _zoom = 13;

  @override
  void initState() {
    super.initState();
    _coordinates = LocationService.coordinatesForLocation(widget.location);
  }

  @override
  void didUpdateWidget(covariant _ListingMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location != widget.location) {
      _coordinates = LocationService.coordinatesForLocation(widget.location);
    }
  }

  Future<void> _openMaps(({double lat, double lng}) coordinates) async {
    final uri = Uri.https(
      'www.google.com',
      '/maps/search/',
      {
        'api': '1',
        'query': '${coordinates.lat},${coordinates.lng}',
      },
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _buildTiles(
    BoxConstraints constraints,
    ({double lat, double lng}) coordinates,
  ) {
    const tileSize = 256.0;
    final tileCount = math.pow(2, _zoom).toDouble();
    final worldX = (coordinates.lng + 180) / 360 * tileCount;
    final latitude = coordinates.lat.clamp(-85.0511, 85.0511);
    final latitudeRadians = latitude * math.pi / 180;
    final worldY = (1 -
            math.log(
                  math.tan(latitudeRadians) +
                      (1 / math.cos(latitudeRadians)),
                ) /
                math.pi) /
        2 *
        tileCount;
    final centerTileX = worldX.floor();
    final centerTileY = worldY.floor();
    final baseLeft =
        constraints.maxWidth / 2 - (worldX - centerTileX) * tileSize;
    final baseTop =
        constraints.maxHeight / 2 - (worldY - centerTileY) * tileSize;

    return Stack(
      fit: StackFit.expand,
      children: [
        for (var xOffset = -1; xOffset <= 1; xOffset++)
          for (var yOffset = -1; yOffset <= 1; yOffset++)
            Positioned(
              left: baseLeft + xOffset * tileSize,
              top: baseTop + yOffset * tileSize,
              width: tileSize,
              height: tileSize,
              child: Image.network(
                'https://tile.openstreetmap.org/$_zoom/'
                '${centerTileX + xOffset}/${centerTileY + yOffset}.png',
                headers: const {
                  'User-Agent': 'KrishiX/in.krishix.krishix',
                },
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
                errorBuilder: (_, __, ___) => ColoredBox(
                  color: Colors.grey.shade200,
                ),
              ),
            ),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 44),
            child: Icon(
              Icons.location_on_rounded,
              color: _kOrange,
              size: 46,
              shadows: [
                Shadow(color: Colors.black26, blurRadius: 5),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<({double lat, double lng})?>(
      future: _coordinates,
      builder: (context, snapshot) {
        final coordinates = snapshot.data;

        if (snapshot.connectionState != ConnectionState.done) {
          return const _MapFrame(
            child: Center(
              child: CircularProgressIndicator(color: _kGreen),
            ),
          );
        }

        if (coordinates == null) {
          return _MapFrame(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_off_outlined,
                      color: Colors.grey.shade500,
                      size: 30,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Map unavailable for ${widget.location}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return _MapFrame(
          child: Stack(
            children: [
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) =>
                      _buildTiles(constraints, coordinates),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: IgnorePointer(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 260),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 5),
                        ],
                      ),
                      child: Text(
                        widget.location,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Column(
                  children: [
                    _MapZoomButton(
                      icon: Icons.add,
                      onPressed: _zoom < 17
                          ? () => setState(() => _zoom++)
                          : null,
                    ),
                    const SizedBox(height: 4),
                    _MapZoomButton(
                      icon: Icons.remove,
                      onPressed: _zoom > 5
                          ? () => setState(() => _zoom--)
                          : null,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  color: Colors.white.withOpacity(0.85),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: const Text(
                    '© OpenStreetMap contributors',
                    style: TextStyle(fontSize: 9, color: Colors.black87),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: FilledButton.icon(
                  onPressed: () => _openMaps(coordinates),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: _kGreen,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  icon: const Icon(Icons.directions_outlined, size: 16),
                  label: const Text(
                    'Open Maps',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MapZoomButton extends StatelessWidget {
  const _MapZoomButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData      icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color:        Colors.white,
      elevation:    3,
      borderRadius: BorderRadius.circular(6),
      child: IconButton(
        onPressed:   onPressed,
        tooltip:     icon == Icons.add ? 'Zoom in' : 'Zoom out',
        constraints: const BoxConstraints.tightFor(width: 36, height: 36),
        padding:     EdgeInsets.zero,
        icon:        Icon(icon, color: _kGreen, size: 20),
      ),
    );
  }
}

class _MapFrame extends StatelessWidget {
  const _MapFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height:       220,
      width:        double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color:        Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border:       Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SECTION TITLE
// ─────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize:   16,
        fontWeight: FontWeight.w800,
        color:      AppColors.textPrimary,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// DETAIL CARD
// ─────────────────────────────────────────────────────────────
class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.listing});
  final Listing listing;

  @override
  Widget build(BuildContext context) {
    final rows = listing.detailRows();
    if (rows.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color:        const Color(0xFFF8FBF8),
        borderRadius: BorderRadius.circular(14),
        border:       Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: rows.asMap().entries.map((e) {
          return _DetailRowWidget(
            label:  e.value.key,
            value:  e.value.value,
            isLast: e.key == rows.length - 1,
          );
        }).toList(),
      ),
    );
  }
}

class _DetailRowWidget extends StatelessWidget {
  const _DetailRowWidget({
    required this.label,
    required this.value,
    required this.isLast,
  });
  final String label;
  final String value;
  final bool   isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(
                color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontSize:   13,
                fontWeight: FontWeight.w600,
                color:      Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize:   13,
                fontWeight: FontWeight.w700,
                color:      AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// BOTTOM CTA BAR
// ─────────────────────────────────────────────────────────────
class _BottomCTA extends StatelessWidget {
  const _BottomCTA({
    required this.onCall,
    required this.onChat,
    this.sellerPhone,
  });
  final VoidCallback onCall;
  final VoidCallback onChat;
  final String?      sellerPhone;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8 + bottomPad),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 1)),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset:     const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 46,
              child: OutlinedButton.icon(
                onPressed: onCall,
                icon:  const Icon(Icons.call_rounded, size: 17),
                label: const Text('Call',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _kGreen,
                  side:  const BorderSide(color: _kGreen, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 46,
              child: ElevatedButton.icon(
                onPressed: onChat,
                icon:  const Icon(Icons.chat_rounded, size: 17),
                label: const Text('Chat with Seller',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kGreen,
                  foregroundColor: Colors.white,
                  elevation:       0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
