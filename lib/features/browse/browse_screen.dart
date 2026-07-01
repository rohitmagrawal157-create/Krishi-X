// lib/features/browse/browse_screen.dart
// Category-specific smart filters:
//
// TRACTORS   → Brand + HP range + condition (New/Used)
// LIVESTOCK  → Animal type + Breed + Age + Milk yield + Color
// LAND       → Area (acres) + Soil type + Water source + Deed type
// CROPS      → Crop type + Qty (kg) + Grade + Harvest date
// FRUITS/VEG → Produce type + Size + Freshness
// RENTAL     → Equipment type + Duration
// ALL        → generic price band only

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/constants/app_spacing.dart';
import 'package:krishix/core/data/listing_feed.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/core/models/user_location.dart';
import 'package:krishix/features/listings/listing_detail_screen.dart';
import 'package:krishix/l10n/app_localizations.dart';

// ─────────────────────────────────────────────────────────────
// CONSTANTS
// ─────────────────────────────────────────────────────────────
const Color _kGreen  = AppColors.primaryGreen;
const Color _kOrange = Color(0xFFF57C00);

// ─────────────────────────────────────────────────────────────
// GENERIC FILTER OPTION
// ─────────────────────────────────────────────────────────────
class _Opt {
  const _Opt(this.id, this.label);
  final String id;
  final String label;
}

// ─────────────────────────────────────────────────────────────
// FILTER DEFINITIONS
// ─────────────────────────────────────────────────────────────
const _tractorBrands = [
  _Opt('mahindra',        'Mahindra'),
  _Opt('swaraj',          'Swaraj'),
  _Opt('john_deere',      'John Deere'),
  _Opt('sonalika',        'Sonalika'),
  _Opt('new_holland',     'New Holland'),
  _Opt('eicher',          'Eicher'),
  _Opt('massey_ferguson', 'Massey Ferguson'),
  _Opt('kubota',          'Kubota'),
  _Opt('escorts',         'Escorts'),
  _Opt('powertrac',       'Powertrac'),
];
const _tractorHP = [
  _Opt('hp_u20', 'Under 20 HP'),
  _Opt('hp_21',  '21–30 HP'),
  _Opt('hp_31',  '31–40 HP'),
  _Opt('hp_41',  '41–50 HP'),
  _Opt('hp_51',  '51–60 HP'),
  _Opt('hp_60p', 'Above 60 HP'),
];
const _tractorCondition = [
  _Opt('new',  'New'),
  _Opt('used', 'Used'),
];
const _animalType = [
  _Opt('cow',     'Cow'),
  _Opt('buffalo', 'Buffalo'),
  _Opt('goat',    'Goat'),
  _Opt('sheep',   'Sheep'),
  _Opt('hen',     'Hen / Poultry'),
  _Opt('ox',      'Ox / Bullock'),
  _Opt('horse',   'Horse'),
  _Opt('pig',     'Pig'),
];
const _animalBreed = [
  _Opt('gir',        'Gir'),
  _Opt('sahiwal',    'Sahiwal'),
  _Opt('murrah',     'Murrah'),
  _Opt('hf',         'HF / Holstein'),
  _Opt('jersey',     'Jersey'),
  _Opt('osmanabadi', 'Osmanabadi'),
  _Opt('sangamneri', 'Sangamneri'),
  _Opt('other',      'Other'),
];
const _animalAge = [
  _Opt('age_0_1', '0–1 year'),
  _Opt('age_1_3', '1–3 years'),
  _Opt('age_3_6', '3–6 years'),
  _Opt('age_6p',  'Above 6 years'),
];
const _milkYield = [
  _Opt('milk_0_5',   '0–5 L/day'),
  _Opt('milk_5_10',  '5–10 L/day'),
  _Opt('milk_10_15', '10–15 L/day'),
  _Opt('milk_15p',   'Above 15 L/day'),
];
const _animalColor = [
  _Opt('black',       'Black'),
  _Opt('white',       'White'),
  _Opt('brown',       'Brown'),
  _Opt('black_white', 'Black & White'),
  _Opt('grey',        'Grey'),
  _Opt('mixed',       'Mixed'),
];
const _landArea = [
  _Opt('area_u1',   'Under 1 Acre'),
  _Opt('area_1_3',  '1–3 Acres'),
  _Opt('area_3_5',  '3–5 Acres'),
  _Opt('area_5_10', '5–10 Acres'),
  _Opt('area_10p',  'Above 10 Acres'),
];
const _soilType = [
  _Opt('black',    'Black Soil'),
  _Opt('red',      'Red Soil'),
  _Opt('alluvial', 'Alluvial'),
  _Opt('laterite', 'Laterite'),
  _Opt('sandy',    'Sandy'),
  _Opt('loam',     'Loamy'),
];
const _waterSource = [
  _Opt('bore',  'Borewell'),
  _Opt('canal', 'Canal'),
  _Opt('well',  'Open Well'),
  _Opt('tank',  'Tank'),
  _Opt('none',  'Rainfed Only'),
];
const _landDeed = [
  _Opt('7_12',  '7/12 Available'),
  _Opt('clear', 'Clear Title'),
  _Opt('lease', 'Lease Land'),
];
const _cropType = [
  _Opt('wheat',     'Wheat'),
  _Opt('rice',      'Rice'),
  _Opt('jowar',     'Jowar'),
  _Opt('bajra',     'Bajra'),
  _Opt('maize',     'Maize'),
  _Opt('soybean',   'Soybean'),
  _Opt('cotton',    'Cotton'),
  _Opt('sugarcane', 'Sugarcane'),
  _Opt('tur',       'Tur Dal'),
  _Opt('chana',     'Chana'),
];
const _cropQty = [
  _Opt('qty_u100',    'Under 100 kg'),
  _Opt('qty_100_500', '100–500 kg'),
  _Opt('qty_500_1t',  '500 kg–1 Ton'),
  _Opt('qty_1t_5t',   '1–5 Tons'),
  _Opt('qty_5tp',     'Above 5 Tons'),
];
const _cropGrade = [
  _Opt('a', 'Grade A'),
  _Opt('b', 'Grade B'),
  _Opt('c', 'Grade C'),
];
const _harvestRecency = [
  _Opt('h_fresh',  'Fresh (this week)'),
  _Opt('h_month',  'This month'),
  _Opt('h_season', 'This season'),
  _Opt('h_stored', 'Stored'),
];
const _produceType = [
  _Opt('mango',   'Mango'),
  _Opt('banana',  'Banana'),
  _Opt('orange',  'Orange'),
  _Opt('grapes',  'Grapes'),
  _Opt('tomato',  'Tomato'),
  _Opt('onion',   'Onion'),
  _Opt('potato',  'Potato'),
  _Opt('cabbage', 'Cabbage'),
  _Opt('spinach', 'Spinach'),
  _Opt('chilli',  'Chilli'),
];
const _produceSize = [
  _Opt('small',  'Small'),
  _Opt('medium', 'Medium'),
  _Opt('large',  'Large'),
  _Opt('xl',     'Extra Large'),
];
const _produceFreshness = [
  _Opt('today',     'Harvested Today'),
  _Opt('2_3_days',  '2–3 Days Old'),
  _Opt('this_week', 'This Week'),
  _Opt('stored',    'Cold Stored'),
];
const _rentalEquipType = [
  _Opt('tractor',   'Tractor'),
  _Opt('harvester', 'Harvester'),
  _Opt('sprayer',   'Sprayer'),
  _Opt('rotavator', 'Rotavator'),
  _Opt('plough',    'Plough'),
  _Opt('thresher',  'Thresher'),
  _Opt('jcb',       'JCB / Excavator'),
];
const _rentalDuration = [
  _Opt('daily',   'Daily'),
  _Opt('weekly',  'Weekly'),
  _Opt('monthly', 'Monthly'),
  _Opt('season',  'Full Season'),
];

