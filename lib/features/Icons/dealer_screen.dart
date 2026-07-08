import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/models/user_location.dart';
import 'package:krishix/core/utils/share_text.dart';
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
  colors: [Color(0xFFE65100), Color(0xFFF57C00)],
  begin:  Alignment.centerLeft,
  end:    Alignment.centerRight,
);

class DealerScreen extends StatefulWidget {
  const DealerScreen({super.key, required this.userLocation});

  final UserLocation userLocation;

  @override
  State<DealerScreen> createState() => _DealerScreenState();
}

class _DealerScreenState extends State<DealerScreen> {
  final _searchCtrl = TextEditingController();
  bool _showSearch  = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<AgriDealer> get _filtered {
    final list = allAgriDealers.where((d) {
      final q = _searchCtrl.text.trim().toLowerCase();
      if (q.isEmpty) return true;
      return d.name.toLowerCase().contains(q) ||
          d.location.toLowerCase().contains(q);
    }).toList();
    list.sort((a, b) => b.rating.compareTo(a.rating));
    return list;
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

  void _onListBusinessTap() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.dealerListBusinessSnackbar),
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
          if (_showSearch)
            Material(
              color: Colors.white,
              elevation: 1,
              shadowColor: Colors.black.withOpacity(0.06),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
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
            ),
          Expanded(
            child: dealers.isEmpty
                ? ListView(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                    children: [
                      _DealerBusinessBanner(
                        headline:   l10n.dealerListBusinessBanner,
                        buttonLabel: l10n.dealerListBusinessCta,
                        onTap:      _onListBusinessTap,
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          l10n.noDealersFound,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                    children: [
                      _DealerBusinessBanner(
                        headline:   l10n.dealerListBusinessBanner,
                        buttonLabel: l10n.dealerListBusinessCta,
                        onTap:      _onListBusinessTap,
                      ),
                      const SizedBox(height: 14),
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

class _DealerBusinessBanner extends StatelessWidget {
  const _DealerBusinessBanner({
    required this.headline,
    required this.buttonLabel,
    required this.onTap,
  });

  final String       headline;
  final String       buttonLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: _kGreenGrad,
        boxShadow: [
          BoxShadow(
            color:      _kGreen.withOpacity(0.22),
            blurRadius: 10,
            offset:     const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headline,
                  style: const TextStyle(
                    color:      Colors.white,
                    fontSize:   15,
                    fontWeight: FontWeight.w800,
                    height:     1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(20),
                    splashColor: Colors.white.withOpacity(0.25),
                    highlightColor: Colors.white.withOpacity(0.12),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: _kOrangeGrad,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:      _kOrange.withOpacity(0.35),
                            blurRadius: 6,
                            offset:     const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      child: Text(
                        buttonLabel,
                        style: const TextStyle(
                          color:      Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize:   12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width:  52,
            height: 52,
            decoration: BoxDecoration(
              color:  Colors.white.withOpacity(0.16),
              shape:  BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.30)),
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: Colors.white,
              size:  26,
            ),
          ),
        ],
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
                        dealer:     dealer,
                        onPriceTap: onBestPrice,
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
    final verified = dealer.isVerified;

    return SizedBox(
      width: _size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border:       Border.all(color: Colors.grey.shade200),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width:  _size,
                height: _size,
                child: Image.asset(
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
              ),
              if (verified)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 5),
                  decoration: const BoxDecoration(
                    gradient: _kOrangeGrad,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize:     MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        size:  11,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          l10n.verifiedListingBadge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
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
            ],
          ),
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
        Text(
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
