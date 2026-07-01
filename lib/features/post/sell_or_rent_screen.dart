// lib/features/post/sell_or_rent_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/features/post/sell_category_screen.dart';
import 'package:krishix/l10n/app_localizations.dart';

const Color _kGreen  = AppColors.primaryGreen;
const Color _kOrange = Color(0xFFF57C00);

// ═══════════════════════════════════════════════════════════════
// SELL OR RENT SCREEN
// ═══════════════════════════════════════════════════════════════
class SellOrRentScreen extends StatefulWidget {
  const SellOrRentScreen({super.key});

  @override
  State<SellOrRentScreen> createState() => _SellOrRentScreenState();
}

class _SellOrRentScreenState extends State<SellOrRentScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>   _fade;
  late final Animation<Offset>   _slide;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor:          Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    _ctrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 500),
    );
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end:   Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _go(bool isRent) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 340),
        pageBuilder: (_, animation, __) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end:   Offset.zero,
          ).animate(CurvedAnimation(
              parent: animation, curve: Curves.easeOutCubic)),
          child: SellCategoryScreen(isRent: isRent),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n        = AppLocalizations.of(context)!;
    final mq          = MediaQuery.of(context);
    final screenH     = mq.size.height;
    // Compact mode for small screens (< 680 logical px body height)
    final bodyH       = screenH - mq.padding.top - mq.padding.bottom;
    final isCompact   = bodyH < 680;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          // ── Farm illustration — bottom, constrained height ─
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: IgnorePointer(
              child: Image.asset(
                'assets/images/login_bottom.png',
                width:           double.infinity,
                // Never taller than 22% of screen; shrinks on small devices
                height:          screenH * (isCompact ? 0.16 : 0.22),
                fit:             BoxFit.cover,
                alignment:       Alignment.topCenter,
                filterQuality:   FilterQuality.medium,
                gaplessPlayback: true,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),

          // ── Scrollable content (never overflows) ──────────
          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                // At minimum fill the screen body so content is centred
                // on large screens but scrolls on small ones
                constraints: BoxConstraints(
                  minHeight: bodyH,
                ),
                child: IntrinsicHeight(
                  child: FadeTransition(
                    opacity: _fade,
                    child: SlideTransition(
                      position: _slide,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          24,
                          isCompact ? 12 : 20,
                          24,
                          // bottom padding = illustration height + safe gap
                          screenH * (isCompact ? 0.18 : 0.24),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [

                            // ── Close button ───────────────
                            Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  width:  40, height: 40,
                                  decoration: BoxDecoration(
                                    color:        Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 1),
                                  ),
                                  child: Icon(Icons.close_rounded,
                                      color: Colors.grey.shade700, size: 20),
                                ),
                              ),
                            ),

                            SizedBox(height: isCompact ? 16 : 28),

                            // ── Heading ────────────────────
                            Text(
                              l10n.listYourItem,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color:         AppColors.textPrimary,
                                fontSize:      26,
                                fontWeight:    FontWeight.w900,
                                height:        1.2,
                                letterSpacing: -0.3,
                              ),
                            ),

                            SizedBox(height: isCompact ? 6 : 8),

                            Text(
                              l10n.listYourItemSubtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color:      Colors.grey.shade500,
                                fontSize:   14,
                                height:     1.5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                            SizedBox(height: isCompact ? 20 : 32),

                            // ── Sell card ──────────────────
                            _OptionCard(
                              icon:        Icons.sell_rounded,
                              title:       l10n.sell,
                              subtitle:    l10n.sellListingSubtitle,
                              buttonLabel: l10n.getStarted,
                              color:       _kGreen,
                              compact:     isCompact,
                              onTap:       () => _go(false),
                            ),

                            SizedBox(height: isCompact ? 12 : 14),

                            // ── Rent card ──────────────────
                            _OptionCard(
                              icon:        Icons.handshake_rounded,
                              title:       l10n.rent,
                              subtitle:    l10n.rentListingSubtitle,
                              buttonLabel: l10n.getStarted,
                              color:       _kOrange,
                              compact:     isCompact,
                              onTap:       () => _go(true),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// OPTION CARD
// ─────────────────────────────────────────────────────────────
class _OptionCard extends StatefulWidget {
  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.color,
    required this.compact,
    required this.onTap,
  });
  final IconData     icon;
  final String       title;
  final String       subtitle;
  final String       buttonLabel;
  final Color        color;
  final bool         compact;   // smaller padding on tiny screens
  final VoidCallback onTap;

  @override
  State<_OptionCard> createState() => _OptionCardState();
}

class _OptionCardState extends State<_OptionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;
  late final Animation<double>   _scale;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync:      this,
      duration:   const Duration(milliseconds: 100),
      lowerBound: 0,
      upperBound: 1,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96)
        .animate(CurvedAnimation(parent: _press, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vPad = widget.compact ? 16.0 : 20.0;
    final iconSz = widget.compact ? 56.0 : 72.0;
    final iconIconSz = widget.compact ? 26.0 : 32.0;

    return GestureDetector(
      onTapDown:   (_) => _press.forward(),
      onTapUp:     (_) { _press.reverse(); widget.onTap(); },
      onTapCancel: ()  => _press.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width:   double.infinity,
          padding: EdgeInsets.symmetric(
              vertical: vPad, horizontal: 24),
          decoration: BoxDecoration(
            color:        widget.color.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: widget.color.withOpacity(0.20), width: 1.5),
            boxShadow: [
              BoxShadow(
                color:      widget.color.withOpacity(0.10),
                blurRadius: 16,
                offset:     const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [

              // ── Icon circle ──────────────────────────
              Container(
                width:  iconSz, height: iconSz,
                decoration: BoxDecoration(
                  color:  widget.color,
                  shape:  BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:      widget.color.withOpacity(0.30),
                      blurRadius: 12,
                      offset:     const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(widget.icon,
                    color: Colors.white, size: iconIconSz),
              ),

              const SizedBox(width: 18),

              // ── Text ─────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize:       MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color:      widget.color,
                        fontSize:   22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        color:      Colors.grey.shade600,
                        fontSize:   13,
                        fontWeight: FontWeight.w500,
                        height:     1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // CTA pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color:        widget.color,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.buttonLabel,
                            style: const TextStyle(
                              color:      Colors.white,
                              fontSize:   13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.arrow_forward_rounded,
                              color: Colors.white, size: 14),
                        ],
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