// ─────────────────────────────────────────────────────────────
// PRICE BANDS
// ─────────────────────────────────────────────────────────────
class _PriceBand {
  const _PriceBand(
      {required this.id, required this.label, this.min, this.max});
  final String id;
  final String label;
  final int?   min;
  final int?   max;
}

List<_PriceBand> _priceBandsForCategory(ListingCategory? category) {
  switch (category) {
    case ListingCategory.tractors:
      return const [
        _PriceBand(id: 't-low',  label: 'Under ₹4L',     max: 399999),
        _PriceBand(id: 't-mid',  label: '₹4L–₹6L',       min: 400000, max: 600000),
        _PriceBand(id: 't-high', label: 'Above ₹6L',     min: 600001),
      ];
    case ListingCategory.crops:
      return const [
        _PriceBand(id: 'c-low',  label: 'Under ₹2K',     max: 1999),
        _PriceBand(id: 'c-mid',  label: '₹2K–₹10K',      min: 2000,   max: 10000),
        _PriceBand(id: 'c-high', label: 'Above ₹10K',    min: 10001),
      ];
    case ListingCategory.livestock:
      return const [
        _PriceBand(id: 'l-low',  label: 'Under ₹50K',    max: 49999),
        _PriceBand(id: 'l-mid',  label: '₹50K–₹1L',      min: 50000,  max: 100000),
        _PriceBand(id: 'l-high', label: 'Above ₹1L',     min: 100001),
      ];
    case ListingCategory.land:
      return const [
        _PriceBand(id: 'la-low',  label: 'Under ₹15L',   max: 1499999),
        _PriceBand(id: 'la-mid',  label: '₹15L–₹30L',    min: 1500000, max: 3000000),
        _PriceBand(id: 'la-high', label: 'Above ₹30L',   min: 3000001),
      ];
    case ListingCategory.rental:
      return const [
        _PriceBand(id: 'r-low',  label: 'Under ₹1K/day', max: 999),
        _PriceBand(id: 'r-mid',  label: '₹1K–₹3K/day',  min: 1000, max: 3000),
        _PriceBand(id: 'r-high', label: 'Above ₹3K/day', min: 3001),
      ];
    case null:
      return const [
        _PriceBand(id: 'a-low',  label: 'Under ₹10K',    max: 9999),
        _PriceBand(id: 'a-mid',  label: '₹10K–₹1L',      min: 10000, max: 100000),
        _PriceBand(id: 'a-high', label: 'Above ₹1L',     min: 100001),
      ];
  }
}

// ─────────────────────────────────────────────────────────────
// SORT HELPERS
// ─────────────────────────────────────────────────────────────
List<ListingPriceSort> _sortsForCategory(ListingCategory? cat) {
  if (cat == ListingCategory.land || cat == ListingCategory.rental) {
    return const [
      ListingPriceSort.newest,
      ListingPriceSort.nearest,
      ListingPriceSort.lowToHigh,
      ListingPriceSort.highToLow,
    ];
  }
  return const [
    ListingPriceSort.newest,
    ListingPriceSort.lowToHigh,
    ListingPriceSort.highToLow,
    ListingPriceSort.nearest,
  ];
}

String _sortLabel(AppLocalizations l10n, ListingPriceSort sort,
    ListingCategory? cat) {
  switch (sort) {
    case ListingPriceSort.newest:
      return l10n.sortNewest;
    case ListingPriceSort.lowToHigh:
      if (cat == ListingCategory.land)   return 'Lowest Price';
      if (cat == ListingCategory.rental) return 'Lowest Rent';
      return l10n.sortPriceLowToHigh;
    case ListingPriceSort.highToLow:
      if (cat == ListingCategory.land)   return 'Highest Price';
      if (cat == ListingCategory.rental) return 'Highest Rent';
      return l10n.sortPriceHighToLow;
    case ListingPriceSort.nearest:
      return 'Nearest First';
  }
}

