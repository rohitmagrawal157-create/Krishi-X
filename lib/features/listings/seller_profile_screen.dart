// lib/features/listings/seller_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/data/mock_listings.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/core/models/user_location.dart';
import 'package:krishix/core/services/user_auth_service.dart';
import 'package:krishix/features/listings/listing_detail_screen.dart';
import 'package:krishix/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color _kGreen  = AppColors.primaryGreen;
const Color _kOrange = Color(0xFFF57C00);

const Map<ListingCategory, List<String>> _categoryImages = {
  ListingCategory.livestock: ['assets/images/cow1.jpeg', 'assets/images/cow2.jpeg'],
  ListingCategory.land:      ['assets/images/land1.jpeg', 'assets/images/land2.jpeg'],
  ListingCategory.tractors:  ['assets/images/tractor1.webp', 'assets/images/tractor2.webp', 'assets/images/machine1.jpeg'],
  ListingCategory.rental:    ['assets/images/rent2.jpeg', 'assets/images/jcb1.jpeg', 'assets/images/machine1.jpeg'],
  ListingCategory.crops:     ['assets/images/mango.jpeg', 'assets/images/veg1.jpeg', 'assets/images/veg2.jpeg'],
};

String _imageFor(ListingCategory cat, int idx) {
  final imgs = _categoryImages[cat];
  if (imgs == null || imgs.isEmpty) return 'assets/images/seeds1.jpeg';
  return imgs[idx % imgs.length];
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

String _formatCount(int value) {
  if (value >= 1000) {
    final compact = value / 1000;
    return '${compact.toStringAsFixed(compact >= 10 ? 0 : 1)}K';
  }
  return '$value';
}

String _formatMonthYear(DateTime date) {
  const months = [
    'Jan','Feb','Mar','Apr','May','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec',
  ];
  return '${months[date.month - 1]} ${date.year}';
}

DateTime? _earliestDate(Iterable<DateTime?> dates) {
  DateTime? earliest;
  for (final date in dates) {
    if (date == null) continue;
    if (earliest == null || date.isBefore(earliest)) earliest = date;
  }
  return earliest;
}

class _SavedProfile {
  const _SavedProfile({
    required this.name,
    required this.phone,
    required this.previousPhone,
    required this.loggedInPhone,
  });

  final String name;
  final String phone;
  final String previousPhone;
  final String loggedInPhone;

  bool ownsSellerPhone(String sellerPhone) {
    final seller = UserAuthService.normalizePhone(sellerPhone);
    if (seller.isEmpty) return false;
    return seller == phone ||
        seller == previousPhone ||
        seller == loggedInPhone;
  }
}

Future<_SavedProfile> _loadSavedProfile() async {
  final loggedInPhone =
      UserAuthService.normalizePhone(await UserAuthService.getLoggedInPhone() ?? '');
  var name = '';
  var phone = loggedInPhone;
  var previousPhone = '';

  try {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString('user_name')?.trim() ?? '';
    final savedPhone = prefs.getString('user_phone') ?? '';
    final normalizedSaved = UserAuthService.normalizePhone(savedPhone);
    if (normalizedSaved.isNotEmpty) phone = normalizedSaved;
    previousPhone = UserAuthService.normalizePhone(
      prefs.getString('user_previous_phone') ?? '',
    );
  } catch (_) {}

  final registered = await UserAuthService.findUser(phone);
  if (name.isEmpty) name = registered?.fullName.trim() ?? '';

  return _SavedProfile(
    name:          name,
    phone:         phone,
    previousPhone: previousPhone,
    loggedInPhone: loggedInPhone,
  );
}

// ═══════════════════════════════════════════════════════════════
// SELLER PROFILE SCREEN
// ═══════════════════════════════════════════════════════════════
class SellerProfileScreen extends StatelessWidget {
  const SellerProfileScreen({
    super.key,
    required this.listing,
    this.userLocation,
  });

  final Listing       listing;
  final UserLocation? userLocation;

  String get _phone    => listing.sellerPhone ?? '';
  String get _sellerId => listing.sellerId ?? '';

  Future<void> _callSeller(BuildContext context, String phone) async {
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:  Text('No phone number available.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final digits = UserAuthService.normalizePhone(phone);
    final uri    = Uri(scheme: 'tel', path: digits);
    final ok     = await launchUrl(uri);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:  Text('Could not start the call.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _copyPhone(BuildContext context, String phone) {
    if (phone.isEmpty) return;
    Clipboard.setData(
      ClipboardData(text: '+91 ${UserAuthService.normalizePhone(phone)}'),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:  Text('Phone number copied'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder<_SavedProfile>(
      future: _loadSavedProfile(),
      builder: (context, snapshot) {
        final profile = snapshot.data ??
            const _SavedProfile(
              name: '', phone: '', previousPhone: '', loggedInPhone: '',
            );
        final ownsThisSeller  = profile.ownsSellerPhone(_phone);
        final sellerName      = ownsThisSeller && profile.name.isNotEmpty
            ? profile.name
            : listing.sellerName;
        final sellerPhone     = ownsThisSeller && profile.phone.isNotEmpty
            ? profile.phone
            : _phone;
        final phoneDisplay    = sellerPhone.isNotEmpty
            ? '+91 ${UserAuthService.normalizePhone(sellerPhone)}'
            : 'Not available';
        final ads             = _sellerId.isNotEmpty
            ? MockListings.bySeller(_sellerId)
            : <Listing>[];
        final sellerListings  = ads.isNotEmpty ? ads : <Listing>[listing];
        final memberSince     = _earliestDate(
          sellerListings.expand((ad) => [ad.sellerMemberSince, ad.postedOn]),
        );
        final memberSinceLabel = memberSince != null
            ? _formatMonthYear(memberSince)
            : listing.memberSinceLabel;
        final totalViews = sellerListings.fold<int>(
          0, (sum, ad) => sum + (ad.viewCount ?? 0),
        );
        final initials = sellerName.isNotEmpty
            ? sellerName.trim().split(' ')
                .take(2).map((w) => w[0].toUpperCase()).join()
            : '?';

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: _kGreen,
            foregroundColor: Colors.white,
            elevation:       0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 20, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('Seller Profile',
                style: TextStyle(fontWeight: FontWeight.w800)),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            children: [

              // ── Identity card ────────────────────────────
              Container(
                width:   double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:        const Color(0xFFF8FBF8),
                  borderRadius: BorderRadius.circular(16),
                  border:       Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 76, height: 76,
                      decoration: BoxDecoration(
                        color:        _kGreen.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(38),
                        border: Border.all(
                            color: _kGreen.withOpacity(0.25), width: 2),
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: const TextStyle(
                            fontSize:   28,
                            fontWeight: FontWeight.w800,
                            color:      _kGreen,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      sellerName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize:   20,
                        fontWeight: FontWeight.w800,
                        color:      AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Wrap(
                      alignment:  WrapAlignment.center,
                      spacing:    8,
                      runSpacing: 8,
                      children: [
                        if (listing.isVerified)
                          _Chip(
                            icon:  Icons.verified_rounded,
                            label: l10n.verifiedSeller,
                            color: _kOrange,
                          ),
                        const _Chip(
                          emoji: '',
                          label: 'Farmer',
                          color: _kGreen,
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),
                    Divider(color: Colors.grey.shade200, height: 1),
                    const SizedBox(height: 16),

                    _ProfileStatsRow(
                      adsCount: sellerListings.length,
                      views:    totalViews,
                    ),

                    const SizedBox(height: 16),

                    _InfoTile(
                      icon:  Icons.call_rounded,
                      label: 'Mobile Number',
                      value: phoneDisplay,
                      trailing: sellerPhone.isNotEmpty
                          ? GestureDetector(
                              onTap: () => _copyPhone(context, sellerPhone),
                              child: Icon(Icons.copy_rounded,
                                  size: 18, color: Colors.grey.shade500),
                            )
                          : null,
                    ),

                    const SizedBox(height: 14),

                    _InfoTile(
                      icon:  Icons.calendar_today_rounded,
                      label: 'Member Since',
                      value: memberSinceLabel,
                    ),

                    const SizedBox(height: 14),

                    _InfoTile(
                      icon:  Icons.local_offer_rounded,
                      label: 'Total Ads',
                      value: '${sellerListings.length} '
                          '${sellerListings.length == 1 ? 'ad' : 'ads'}',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── All ads header ───────────────────────────
              Row(
                children: [
                  Text(
                    'All Ads by $sellerName',
                    style: const TextStyle(
                      fontSize:   16,
                      fontWeight: FontWeight.w800,
                      color:      AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  // if (ads.isNotEmpty)
                  //   Container(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 10, vertical: 4),
                  //     decoration: BoxDecoration(
                  //       color:        _kGreen.withOpacity(0.10),
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     // child: Text(
                  //     //   '${ads.length} ads',
                  //     //   style: TextStyle(
                  //     //     fontSize:   12,
                  //     //     fontWeight: FontWeight.w700,
                  //     //     color:      _kGreen,
                  //     //   ),
                  //     // ),
                  //   ),
                ],
              ),

              const SizedBox(height: 14),

              if (ads.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'No other ads by this seller.',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ),
                )
              else
                _SellerAdsList(ads: ads, userLocation: userLocation),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CHIP
// ─────────────────────────────────────────────────────────────
class _Chip extends StatelessWidget {
  const _Chip({
    this.icon,
    this.emoji,
    required this.label,
    required this.color,
  });
  final IconData? icon;
  final String?   emoji;
  final String    label;
  final Color     color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:        color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border:       Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)  Icon(icon, size: 14, color: color),
          if (emoji != null) Text(emoji!, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize:   12,
              fontWeight: FontWeight.w700,
              color:      color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PROFILE STATS ROW
// ─────────────────────────────────────────────────────────────
class _ProfileStatsRow extends StatelessWidget {
  const _ProfileStatsRow({
    required this.adsCount,
    required this.views,
  });
  final int adsCount;
  final int views;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ProfileStat(
            icon:  Icons.local_offer_rounded,
            label: 'Ads',
            value: _formatCount(adsCount),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ProfileStat(
            icon:  Icons.visibility_rounded,
            label: 'Views',
            value: _formatCount(views),
          ),
        ),
      ],
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String   label;
  final String   value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 68),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:       Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 17, color: _kGreen),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize:   14,
              fontWeight: FontWeight.w900,
              color:      AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize:   10,
              fontWeight: FontWeight.w700,
              color:      Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// INFO TILE
// ─────────────────────────────────────────────────────────────
class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });
  final IconData icon;
  final String   label;
  final String   value;
  final Widget?  trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color:        _kGreen.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 17, color: _kGreen),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize:   11,
                  color:      Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize:   14,
                  fontWeight: FontWeight.w800,
                  color:      AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SELLER ADS LIST  (replaces the old 2-column grid)
// ─────────────────────────────────────────────────────────────
class _SellerAdsList extends StatelessWidget {
  const _SellerAdsList({required this.ads, this.userLocation});
  final List<Listing>  ads;
  final UserLocation?  userLocation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < ads.length; i++) ...[
          _SellerAdCard(
            listing:      ads[i],
            imgIdx:       i,
            userLocation: userLocation,
          ),
          if (i < ads.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SELLER AD CARD  — horizontal list style matching screenshot
// Layout: [thumbnail] | [title · price · year · dot · location] | [♡]
// ─────────────────────────────────────────────────────────────
class _SellerAdCard extends StatefulWidget {
  const _SellerAdCard({
    required this.listing,
    required this.imgIdx,
    this.userLocation,
  });
  final Listing       listing;
  final int           imgIdx;
  final UserLocation? userLocation;

  @override
  State<_SellerAdCard> createState() => _SellerAdCardState();
}

class _SellerAdCardState extends State<_SellerAdCard> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final locale  = Localizations.localeOf(context);
    final l10n    = AppLocalizations.of(context)!;
    final listing = widget.listing;

    // Year — from postedOn or null
    final year = listing.postedOn?.year.toString();

    // Category label (short)
    final categoryLabel = _categoryLabel(listing.category);

    // Rental duration suffix
    final rentSuffix = listing.type == ListingType.rent &&
            listing.rentalDuration != null
        ? ' / ${listing.rentalDuration!.toLowerCase()}'
        : '';

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ListingDetailScreen(
            listing:      listing,
            imageIndex:   widget.imgIdx,
            userLocation: widget.userLocation,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.circular(14),
          border:       Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color:      Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset:     const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Thumbnail ───────────────────────────────
            SizedBox(
              width:  120,
              height: 110,
              child: Image.asset(
                _imageFor(listing.category, widget.imgIdx),
                fit:           BoxFit.cover,
                filterQuality: FilterQuality.medium,
                errorBuilder:  (_, __, ___) =>
                    const ColoredBox(color: Color(0xFFF3F7F0)),
              ),
            ),

            // ── Info ─────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:  MainAxisAlignment.center,
                  children: [

                    // Title
                    Text(
                      listing.displayTitle(l10n),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize:   14,
                        fontWeight: FontWeight.w800,
                        color:      AppColors.textPrimary,
                        height:     1.3,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Price
                    Text(
                      '${_formatPrice(listing.price)}$rentSuffix',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize:   15,
                        fontWeight: FontWeight.w900,
                        color:      _kGreen,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Year • Category  (meta row)
                    Row(
                      children: [
                        if (year != null) ...[
                          Text(
                            year,
                            style: TextStyle(
                              fontSize:   12,
                              fontWeight: FontWeight.w600,
                              color:      Colors.grey.shade500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Container(
                              width: 3, height: 3,
                              decoration: BoxDecoration(
                                color:  Colors.grey.shade400,
                                shape:  BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                        Flexible(
                          child: Text(
                            categoryLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize:   12,
                              fontWeight: FontWeight.w600,
                              color:      Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Location
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on_rounded,
                            size: 12, color: _kOrange),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            listing.shortLocation,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize:   11,
                              fontWeight: FontWeight.w600,
                              color:      Colors.grey.shade600,
                            ),
                          ),
                        ),
                        if (listing.distanceKm != null) ...[
                          Text(
                            '  •  ${listing.distanceKm!.toStringAsFixed(1)} km',
                            style: TextStyle(
                              fontSize:   11,
                              color:      Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Save / heart button ─────────────────────
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
            //   child: GestureDetector(
            //     onTap: () => setState(() => _saved = !_saved),
            //     child: Container(
            //       width:  34, height: 34,
            //       decoration: BoxDecoration(
            //         color:        _saved
            //             ? Colors.red.withOpacity(0.08)
            //             : Colors.grey.shade100,
            //         borderRadius: BorderRadius.circular(17),
            //         border: Border.all(
            //           color: _saved
            //               ? Colors.red.withOpacity(0.25)
            //               : Colors.grey.shade300,
            //           width: 1,
            //         ),
            //       ),
            //       // child: Icon(
            //       //   _saved
            //       //       ? Icons.favorite_rounded
            //       //       : Icons.favorite_border_rounded,
            //       //   size:  16,
            //       //   color: _saved ? Colors.red : _kGreen,
            //       // ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  String _categoryLabel(ListingCategory cat) {
    switch (cat) {
      case ListingCategory.tractors:  return 'Tractor';
      case ListingCategory.livestock: return 'Livestock';
      case ListingCategory.land:      return 'Farm Land';
      case ListingCategory.crops:     return 'Crops';
      case ListingCategory.rental:    return 'Rental';
      default:                        return 'Other';
    }
  }
}