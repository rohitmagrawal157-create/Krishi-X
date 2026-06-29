// lib/features/post/post_listing_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/core/services/location_service.dart';
import 'package:krishix/core/widgets/location_picker.dart';
import 'package:krishix/features/post/forms/post_form_config.dart';
import 'package:krishix/features/post/widgets/post_form_fields.dart';
import 'package:krishix/features/post/widgets/post_photo_picker.dart';

const Color _kGreen  = AppColors.primaryGreen;
const Color _kOrange = Color(0xFFFF6B00);
/// Same soft background for every post form (sell, rent, land, crops, etc.).
const Color _kFormPageBg = Color(0xFFF1F8E9);

// ═══════════════════════════════════════════════════════════════
// EXTENDED CATEGORY  (superset of ListingCategory)
// We keep the original enum for the Listing model but use a richer
// enum internally for the post form.
// ═══════════════════════════════════════════════════════════════
enum _PostCat {
  cropsGrains,
  seedsPlants,
  fruitsVeg,
  livestock,
  tractors,
  landBuy,
  landRent,
  rental,
}

extension _PostCatX on _PostCat {
  String titleFieldLabel(String? sectionId) {
    if (sectionId == CategorySectionId.farmMachinery) return 'Farm Machinery Name *';
    if (sectionId == CategorySectionId.tractorsParts) return 'Tractor Part Name *';
    if (sectionId == CategorySectionId.farmMachineryRent) return 'Machinery Name *';
    if (sectionId == CategorySectionId.jcbRental) return 'JCB / Excavator Name *';
    if (sectionId == CategorySectionId.tractorRental) return 'Tractor Name *';
    switch (this) {
      case _PostCat.cropsGrains: return 'Crop or Grain Name *';
      case _PostCat.seedsPlants: return 'Seed or Plant Name *';
      case _PostCat.fruitsVeg:   return 'Fruit or Vegetable Name *';
      case _PostCat.livestock:   return 'Livestock Name *';
      case _PostCat.tractors:    return 'Tractor Name *';
      case _PostCat.landBuy:     return 'Farm Land Name *';
      case _PostCat.landRent:    return 'Farm Land Name *';
      case _PostCat.rental:      return 'Equipment Name *';
    }
  }

  String get label {
    switch (this) {
      case _PostCat.cropsGrains: return 'Crops & Grains';
      case _PostCat.seedsPlants: return 'Seeds & Plants';
      case _PostCat.fruitsVeg:   return 'Fruits & Vegetables';
      case _PostCat.livestock:   return 'Livestock';
      case _PostCat.tractors:    return 'Tractors & Machinery';
      case _PostCat.landBuy:     return 'Farm Land – Buy/Sell';
      case _PostCat.landRent:    return 'Farm Land – Lease/Rent';
      case _PostCat.rental:      return 'Rental Equipment';
    }
  }

  IconData get icon {
    switch (this) {
      case _PostCat.cropsGrains: return Icons.grass_rounded;
      case _PostCat.seedsPlants: return Icons.yard_rounded;
      case _PostCat.fruitsVeg:   return Icons.eco_rounded;
      case _PostCat.livestock:   return Icons.pets_rounded;
      case _PostCat.tractors:    return Icons.agriculture_rounded;
      case _PostCat.landBuy:     return Icons.landscape_rounded;
      case _PostCat.landRent:    return Icons.real_estate_agent_rounded;
      case _PostCat.rental:      return Icons.construction_rounded;
    }
  }

  Color get color {
    switch (this) {
      case _PostCat.cropsGrains: return const Color(0xFF689F38);
      case _PostCat.seedsPlants: return const Color(0xFF558B2F);
      case _PostCat.fruitsVeg:   return const Color(0xFF7CB342);
      case _PostCat.livestock:   return const Color(0xFF8D6E63);
      case _PostCat.tractors:    return const Color(0xFF388E3C);
      case _PostCat.landBuy:     return const Color(0xFF0277BD);
      case _PostCat.landRent:    return const Color(0xFF00838F);
      case _PostCat.rental:      return const Color(0xFFF57C00);
    }
  }

  // Map back to ListingCategory for the Listing model
  ListingCategory get listingCategory {
    switch (this) {
      case _PostCat.cropsGrains:
      case _PostCat.seedsPlants:
      case _PostCat.fruitsVeg:   return ListingCategory.crops;
      case _PostCat.livestock:   return ListingCategory.livestock;
      case _PostCat.tractors:    return ListingCategory.tractors;
      case _PostCat.landBuy:
      case _PostCat.landRent:    return ListingCategory.land;
      case _PostCat.rental:      return ListingCategory.rental;
    }
  }

  // Force listing type for land variants
  ListingType? get forcedType {
    if (this == _PostCat.landBuy)  return ListingType.sell;
    if (this == _PostCat.landRent) return ListingType.rent;
    if (this == _PostCat.rental)   return ListingType.rent;
    return null;
  }

