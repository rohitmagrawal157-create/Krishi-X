import 'package:krishix/core/models/listing.dart';

/// Category tile images — [assets/new_ctg/].
/// Listing card/detail pools — [assets/images/] (per subcategory when available).
abstract final class CategoryImages {
  // ── Main category tiles (home, sell/rent picker) ───────────
  static const cropsGrains   = 'assets/new_ctg/KrishiX_App-04.jpg';
  static const fruitsVeg     = 'assets/new_ctg/KrishiX_App-05.jpg';
  static const vegetables    = 'assets/new_ctg/KrishiX_App-43.jpg';
  static const fruits        = 'assets/new_ctg/KrishiX_App-48.jpg';
  static const livestock     = 'assets/new_ctg/KrishiX_App-06.jpg';
  static const land          = 'assets/new_ctg/KrishiX_App-07.jpg';
  static const seedsPlants   = 'assets/new_ctg/KrishiX_App-08.jpg';
  static const farmMachinery = 'assets/new_ctg/KrishiX_App-09.jpg';
  static const tractors      = 'assets/new_ctg/KrishiX_App-10.jpg';
  static const jcbRental     = 'assets/new_ctg/KrishiX_App-23.jpg';

  /// Catch-all tile shown at the end of every subcategory group grid.
  static const subcategoryOthers = 'assets/new_ctg/KrishiX_App-11.jpg';

  // ── Listing images (assets/images/) ────────────────────────
  static const wheat1    = 'assets/images/wheat1.jpg';
  static const wheat2    = 'assets/images/wheat2.jpg';
  static const wheatBase = 'assets/images/wheat.jpeg';

  static const tomato1 = 'assets/images/Tomato1.jpg';
  static const tomato2 = 'assets/images/tomato2.jpg';

  static const potato1 = 'assets/images/potato1.jpg';
  static const potato2 = 'assets/images/potato2.jpg';

  static const mango    = 'assets/images/mango.jpeg';
  static const mango2   = 'assets/images/mango2.jpg';
  static const mango3   = 'assets/images/mango3.jpg';

  static const rice    = 'assets/images/rice.jpeg';
  static const rice1   = 'assets/images/rice1.jpg';
  static const rice2   = 'assets/images/rice2.jpg';

  static const maize    = 'assets/images/maize.jpeg';
  static const maize1   = 'assets/images/maize1.jpg';
  static const maize2   = 'assets/images/maize2.jpg';
  static const maize3   = 'assets/images/maize3.jpg';

  static const jawar1    = 'assets/images/jawar1.jpg';
  static const jawar2    = 'assets/images/jawar2.jpg';
  static const jowarBase = jawar1;

  static const bajra1    = 'assets/images/bajra1.jpg';
  static const bajra2    = 'assets/images/bajara2.jpg';
  static const bajraBase = bajra1;

  static const barleyImg = wheat1;

  static const cow1     = 'assets/images/cow1.jpeg';
  static const cow2     = 'assets/images/cow2.jpeg';
  static const cow3     = 'assets/images/cow3.jpg';

  static const buffelo1 = 'assets/images/buffelo1.jpg';
  static const buffelo2 = 'assets/images/buffelo2.jpg';
  static const buffelo3 = 'assets/images/buffelo3.jpg';

  static const bull1 = 'assets/images/bull1.jpg';
  static const bull2 = 'assets/images/bull2.jpg';

  static const chicken1 = 'assets/images/chiken1.jpg';
  static const chicken2 = 'assets/images/chicken2.jpg';

  static const duck1 = 'assets/images/duck1.jpg';
  static const duck2 = 'assets/images/duck2.jpg';

  static const bananaBase = 'assets/images/banana.jpeg';
  static const banana1    = 'assets/images/banana1.jpg';
  static const banana2    = 'assets/images/banana2.jpg';

  static const orange1 = 'assets/images/orange1.jpg';
  static const orange2 = 'assets/images/orange2.jpg';

  static const anar1 = 'assets/images/anar1.jpg';
  static const anar2 = 'assets/images/anar2.jpg';

  static const garlic1 = 'assets/images/garlic1.jpg';
  static const garlic2 = 'assets/images/garlic2.jpg';

  static const onion1 = 'assets/images/onion1.jpeg';
  static const onion2 = 'assets/images/onion2.jpg';
  static const onion3 = 'assets/images/onion3.jpg';

  static const brinjal1 = 'assets/images/Brinjal2.jpeg';

  static const chilli1 = 'assets/images/chilli1.jpg';
  static const chilli2 = 'assets/images/chilli2.jpg';