IconData _sortIcon(ListingPriceSort sort) {
  switch (sort) {
    case ListingPriceSort.newest:    return Icons.schedule_rounded;
    case ListingPriceSort.lowToHigh: return Icons.arrow_upward_rounded;
    case ListingPriceSort.highToLow: return Icons.arrow_downward_rounded;
    case ListingPriceSort.nearest:   return Icons.near_me_rounded;
  }
}

String _categoryLabel(AppLocalizations l10n, ListingCategory cat) {
  switch (cat) {
    case ListingCategory.tractors:  return l10n.categoryTractors;
    case ListingCategory.crops:     return l10n.categoryCrops;
    case ListingCategory.livestock: return l10n.categoryLivestock;
    case ListingCategory.land:      return l10n.categoryLand;
    case ListingCategory.rental:    return l10n.categoryRental;
  }
}

String _categoryEmoji(ListingCategory? cat) {
  switch (cat) {
    case ListingCategory.tractors:  return '🚜';
    case ListingCategory.crops:     return '🌾';
    case ListingCategory.livestock: return '🐄';
    case ListingCategory.land:      return '🌍';
    case ListingCategory.rental:    return '🔧';
    case null:                      return '🏪';
  }
}

// ─────────────────────────────────────────────────────────────
// FILTER STATE
// ─────────────────────────────────────────────────────────────
class _FilterState {
  ListingCategory?  category;
  ListingType?      listingType;
  _PriceBand?       priceBand;
  ListingPriceSort  priceSort    = ListingPriceSort.newest;
  bool              verifiedOnly = false;
  bool              nearbyOnly   = false;
  String? tractorBrand;
  String? tractorHP;
  String? tractorCondition;
  String? animalType;
  String? animalBreed;
  String? animalAge;
  String? milkYield;
  String? animalColor;
  String? landArea;
  String? soilType;
  String? waterSource;
  String? landDeed;
  String? cropType;
  String? cropQty;
  String? cropGrade;
  String? harvestRecency;
  String? produceType;
  String? produceSize;
  String? produceFreshness;
  String? rentalEquipType;
  String? rentalDuration;

  int get activeExtraCount {
    int n = 0;
    if (verifiedOnly)             n++;
    if (nearbyOnly)               n++;
    if (tractorBrand != null)     n++;
    if (tractorHP != null)        n++;
    if (tractorCondition != null) n++;
    if (animalType != null)       n++;
    if (animalBreed != null)      n++;
    if (animalAge != null)        n++;
    if (milkYield != null)        n++;
    if (animalColor != null)      n++;
    if (landArea != null)         n++;
    if (soilType != null)         n++;
    if (waterSource != null)      n++;
    if (landDeed != null)         n++;
    if (cropType != null)         n++;
    if (cropQty != null)          n++;
    if (cropGrade != null)        n++;
    if (harvestRecency != null)   n++;
    if (produceType != null)      n++;
    if (produceSize != null)      n++;
    if (produceFreshness != null) n++;
    if (rentalEquipType != null)  n++;
    if (rentalDuration != null)   n++;
    return n;
  }

  _FilterState copyWith() {
    final f = _FilterState();
    f.category         = category;
    f.listingType      = listingType;
    f.priceBand        = priceBand;
    f.priceSort        = priceSort;
    f.verifiedOnly     = verifiedOnly;
    f.nearbyOnly       = nearbyOnly;
    f.tractorBrand     = tractorBrand;
    f.tractorHP        = tractorHP;
    f.tractorCondition = tractorCondition;
    f.animalType       = animalType;
    f.animalBreed      = animalBreed;
    f.animalAge        = animalAge;
    f.milkYield        = milkYield;
    f.animalColor      = animalColor;
    f.landArea         = landArea;
    f.soilType         = soilType;
    f.waterSource      = waterSource;
    f.landDeed         = landDeed;
    f.cropType         = cropType;
    f.cropQty          = cropQty;
    f.cropGrade        = cropGrade;
    f.harvestRecency   = harvestRecency;
    f.produceType      = produceType;
    f.produceSize      = produceSize;
    f.produceFreshness = produceFreshness;
    f.rentalEquipType  = rentalEquipType;
    f.rentalDuration   = rentalDuration;
    return f;
  }

  void resetCategorySpecific() {
    listingType = null; priceBand = null;
    priceSort   = ListingPriceSort.newest;
    tractorBrand = null; tractorHP = null; tractorCondition = null;
    animalType = null; animalBreed = null; animalAge = null;
    milkYield = null; animalColor = null;
    landArea = null; soilType = null; waterSource = null; landDeed = null;
    cropType = null; cropQty = null; cropGrade = null; harvestRecency = null;
    produceType = null; produceSize = null; produceFreshness = null;
    rentalEquipType = null; rentalDuration = null;
  }
}

// ═══════════════════════════════════════════════════════════════
// CUSTOM PICKER — replaces all native DropdownButton widgets
// ═══════════════════════════════════════════════════════════════

/// A single item shown inside the picker sheet.
class _PickerItem<T> {
  const _PickerItem({
    required this.value,
    required this.label,
    this.emoji,
    this.icon,
  });
  final T        value;
  final String   label;
  final String?  emoji;
  final IconData? icon;
}

/// Styled pill/chip trigger button.
class _PickerTrigger extends StatelessWidget {
  const _PickerTrigger({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });
  final IconData     icon;
  final String       label;
  final VoidCallback onTap;
  final bool         isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height:  40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isActive ? _kGreen.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? _kGreen : Colors.grey.shade300,
            width: isActive ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: isActive ? _kGreen : Colors.grey.shade600,
                size:  16),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize:   12,
                  fontWeight: FontWeight.w800,
                  color: isActive ? _kGreen : const Color(0xFF1A1A1A),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down_rounded,
                size:  16,
                color: isActive ? _kGreen : Colors.grey.shade500),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Boxed optional — lets us distinguish "dismiss" from "pick null"
// ─────────────────────────────────────────────────────────────
class _Picked<T> {
  const _Picked(this.value);
  final T value;
}