  Color get bgColor => _kFormPageBg;

  /// Same images as home-screen category tiles.
  String imagePath([String? sectionId]) {
    if (sectionId != null) {
      final mapped = _sectionCategoryImages[sectionId];
      if (mapped != null) return mapped;
    }
    return _defaultCategoryImages[this]!;
  }
}

const _sectionCategoryImages = <String, String>{
  CategorySectionId.cropsAndGrains:      'assets/sub_ctg/KrishiX_App-31.jpg',
  CategorySectionId.fruitsVeg:           'assets/sub_ctg/KrishiX_App-47.jpg',
  CategorySectionId.livestock:             'assets/sub_ctg/KrishiX_App-54.jpg',
  CategorySectionId.agricultureLandSale:   'assets/sub_ctg/KrishiX_App-65.jpg',
  CategorySectionId.seedsAndPlants:        'assets/sub_ctg/KrishiX_App-71.jpg',
  CategorySectionId.farmMachinery:         'assets/sub_ctg/KrishiX_App-21.jpg',
  CategorySectionId.tractorsBuy:           'assets/sub_ctg/KrishiX_App-17.jpg',
  CategorySectionId.tractorsParts:         'assets/sub_ctg/KrishiX_App-17.jpg',
  CategorySectionId.agricultureLandLease:  'assets/sub_ctg/KrishiX_App-65.jpg',
  CategorySectionId.tractorRental:         'assets/sub_ctg/KrishiX_App-17.jpg',
  CategorySectionId.farmMachineryRent:     'assets/sub_ctg/KrishiX_App-21.jpg',
  CategorySectionId.jcbRental:             'assets/sub_ctg/KrishiX_App-23.jpg',
};

const _defaultCategoryImages = <_PostCat, String>{
  _PostCat.cropsGrains: 'assets/sub_ctg/KrishiX_App-31.jpg',
  _PostCat.seedsPlants: 'assets/sub_ctg/KrishiX_App-71.jpg',
  _PostCat.fruitsVeg:   'assets/sub_ctg/KrishiX_App-47.jpg',
  _PostCat.livestock:   'assets/sub_ctg/KrishiX_App-54.jpg',
  _PostCat.tractors:    'assets/sub_ctg/KrishiX_App-17.jpg',
  _PostCat.landBuy:     'assets/sub_ctg/KrishiX_App-65.jpg',
  _PostCat.landRent:     'assets/sub_ctg/KrishiX_App-65.jpg',
  _PostCat.rental:      'assets/sub_ctg/KrishiX_App-21.jpg',
};

// Map incoming section / category → _PostCat
_PostCat _postCatFrom({
  String? sectionId,
  ListingCategory? cat,
  ListingType? type,
}) {
  if (sectionId != null) {
    switch (sectionId) {
      case CategorySectionId.cropsAndGrains:
        return _PostCat.cropsGrains;
      case CategorySectionId.fruitsVeg:
        return _PostCat.fruitsVeg;
      case CategorySectionId.seedsAndPlants:
        return _PostCat.seedsPlants;
      case CategorySectionId.livestock:
        return _PostCat.livestock;
      case CategorySectionId.tractorsBuy:
      case CategorySectionId.farmMachinery:
      case CategorySectionId.tractorsParts:
        return _PostCat.tractors;
      case CategorySectionId.agricultureLandSale:
        return _PostCat.landBuy;
      case CategorySectionId.agricultureLandLease:
        return _PostCat.landRent;
      case CategorySectionId.tractorRental:
      case CategorySectionId.farmMachineryRent:
      case CategorySectionId.jcbRental:
        return _PostCat.rental;
    }
  }
  return _defaultPostCat(cat, type);
}

// Map incoming ListingCategory → default _PostCat
_PostCat _defaultPostCat(ListingCategory? cat, ListingType? type) {
  if (cat == null) return _PostCat.cropsGrains;
  switch (cat) {
    case ListingCategory.crops:     return _PostCat.cropsGrains;
    case ListingCategory.livestock: return _PostCat.livestock;
    case ListingCategory.tractors:  return _PostCat.tractors;
    case ListingCategory.land:
      return type == ListingType.rent ? _PostCat.landRent : _PostCat.landBuy;
    case ListingCategory.rental:    return _PostCat.rental;
  }
}

// ── Per-category extra fields ─────────────────────────────────
class _ExtraField {
  const _ExtraField({
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.suffixText,
    this.formatters,
    this.unitOptions,
    this.defaultUnit,
  });
  final String                    label;
  final String                    hint;
  final IconData                  icon;
  final TextInputType             keyboardType;
  final String?                   suffixText;
  final List<TextInputFormatter>? formatters;
  final List<String>?             unitOptions;
  final String?                   defaultUnit;