  static const seeds1  = 'assets/images/seeds1.jpeg';
  static const seeds2  = 'assets/images/seeds2.jpeg';
  static const seed1   = seeds1;

  static const landBase = 'assets/images/land.jpeg';
  static const land1    = 'assets/images/land1.jpeg';
  static const land2    = 'assets/images/land2.jpeg';

  static const tractor1    = 'assets/images/tractor1.webp';
  static const tractor2    = 'assets/images/tractor2.webp';
  static const tractorAlt  = tractor2;

  static const machine1 = 'assets/images/machine1.jpeg';
  static const machine2 = 'assets/images/machine2.jpeg';
  static const machin1  = machine1;

  static const rotavator1 = 'assets/images/Rotavator1.webp';
  static const rotavator2 = 'assets/images/Rotavator2.webp';

  static const cultivator1 = 'assets/images/Cultivator1.webp';
  static const cultivator2 = 'assets/images/Cultivator2.webp';

  static const discHarrow1 = 'assets/images/DiscHarrow1.webp';
  static const discHarrow2 = 'assets/images/discHorrow2.webp';

  static const rent2  = 'assets/images/rent2.jpeg';
  static const jcb1   = machine1;
  static const veg1    = onion1;
  static const veg2    = tomato1;
  static const fruits1 = mango;
  static const food1   = potato1;
  static const pets1   = chicken1;

  static const defaultFallback = mango;

  // ── Per-subcategory listing pools (1–3 photos each) ────────
  static const _wheatPool     = [wheat1, wheat2, wheatBase];
  static const _tomatoPool    = [tomato1, tomato2];
  static const _potatoPool    = [potato1, potato2];
  static const _mangoPool     = [mango, mango2, mango3];
  static const _ricePool      = [rice1, rice2, rice];
  static const _maizePool     = [maize1, maize2, maize3];
  static const _jowarPool     = [jawar1, jawar2, maize1];
  static const _bajraPool     = [bajra1, bajra2];
  static const _barleyPool    = [wheat1, wheat2];
  static const _cowPool       = [cow1, cow2, cow3];
  static const _buffaloPool   = [buffelo1, buffelo2, buffelo3];
  static const _bullPool      = [bull1, bull2, cow1];
  static const _chickenPool   = [chicken1, chicken2];
  static const _duckPool      = [duck1, duck2];
  static const _bananaPool    = [banana1, banana2, bananaBase];
  static const _orangePool    = [orange1, orange2];
  static const _pomegranatePool = [anar1, anar2];
  static const _garlicPool    = [garlic1, garlic2];
  static const _onionPool     = [onion1, onion2, onion3];
  static const _brinjalPool   = [brinjal1];
  static const _chilliPool    = [chilli1, chilli2];
  static const _seedsPool     = [seeds1, seeds2];
  static const _landPool      = [land1, land2, landBase];
  static const _tractorsPool  = [tractor1, tractor2];
  static const _rentalPool    = [rent2, machine1, machine2];
  static const _machineryPool = [machine1, machine2];
  static const _rotavatorPool = [rotavator1, rotavator2];
  static const _cultivatorPool = [cultivator1, cultivator2];
  static const _discHarrowPool = [discHarrow1, discHarrow2];
  static const _jcbPool       = [jcb1, machine1, machine2];
  static const _vegPool       = [onion1, tomato1, potato1];
  static const _fruitsPool    = [mango, mango2, mango3];
  static const _livestockPool = [cow1, cow2, cow3];
  static const _poultryPool   = [chicken1, chicken2, duck1];
  static const _cropsPool     = [mango, onion1, tomato1, seeds1, seeds2];

