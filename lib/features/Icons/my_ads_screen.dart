// lib/features/my_ads/my_ads_screen.dart

import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/core/models/user_location.dart';
import 'package:krishix/features/listings/listing_detail_screen.dart';
import 'package:krishix/l10n/app_localizations.dart';

const Color _kGreen = AppColors.primaryGreen;

// ─────────────────────────────────────────────────────────────
// MOCK ADS
// ─────────────────────────────────────────────────────────────
final List<Listing> _sampleAds = [
  Listing(
    id: 'ad_001', title: 'Maize (Makka) – 15 Quintal',
    titleHi: 'मक्का – 15 क्विंटल', titleMr: 'मका – १५ क्विंटल', titleGu: 'મકાઈ – 15 ક્વિ.',
    description: 'Fresh maize harvest, 15 quintal available. Quality A-grade.',
    descriptionHi: 'ताजी मक्का, A-ग्रेड.', descriptionMr: 'ताजी मका, अ-श्रेणी.',
    price: 18000, location: 'Aurangabad, MH', category: ListingCategory.crops,
    type: ListingType.sell, isVerified: true, sellerName: 'Ramesh Patil',
    sellerPhone: '+91 98765 43210', imageEmoji: '🌽', distanceKm: 3.2,
    viewCount: 142, likeCount: 18,
    postedOn: DateTime(2026, 6, 23), sellerMemberSince: DateTime(2024, 1, 1),
  ),
  Listing(
    id: 'ad_002', title: 'Mahindra 575 DI Tractor – 2019',
    titleHi: 'महिंद्रा 575 DI ट्रैक्टर', titleMr: 'महिंद्रा ट्रॅक्टर – २०१९',
    description: 'Well maintained 2019 Mahindra 575 DI. 4500 hrs. New tyres.',
    descriptionHi: '2019 महिंद्रा, 4500 घंटे.', descriptionMr: '2019 महिंद्रा, ४५०० तास.',
    price: 420000, location: 'Jalna, MH', category: ListingCategory.tractors,
    type: ListingType.sell, isVerified: false, sellerName: 'Suresh Deshmukh',
    sellerPhone: '+91 91234 56789', imageEmoji: '🚜', distanceKm: 12.5,
    viewCount: 0, likeCount: 0,
    postedOn: DateTime(2026, 6, 20), sellerMemberSince: DateTime(2023, 8, 1),
  ),
  Listing(
    id: 'ad_003', title: 'Murrah Buffalo – High Milk Yield',
    titleHi: 'मुर्रा भैंस – उच्च दुग्ध', titleMr: 'मुर्रा म्हैस – उच्च दूध',
    description: 'Healthy Murrah buffalo, 14 litres/day. Vaccinated, 3 yrs old.',
    descriptionHi: 'मुर्रा भैंस, 14 लीटर/दिन.', descriptionMr: 'मुर्रा म्हैस, १४ लिटर.',
    price: 85000, location: 'Beed, MH', category: ListingCategory.livestock,
    type: ListingType.sell, isVerified: true, sellerName: 'Vijay Shinde',
    sellerPhone: '+91 70000 12345', imageEmoji: '🐃', distanceKm: 28.0,
    viewCount: 87, likeCount: 5,
    postedOn: DateTime(2026, 5, 1), sellerMemberSince: DateTime(2024, 3, 1),
  ),
  Listing(
    id: 'ad_004', title: 'JCB 3DX Backhoe – On Rent',
    titleHi: 'JCB 3DX बैकहो – किराये पर', titleMr: 'जेसीबी ३डीएक्स – भाड्याने',
    description: 'JCB 3DX daily/weekly rent. Experienced operator included.',
    descriptionHi: 'JCB दैनिक/साप्ताहिक किराये.', descriptionMr: 'जेसीबी दैनिक भाड्याने.',
    price: 4500, location: 'Osmanabad, MH', category: ListingCategory.rental,
    type: ListingType.rent, rentalDuration: 'Day',
    isVerified: true, sellerName: 'Prakash More',
    sellerPhone: '+91 88001 23456', imageEmoji: '🏗️', distanceKm: 7.8,
    viewCount: 211, likeCount: 31,
    postedOn: DateTime(2026, 6, 18), sellerMemberSince: DateTime(2023, 5, 1),
  ),
];

const Map<ListingCategory, List<String>> _catImages = {
  ListingCategory.livestock: ['assets/images/cow1.jpeg',     'assets/images/cow2.jpeg'],
  ListingCategory.land:      ['assets/images/land1.jpeg',    'assets/images/land2.jpeg'],
  ListingCategory.tractors:  ['assets/images/tractor1.webp', 'assets/images/tractor2.webp'],
  ListingCategory.rental:    ['assets/images/rent2.jpeg',    'assets/images/jcb1.jpeg'],
  ListingCategory.crops:     ['assets/images/mango.jpeg',    'assets/images/veg1.jpeg'],
};

String _imgFor(ListingCategory cat, int idx) {
  final imgs = _catImages[cat];
  if (imgs == null || imgs.isEmpty) return 'assets/images/seeds1.jpeg';
  return imgs[idx % imgs.length];
}