Future<_Picked<T>?> _showPicker<T>({
  required BuildContext      context,
  required String            title,
  required List<_PickerItem<T>> items,
  required T?                selected,
}) async {
  return showModalBottomSheet<_Picked<T>>(
    context:            context,
    backgroundColor:    Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _PickerSheet<T>(
      title:    title,
      items:    items,
      selected: selected,
    ),
  );
}

class _PickerSheet<T> extends StatelessWidget {
  const _PickerSheet({
    super.key,
    required this.title,
    required this.items,
    required this.selected,
  });
  final String               title;
  final List<_PickerItem<T>> items;
  final T?                   selected;

  @override
  Widget build(BuildContext context) {
    const itemH  = 56.0;
    final maxH   = MediaQuery.of(context).size.height * 0.75;
    final wantH  = 80 + items.length * itemH + 24.0 +
        MediaQuery.of(context).padding.bottom;
    final sheetH = wantH.clamp(200.0, maxH);

    return Container(
      height: sheetH,
      decoration: const BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle + title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color:        Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text(title,
                        style: const TextStyle(
                          fontSize:   17,
                          fontWeight: FontWeight.w800,
                          color:      Color(0xFF1A1A1A),
                        )),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color:        Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(Icons.close_rounded,
                            size: 18, color: Colors.grey.shade600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(height: 1, color: Colors.grey.shade200),
              ],
            ),
          ),

          // Item list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 6),
              itemCount: items.length,
              itemBuilder: (ctx, i) {
                final item       = items[i];
                final isSelected = item.value == selected;

                return InkWell(
                  onTap: () =>
                      Navigator.pop(ctx, _Picked<T>(item.value)),
                  child: Container(
                    height: itemH,
                    color: isSelected
                        ? _kGreen.withOpacity(0.06)
                        : Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20),
                    child: Row(
                      children: [
                        // Leading
                        if (item.emoji != null)
                          SizedBox(
                            width: 32,
                            child: Text(item.emoji!,
                                style:
                                    const TextStyle(fontSize: 20)),
                          )
                        else if (item.icon != null)
                          Container(
                            width:  32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? _kGreen.withOpacity(0.15)
                                  : Colors.grey.shade100,
                              borderRadius:
                                  BorderRadius.circular(8),
                            ),
                            child: Icon(item.icon!,
                                size:  16,
                                color: isSelected
                                    ? _kGreen
                                    : Colors.grey.shade600),
                          )
                        else
                          const SizedBox(width: 32),

                        const SizedBox(width: 14),

                        // Label
                        Expanded(
                          child: Text(
                            item.label,
                            style: TextStyle(
                              fontSize:   14,
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: isSelected
                                  ? _kGreen
                                  : const Color(0xFF2D2D2D),
                            ),
                          ),
                        ),

                        // Check
                        AnimatedSwitcher(
                          duration:
                              const Duration(milliseconds: 180),
                          child: isSelected
                              ? Container(
                                  key: const ValueKey('chk'),
                                  width:  24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: _kGreen,
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                      Icons.check_rounded,
                                      size:  14,
                                      color: Colors.white),
                                )
                              : const SizedBox(
                                  key: ValueKey('emp'),
                                  width: 24, height: 24),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(
              height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// BROWSE SCREEN
// ═══════════════════════════════════════════════════════════════
class BrowseScreen extends StatefulWidget {
  const BrowseScreen({
    super.key,
    this.initialCategory,
    this.initialListingType,
    this.initialDetailLabel,
    this.initialDetailKeywords = const [],
    this.userLocation,
  });
  final ListingCategory? initialCategory;
  final ListingType?     initialListingType;
  final String?          initialDetailLabel;
  final List<String>     initialDetailKeywords;
  final UserLocation?    userLocation;

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _filters          = _FilterState();
  final _items            = <Listing>[];

  var    _page          = 0;
  var    _isLoadingMore = false;
  var    _hasMore       = true;
  Timer? _debounce;
  String?      _detailLabel;
  List<String> _detailKeywords = const [];

  @override
  void initState() {
    super.initState();
    _filters.category    = widget.initialCategory;
    _filters.listingType = widget.initialListingType;
    _detailLabel         = widget.initialDetailLabel;
    _detailKeywords      = widget.initialDetailKeywords;
    _loadMore();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_hasMore || _isLoadingMore) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  void _resetAndSearch() {
    setState(() { _page = 0; _items.clear(); _hasMore = true; });
    _loadMore();
  }

  void _onSearchChanged(String _) {
    setState(() {});
    _debounce?.cancel();
    _debounce =
        Timer(const Duration(milliseconds: 350), _resetAndSearch);
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 180));
    final batch = ListingFeed.fetchPage(
      _page,
      searchQuery:    _searchController.text,
      category:       _filters.category,
      verifiedOnly:   _filters.verifiedOnly,
      userLocation:   widget.userLocation,
      nearbyOnly:     _filters.nearbyOnly,
      priceSort:      _filters.priceSort,
      listingType:    _filters.listingType,
      minPrice:       _filters.priceBand?.min,
      maxPrice:       _filters.priceBand?.max,
      detailKeywords: _detailKeywords,
    );
    if (!mounted) return;
    setState(() {
      _items.addAll(batch);
      _page++;
      _isLoadingMore = false;
      _hasMore       = batch.length == ListingFeed.pageSize;
    });
  }

  // ── Navigate to listing detail ──────────────────────────
  void _openDetail(Listing listing, int imgIdx) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ListingDetailScreen(
          listing:      listing,
          imageIndex:   imgIdx,
          userLocation: widget.userLocation,
        ),
      ),
    );
  }