  static const Map<String, List<String>> _subcategoryPools = {
    // Cereals & grains
    'wheat':                  _wheatPool,
    'rice':                   _ricePool,
    'rice_paddy':             _ricePool,
    'maize':                  _maizePool,
    'maize_corn':             _maizePool,
    'jowar':                  _jowarPool,
    'sorghum_jowar':          _jowarPool,
    'bajra':                  _bajraPool,
    'pearl_millet_bajra':     _bajraPool,
    'barley':                 _barleyPool,
    // Pulses
    'tur':                    _seedsPool,
    'pigeon_pea_tur':         _seedsPool,
    'chana':                  _seedsPool,
    'chickpea_chana':         _seedsPool,
    'moong':                  _seedsPool,
    'green_gram_moong':       _seedsPool,
    'udid':                   _seedsPool,
    'black_gram_urad':        _seedsPool,
    'masoor':                 _seedsPool,
    'lentil_masoor':          _seedsPool,
    'field_pea_vatana':       _seedsPool,
    'cowpea_chawli':          _seedsPool,
    'kidney_bean_rajma':      _seedsPool,
    // Oil seeds & commercial
    'soybean':                _seedsPool,
    'groundnut':              _seedsPool,
    'mustard':                _seedsPool,
    'sunflower':              _seedsPool,
    'sesame':                 _seedsPool,
    'safflower':              _seedsPool,
    'linseed':                _seedsPool,
    'castor':                 _seedsPool,
    'cotton':                 _seedsPool,
    'sugarcane':              _seedsPool,
    'turmeric':               _vegPool,
    'ginger':                 _vegPool,
    // Vegetables
    'onion':                  _onionPool,
    'onion_seed':             _seedsPool,
    'tomato':                 _tomatoPool,
    'potato':                 _potatoPool,
    'garlic':                 _garlicPool,
    'chilli':                 _chilliPool,
    'brinjal':                _brinjalPool,
    'cabbage':                _vegPool,
    'cauliflower':            _vegPool,
    'okra':                   _vegPool,
    'cucumber':               _vegPool,
    'ridge_gourd':            _vegPool,
    'coriander':              _vegPool,
    'coriander_leaves':       _vegPool,
    'fenugreek':              _vegPool,
    'spinach':                _vegPool,
    'dill_leaves':            _vegPool,
    // Fruits
    'mango':                  _mangoPool,
    'banana':                 _bananaPool,
    'pomegranate':            _pomegranatePool,
    'orange':                 _orangePool,
    'lemon':                  _orangePool,
    'grapes':                 _fruitsPool,
    'papaya':                 _fruitsPool,
    'guava':                  _fruitsPool,
    'watermelon':             _fruitsPool,
    'custard_apple':          _fruitsPool,
    'apple':                  _fruitsPool,
    'sapota':                 _fruitsPool,
    'java_plum':              _fruitsPool,
    'indian_jujube':          _fruitsPool,
    'fig':                    _fruitsPool,
    // Livestock
    'cow':                    _cowPool,
    'buffalo':                _buffaloPool,
    'bull':                   _bullPool,
    'goat':                   _poultryPool,
    'sheep':                  _poultryPool,
    'chicken':                _chickenPool,
    'duck':                   _duckPool,
    'turkey':                 _chickenPool,
    'quail':                  _chickenPool,
    // Land
    'agricultural_land':      _landPool,
    'farm_house_land':        _landPool,
    'orchard_land':           _landPool,
    'land_for_sale':          _landPool,
    'land_for_lease':         _landPool,
    'partnership_farming':    _landPool,
    // Tractors & brands
    'mahindra':               _tractorsPool,
    'swaraj':                 _tractorsPool,
    'sonalika':               _tractorsPool,
    'john_deere':             _tractorsPool,
    'massey_ferguson':        _tractorsPool,
    'farmtrac':               _tractorsPool,
    'powertrac':              _tractorsPool,
    'eicher':                 _tractorsPool,
    'tafe':                   _tractorsPool,
    'under_20_hp':            _tractorsPool,
    'hp_21_30':               _tractorsPool,
    'hp_31_40':               _tractorsPool,
    'hp_41_50':               _tractorsPool,
    'hp_51_60':               _tractorsPool,
    'above_60_hp':            _tractorsPool,
    'tyres':                  _tractorsPool,
    'batteries':              _tractorsPool,
    'hydraulic_parts':        _tractorsPool,
    'pto_parts':              _tractorsPool,
    'engine_parts':           _tractorsPool,
    'tractor_seats':          _tractorsPool,
    // Farm machinery
    'rotavator':              _rotavatorPool,
    'cultivator':             _cultivatorPool,
    'disc_harrow':            _discHarrowPool,
    'plough':                 _machineryPool,
    'subsoiler':              _machineryPool,
    'ridger':                 _machineryPool,
    'seed_drill':             _machineryPool,
    'planter':                _machineryPool,
    'paddy_seeder':           _machineryPool,
    'fertilizer_drill':       _machineryPool,
    'power_sprayer':          _machineryPool,
    'battery_sprayer':        _machineryPool,
    'boom_sprayer':           _machineryPool,
    'fogging_machine':        _machineryPool,
    'drone_harvester':        _machineryPool,
    'harvester':              _machineryPool,
    'mini_harvester':         _machineryPool,
    'reaper':                 _machineryPool,
    'combine_harvester':      _machineryPool,
    'thresher':               _machineryPool,
    'baler':                  _machineryPool,
    'grain_cleaner':          _machineryPool,
    'winnower':               _machineryPool,
    'water_pump':             _machineryPool,
    'solar_pump':             _machineryPool,
    'drip_system':            _machineryPool,
    'sprinkler_system':       _machineryPool,
    'power_weeder':           _machineryPool,
    'power_tiller':           _machineryPool,
    'mini_tiller':            _machineryPool,
    // Rental
    'tractor_rental':         _rentalPool,
    'machinery_rental':       _rentalPool,
    'labour_services':        _rentalPool,
    'jcb_types':              _jcbPool,
  };