  bool get hasUnitPicker =>
      unitOptions != null && unitOptions!.isNotEmpty;
}

const Map<_PostCat, String> _titleHints = {
  _PostCat.cropsGrains: 'e.g. Wheat – 20 Quintal, A-Grade',
  _PostCat.seedsPlants: 'e.g. Hybrid Tomato Seeds – 500g Pack',
  _PostCat.fruitsVeg:   'e.g. Fresh Alphonso Mangoes – 10 Dozen',
  _PostCat.livestock:   'e.g. Murrah Buffalo – High Milk Yield',
  _PostCat.tractors:    'e.g. Mahindra 575 DI – 2019 Model',
  _PostCat.landBuy:     'e.g. 5 Acre Irrigated Farm Land for Sale',
  _PostCat.landRent:    'e.g. 3 Acre Farm Land Available for Lease',
  _PostCat.rental:      'e.g. JCB 3DX Backhoe – Available Daily',
};

final Map<_PostCat, List<_ExtraField>> _extraFields = {
  _PostCat.cropsGrains: [
    _ExtraField(
      label:       'Quantity',
      hint:        'e.g. 20',
      icon:        Icons.scale_rounded,
      keyboardType: TextInputType.number,
      unitOptions: PostUnits.cropsGrains,
      defaultUnit: 'Quintal',
      formatters:  [FilteringTextInputFormatter.digitsOnly],
    ),
    _ExtraField(
      label: 'Grade / Quality',
      hint:  'e.g. A-Grade, Premium, Mixed',
      icon:  Icons.workspace_premium_rounded,
    ),
    _ExtraField(
      label: 'Harvest Date',
      hint:  'e.g. June 2026',
      icon:  Icons.calendar_today_rounded,
    ),
  ],
  _PostCat.seedsPlants: [
    _ExtraField(
      label: 'Crop / Plant Type',
      hint:  'e.g. Tomato, Brinjal, Onion, Mango sapling',
      icon:  Icons.yard_rounded,
    ),
    _ExtraField(
      label:       'Quantity / Pack Size',
      hint:        'e.g. 500',
      icon:        Icons.scale_rounded,
      keyboardType: TextInputType.number,
      unitOptions: PostUnits.seedsPlants,
      defaultUnit: 'grams',
      formatters:  [FilteringTextInputFormatter.digitsOnly],
    ),
    _ExtraField(
      label: 'Seed / Plant Brand',
      hint:  'e.g. Mahyco, Syngenta, Local variety',
      icon:  Icons.branding_watermark_rounded,
    ),
    _ExtraField(
      label: 'Sowing Season',
      hint:  'e.g. Kharif, Rabi, Any season',
      icon:  Icons.wb_sunny_rounded,
    ),
  ],
  _PostCat.fruitsVeg: [
    _ExtraField(
      label: 'Variety',
      hint:  'e.g. Alphonso, Devgad, Cherry Tomato',
      icon:  Icons.eco_rounded,
    ),
    _ExtraField(
      label:       'Quantity Available',
      hint:        'e.g. 50',
      icon:        Icons.scale_rounded,
      keyboardType: TextInputType.number,
      unitOptions: PostUnits.fruitsVeg,
      defaultUnit: 'Kg',
      formatters:  [FilteringTextInputFormatter.digitsOnly],
    ),
    _ExtraField(
      label: 'Grade / Quality',
      hint:  'e.g. Premium, Export, Mixed',
      icon:  Icons.workspace_premium_rounded,
    ),
    _ExtraField(
      label: 'Harvest / Available From',
      hint:  'e.g. Ready now, July 2026',
      icon:  Icons.calendar_today_rounded,
    ),
  ],
  _PostCat.livestock: [
    _ExtraField(
      label: 'Breed',
      hint:  'e.g. Murrah, HF, Gir, Sahiwal',
      icon:  Icons.pets_rounded,
    ),
    _ExtraField(
      label: 'Age',
      hint:  'e.g. 3 years, 18 months',
      icon:  Icons.cake_rounded,
    ),
    _ExtraField(
      label:       'Milk Yield (if applicable)',
      hint:        'e.g. 14',
      icon:        Icons.water_drop_rounded,
      keyboardType: TextInputType.number,
      suffixText:  'L/day',
      formatters:  [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
    ),
  ],
  _PostCat.tractors: [
    _ExtraField(
      label: 'Brand',
      hint:  'e.g. Mahindra, Swaraj, John Deere',
      icon:  Icons.branding_watermark_rounded,
    ),
    _ExtraField(
      label:       'Year of Manufacture',
      hint:        'e.g. 2019',
      icon:        Icons.calendar_month_rounded,
      keyboardType: TextInputType.number,
      formatters:  [FilteringTextInputFormatter.digitsOnly],
    ),
    _ExtraField(
      label:       'Horse Power (HP)',
      hint:        'e.g. 45',
      icon:        Icons.speed_rounded,
      keyboardType: TextInputType.number,
      suffixText:  'HP',
      formatters:  [FilteringTextInputFormatter.digitsOnly],
    ),
    _ExtraField(
      label: 'Condition',
      hint:  'e.g. Good, Excellent, Needs Repair',
      icon:  Icons.star_outline_rounded,
    ),
  ],
  _PostCat.landBuy: [
    _ExtraField(
      label:       'Total Area',
      hint:        'e.g. 5',
      icon:        Icons.straighten_rounded,
      keyboardType: TextInputType.number,
      suffixText:  'Acres',
      formatters:  [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
    ),
    _ExtraField(
      label: 'Survey Number',
      hint:  'e.g. 142/3 (optional)',
      icon:  Icons.pin_outlined,
    ),
    _ExtraField(
      label: 'Soil Type',
      hint:  'e.g. Black, Red, Alluvial',
      icon:  Icons.layers_rounded,
    ),
    _ExtraField(
      label: 'Water Source',
      hint:  'e.g. Borewell, Canal, Rain-fed',
      icon:  Icons.water_rounded,
    ),
    _ExtraField(
      label: 'Road Access',
      hint:  'e.g. Yes – 10ft road, No',
      icon:  Icons.add_road_rounded,
    ),
    _ExtraField(
      label: 'Legal Status',
      hint:  'e.g. Clear title, NA converted',
      icon:  Icons.gavel_rounded,
    ),
  ],
  _PostCat.landRent: [
    _ExtraField(
      label:       'Total Area Available',
      hint:        'e.g. 3',
      icon:        Icons.straighten_rounded,
      keyboardType: TextInputType.number,
      suffixText:  'Acres',
      formatters:  [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
    ),
    _ExtraField(
      label: 'Lease Duration',
      hint:  'e.g. 1 year, Season-wise, 3 years',
      icon:  Icons.access_time_rounded,
    ),
    _ExtraField(
      label: 'Soil Type',
      hint:  'e.g. Black, Red, Alluvial',
      icon:  Icons.layers_rounded,
    ),
    _ExtraField(
      label: 'Water Source',
      hint:  'e.g. Borewell, Canal, Rain-fed',
      icon:  Icons.water_rounded,
    ),
    _ExtraField(
      label: 'Existing Crop (if any)',
      hint:  'e.g. Sugarcane, Cotton, Fallow',
      icon:  Icons.grass_rounded,
    ),
    _ExtraField(
      label: 'Lease Terms',
      hint:  'e.g. Negotiable, Fixed rent ₹8000/acre/yr',
      icon:  Icons.handshake_outlined,
    ),
  ],
  _PostCat.rental: [
    _ExtraField(
      label: 'Equipment Type',
      hint:  'e.g. Rotavator, JCB, Sprayer, Harvester',
      icon:  Icons.construction_rounded,
    ),
    _ExtraField(
      label: 'Rental Duration',
      hint:  'e.g. Per Hour, Per Day, Weekly',
      icon:  Icons.access_time_rounded,
    ),
    _ExtraField(
      label: 'Delivery Available?',
      hint:  'e.g. Yes – within 20 km, No – self pickup',
      icon:  Icons.local_shipping_rounded,
    ),
  ],
};

const Map<_PostCat, String> _descHints = {
  _PostCat.cropsGrains: 'Describe crop quality, packaging, storage, any certifications…',
  _PostCat.seedsPlants: 'Describe germination rate, source, any certifications, storage advice…',
  _PostCat.fruitsVeg:   'Describe freshness, packaging, delivery options, minimum order…',
  _PostCat.livestock:   'Describe health condition, vaccination history, feeding habits…',
  _PostCat.tractors:    'Describe service history, attachments included, any repairs done…',
  _PostCat.landBuy:     'Describe road access, irrigation, nearby facilities, legal status…',
  _PostCat.landRent:    'Describe current land condition, who bears water/electricity cost, access road…',
  _PostCat.rental:      'Describe availability, included operator, service area, terms…',
};

// ═══════════════════════════════════════════════════════════════
// POST LISTING SCREEN  (2-page stepper)
// ═══════════════════════════════════════════════════════════════
class PostListingScreen extends StatefulWidget {
  const PostListingScreen({
    super.key,
    this.sectionId,
    this.initialCategory,
    this.initialType,
    this.categoryLabel,
  });
  final String?          sectionId;
  final ListingCategory? initialCategory;
  final ListingType?     initialType;
  final String?          categoryLabel;

  @override
  State<PostListingScreen> createState() => _PostListingScreenState();
}

class _PostListingScreenState extends State<PostListingScreen> {
  late _PostCat    _cat;
  late ListingType _type;

  final _pageCtrl = PageController();
  int _page = 0;

  // Page 1
  final _titleCtr = TextEditingController();
  final _priceCtr = TextEditingController();
  final _descCtr  = TextEditingController();
  final Map<String, TextEditingController> _extraCtrs = {};
  final Map<String, String> _unitSelections = {};

  // Page 2
  final _nameCtr     = TextEditingController(text: 'Ramesh Patil');
  final _locationCtr = TextEditingController(
    text: 'Aurangabad, Chhatrapati Sambhajinagar, Maharashtra',
  );
  final _phoneCtr    = TextEditingController(text: '+91 98765 43210');

  final _formKey1 = GlobalKey<FormState>();
  Key   _page1Key = UniqueKey();
  final _formKey2 = GlobalKey<FormState>();
  bool  _isSubmitting = false;
  int   _photoCount = 0;
  bool  _photosError = false;
  final _photoPickerKey = GlobalKey<PostPhotoPickerState>();

  List<_ExtraField> get _fields => _extraFields[_cat] ?? [];

  /// Sell → green top · Rent → orange top.
  Color get _headerColor =>
      _type == ListingType.sell ? _kGreen : _kOrange;

  /// Opposite of header — category box & action buttons.
  Color get _accentColor =>
      _type == ListingType.sell ? _kOrange : _kGreen;

  @override
  void initState() {
    super.initState();
    _cat  = _postCatFrom(
      sectionId: widget.sectionId,
      cat:       widget.initialCategory,
      type:      widget.initialType,
    );
    _type = widget.initialType ?? _cat.forcedType ?? ListingType.sell;
    _initExtraControllers();
  }

  void _initExtraControllers() {
    for (final c in _extraCtrs.values) c.dispose();
    _extraCtrs.clear();
    _unitSelections.clear();
    for (final f in _fields) {
      _extraCtrs[f.label] = TextEditingController();
      if (f.hasUnitPicker) {
        _unitSelections[f.label] =
            f.defaultUnit ?? f.unitOptions!.first;
      }
    }
  }

  void _onCatChanged(_PostCat newCat) {
    setState(() {
      _cat      = newCat;
      _type     = newCat.forcedType ?? _type;
      _page1Key = UniqueKey();
      _initExtraControllers();
      _titleCtr.clear();
      _priceCtr.clear();
      _descCtr.clear();
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _titleCtr.dispose();
    _priceCtr.dispose();
    _descCtr.dispose();
    for (final c in _extraCtrs.values) c.dispose();
    _nameCtr.dispose();
    _locationCtr.dispose();
    _phoneCtr.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (!_formKey1.currentState!.validate()) return;
    if (_photoCount < 1) {
      setState(() => _photosError = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please add at least 1 photo before continuing'),
          backgroundColor: _accentColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    setState(() {
      _page = 1;
      _photosError = false;
    });
    _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 320), curve: Curves.easeInOut);
  }

  void _prevPage() {
    setState(() => _page = 0);
    _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 320), curve: Curves.easeInOut);
  }

  Future<void> _submit() async {
    if (!_formKey2.currentState!.validate()) return;
    if (_photoCount < 1) {
      setState(() {
        _page = 0;
        _photosError = true;
      });
      _pageCtrl.jumpToPage(0);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please add at least 1 photo before submitting'),
          backgroundColor: _accentColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Row(children: [
        Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
        SizedBox(width: 10),
        Text('Ad submitted! It will go live after review.'),
      ]),
      backgroundColor: _kGreen,
      behavior:        SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cat.bgColor,
      appBar:          _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageCtrl,
              physics:    const NeverScrollableScrollPhysics(),
              children: [_buildPage1(), _buildPage2()],
            ),
          ),
        ],
      ),
    );
  }

  // ── AppBar ───────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _headerColor,
      foregroundColor: Colors.white,
      elevation:       0,
      centerTitle:     true,
      title: Text(
        _page == 0 ? 'Post Ad – Listing Details' : 'Post Ad – Seller Details',
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () {
          if (_page == 1) _prevPage(); else Navigator.of(context).pop();
        },
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            children: [
              _CompactStep(
                number:    1,
                label:     'Listing',
                active:    _page == 0,
                done:      _page > 0,
                tintColor: _headerColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      color: _page > 0
                          ? Colors.white
                          : Colors.white.withOpacity(0.28),
                    ),
                  ),
                ),
              ),
              _CompactStep(
                number:    2,
                label:     'Seller',
                active:    _page == 1,
                done:      false,
                tintColor: _headerColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════ PAGE 1 ══════════════════════════════════════
  Widget _buildPage1() {
    final titleHint = _titleHints[_cat] ?? 'Enter listing title';
    final fields    = _extraFields[_cat] ?? [];

    return KeyedSubtree(
      key: _page1Key,
      child: Form(
        key: _formKey1,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Category banner
              _CategoryBanner(
                cat:          _cat,
                type:         _type,
                sectionId:    widget.sectionId,
                accentColor:  _accentColor,
              ),

              const SizedBox(height: 24),

              // Title
              _FieldLabel(
                label: _cat.titleFieldLabel(widget.sectionId),
                icon: Icons.title_rounded,
              ),
              const SizedBox(height: 8),
              _Field(
                controller:     _titleCtr,
                hint:           titleHint,
                capitalization: TextCapitalization.words,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Title is required' : null,
              ),

              const SizedBox(height: 18),

              // Dynamic extra fields
              for (final field in fields) ...[
                _FieldLabel(label: field.label, icon: field.icon),
                const SizedBox(height: 8),
                if (field.hasUnitPicker)
                  PostQuantityField(
                    controller:   _extraCtrs[field.label]!,
                    hint:         field.hint,
                    units:        field.unitOptions!,
                    selectedUnit: _unitSelections[field.label]!,
                    formatters:   field.formatters,
                    accentColor:  _accentColor,
                    onUnitChanged: (unit) {
                      setState(() => _unitSelections[field.label] = unit);
                    },
                  )
                else
                  _Field(
                    controller:   _extraCtrs[field.label]!,
                    hint:         field.hint,
                    keyboardType: field.keyboardType,
                    suffixText:   field.suffixText,
                    formatters:   field.formatters,
                  ),
                const SizedBox(height: 18),
              ],

              // Price
              _FieldLabel(
                label: _type == ListingType.rent
                    ? 'Rental Price *' : 'Expected Price *',
                icon: Icons.currency_rupee_rounded,
              ),
              const SizedBox(height: 8),
              _Field(
                controller:   _priceCtr,
                hint:         _type == ListingType.rent
                    ? 'e.g. 4500  (per day)' : 'e.g. 18000',
                prefixText:   '₹ ',
                keyboardType: TextInputType.number,
                formatters:   [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Price is required' : null,
              ),

              const SizedBox(height: 18),

              // ── Photo upload (required) ───────────────
              const _FieldLabel(
                  label: 'Photos *',
                  icon:  Icons.photo_library_outlined),
              const SizedBox(height: 4),
              Text(
                'Minimum 1 photo required · up to 5 photos',
                style: TextStyle(
                    fontSize: 11, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 10),
              PostPhotoPicker(
                key: _photoPickerKey,
                accentColor: _accentColor,
                showError: _photosError,
                onChanged: (count) {
                  setState(() {
                    _photoCount = count;
                    if (count > 0) _photosError = false;
                  });
                },
              ),

              const SizedBox(height: 18),

              // Description
              _FieldLabel(
                  label: 'Description *',
                  icon:  Icons.description_outlined),
              const SizedBox(height: 4),
              Text(
                _descHints[_cat] ?? '',
                style: TextStyle(
                    fontSize: 11, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller:   _descCtr,
                minLines:     4,
                maxLines:     6,
                keyboardType: TextInputType.multiline,
                decoration:   _inputDecoration(
                    hint: 'Write a detailed description…'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Description is required' : null,
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentColor,
                    foregroundColor: Colors.white,
                    elevation:       0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Next',
                          style: TextStyle(
                              fontSize:   16,
                              fontWeight: FontWeight.w800)),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_rounded, size: 22),
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

  // ═══════════ PAGE 2 ══════════════════════════════════════
  Widget _buildPage2() {
    return Form(
      key: _formKey2,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding:    const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:        _kGreen.withOpacity(0.07),
                borderRadius: BorderRadius.circular(12),
                border:       Border.all(color: _kGreen.withOpacity(0.20)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: _kGreen, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'These details will be shown to buyers. '
                      'Phone number is fetched from your account.',
                      style: TextStyle(
                        fontSize: 12,
                        color:    _kGreen.withOpacity(0.85),
                        height:   1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const _FieldLabel(
                label: 'Your Name *',
                icon:  Icons.person_outline_rounded),
            const SizedBox(height: 8),
            _Field(
              controller:     _nameCtr,
              hint:           'Full name',
              capitalization: TextCapitalization.words,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Name is required' : null,
            ),

            const SizedBox(height: 18),

            const _FieldLabel(
                label: 'Location *',
                icon:  Icons.location_on_outlined),
            const SizedBox(height: 4),
            Text(
              'Village / Taluka / District where the item is located',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 8),
            LocationPickerField(
              controller: _locationCtr,
              accentColor: _kGreen,
              useFullScreen: true,
              onUseMyLocation: () async {
                final loc = await LocationService.fetchCurrentLocation(
                  requestPermissionIfNeeded: true,
                );
                return loc.permissionGranted ? loc : null;
              },
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Location is required' : null,
            ),

            const SizedBox(height: 18),

            const _FieldLabel(
                label: 'Contact Number',
                icon:  Icons.phone_outlined),
            const SizedBox(height: 4),
            Text(
              'Fetched from your account — cannot be changed here',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller:  _phoneCtr,
              enabled:     false,
              keyboardType: TextInputType.phone,
              style: TextStyle(
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600),
              decoration: _inputDecoration(
                hint:       '+91 XXXXX XXXXX',
                filled:     true,
                fillColor:  Colors.grey.shade100,
                prefixIcon: Icon(Icons.lock_outline_rounded,
                    size: 18, color: Colors.grey.shade400),
              ),
            ),

            const SizedBox(height: 32),

            _ListingSummary(
              category: _cat.label,
              type:     _type == ListingType.sell ? 'Sell' : 'Rent',
              title:    _titleCtr.text,
              price:    _priceCtr.text,
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor:         _accentColor,
                  foregroundColor:         Colors.white,
                  disabledBackgroundColor: _accentColor.withOpacity(0.50),
                  elevation:               0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 24, height: 24,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5))
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_rounded, size: 20),
                          SizedBox(width: 10),
                          Text('Submit Listing',
                              style: TextStyle(
                                  fontSize:   16,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 12),
            Center(
              child: Text(
                'Your listing will be reviewed before going live.',
                style: TextStyle(
                    fontSize: 12, color: Colors.grey.shade500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Category sheet ───────────────────────────────────────
  void _showCategorySheet() {
    showModalBottomSheet<void>(
      context:    context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.60,
        minChildSize:     0.45,
        maxChildSize:     0.85,
        expand:           false,
        builder: (_, ctrl) => Column(
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Select Category',
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                controller: ctrl,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                children: _PostCat.values.map((cat) {
                  final sel = _cat == cat;
                  return GestureDetector(
                    onTap: () {
                      _onCatChanged(cat);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color:        sel ? cat.color.withOpacity(0.10) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: sel ? cat.color : Colors.grey.shade200,
                          width: sel ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width:  38, height: 38,
                            decoration: BoxDecoration(
                              color:        cat.color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(cat.icon, size: 20, color: cat.color),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              cat.label,
                              style: TextStyle(
                                fontSize:   14,
                                fontWeight: FontWeight.w700,
                                color: sel ? cat.color : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (sel)
                            Icon(Icons.check_circle_rounded,
                                size: 20, color: cat.color),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Type sheet ───────────────────────────────────────────
  void _showTypeSheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sell or Rent?',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            Row(
              children: [
                _TypeTile(
                  label:    'Sell',
                  icon:     Icons.sell_outlined,
                  selected: _type == ListingType.sell,
                  onTap: () {
                    setState(() => _type = ListingType.sell);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 12),
                _TypeTile(
                  label:    'Rent',
                  icon:     Icons.handshake_outlined,
                  selected: _type == ListingType.rent,
                  onTap: () {
                    setState(() => _type = ListingType.rent);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CATEGORY BANNER
// ─────────────────────────────────────────────────────────────
class _CategoryBanner extends StatelessWidget {
  const _CategoryBanner({
    required this.cat,
    required this.type,
    required this.accentColor,
    this.sectionId,
  });
  final _PostCat     cat;
  final ListingType  type;
  final Color        accentColor;
  final String?      sectionId;

  @override
  Widget build(BuildContext context) {
    final isRent = type == ListingType.rent;
    final imagePath = cat.imagePath(sectionId);
    final gradientStart = Color.lerp(accentColor, Colors.black, 0.18)!;
    return Container(
      padding:    const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [gradientStart, accentColor],
          begin: Alignment.topLeft,
          end:   Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width:  48,
              height: 48,
              color:  Colors.white,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  cat.icon,
                  color: accentColor,
                  size: 26,
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
                  cat.label,
                  style: const TextStyle(
                    color:      Colors.white,
                    fontSize:   15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isRent ? 'Rental listing' : 'For sale listing',
                  style: TextStyle(
                    color:    Colors.white.withOpacity(0.80),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _ListingTypeChip(isRent: isRent),
        ],
      ),
    );
  }
}

class _ListingTypeChip extends StatelessWidget {
  const _ListingTypeChip({required this.isRent});

  final bool isRent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color:        Colors.white.withOpacity(0.22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.45)),
      ),
      child: Text(
        isRent ? 'Rent' : 'Sell',
        style: const TextStyle(
          color:      Colors.white,
          fontSize:   11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// LISTING SUMMARY
// ─────────────────────────────────────────────────────────────
class _ListingSummary extends StatelessWidget {
  const _ListingSummary({
    required this.category,
    required this.type,
    required this.title,
    required this.price,
  });
  final String category;
  final String type;
  final String title;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:    const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        const Color(0xFFF0F7F0),
        borderRadius: BorderRadius.circular(12),
        border:       Border.all(color: _kGreen.withOpacity(0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_rounded, size: 16, color: _kGreen),
              const SizedBox(width: 6),
              const Text('Listing Summary',
                  style: TextStyle(
                    fontSize:   13,
                    fontWeight: FontWeight.w800,
                    color:      AppColors.textPrimary,
                  )),
            ],
          ),
          const SizedBox(height: 12),
          _SummaryRow(label: 'Category', value: category),
          _SummaryRow(label: 'Type',     value: type),
          if (title.isNotEmpty)
            _SummaryRow(label: 'Title', value: title),
          if (price.isNotEmpty)
            _SummaryRow(label: 'Price', value: '₹$price'),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: TextStyle(
                  fontSize:   12,
                  color:      Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                )),
          ),
          const Text('  ·  '),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                  fontSize:   12,
                  fontWeight: FontWeight.w700,
                  color:      AppColors.textPrimary,
                )),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// COMPACT STEP (inline circle + label)
// ─────────────────────────────────────────────────────────────
class _CompactStep extends StatelessWidget {
  const _CompactStep({
    required this.number,
    required this.label,
    required this.active,
    required this.done,
    required this.tintColor,
  });

  final int    number;
  final String label;
  final bool   active;
  final bool   done;
  final Color  tintColor;

  @override
  Widget build(BuildContext context) {
    final filled = active || done;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width:  20,
          height: 20,
          decoration: BoxDecoration(
            color:  filled ? Colors.white : Colors.transparent,
            shape:  BoxShape.circle,
            border: Border.all(
              color: filled
                  ? Colors.white
                  : Colors.white.withOpacity(0.45),
              width: 1.5,
            ),
          ),
          child: Center(
            child: done
                ? Icon(Icons.check_rounded, size: 12, color: tintColor)
                : Text(
                    '$number',
                    style: TextStyle(
                      fontSize:   10,
                      fontWeight: FontWeight.w800,
                      height:     1,
                      color: filled ? tintColor : Colors.white.withOpacity(0.70),
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize:   11,
            fontWeight: active ? FontWeight.w800 : FontWeight.w600,
            color: active || done
                ? Colors.white
                : Colors.white.withOpacity(0.55),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TYPE TILE
// ─────────────────────────────────────────────────────────────
class _TypeTile extends StatelessWidget {
  const _TypeTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final String       label;
  final IconData     icon;
  final bool         selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color:        selected ? _kGreen : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? _kGreen : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size:  22,
                  color: selected ? Colors.white : Colors.grey.shade600),
              const SizedBox(height: 6),
              Text(label,
                  style: TextStyle(
                    fontSize:   14,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : AppColors.textPrimary,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// FIELD LABEL
// ─────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, required this.icon});
  final String   label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _kGreen),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
              fontSize:   13,
              fontWeight: FontWeight.w700,
              color:      AppColors.textPrimary,
            )),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// REUSABLE FIELD
// ─────────────────────────────────────────────────────────────
class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    this.prefixText,
    this.suffixText,
    this.keyboardType,
    this.capitalization = TextCapitalization.none,
    this.formatters,
    this.validator,
  });
  final TextEditingController      controller;
  final String                     hint;
  final String?                    prefixText;
  final String?                    suffixText;
  final TextInputType?             keyboardType;
  final TextCapitalization         capitalization;
  final List<TextInputFormatter>?  formatters;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:         controller,
      keyboardType:       keyboardType,
      textCapitalization: capitalization,
      inputFormatters:    formatters,
      decoration: _inputDecoration(
          hint: hint, prefixText: prefixText, suffixText: suffixText),
      validator: validator,
    );
  }
}
// ─────────────────────────────────────────────────────────────
// INPUT DECORATION
// ─────────────────────────────────────────────────────────────
InputDecoration _inputDecoration({
  required String hint,
  String?  prefixText,
  String?  suffixText,
  bool     filled    = true,
  Color?   fillColor,
  Widget?  prefixIcon,
}) {
  return InputDecoration(
    hintText:    hint,
    hintStyle:   TextStyle(color: Colors.grey.shade400, fontSize: 13),
    prefixText:  prefixText,
    suffixText:  suffixText,
    prefixStyle: const TextStyle(
        fontWeight: FontWeight.w700, color: AppColors.textPrimary),
    suffixStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color:      Colors.grey.shade500,
        fontSize:   13),
    prefixIcon:     prefixIcon,
    filled:         filled,
    fillColor:      fillColor ?? Colors.white,
    counterText:    '',
    contentPadding: const EdgeInsets.symmetric(
        horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:   BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:   BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:   const BorderSide(color: _kGreen, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:   const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:   const BorderSide(color: Colors.red, width: 2),
    ),
  );
}