  // ── Category picker ─────────────────────────────────────
  Future<void> _showCategoryPicker(AppLocalizations l10n) async {
    final items = <_PickerItem<ListingCategory?>>[
      _PickerItem<ListingCategory?>(
          value: null, label: l10n.filterAll, emoji: '🏪'),
      ...ListingCategory.values.map((cat) =>
          _PickerItem<ListingCategory?>(
            value: cat,
            label: _categoryLabel(l10n, cat),
            emoji: _categoryEmoji(cat),
          )),
    ];

    final result = await _showPicker<ListingCategory?>(
      context:  context,
      title:    'Select Category',
      items:    items,
      selected: _filters.category,
    );

    // result is null if dismissed, _Picked(value) if user tapped.
    // value can itself be null meaning "All".
    if (!mounted || result == null) return;
    setState(() {
      _filters.category = result.value;
      _filters.resetCategorySpecific();
      _detailLabel    = null;
      _detailKeywords = const [];
    });
    _resetAndSearch();
  }

  // ── Sort picker ─────────────────────────────────────────
  Future<void> _showSortPicker(AppLocalizations l10n) async {
    final sorts = _sortsForCategory(_filters.category);
    final items = sorts.map((s) => _PickerItem<ListingPriceSort>(
          value: s,
          label: _sortLabel(l10n, s, _filters.category),
          icon:  _sortIcon(s),
        )).toList();

    final result = await _showPicker<ListingPriceSort>(
      context:  context,
      title:    'Sort by',
      items:    items,
      selected: _filters.priceSort,
    );

    if (!mounted || result == null) return;
    setState(() => _filters.priceSort = result.value);
    _resetAndSearch();
  }

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context:            context,
      isScrollControlled: true,
      backgroundColor:    Colors.transparent,
      builder: (_) => _FilterSheet(
        filters:  _filters.copyWith(),
        category: _filters.category,
        onApply:  (updated) {
          setState(() {
            _filters.listingType      = updated.listingType;
            _filters.priceBand        = updated.priceBand;
            _filters.priceSort        = updated.priceSort;
            _filters.verifiedOnly     = updated.verifiedOnly;
            _filters.nearbyOnly       = updated.nearbyOnly;
            _filters.tractorBrand     = updated.tractorBrand;
            _filters.tractorHP        = updated.tractorHP;
            _filters.tractorCondition = updated.tractorCondition;
            _filters.animalType       = updated.animalType;
            _filters.animalBreed      = updated.animalBreed;
            _filters.animalAge        = updated.animalAge;
            _filters.milkYield        = updated.milkYield;
            _filters.animalColor      = updated.animalColor;
            _filters.landArea         = updated.landArea;
            _filters.soilType         = updated.soilType;
            _filters.waterSource      = updated.waterSource;
            _filters.landDeed         = updated.landDeed;
            _filters.cropType         = updated.cropType;
            _filters.cropQty          = updated.cropQty;
            _filters.cropGrade        = updated.cropGrade;
            _filters.harvestRecency   = updated.harvestRecency;
            _filters.produceType      = updated.produceType;
            _filters.produceSize      = updated.produceSize;
            _filters.produceFreshness = updated.produceFreshness;
            _filters.rentalEquipType  = updated.rentalEquipType;
            _filters.rentalDuration   = updated.rentalDuration;
          });
          _resetAndSearch();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n        = AppLocalizations.of(context)!;
    final extraActive = _filters.activeExtraCount;
    final catLabel    = _filters.category != null
        ? '${_categoryEmoji(_filters.category!)} '
          '${_categoryLabel(l10n, _filters.category!)}'
        : '${_categoryEmoji(null)} ${l10n.filterAll}';
    final sortLabel = _sortLabel(
        l10n, _filters.priceSort, _filters.category);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: _kGreen,
        foregroundColor: Colors.white,
        elevation:       0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 20, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
          style: IconButton.styleFrom(
            shape:           const CircleBorder(),
            backgroundColor: Colors.white.withOpacity(0.12),
          ),
        ),
        title: Text(
          _detailLabel ?? l10n.browse,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [

          // ── TOP CONTROLS ──────────────────────────────────
          Material(
            color:       Colors.white,
            elevation:   2,
            shadowColor: Colors.black.withOpacity(0.08),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                children: [

                  _SearchBar(
                    controller: _searchController,
                    hint:       l10n.searchPlaceholder,
                    onChanged:  _onSearchChanged,
                    onClear: () {
                      _searchController.clear();
                      _resetAndSearch();
                    },
                  ),

                  const SizedBox(height: 10),

                  if (widget.userLocation != null)
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded,
                            color: _kOrange, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.userLocation!.displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color:      AppColors.textSecondary,
                              fontSize:   12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 10),

                  // ── Category + Sort + Filters ────────────
                  Row(
                    children: [
                      // Category picker
                      // Expanded(
                      //   child: _PickerTrigger(
                      //     icon:     Icons.category_rounded,
                      //     label:    catLabel,
                      //     isActive: _filters.category != null,
                      //     onTap:    () => _showCategoryPicker(l10n),
                      //   ),
                      // ),

                      // const SizedBox(width: 8),

                      // Sort picker
                      Expanded(
                        child: _PickerTrigger(
                          icon:     _sortIcon(_filters.priceSort),
                          label:    sortLabel,
                          isActive: _filters.priceSort !=
                              ListingPriceSort.newest,
                          onTap:    () => _showSortPicker(l10n),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Advanced filters
                      GestureDetector(
                        onTap: _showFilterSheet,
                        child: Container(
                          height:  40,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12),
                          decoration: BoxDecoration(
                            color: extraActive > 0
                                ? _kOrange
                                : Colors.white,
                            borderRadius:
                                BorderRadius.circular(10),
                            border: Border.all(
                              color: extraActive > 0
                                  ? _kOrange
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.tune_rounded,
                                  size:  18,
                                  color: extraActive > 0
                                      ? Colors.white
                                      : _kGreen),
                              const SizedBox(width: 4),
                              Text(
                                extraActive > 0
                                    ? 'Filters ($extraActive)'
                                    : 'Filters',
                                style: TextStyle(
                                  fontSize:   12,
                                  fontWeight: FontWeight.w800,
                                  color: extraActive > 0
                                      ? Colors.white
                                      : const Color(0xFF1A1A1A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── RESULTS ───────────────────────────────────────
          Expanded(
            child: _items.isEmpty && !_isLoadingMore
                ? Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.all(AppSpacing.lg),
                      child: Text(
                        l10n.noListingsYet,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge,
                      ),
                    ),
                  )
                : ListView(
                    controller: _scrollController,
                    padding:    EdgeInsets.zero,
                    children: [
                      _BrowseNearbyBox(
                        items:        _items,
                        l10n:         l10n,
                        userLocation: widget.userLocation,
                        onItemTap:    _openDetail,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md, 0,
                            AppSpacing.md, AppSpacing.xl),
                        child: _BrowseGrid(
                          items:         _items,
                          isLoadingMore: _isLoadingMore,
                          l10n:          l10n,
                          onItemTap:     _openDetail,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
    // ── END build ─────────────────────────────────────────
  }
  // ── END _BrowseScreenState ─────────────────────────────────
}

// ═══════════════════════════════════════════════════════════════
// FILTER BOTTOM SHEET  (top-level — NOT nested in state)
// ═══════════════════════════════════════════════════════════════
class _FilterSheet extends StatefulWidget {
  const _FilterSheet({
    required this.filters,
    required this.category,
    required this.onApply,
  });
  final _FilterState               filters;
  final ListingCategory?           category;
  final ValueChanged<_FilterState> onApply;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late final _FilterState _f;

  @override
  void initState() {
    super.initState();
    _f = widget.filters.copyWith();
  }

  Widget _section(String title, Widget child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize:   13,
                  fontWeight: FontWeight.w800,
                  color:      AppColors.textPrimary)),
          const SizedBox(height: 8),
          child,
          const SizedBox(height: 18),
        ],
      );

  Widget _chips(List<_Opt> opts, String? selected,
      ValueChanged<String?> onSelect) {
    return Wrap(
      spacing:    8,
      runSpacing: 8,
      children: opts.map((o) {
        final active = selected == o.id;
        return GestureDetector(
          onTap: () =>
              setState(() => onSelect(active ? null : o.id)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            padding:  const EdgeInsets.symmetric(
                horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color:        active ? _kGreen : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: active
                      ? _kGreen
                      : Colors.grey.shade300),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color:      _kGreen.withOpacity(0.22),
                        blurRadius: 6,
                        offset:     const Offset(0, 2),
                      )
                    ]
                  : [],
            ),
            child: Text(o.label,
                style: TextStyle(
                  fontSize:   12,
                  fontWeight: FontWeight.w700,
                  color: active
                      ? Colors.white
                      : AppColors.textPrimary,
                )),
          ),
        );
      }).toList(),
    );
  }

  Widget _toggle(String label, bool value,
      ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize:   13,
                fontWeight: FontWeight.w700)),
        Switch(
          value:     value,
          onChanged: (v) => setState(() => onChanged(v)),
          activeColor: _kGreen,
          materialTapTargetSize:
              MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cat   = widget.category;
    final bands = _priceBandsForCategory(cat);

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize:     0.40,
      maxChildSize:     0.95,
      builder: (_, sc) => Container(
        decoration: const BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 38, height: 4,
              decoration: BoxDecoration(
                  color:        Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 12),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text('Filters',
                      style: TextStyle(
                          fontSize:   17,
                          fontWeight: FontWeight.w800)),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => setState(
                        () => _f.resetCategorySpecific()),
                    icon: const Icon(Icons.refresh_rounded,
                        size: 16, color: _kOrange),
                    label: const Text('Reset',
                        style: TextStyle(
                            color:      _kOrange,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            Expanded(
              child: ListView(
                controller: sc,
                padding: const EdgeInsets.fromLTRB(
                    20, 16, 20, 32),
                children: [

                  _section('Price Range',
                    _chips(
                      bands
                          .map((b) => _Opt(b.id, b.label))
                          .toList(),
                      _f.priceBand?.id,
                      (id) => _f.priceBand = id == null
                          ? null
                          : bands
                              .firstWhere((b) => b.id == id),
                    ),
                  ),

                  // if (cat == ListingCategory.tractors) ...[
                  //   _section('Brand',
                  //       _chips(_tractorBrands, _f.tractorBrand,
                  //           (v) => _f.tractorBrand = v)),
                  //   _section('HP Range',
                  //       _chips(_tractorHP, _f.tractorHP,
                  //           (v) => _f.tractorHP = v)),
                  //   _section('Condition',
                  //       _chips(_tractorCondition,
                  //           _f.tractorCondition,
                  //           (v) => _f.tractorCondition = v)),
                  // ],

                  // if (cat == ListingCategory.livestock) ...[
                  //   _section('Animal Type',
                  //       _chips(_animalType, _f.animalType,
                  //           (v) => _f.animalType = v)),
                  //   _section('Breed',
                  //       _chips(_animalBreed, _f.animalBreed,
                  //           (v) => _f.animalBreed = v)),
                  //   _section('Age',
                  //       _chips(_animalAge, _f.animalAge,
                  //           (v) => _f.animalAge = v)),
                  //   _section('Milk Yield / Day',
                  //       _chips(_milkYield, _f.milkYield,
                  //           (v) => _f.milkYield = v)),
                  //   _section('Color',
                  //       _chips(_animalColor, _f.animalColor,
                  //           (v) => _f.animalColor = v)),
                  // ],

                  // if (cat == ListingCategory.land) ...[
                  //   _section('Area',
                  //       _chips(_landArea, _f.landArea,
                  //           (v) => _f.landArea = v)),
                  //   _section('Soil Type',
                  //       _chips(_soilType, _f.soilType,
                  //           (v) => _f.soilType = v)),
                  //   _section('Water Source',
                  //       _chips(_waterSource, _f.waterSource,
                  //           (v) => _f.waterSource = v)),
                  //   _section('Legal / Deed',
                  //       _chips(_landDeed, _f.landDeed,
                  //           (v) => _f.landDeed = v)),
                  // ],

                  // if (cat == ListingCategory.crops) ...[
                  //   _section('Crop Type',
                  //       _chips(_cropType, _f.cropType,
                  //           (v) => _f.cropType = v)),
                  //   _section('Quantity',
                  //       _chips(_cropQty, _f.cropQty,
                  //           (v) => _f.cropQty = v)),
                  //   _section('Grade',
                  //       _chips(_cropGrade, _f.cropGrade,
                  //           (v) => _f.cropGrade = v)),
                  //   _section('Harvest',
                  //       _chips(_harvestRecency,
                  //           _f.harvestRecency,
                  //           (v) => _f.harvestRecency = v)),
                  // ],

                  // if (cat == null) ...[
                  //   _section('Produce Type',
                  //       _chips(_produceType, _f.produceType,
                  //           (v) => _f.produceType = v)),
                  //   _section('Size',
                  //       _chips(_produceSize, _f.produceSize,
                  //           (v) => _f.produceSize = v)),
                  //   _section('Freshness',
                  //       _chips(_produceFreshness,
                  //           _f.produceFreshness,
                  //           (v) => _f.produceFreshness = v)),
                  // ],

                  // if (cat == ListingCategory.rental) ...[
                  //   _section('Equipment Type',
                  //       _chips(_rentalEquipType,
                  //           _f.rentalEquipType,
                  //           (v) => _f.rentalEquipType = v)),
                  //   _section('Rental Duration',
                  //       _chips(_rentalDuration,
                  //           _f.rentalDuration,
                  //           (v) => _f.rentalDuration = v)),
                  // ],

                  const Divider(),
                  const SizedBox(height: 8),
                  _toggle('Verified Sellers Only',
                      _f.verifiedOnly,
                      (v) => _f.verifiedOnly = v),
                  const SizedBox(height: 4),
                  _toggle('Nearby Only', _f.nearbyOnly,
                      (v) => _f.nearbyOnly = v),
                ],
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    20, 12, 20, 16),
                child: SizedBox(
                  width:  double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onApply(_f);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: const Text('Apply Filters',
                        style: TextStyle(
                            fontSize:   15,
                            fontWeight: FontWeight.w800)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SEARCH BAR
// ═══════════════════════════════════════════════════════════════
class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.onClear,
  });
  final TextEditingController controller;
  final String                hint;
  final ValueChanged<String>  onChanged;
  final VoidCallback          onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color:        const Color(0xFFF6F8F5),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color:      Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset:     const Offset(0, 2)),
        ],
      ),
      child: TextField(
        controller:      controller,
        style:           const TextStyle(fontSize: 14),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText:  hint,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: const Icon(Icons.search_rounded,
              color: _kGreen, size: 22),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon:      const Icon(Icons.close_rounded),
                  color:     _kOrange,
                  onPressed: onClear,
                )
              : null,
          border:         InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 11),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// IMAGE + PRICE HELPERS (shared by all card widgets)
// ═══════════════════════════════════════════════════════════════
const Map<ListingCategory, List<String>> _categoryImages = {
  ListingCategory.livestock: [
    'assets/images/cow1.jpeg', 'assets/images/cow2.jpeg'],
  ListingCategory.land: [
    'assets/images/land1.jpeg', 'assets/images/land2.jpeg'],
  ListingCategory.tractors: [
    'assets/images/tractor1.webp', 'assets/images/tractor2.webp',
    'assets/images/machine1.jpeg', 'assets/images/jcb1.jpeg'],
  ListingCategory.rental: [
    'assets/images/rent2.jpeg', 'assets/images/jcb1.jpeg',
    'assets/images/machine1.jpeg'],
  ListingCategory.crops: [
    'assets/images/mango.jpeg', 'assets/images/veg1.jpeg',
    'assets/images/veg2.jpeg',  'assets/images/banana.jpeg',
    'assets/images/seeds1.jpeg'],
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

// ═══════════════════════════════════════════════════════════════
// PRODUCT CARD  (stateful for heart toggle)
// ═══════════════════════════════════════════════════════════════
class _ProductCard extends StatefulWidget {
  const _ProductCard({
    required this.listing,
    required this.imageIndex,
    required this.onTap,
  });
  final Listing      listing;
  final int          imageIndex;
  final VoidCallback onTap;

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final l10n   = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.circular(12),
          border:       Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
                color:      Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset:     const Offset(0, 3)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Image + heart
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    _imageFor(widget.listing.category,
                        widget.imageIndex),
                    fit:           BoxFit.contain,
                    filterQuality: FilterQuality.medium,
                    errorBuilder: (_, __, ___) =>
                        const ColoredBox(
                            color: Color(0xFFF3F7F0)),
                  ),
                  Positioned(
                    top: 6, right: 6,
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _saved = !_saved),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.12),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Icon(
                          _saved
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size:  18,
                          color: _saved
                              ? Colors.red
                              : Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatPrice(widget.listing.price),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color:      _kGreen,
                        fontSize:   15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.listing.displayTitle(l10n),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color:      AppColors.textPrimary,
                        fontSize:   12,
                        fontWeight: FontWeight.w700,
                        height:     1.25,
                      ),
                    ),
                    const Spacer(),
                    Row(children: [
                      Icon(Icons.location_on_outlined,
                          color: Colors.grey.shade600,
                          size:  14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.listing.distanceKm != null
                              ? '${widget.listing.shortLocation} • '
                                '${l10n.kmAway(widget.listing.distanceKm!.toStringAsFixed(1))}'
                              : widget.listing.shortLocation,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color:      Colors.grey.shade600,
                            fontSize:   11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ]),
                    if (widget.listing.isVerified) ...[
                      const SizedBox(height: 5),
                      Row(children: [
                        const Icon(Icons.verified_rounded,
                            color: _kOrange, size: 14),
                        const SizedBox(width: 4),
                        Text(l10n.verifiedSeller,
                            style: const TextStyle(
                              color:      _kOrange,
                              fontSize:   11,
                              fontWeight: FontWeight.w800,
                            )),
                      ]),
                    ],
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

// ═══════════════════════════════════════════════════════════════
// BROWSE NEARBY BOX
// ═══════════════════════════════════════════════════════════════
class _BrowseNearbyBox extends StatelessWidget {
  const _BrowseNearbyBox({
    required this.items,
    required this.l10n,
    required this.onItemTap,
    this.userLocation,
  });
  final List<Listing>                     items;
  final AppLocalizations                  l10n;
  final void Function(Listing, int)       onItemTap;
  final UserLocation?                     userLocation;

  @override
  Widget build(BuildContext context) {
    final nearby = items.take(6).toList();
    if (nearby.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      child: Container(
        decoration: BoxDecoration(
          color:        const Color(0xFFEDF7ED),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: AppColors.primaryGreen.withOpacity(0.22)),
        ),
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 48,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(l10n.nearbyAds,
                      style: const TextStyle(
                        fontSize:   15,
                        fontWeight: FontWeight.w800,
                        color:      AppColors.textPrimary,
                      )),
                  Text('${nearby.length} results',
                      style: const TextStyle(
                        fontSize:   12,
                        fontWeight: FontWeight.w600,
                        color:      AppColors.primaryGreen,
                      )),
                ],
              ),
            ),
            _BrowseNearbyGrid(
                listings:  nearby,
                l10n:      l10n,
                onItemTap: onItemTap),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// BROWSE NEARBY GRID
// ═══════════════════════════════════════════════════════════════
class _BrowseNearbyGrid extends StatelessWidget {
  const _BrowseNearbyGrid({
    required this.listings,
    required this.l10n,
    required this.onItemTap,
  });
  final List<Listing>               listings;
  final AppLocalizations            l10n;
  final void Function(Listing, int) onItemTap;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < listings.length; i += 2) {
      final left  = listings[i];
      final right =
          (i + 1 < listings.length) ? listings[i + 1] : null;
      rows.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _BrowseNearbyCard(
              listing: left,
              imgIdx:  i,
              l10n:    l10n,
              onTap:   () => onItemTap(left, i),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: right != null
                ? _BrowseNearbyCard(
                    listing: right,
                    imgIdx:  i + 1,
                    l10n:    l10n,
                    onTap:   () => onItemTap(right, i + 1),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ));
      if (i + 2 < listings.length) {
        rows.add(const SizedBox(height: 10));
      }
    }
    return Column(children: rows);
  }
}

// ═══════════════════════════════════════════════════════════════
// BROWSE NEARBY CARD  (stateful for heart toggle)
// ═══════════════════════════════════════════════════════════════
class _BrowseNearbyCard extends StatefulWidget {
  const _BrowseNearbyCard({
    required this.listing,
    required this.imgIdx,
    required this.l10n,
    required this.onTap,
  });
  final Listing          listing;
  final int              imgIdx;
  final AppLocalizations l10n;
  final VoidCallback     onTap;

  @override
  State<_BrowseNearbyCard> createState() =>
      _BrowseNearbyCardState();
}

class _BrowseNearbyCardState extends State<_BrowseNearbyCard> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color:      Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset:     const Offset(0, 2)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize:       MainAxisSize.min,
          children: [

            // Image + heart
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    _imageFor(widget.listing.category,
                        widget.imgIdx),
                    fit:           BoxFit.contain,
                    filterQuality: FilterQuality.medium,
                    errorBuilder: (_, __, ___) =>
                        const ColoredBox(
                            color: Color(0xFFF3F7F0)),
                  ),
                  Positioned(
                    top: 6, right: 6,
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _saved = !_saved),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.12),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Icon(
                          _saved
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size:  18,
                          color: _saved
                              ? Colors.red
                              : Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 7, 8, 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatPrice(widget.listing.price),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize:   14,
                      fontWeight: FontWeight.w900,
                      color:      _kGreen,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.listing.displayTitle(widget.l10n),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize:   12,
                      fontWeight: FontWeight.w700,
                      color:      AppColors.textPrimary,
                      height:     1.25,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(children: [
                    Icon(Icons.location_on_outlined,
                        size:  12,
                        color: Colors.grey.shade600),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        widget.listing.shortLocation,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize:   10,
                          fontWeight: FontWeight.w600,
                          color:      Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ]),
                  if (widget.listing.isVerified) ...[
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.verified_rounded,
                          size: 12, color: _kOrange),
                      const SizedBox(width: 3),
                      Text(
                        widget.l10n.verifiedSeller,
                        style: const TextStyle(
                          fontSize:   10,
                          fontWeight: FontWeight.w800,
                          color:      _kOrange,
                        ),
                      ),
                    ]),
                  ],
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
// BROWSE GRID
// ═══════════════════════════════════════════════════════════════
class _BrowseGrid extends StatelessWidget {
  const _BrowseGrid({
    required this.items,
    required this.isLoadingMore,
    required this.l10n,
    required this.onItemTap,
  });
  final List<Listing>               items;
  final bool                        isLoadingMore;
  final AppLocalizations            l10n;
  final void Function(Listing, int) onItemTap;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += 2) {
      final left  = items[i];
      final right =
          (i + 1 < items.length) ? items[i + 1] : null;
      rows.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _ProductCard(
              listing:    left,
              imageIndex: i,
              onTap:      () => onItemTap(left, i),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: right != null
                ? _ProductCard(
                    listing:    right,
                    imageIndex: i + 1,
                    onTap:      () => onItemTap(right, i + 1),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ));
      if (i + 2 < items.length || isLoadingMore) {
        rows.add(const SizedBox(height: AppSpacing.md));
      }
    }
    if (isLoadingMore) {
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 22, height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text(l10n.loadingMore,
              style: const TextStyle(
                fontSize:   AppTextSize.body,
                color:      AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              )),
        ],
      ));
    }
    return Column(children: rows);
  }
}