import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/models/user_location.dart';
import 'package:krishix/core/widgets/mobile_option_picker.dart';
import 'package:krishix/features/icons/dealer_data.dart';
import 'package:krishix/features/icons/dealer_detail_screen.dart';
import 'package:krishix/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

const Color _kGreen  = AppColors.primaryGreen;
const Color _kOrange = Color(0xFFF57C00);

const LinearGradient _kGreenGrad = LinearGradient(
  colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
  begin:  Alignment.centerLeft,
  end:    Alignment.centerRight,
);

const LinearGradient _kOrangeGrad = LinearGradient(
  colors: [Color(0xFFFF8C00), Color(0xFFFF6B00)],
  begin:  Alignment.topLeft,
  end:    Alignment.bottomRight,
);

enum _DealerSort { topRated, nearest, nameAz }

class DealerScreen extends StatefulWidget {
  const DealerScreen({super.key, required this.userLocation});

  final UserLocation userLocation;

  @override
  State<DealerScreen> createState() => _DealerScreenState();
}

class _DealerScreenState extends State<DealerScreen> {
  _DealerSort     _sort         = _DealerSort.topRated;
  DealerCategory  _category     = DealerCategory.all;
  bool            _verifiedOnly = false;
  final _searchCtrl = TextEditingController();
  bool _showSearch  = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<AgriDealer> get _filtered {
    var list = allAgriDealers.where((d) {
      if (_category != DealerCategory.all && d.category != _category) {
        return false;
      }
      if (_verifiedOnly && !d.isVerified) return false;
      final q = _searchCtrl.text.trim().toLowerCase();
      if (q.isNotEmpty &&
          !d.name.toLowerCase().contains(q) &&
          !d.location.toLowerCase().contains(q)) {
        return false;
      }
      return true;
    }).toList();

    switch (_sort) {
      case _DealerSort.topRated:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case _DealerSort.nearest:
        break;
      case _DealerSort.nameAz:
        list.sort((a, b) => a.name.compareTo(b.name));
    }
    return list;
  }

  String _categoryLabel(AppLocalizations l10n, DealerCategory c) =>
      localizedDealerCategory(l10n, c);

  String _sortLabel(AppLocalizations l10n) {
    switch (_sort) {
      case _DealerSort.topRated:
        return l10n.dealerSortTopRated;
      case _DealerSort.nearest:
        return l10n.dealerSortNearest;
      case _DealerSort.nameAz:
        return l10n.dealerSortNameAz;
    }
  }

  String _sortChipLabel(AppLocalizations l10n) =>
      l10n.sortByOption(_sortLabel(l10n));

  Future<void> _pickCategory() async {
    final l10n = AppLocalizations.of(context)!;
    final options = dealerFilterCategories
        .map((c) => _categoryLabel(l10n, c))
        .toList(growable: false);
    final picked = await showMobileStringPicker(
      context:     context,
      title:       l10n.filterCategory,
      options:     options,
      selected:    _categoryLabel(l10n, _category),
      accentColor: _kGreen,
    );
    if (picked == null) return;
    setState(() {
      _category = dealerFilterCategories.firstWhere(
        (c) => _categoryLabel(l10n, c) == picked,
      );
    });
  }

  Future<void> _pickSort() async {
    final l10n = AppLocalizations.of(context)!;
    final options = [
      l10n.dealerSortTopRated,
      l10n.dealerSortNearest,
      l10n.dealerSortNameAz,
    ];
    final picked = await showMobileStringPicker(
      context:     context,
      title:       l10n.sortBy,
      options:     options,
      selected:    _sortLabel(l10n),
      accentColor: _kGreen,
    );
    if (picked == null) return;
    final index = options.indexOf(picked);
    setState(() {
      _sort = switch (index) {
        1 => _DealerSort.nearest,
        2 => _DealerSort.nameAz,
        _ => _DealerSort.topRated,
      };
    });
  }