  // ── Listing image pools per category (fallback) ────────────
  static const cropsPool     = _cropsPool;
  static const livestockPool = _livestockPool;
  static const landPool      = _landPool;
  static const tractorsPool  = _tractorsPool;
  static const rentalPool    = _rentalPool;

  static List<String> listingPool(ListingCategory category) {
    switch (category) {
      case ListingCategory.crops:
        return cropsPool;
      case ListingCategory.livestock:
        return livestockPool;
      case ListingCategory.land:
        return landPool;
      case ListingCategory.tractors:
        return tractorsPool;
      case ListingCategory.rental:
        return rentalPool;
    }
  }

  /// Unique photos for a subcategory key (browse showcase count).
  static List<String> listingImagesForKey(String titleKey) {
    final key = _normalizeTitleKey(titleKey);
    if (key == null) return const [];
    final pool = _subcategoryPools[key];
    if (pool == null || pool.isEmpty) return const [];
    return _uniqueInOrder(pool);
  }

  /// How many distinct listings to show when a subcategory is opened.
  static int showcaseCountForKey(String titleKey) =>
      listingImagesForKey(titleKey).length;

  /// All listing photos for a product (carousel / gallery).
  static List<String> listingImagesFor(Listing listing) {
    final key = _normalizeTitleKey(listing.titleKey);
    if (key != null) {
      final pool = _subcategoryPools[key];
      if (pool != null && pool.isNotEmpty) return _uniqueInOrder(pool);
    }
    return listingPool(listing.category);
  }

  /// Single listing photo — [index] maps to photo 1, 2, 3… in the pool.
  static String listingImageFor(Listing listing, int index) {
    final pool = listingImagesFor(listing);
    return pool[index.abs() % pool.length];
  }

  /// Home / feed card thumbnail — always the primary photo (cow1, tractor1…).
  static String homeListingImage(Listing listing) {
    final key = _normalizeTitleKey(listing.titleKey);
    if (key != null) {
      final imgs = listingImagesForKey(key);
      if (imgs.isNotEmpty) return imgs.first;
    }
    return _primaryImageForListing(listing);
  }

  static String primaryListingImage(ListingCategory category) {
    switch (category) {
      case ListingCategory.crops:
        return mango;
      case ListingCategory.livestock:
        return cow1;
      case ListingCategory.land:
        return land1;
      case ListingCategory.tractors:
        return tractor1;
      case ListingCategory.rental:
        return rent2;
    }
  }

  static String _primaryImageForListing(Listing listing) {
    final text =
        '${listing.title} ${listing.brand ?? ''} ${listing.equipmentType ?? ''} '
                '${listing.breed ?? ''}'
            .toLowerCase();

    const keywords = <String, String>{
      'rotavator':  rotavator1,
      'cultivator': cultivator1,
      'disc harrow': discHarrow1,
      'buffalo':    buffelo1,
      'bull':       bull1,
      'cow':        cow1,
      'chicken':    chicken1,
      'duck':       duck1,
      'onion':      onion1,
      'brinjal':    brinjal1,
      'tomato':     tomato1,
      'potato':     potato1,
      'wheat':      wheat1,
      'rice':       rice1,
      'maize':      maize1,
      'mango':      mango,
      'banana':     banana1,
      'garlic':     garlic1,
      'chilli':     chilli1,
      'tractor':    tractor1,
      'jcb':        jcb1,
      'acre':       land1,
      'farm land':  land1,
    };

    for (final entry in keywords.entries) {
      if (text.contains(entry.key)) return entry.value;
    }

    return primaryListingImage(listing.category);
  }

  static String listingImageAt(ListingCategory category, int index) {
    final pool = listingPool(category);
    return pool[index.abs() % pool.length];
  }

  static List<String> _uniqueInOrder(List<String> paths) {
    final seen = <String>{};
    final unique = <String>[];
    for (final path in paths) {
      if (seen.add(path)) unique.add(path);
    }
    return unique;
  }

  static String? _normalizeTitleKey(String? key) {
    if (key == null || key.trim().isEmpty) return null;
    var normalized = key.trim().toLowerCase().replaceAll(' ', '_');
    if (normalized == 'other') normalized = 'others';
    return normalized;
  }
}