String _formatPrice(int price) {
  final v = price.toString();
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

String _fmtDate(DateTime dt) {
  const m = ['JAN','FEB','MAR','APR','MAY','JUN',
              'JUL','AUG','SEP','OCT','NOV','DEC'];
  return '${dt.day} ${m[dt.month - 1]}  ${dt.year}';
}

// ── Status ────────────────────────────────────────────────────
enum _St { active, pending, expired }

extension _StX on _St {
  String get label => const ['ACTIVE','PENDING','EXPIRED'][index];
  Color  get color => [_kGreen, const Color(0xFF1565C0), Colors.grey.shade600][index];

  String get msg => [
    'Your ad is live and visible to buyers.',
    'This ad is being processed and it will be live soon',
    'This ad has expired. Renew it to get more responses.',
  ][index];
}

_St _stFor(int i) => _St.values[i % 3];

// ═══════════════════════════════════════════════════════════════
// SCREEN
// ═══════════════════════════════════════════════════════════════
class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({super.key, required this.userLocation});
  final UserLocation userLocation;

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  late final List<Listing> _ads;
  bool _expanded = true;

  @override
  void initState() {
    super.initState();
    _ads = List.of(_sampleAds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F2),
      appBar: _appBar(),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _sectionHeader(),
          // ── Cards OR empty state ──────────────────────
          if (_ads.isEmpty)
            _emptyBody()
          else if (_expanded)
            for (var i = 0; i < _ads.length; i++) ...[
              const SizedBox(height: 10),
              _AdCard(
                listing:      _ads[i],
                status:       _stFor(i),
                img:          _imgFor(_ads[i].category, i),
                loc:          widget.userLocation,
                onEdit:       () => _snack('Edit: ${_ads[i].title}'),
                onDelete:     () => _confirmDelete(i),
                onSellFaster: () => _snack('Boost Ad — coming soon!'),
              ),
            ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── App bar ──────────────────────────────────────────────
  PreferredSizeWidget _appBar() => AppBar(
        backgroundColor:           _kGreen,
        foregroundColor:           Colors.white,
        elevation:                 0,
        centerTitle:               true,
        automaticallyImplyLeading: false,
        title: const Text('MY ADS',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w800,
                color: Colors.white, letterSpacing: 1.0)),
      );

  // ── Section header ───────────────────────────────────────
  Widget _sectionHeader() {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        child: Row(
          children: [
            Text(
              'View all (${_ads.length})',
              style: const TextStyle(
                  fontSize:   16,
                  fontWeight: FontWeight.w700,
                  color:      AppColors.textPrimary),
            ),
            const SizedBox(width: 6),
            AnimatedRotation(
              turns:    _expanded ? 0 : -0.5,
              duration: const Duration(milliseconds: 200),
              child: Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey.shade600, size: 22),
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty body ────────────────────────────────────────────
  Widget _emptyBody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
      child: Column(
        children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              color:  _kGreen.withOpacity(0.08), shape: BoxShape.circle,
              border: Border.all(color: _kGreen.withOpacity(0.15), width: 2),
            ),
            child: Icon(Icons.storefront_outlined,
                size: 44, color: _kGreen.withOpacity(0.55)),
          ),
          const SizedBox(height: 20),
          const Text("You haven't listed anything yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text('Let go of what you don\'t use anymore',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity, height: 48,
            child: ElevatedButton(
              onPressed: () => _snack('Post Ad — coming soon!'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kGreen, foregroundColor: Colors.white,
                elevation: 0, shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Start selling',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: _kGreen,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ));

  void _confirmDelete(int idx) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Ad',
            style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        content: Text('Delete "${_ads[idx].title}"?',
            style: TextStyle(color: Colors.grey.shade700)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            onPressed: () { Navigator.pop(ctx); setState(() => _ads.removeAt(idx)); },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, foregroundColor: Colors.white,
              elevation: 0, shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// AD CARD  — matches OLX card layout exactly in KrishiX colours
//
// ┌──────────────────────────────────────────┐
// │  FROM: 23 JUN 2026                  •••  │  ← header row
// ├──────────────────────────────────────────┤
// │ [img] Title                              │
// │       ₹ price                            │  ← image + info
// │       👁 Views: -  |  ♥ Likes: -         │
// ├──────────────────────────────────────────┤
// │ [PENDING]                                │  ← status badge
// │ | This ad is being processed…            │  ← left-bar msg
// │                        [Sell faster now] │  ← CTA button
// └──────────────────────────────────────────┘
// ─────────────────────────────────────────────────────────────
class _AdCard extends StatelessWidget {
  const _AdCard({
    required this.listing,
    required this.status,
    required this.img,
    required this.loc,
    required this.onEdit,
    required this.onDelete,
    required this.onSellFaster,
  });
  final Listing      listing;
  final _St          status;
  final String       img;
  final UserLocation loc;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSellFaster;

  @override
  Widget build(BuildContext context) {
    final locale   = Localizations.localeOf(context);
    final l10n     = AppLocalizations.of(context)!;
    final postedOn = listing.postedOn ?? DateTime.now();
    final views    = listing.viewCount ?? 0;
    final likes    = listing.likeCount ?? 0;

    return Container(
        margin:      const EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration:  BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.circular(8),
          border:        Border.all(color: Colors.grey.shade200, width: 0.8),
          boxShadow: [
            BoxShadow(
              color:      Colors.black.withOpacity(0.05),
              blurRadius: 6, offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── ROW 1: Posted On · ··· · ACTIVE badge ───────
            Container(
              color:   Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Posted On: ',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500)),
                  Text(_fmtDate(postedOn),
                      style: const TextStyle(
                          fontSize:      12,
                          fontWeight:    FontWeight.w800,
                          color:         AppColors.textPrimary,
                          letterSpacing: 0.2)),
                  const Spacer(),

                   // Status badge — rightmost
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color:        status.color,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      status.label,
                      style: const TextStyle(
                          fontSize:      11,
                          fontWeight:    FontWeight.w800,
                          color:         Colors.white,
                          letterSpacing: 0.5),
                    ),
                  ),
                  // ··· popup menu
                  SizedBox(
                    width: 30, height: 30,
                    child: PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.more_horiz_rounded,
                          color: Colors.grey.shade500, size: 20),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      onSelected: (v) {
                        if (v == 'edit')   onEdit();
                        if (v == 'delete') onDelete();
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(children: [
                            Icon(Icons.edit_outlined, size: 16,
                                color: AppColors.textPrimary),
                            SizedBox(width: 10),
                            Text('Edit Ad'),
                          ]),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(children: [
                            Icon(Icons.delete_outline_rounded,
                                size: 16, color: Colors.red),
                            SizedBox(width: 10),
                            Text('Delete',
                                style: TextStyle(color: Colors.red)),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                 
                ],
              ),
            ),

            Divider(height: 1, thickness: 1, color: Colors.grey.shade200),

            // ── ROW 2: Thumbnail + Title / Price / Views — ONLY this opens detail
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => ListingDetailScreen(
                    listing: listing, userLocation: loc),
              )),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail
                Container(
  width: 95, height: 90,
  margin: const EdgeInsets.all(10),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.grey.shade200, width: 0.8),
  ),
  clipBehavior: Clip.antiAlias,
  child: Image.asset(
    img,
    fit:           BoxFit.cover,
    filterQuality: FilterQuality.medium,
    errorBuilder: (_, __, ___) => Container(
      color: const Color(0xFFE8F5E9),
      child: Center(child: Text(listing.imageEmoji,
          style: const TextStyle(fontSize: 30))),
    ),
  ),
),
                // Info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          listing.displayTitle(l10n),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize:   15,
                              fontWeight: FontWeight.w800,
                              color:      AppColors.textPrimary,
                              height:     1.3),
                        ),
                        const SizedBox(height: 5),
                        // Price
                        Row(
                          children: [
                            Text(
                              _formatPrice(listing.price),
                              style: TextStyle(
                                  fontSize:   14,
                                  fontWeight: FontWeight.w700,
                                  color:      Colors.grey.shade800),
                            ),
                            if (listing.type == ListingType.rent &&
                                listing.rentalDuration != null) ...[
                              const SizedBox(width: 3),
                              Text('/ ${listing.rentalDuration!.toLowerCase()}',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade500)),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Views | Likes
                        Row(
                          children: [
                            Icon(Icons.remove_red_eye_outlined,
                                size: 14, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text(
                              'Views: ${views > 0 ? views : '-'}',
                              style: TextStyle(
                                  fontSize:   12,
                                  fontWeight: FontWeight.w500,
                                  color:      Colors.grey.shade600),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8),
                              child: Container(
                                  width: 1, height: 12,
                                  color: Colors.grey.shade400),
                            ),
                            Icon(Icons.favorite_rounded,
                                size:  14,
                                color: likes > 0
                                    ? Colors.red
                                    : Colors.grey.shade400),
                            const SizedBox(width: 4),
                            Text(
                              'Likes: ${likes > 0 ? likes : '-'}',
                              style: TextStyle(
                                  fontSize:   12,
                                  fontWeight: FontWeight.w500,
                                  color:      Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              ),   // end Row
            ),   // end GestureDetector

            Divider(height: 1, thickness: 1, color: Colors.grey.shade200),

            // ── ROW 3: Left-bar msg (left) + Sell faster now (right) ──
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left accent bar + status message
                  Expanded(
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: 3,
                            decoration: BoxDecoration(
                              color:        status.color,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              status.msg,
                              style: TextStyle(
                                  fontSize: 12,
                                  color:    Colors.grey.shade600,
                                  height:   1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Sell faster now button
                  OutlinedButton(
                    onPressed: onSellFaster,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side:  BorderSide(
                          color: Colors.grey.shade400, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      minimumSize:   Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Sell faster now',
                      style: TextStyle(
                          fontSize:   13,
                          fontWeight: FontWeight.w800,
                          color:      AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}