  Future<void> _call(String phone) async {
    final uri = Uri.parse('tel:${phone.replaceAll(RegExp(r'\s+'), '')}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _whatsapp(String phone) async {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse('https://wa.me/91${digits.length > 10 ? digits.substring(digits.length - 10) : digits}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _bestPrice(AgriDealer dealer) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.priceRequestSentTo(dealer.name)),
        backgroundColor: _kGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _openDealer(AgriDealer dealer) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DealerDetailScreen(
          dealer:       dealer,
          userLocation: widget.userLocation,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n     = AppLocalizations.of(context)!;
    final dealers  = _filtered;
    final location = widget.userLocation.displayName;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor:           _kGreen,
        foregroundColor:           Colors.white,
        elevation:                 0,
        centerTitle:               false,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dealers,
              style: const TextStyle(
                fontSize:   18,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              location,
              style: TextStyle(
                fontSize:   12,
                fontWeight: FontWeight.w500,
                color:      Colors.white.withOpacity(0.85),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showSearch ? Icons.close_rounded : Icons.search_rounded,
              color: _kGreen,
              size: 20,
            ),
            onPressed: () => setState(() => _showSearch = !_showSearch),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape:           const CircleBorder(),
              fixedSize:       const Size(36, 36),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: () => Share.share(
              '${l10n.agriDealers}\n'
              '${l10n.shareAppDownload}: $krishiXAppLink',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Material(
            color: Colors.white,
            elevation: 1,
            shadowColor: Colors.black.withOpacity(0.06),
            child: Column(
              children: [
                if (_showSearch)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: l10n.searchDealersHint,
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          size:  20,
                          color: _kGreen,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: _kGreen, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    children: [
                      _FilterChip(
                        icon:   Icons.category_rounded,
                        label:  _categoryLabel(l10n, _category),
                        active: _category != DealerCategory.all,
                        onTap:  _pickCategory,
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        icon:   Icons.swap_vert_rounded,
                        label:  _sortChipLabel(l10n),
                        active: _sort != _DealerSort.topRated,
                        onTap:  _pickSort,
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        icon:   Icons.verified_rounded,
                        label:  l10n.verifiedSeller,
                        active: _verifiedOnly,
                        onTap:  () => setState(
                            () => _verifiedOnly = !_verifiedOnly),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: dealers.isEmpty
                ? Center(
                    child: Text(
                      l10n.noDealersFound,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 15,
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                    children: [
                      Text(
                        l10n.dealerResultsIn(dealers.length, location),
                        style: const TextStyle(
                          fontSize:   14,
                          fontWeight: FontWeight.w800,
                          color:      AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (final d in dealers) ...[
                        _DealerListCard(
                          dealer:      d,
                          onTap:       () => _openDealer(d),
                          onCall:      () => _call(d.phone),
                          onWhatsApp:  () => _whatsapp(d.phone),
                          onBestPrice: () => _bestPrice(d),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final IconData     icon;
  final String       label;
  final VoidCallback onTap;
  final bool         active;

  @override
  Widget build(BuildContext context) {
    return _DealerChip(
      icon:   icon,
      label:  label,
      active: active,
      onTap:  onTap,
    );
  }
}

/// Shared chip — orange gradient when selected, white when not.
class _DealerChip extends StatelessWidget {
  const _DealerChip({
    required this.label,
    required this.onTap,
    this.active = false,
    this.icon,
  });

  final String       label;
  final VoidCallback onTap;
  final bool         active;
  final IconData?    icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            gradient:     active ? _kOrangeGrad : null,
            color:        active ? null : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: active
                ? null
                : Border.all(color: Colors.grey.shade300),
            boxShadow: active
                ? [
                    BoxShadow(
                      color:      _kOrange.withOpacity(0.28),
                      blurRadius: 6,
                      offset:     const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size:  15,
                  color: active ? Colors.white : _kOrange,
                ),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize:   13,
                  fontWeight: FontWeight.w700,
                  height:     1.2,
                  color:      active ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DealerListCard extends StatelessWidget {
  const _DealerListCard({
    required this.dealer,
    required this.onTap,
    required this.onCall,
    required this.onWhatsApp,
    required this.onBestPrice,
  });

  final AgriDealer   dealer;
  final VoidCallback onTap;
  final VoidCallback onCall;
  final VoidCallback onWhatsApp;
  final VoidCallback onBestPrice;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DealerThumbnail(dealer: dealer),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DealerInfo(
                        dealer:      dealer,
                        onPriceTap:  onBestPrice,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: _ActionButton(
                    label:             l10n.callNow,
                    icon:              Icons.call_rounded,
                    useGreenGradient:  true,
                    onTap:             onCall,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 4,
                  child: _ActionButton(
                    label:  l10n.listingWhatsApp,
                    icon:   Icons.chat_rounded,
                    color:  const Color(0xFF25D366),
                    onTap:  onWhatsApp,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 5,
                  child: _ActionButton(
                    label:  l10n.getBestPrice,
                    icon:   Icons.local_offer_outlined,
                    onTap:  onBestPrice,
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

class _DealerThumbnail extends StatelessWidget {
  const _DealerThumbnail({required this.dealer});

  final AgriDealer dealer;

  static const _size = 96.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final badge = dealer.isTopSearch ? l10n.topSearchBadge : null;

    return SizedBox(
      width:  _size,
      height: _size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              dealerHeroImage(dealer),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => ColoredBox(
                color: _kGreen.withOpacity(0.08),
                child: const Icon(
                  Icons.storefront_rounded,
                  color: _kGreen,
                  size:  36,
                ),
              ),
            ),
            if (badge != null)
              Positioned(
                left:  0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: _kGreenGrad,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize:     MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.travel_explore_rounded,
                        size:  11,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          badge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color:      Colors.white,
                            fontSize:   9,
                            fontWeight: FontWeight.w800,
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

class _DealerInfo extends StatelessWidget {
  const _DealerInfo({
    required this.dealer,
    required this.onPriceTap,
  });

  final AgriDealer   dealer;
  final VoidCallback onPriceTap;

  String _priceLabel(AppLocalizations l10n) {
    if (dealer.priceHint != null) {
      if (dealer.priceHint == 'Ask for Price') return l10n.askForPrice;
      return dealer.priceHint!;
    }
    return dealer.productsLink ?? l10n.askForPrice;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: [
            _TagChip(
              label: l10n.yearsInBusiness(dealer.yearsInBusiness),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(Icons.thumb_up_alt_rounded,
                  size: 16, color: Colors.grey.shade800),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                dealer.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize:   14,
                  fontWeight: FontWeight.w800,
                  color:      AppColors.textPrimary,
                  height:     1.25,
                ),
              ),
            ),
          ],
        ),
        if (dealer.isVerified) ...[
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color:        _kGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.verified_rounded,
                    size: 14, color: _kGreen),
              ),
              const SizedBox(width: 3),
              Text(
                l10n.verifiedListingBadge,
                style: const TextStyle(
                  fontSize:   11,
                  fontWeight: FontWeight.w700,
                  color:      _kGreen,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 4),
        Text(
          dealer.location,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize:   12,
            color:      Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (dealer.highlight != null) ...[
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.bolt_rounded, size: 14, color: _kOrange),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  dealer.highlight!,
                  style: TextStyle(
                    fontSize:   11,
                    fontWeight: FontWeight.w600,
                    color:      _kOrange.withOpacity(0.95),
                  ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onPriceTap,
          child: Text(
            _priceLabel(l10n),
            style: TextStyle(
              fontSize:       12,
              color:          _kGreen,
              fontWeight:     FontWeight.w700,
              decoration:     TextDecoration.underline,
              decorationColor: _kGreen.withOpacity(0.45),
            ),
          ),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
    this.icon,
    this.iconColor,
  });

  final String    label;
  final IconData? icon;
  final Color?    iconColor;

  @override
  Widget build(BuildContext context) {
    final c = iconColor ?? Colors.grey.shade700;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(6),
        border:       Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: c),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize:   10,
              fontWeight: FontWeight.w700,
              color:      Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.useGreenGradient = false,
    this.color,
  });

  final String       label;
  final IconData     icon;
  final VoidCallback onTap;
  final bool         useGreenGradient;
  final Color?       color;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? AppColors.textPrimary;
    final filled = useGreenGradient;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        splashColor: filled
            ? Colors.white.withOpacity(0.25)
            : accent.withOpacity(0.12),
        highlightColor: filled
            ? Colors.white.withOpacity(0.15)
            : accent.withOpacity(0.08),
        child: Ink(
          height: 38,
          decoration: BoxDecoration(
            gradient: filled ? _kGreenGrad : null,
            color:    filled ? null : Colors.white,
            border:   filled
                ? null
                : Border.all(color: Colors.grey.shade400, width: 1.2),
            borderRadius: BorderRadius.circular(8),
            boxShadow: filled
                ? [
                    BoxShadow(
                      color:      _kGreen.withOpacity(0.28),
                      blurRadius: 6,
                      offset:     const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size:  14,
                color: filled ? Colors.white : accent,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize:   10,
                    fontWeight: FontWeight.w800,
                    color:      filled ? Colors.white : AppColors.textPrimary,
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
