// lib/features/post/sell_category_screen.dart

import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/features/category/category_detail_screen.dart';

const Color _kGreen  = AppColors.primaryGreen;
const Color _kOrange = Color(0xFFF57C00);

const LinearGradient _kGreenGrad = LinearGradient(
  colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
  begin:  Alignment.topLeft,
  end:    Alignment.bottomRight,
);
const LinearGradient _kOrangeGrad = LinearGradient(
  colors: [Color(0xFFE65100), Color(0xFFF57C00)],
  begin:  Alignment.topLeft,
  end:    Alignment.bottomRight,
);

// ── Category definition ──────────────────────────────────────
class _PostCategory {
  const _PostCategory({
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.imagePath,
    required this.listingCategory,
    required this.color,
    required this.sectionId,
  });
  final String          label;
  final String          sublabel;
  final IconData        icon;
  final String          imagePath;
  final ListingCategory listingCategory;
  final Color           color;
  final String          sectionId;
}

// ═══════════════════════════════════════════════════════════════
// SELL (BUY) CATEGORIES
// ═══════════════════════════════════════════════════════════════
const _sellCategories = <_PostCategory>[
  _PostCategory(
    label:           'Crops & Grains',
    sublabel:        'Wheat, rice, maize, pulses…',
    icon:            Icons.grass_rounded,
    imagePath:       'assets/sub_ctg/KrishiX_App-31.jpg',
    listingCategory: ListingCategory.crops,
    color:           Color(0xFF689F38),
    sectionId:       CategorySectionId.cropsAndGrains,
  ),
  _PostCategory(
    label:           'Fruits & Vegetables',
    sublabel:        'Mangoes, onions, tomatoes…',
    icon:            Icons.eco_rounded,
    imagePath:       'assets/sub_ctg/KrishiX_App-47.jpg',
    listingCategory: ListingCategory.crops,
    color:           Color(0xFF7CB342),
    sectionId:       CategorySectionId.fruitsVeg,
  ),
  _PostCategory(
    label:           'Seeds & Plants',
    sublabel:        'Seeds, saplings, nursery…',
    icon:            Icons.yard_rounded,
    imagePath:       'assets/sub_ctg/KrishiX_App-71.jpg',
    listingCategory: ListingCategory.crops,
    color:           Color(0xFF558B2F),
    sectionId:       CategorySectionId.seedsAndPlants,
  ),
  _PostCategory(
    label:           'Livestock',
    sublabel:        'Cows, buffaloes, goats…',
    icon:            Icons.pets_rounded,
    imagePath:       'assets/sub_ctg/KrishiX_App-54.jpg',
    listingCategory: ListingCategory.livestock,
    color:           Color(0xFF8D6E63),
    sectionId:       CategorySectionId.livestock,
  ),
  _PostCategory(
    label:           'Tractors',
    sublabel:        'New & used tractors',
    icon:            Icons.agriculture_rounded,
    imagePath:       'assets/sub_ctg/KrishiX_App-17.jpg',
    listingCategory: ListingCategory.tractors,
    color:           Color(0xFF388E3C),
    sectionId:       CategorySectionId.tractorsBuy,
  ),
  _PostCategory(
    label:           'Farm Machinery',
    sublabel:        'Rotavators, sprayers, pumps…',
    icon:            Icons.precision_manufacturing_rounded,
    imagePath:       'assets/sub_ctg/KrishiX_App-21.jpg',
    listingCategory: ListingCategory.tractors,
    color:           Color(0xFF6D4C41),
    sectionId:       CategorySectionId.farmMachinery,
  ),
  _PostCategory(
    label:           'Farm Land',
    sublabel:        'Agricultural land for sale',
    icon:            Icons.landscape_rounded,
    imagePath:       'assets/sub_ctg/KrishiX_App-65.jpg',
    listingCategory: ListingCategory.land,
    color:           Color(0xFF0277BD),
    sectionId:       CategorySectionId.agricultureLandSale,
  ),
];

// ═══════════════════════════════════════════════════════════════
// RENT CATEGORIES
// ═══════════════════════════════════════════════════════════════
const _rentCategories = <_PostCategory>[
  _PostCategory(
    label:           'Tractor Rental',
    sublabel:        'Hourly, daily or seasonal',
    icon:            Icons.agriculture_rounded,
    imagePath:       'assets/sub_ctg/KrishiX_App-17.jpg',
    listingCategory: ListingCategory.rental,
    color:           Color(0xFF388E3C),
    sectionId:       CategorySectionId.tractorRental,
  ),
  _PostCategory(
    label:           'Farm Machinery',
    sublabel:        'Rotavators, harvesters, seeders…',
    icon:            Icons.precision_manufacturing_rounded,
    imagePath:       'assets/sub_ctg/KrishiX_App-21.jpg',
    listingCategory: ListingCategory.rental,
    color:           Color(0xFF6D4C41),
    sectionId:       CategorySectionId.farmMachineryRent,
  ),
  _PostCategory(
    label:           'JCB / Excavator',
    sublabel:        'Backhoe, loader, bulldozer…',
    icon:            Icons.construction_rounded,
    imagePath:       'assets/sub_ctg/KrishiX_App-23.jpg',
    listingCategory: ListingCategory.rental,
    color:           Color(0xFFF57C00),
    sectionId:       CategorySectionId.jcbRental,
  ),
  _PostCategory(
    label:           'Land Lease',
    sublabel:        'Put your land on lease',
    icon:            Icons.landscape_rounded,
    imagePath:       'assets/sub_ctg/KrishiX_App-65.jpg',
    listingCategory: ListingCategory.land,
    color:           Color(0xFF0277BD),
    sectionId:       CategorySectionId.agricultureLandLease,
  ),
];

// ═══════════════════════════════════════════════════════════════
// SELL CATEGORY SCREEN
// ═══════════════════════════════════════════════════════════════
class SellCategoryScreen extends StatefulWidget {
  const SellCategoryScreen({super.key, required this.isRent});
  final bool isRent;

  @override
  State<SellCategoryScreen> createState() => _SellCategoryScreenState();
}

class _SellCategoryScreenState extends State<SellCategoryScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>   _fade;
  late final Animation<Offset>   _slide;

  bool get _isRent => widget.isRent;
  LinearGradient get _grad   => _isRent ? _kOrangeGrad : _kGreenGrad;
  Color          get _accent => _isRent ? _kOrange     : _kGreen;
  List<_PostCategory> get _cats =>
      _isRent ? _rentCategories : _sellCategories;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 450),
    );
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.10),
      end:   Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onCategoryTap(_PostCategory cat) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 320),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: CurvedAnimation(
              parent: animation, curve: Curves.easeOut),
          child: CategoryDetailScreen(
            sectionId:     cat.sectionId,
            postFlow:      true,
            isRent:        _isRent,
            categoryLabel: cat.label,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Gradient header bg
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              height: 220,
              decoration: BoxDecoration(gradient: _grad),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 20),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Text(
                          _isRent
                              ? 'What do you want to Rent out?'
                              : 'What do you want to Sell?',
                          style: const TextStyle(
                            color:      Colors.white,
                            fontSize:   18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                // Subtitle
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: Text(
                //     _isRent
                //         ? 'Select a category to list your rental'
                //         : 'Select a category to list your item',
                //     style: TextStyle(
                //       color:    Colors.white.withOpacity(0.85),
                //       fontSize: 13,
                //     ),
                //   ),
                // ),

                // Category count badge
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 10, vertical: 4),
                //     decoration: BoxDecoration(
                //       color:        Colors.white.withOpacity(0.20),
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     // child: Text(
                //     //   '${_cats.length} categories',
                //     //   style: const TextStyle(
                //     //     color:      Colors.white,
                //     //     fontSize:   11,
                //     //     fontWeight: FontWeight.w700,
                //     //   ),
                //     // ),
                //   ),
                // ),

                // const SizedBox(height: 16),

                // Category grid
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color:        Colors.white,
                      // borderRadius: BorderRadius.vertical(
                      //     top: Radius.circular(24)),
                    ),
                    child: ClipRRect(
                      // borderRadius: const BorderRadius.vertical(
                      //     top: Radius.circular(24)),
                      child: FadeTransition(
                        opacity: _fade,
                        child: SlideTransition(
                          position: _slide,
                          child: _buildGrid(),
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
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:   3,
        mainAxisSpacing:  12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemCount:   _cats.length,
      itemBuilder: (_, i) => _CategoryCard(
        cat:    _cats[i],
        accent: _accent,
        onTap:  () => _onCategoryTap(_cats[i]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CATEGORY CARD - FIXED OVERFLOW ISSUE
// ─────────────────────────────────────────────────────────────
class _CategoryCard extends StatefulWidget {
  const _CategoryCard({
    required this.cat,
    required this.accent,
    required this.onTap,
  });
  final _PostCategory cat;
  final Color         accent;
  final VoidCallback  onTap;

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;
  late final Animation<double>   _scale;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync:      this,
      duration:   const Duration(milliseconds: 90),
      lowerBound: 0,
      upperBound: 1,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.94)
        .animate(CurvedAnimation(parent: _press, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:   (_) => _press.forward(),
      onTapUp:     (_) { _press.reverse(); widget.onTap(); },
      onTapCancel: ()  => _press.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            color:        Colors.white,
            borderRadius: BorderRadius.circular(12),
            border:       Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color:      Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset:     const Offset(0, 3),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Image section - Fixed height ratio
              Expanded(
                flex: 4,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      widget.cat.imagePath,
                      fit:           BoxFit.cover,
                      filterQuality: FilterQuality.medium,
                      errorBuilder:  (_, __, ___) => Container(
                        color: widget.cat.color.withOpacity(0.12),
                        child: Icon(widget.cat.icon,
                            size:  32,
                            color: widget.cat.color.withOpacity(0.60)),
                      ),
                    ),
                    // Soft gradient overlay
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin:  Alignment.topCenter,
                          end:    Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.15),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Info section - FIXED: Properly constrained
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 6,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Category label - with proper constraints
                      Flexible(
                        child: Text(
                          widget.cat.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 1),
                      // Sub-label - with proper constraints
                      Flexible(
                        child: Text(
                          widget.cat.sublabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.grey.shade500,
                            height: 1.0,
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
      ),
    );
  }
}
