// lib/core/data/subcategories.dart
import 'package:krishix/core/models/listing.dart';

class SubcategoryItem {
  const SubcategoryItem({
    required this.labelKey,
    required this.imagePath,
  });
  final String labelKey;
  final String imagePath;
}

class SubcategoryGroup {
  const SubcategoryGroup({
    required this.titleKey,
    required this.items,
  });
  final String                titleKey;
  final List<SubcategoryItem> items;
}

class CategoryDetail {
  const CategoryDetail({
    required this.emoji,
    required this.titleKey,
    required this.listingCategory,
    required this.groups,
  });
  final String           emoji;
  final String           titleKey;
  final ListingCategory? listingCategory;
  final List<SubcategoryGroup> groups;
}

class CategorySectionId {
  // ── Buy ──────────────────────────────────────────────────
  static const String cropsAndGrains      = 'crops_and_grains';
  static const String fruitsVeg           = 'fruits_veg';
  static const String livestock           = 'livestock';
  static const String agricultureLandSale = 'agriculture_land_sale'; // Buy: land for sale only
  static const String seedsAndPlants      = 'seeds_and_plants';
  static const String farmMachinery       = 'farm_machinery';
  static const String tractors            = 'tractors';            // Buy: TractorPickerScreen
  static const String tractorsBuy         = 'tractors_buy';
  static const String tractorsParts       = 'tractors_parts';

  // ── Rent ─────────────────────────────────────────────────
  static const String agricultureLandLease = 'agriculture_land_lease'; // Rent: lease only
  static const String tractorRental        = 'tractor_rental';
  static const String farmMachineryRent    = 'farm_machinery_rent';
  static const String jcbRental            = 'jcb_rental';

  // ── Legacy (kept for backward compat) ───────────────────
  static const String agricultureLand = 'agriculture_land';
  static const String rentals         = 'rentals';
}

const Map<String, CategoryDetail> kCategoryDetails = {

  // ════════════════════════════════════════════════════════
  // BUY CATEGORIES
  // ════════════════════════════════════════════════════════

  // ── Crops & Grains ───────────────────────────────────────
  CategorySectionId.cropsAndGrains: CategoryDetail(
    emoji: '🌾',
    titleKey: 'cropsAndGrains',
    listingCategory: ListingCategory.crops,
    groups: [
      SubcategoryGroup(
        titleKey: 'cereals',
        items: [
          SubcategoryItem(labelKey: 'wheat',  imagePath: 'assets/sub_ctg/KrishiX_App-31.jpg'),
          SubcategoryItem(labelKey: 'rice',   imagePath: 'assets/sub_ctg/KrishiX_App-32.jpg'),
          SubcategoryItem(labelKey: 'maize',  imagePath: 'assets/sub_ctg/KrishiX_App-35.jpg'),
          SubcategoryItem(labelKey: 'jowar',  imagePath: 'assets/sub_ctg/KrishiX_App-36.jpg'),
          SubcategoryItem(labelKey: 'bajra',  imagePath: 'assets/sub_ctg/KrishiX_App-37.jpg'),
          SubcategoryItem(labelKey: 'barley', imagePath: 'assets/sub_ctg/KrishiX_App-31.jpg'),
        ],
      ),
      SubcategoryGroup(
        titleKey: 'pulses',
        items: [
          SubcategoryItem(labelKey: 'tur',    imagePath: 'assets/sub_ctg/KrishiX_App-36.jpg'),
          SubcategoryItem(labelKey: 'chana',  imagePath: 'assets/sub_ctg/KrishiX_App-37.jpg'),
          SubcategoryItem(labelKey: 'moong',  imagePath: 'assets/sub_ctg/KrishiX_App-40.jpg'),
          SubcategoryItem(labelKey: 'udid',   imagePath: 'assets/sub_ctg/KrishiX_App-36.jpg'),
          SubcategoryItem(labelKey: 'masoor', imagePath: 'assets/sub_ctg/KrishiX_App-37.jpg'),
        ],
      ),
      SubcategoryGroup(
        titleKey: 'oil_seeds',
        items: [
          SubcategoryItem(labelKey: 'soybean',   imagePath: 'assets/sub_ctg/KrishiX_App-33.jpg'),
          SubcategoryItem(labelKey: 'groundnut', imagePath: 'assets/sub_ctg/KrishiX_App-38.jpg'),
          SubcategoryItem(labelKey: 'mustard',   imagePath: 'assets/sub_ctg/KrishiX_App-40.jpg'),
          SubcategoryItem(labelKey: 'sunflower', imagePath: 'assets/sub_ctg/KrishiX_App-33.jpg'),
          SubcategoryItem(labelKey: 'sesame',    imagePath: 'assets/sub_ctg/KrishiX_App-40.jpg'),
        ],
      ),
      SubcategoryGroup(
        titleKey: 'commercial_crops',
        items: [
          SubcategoryItem(labelKey: 'cotton',    imagePath: 'assets/sub_ctg/KrishiX_App-34.jpg'),
          SubcategoryItem(labelKey: 'sugarcane', imagePath: 'assets/sub_ctg/KrishiX_App-39.jpg'),
        ],
      ),
    ],
  ),

  // ── Fruits & Vegetables ──────────────────────────────────
  CategorySectionId.fruitsVeg: CategoryDetail(
    emoji: '🍎',
    titleKey: 'fruitsAndVegetables',
    listingCategory: ListingCategory.crops,
    groups: [
      SubcategoryGroup(
        titleKey: 'vegetables',
        items: [
          SubcategoryItem(labelKey: 'onion',       imagePath: 'assets/sub_ctg/KrishiX_App-42.jpg'),
          SubcategoryItem(labelKey: 'tomato',      imagePath: 'assets/sub_ctg/KrishiX_App-43.jpg'),
          SubcategoryItem(labelKey: 'potato',      imagePath: 'assets/sub_ctg/KrishiX_App-38.jpg'),
          SubcategoryItem(labelKey: 'garlic',      imagePath: 'assets/sub_ctg/KrishiX_App-44.jpg'),
          SubcategoryItem(labelKey: 'chilli',      imagePath: 'assets/sub_ctg/KrishiX_App-45.jpg'),
          SubcategoryItem(labelKey: 'brinjal',     imagePath: 'assets/sub_ctg/KrishiX_App-46.jpg'),
          SubcategoryItem(labelKey: 'cabbage',     imagePath: 'assets/sub_ctg/KrishiX_App-41.jpg'),
          SubcategoryItem(labelKey: 'cauliflower', imagePath: 'assets/sub_ctg/KrishiX_App-41.jpg'),
          SubcategoryItem(labelKey: 'okra',        imagePath: 'assets/sub_ctg/KrishiX_App-41.jpg'),
          SubcategoryItem(labelKey: 'cucumber',    imagePath: 'assets/sub_ctg/KrishiX_App-41.jpg'),
        ],
      ),
      SubcategoryGroup(
        titleKey: 'fruits',
        items: [
          SubcategoryItem(labelKey: 'mango',       imagePath: 'assets/sub_ctg/KrishiX_App-48.jpg'),
          SubcategoryItem(labelKey: 'banana',      imagePath: 'assets/sub_ctg/KrishiX_App-49.jpg'),
          SubcategoryItem(labelKey: 'pomegranate', imagePath: 'assets/sub_ctg/KrishiX_App-50.jpg'),
          SubcategoryItem(labelKey: 'orange',      imagePath: 'assets/sub_ctg/KrishiX_App-51.jpg'),
          SubcategoryItem(labelKey: 'grapes',      imagePath: 'assets/sub_ctg/KrishiX_App-52.jpg'),
          SubcategoryItem(labelKey: 'papaya',      imagePath: 'assets/sub_ctg/KrishiX_App-53.jpg'),
          SubcategoryItem(labelKey: 'guava',       imagePath: 'assets/sub_ctg/KrishiX_App-47.jpg'),
          SubcategoryItem(labelKey: 'watermelon',  imagePath: 'assets/sub_ctg/KrishiX_App-47.jpg'),
          SubcategoryItem(labelKey: 'sweet_lime',  imagePath: 'assets/sub_ctg/KrishiX_App-51.jpg'),
        ],
      ),
    ],
  ),

  // ── Livestock ────────────────────────────────────────────
  CategorySectionId.livestock: CategoryDetail(
    emoji: '🐄',
    titleKey: 'livestock',
    listingCategory: ListingCategory.livestock,
    groups: [
      SubcategoryGroup(
        titleKey: 'Animals',
        items: [
          SubcategoryItem(labelKey: 'cow',     imagePath: 'assets/sub_ctg/KrishiX_App-54.jpg'),
          SubcategoryItem(labelKey: 'buffalo', imagePath: 'assets/sub_ctg/KrishiX_App-55.jpg'),
          SubcategoryItem(labelKey: 'bull',    imagePath: 'assets/sub_ctg/KrishiX_App-56.jpg'),
          SubcategoryItem(labelKey: 'goat',    imagePath: 'assets/sub_ctg/KrishiX_App-59.jpg'),
          SubcategoryItem(labelKey: 'sheep',   imagePath: 'assets/sub_ctg/KrishiX_App-60.jpg'),
        ],
      ),
      SubcategoryGroup(
        titleKey: 'poultry',
        items: [
          SubcategoryItem(labelKey: 'chicken', imagePath: 'assets/sub_ctg/KrishiX_App-61.jpg'),
          SubcategoryItem(labelKey: 'duck',    imagePath: 'assets/sub_ctg/KrishiX_App-63.jpeg'),
          SubcategoryItem(labelKey: 'turkey',  imagePath: 'assets/sub_ctg/KrishiX_App-58.jpg'),
          SubcategoryItem(labelKey: 'quail',   imagePath: 'assets/sub_ctg/KrishiX_App-64.jpeg'),
        ],
      ),
    ],
  ),

  // ── Agriculture Land — BUY (sale only) ───────────────────
  CategorySectionId.agricultureLandSale: CategoryDetail(
    emoji: '🪴',
    titleKey: 'farm_land',
    listingCategory: ListingCategory.land,
    groups: [
      SubcategoryGroup(
        titleKey: 'land_for_sale',
        items: [
          SubcategoryItem(labelKey: 'agricultural_land', imagePath: 'assets/sub_ctg/KrishiX_App-65.jpg'),
          SubcategoryItem(labelKey: 'farm_house_land',   imagePath: 'assets/sub_ctg/KrishiX_App-66.jpg'),
          SubcategoryItem(labelKey: 'orchard_land',      imagePath: 'assets/sub_ctg/KrishiX_App-69.jpg'),
        ],
      ),
    ],
  ),

  // ── Seeds & Plants ───────────────────────────────────────
  CategorySectionId.seedsAndPlants: CategoryDetail(
  emoji: '🌱',
  titleKey: 'seeds_and_plants',
  listingCategory: ListingCategory.crops,
  groups: [

    // ── CEREAL CROPS ──────────────────────────────────────
    SubcategoryGroup(
      titleKey: 'cereal_crops',
      items: [
        SubcategoryItem(labelKey: 'wheat',                  imagePath: 'assets/sub_ctg/KrishiX_App-71.jpg'),
        SubcategoryItem(labelKey: 'rice_paddy',             imagePath: 'assets/sub_ctg/KrishiX_App-71.jpg'),
        SubcategoryItem(labelKey: 'sorghum_jowar',          imagePath: 'assets/sub_ctg/KrishiX_App-71.jpg'),
        SubcategoryItem(labelKey: 'pearl_millet_bajra',     imagePath: 'assets/sub_ctg/KrishiX_App-71.jpg'),
        SubcategoryItem(labelKey: 'maize_corn',             imagePath: 'assets/sub_ctg/KrishiX_App-71.jpg'),
        SubcategoryItem(labelKey: 'barnyard_millet_bhagar', imagePath: 'assets/sub_ctg/KrishiX_App-71.jpg'),
      ],
    ),

    // ── PULSE CROPS ───────────────────────────────────────
    SubcategoryGroup(
      titleKey: 'pulse_crops',
      items: [
        SubcategoryItem(labelKey: 'pigeon_pea_tur',     imagePath: 'assets/sub_ctg/KrishiX_App-71.jpg'),
        SubcategoryItem(labelKey: 'chickpea_chana',     imagePath: 'assets/sub_ctg/KrishiX_App-71.jpg'),
        SubcategoryItem(labelKey: 'green_gram_moong',   imagePath: 'assets/sub_ctg/KrishiX_App-71.jpg'),
        SubcategoryItem(labelKey: 'black_gram_urad',    imagePath: 'assets/sub_ctg/KrishiX_App-71.jpg'),
        SubcategoryItem(labelKey: 'lentil_masoor',      imagePath: 'assets/sub_ctg/KrishiX_App-71.jpg'),
        SubcategoryItem(labelKey: 'field_pea_vatana',   imagePath: 'assets/sub_ctg/KrishiX_App-71.jpg'),
        SubcategoryItem(labelKey: 'cowpea_chawli',      imagePath: 'assets/sub_ctg/KrishiX_App-71.jpg'),
        SubcategoryItem(labelKey: 'kidney_bean_rajma',  imagePath: 'assets/sub_ctg/KrishiX_App-71.jpg'),
      ],
    ),

    // ── OIL SEEDS ─────────────────────────────────────────
    SubcategoryGroup(
      titleKey: 'oil_seeds',
      items: [
        SubcategoryItem(labelKey: 'groundnut',  imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'mustard',    imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'sesame',     imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'safflower',  imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'linseed',    imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'castor',     imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
      ],
    ),

    // ── CASH CROPS ────────────────────────────────────────
    SubcategoryGroup(
      titleKey: 'cash_crops',
      items: [
        SubcategoryItem(labelKey: 'sugarcane', imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'turmeric',  imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'ginger',    imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'cotton',    imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'soybean',   imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
      ],
    ),

    // ── SPICE CROPS ───────────────────────────────────────
    SubcategoryGroup(
      titleKey: 'spice_crops',
      items: [
        SubcategoryItem(labelKey: 'turmeric',   imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'ginger',     imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'garlic',     imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'chilli',     imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'coriander',  imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'fenugreek',  imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'onion_seed', imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
      ],
    ),

    // ── VEGETABLE SEEDS ───────────────────────────────────
    SubcategoryGroup(
      titleKey: 'vegetable_seeds',
      items: [
        SubcategoryItem(labelKey: 'onion',        imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'potato',       imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'okra',         imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'chilli',       imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'cucumber',     imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'ridge_gourd',  imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'bitter_gourd', imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'bottle_gourd', imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
        SubcategoryItem(labelKey: 'dill',         imagePath: 'assets/sub_ctg/KrishiX_App-72.jpg'),
      ],
    ),

    // ── FRUIT CROPS ───────────────────────────────────────
    SubcategoryGroup(
      titleKey: 'fruit_crops',
      items: [
        SubcategoryItem(labelKey: 'mango',          imagePath: 'assets/sub_ctg/KrishiX_App-73.jpg'),
        SubcategoryItem(labelKey: 'custard_apple',  imagePath: 'assets/sub_ctg/KrishiX_App-73.jpg'),
        SubcategoryItem(labelKey: 'papaya',         imagePath: 'assets/sub_ctg/KrishiX_App-73.jpg'),
        SubcategoryItem(labelKey: 'jamun',          imagePath: 'assets/sub_ctg/KrishiX_App-73.jpg'),
      ],
    ),

    // ── FODDER CROPS ──────────────────────────────────────
    SubcategoryGroup(
      titleKey: 'fodder_crops',
      items: [
        SubcategoryItem(labelKey: 'fodder_maize',        imagePath: 'assets/sub_ctg/KrishiX_App-71.jpg'),
        SubcategoryItem(labelKey: 'fodder_sorghum',      imagePath: 'assets/sub_ctg/KrishiX_App-71.jpg'),
        SubcategoryItem(labelKey: 'fodder_pearl_millet', imagePath: 'assets/sub_ctg/KrishiX_App-71.jpg'),
      ],
    ),

    // ── PLANTS & SAPLINGS ─────────────────────────────────
    SubcategoryGroup(
      titleKey: 'plants_and_saplings',
      items: [
        SubcategoryItem(labelKey: 'mango_sapling',       imagePath: 'assets/sub_ctg/KrishiX_App-74.jpg'),
        SubcategoryItem(labelKey: 'pomegranate_sapling', imagePath: 'assets/sub_ctg/KrishiX_App-74.jpg'),
        SubcategoryItem(labelKey: 'sweet_lime_sapling',  imagePath: 'assets/sub_ctg/KrishiX_App-74.jpg'),
        SubcategoryItem(labelKey: 'orange_sapling',      imagePath: 'assets/sub_ctg/KrishiX_App-74.jpg'),
        SubcategoryItem(labelKey: 'cashew_sapling',      imagePath: 'assets/sub_ctg/KrishiX_App-74.jpg'),
        SubcategoryItem(labelKey: 'coconut_sapling',     imagePath: 'assets/sub_ctg/KrishiX_App-74.jpg'),
        SubcategoryItem(labelKey: 'teak_sapling',        imagePath: 'assets/sub_ctg/KrishiX_App-74.jpg'),
        SubcategoryItem(labelKey: 'bamboo_sapling',      imagePath: 'assets/sub_ctg/KrishiX_App-74.jpg'),
        SubcategoryItem(labelKey: 'tissue_culture_plants', imagePath: 'assets/sub_ctg/KrishiX_App-74.jpg'),
        SubcategoryItem(labelKey: 'nursery_plants',      imagePath: 'assets/sub_ctg/KrishiX_App-74.jpg'),
      ],
    ),

  ],
),
  // ── Farm Machinery — BUY ─────────────────────────────────
  CategorySectionId.farmMachinery: CategoryDetail(
    emoji: '⚙️',
    titleKey: 'farm_machinery',
    listingCategory: ListingCategory.tractors,
    groups: [
      SubcategoryGroup(
        titleKey: 'land_preparation',
        items: [
          SubcategoryItem(labelKey: 'rotavator',   imagePath: 'assets/sub_ctg/KrishiX_App-21.jpg'),
          SubcategoryItem(labelKey: 'cultivator',  imagePath: 'assets/sub_ctg/KrishiX_App-22.jpg'),
          SubcategoryItem(labelKey: 'disc_harrow', imagePath: 'assets/sub_ctg/KrishiX_App-27.jpg'),
          SubcategoryItem(labelKey: 'plough',      imagePath: 'assets/sub_ctg/KrishiX_App-27.jpg'),
          SubcategoryItem(labelKey: 'subsoiler',   imagePath: 'assets/sub_ctg/KrishiX_App-22.jpg'),
          SubcategoryItem(labelKey: 'ridger',      imagePath: 'assets/sub_ctg/KrishiX_App-21.jpg'),
        ],
      ),
      SubcategoryGroup(
        titleKey: 'sowing_equipment',
        items: [
          SubcategoryItem(labelKey: 'seed_drill',       imagePath: 'assets/sub_ctg/KrishiX_App-24.jpg'),
          SubcategoryItem(labelKey: 'planter',          imagePath: 'assets/sub_ctg/KrishiX_App-28.jpg'),
          SubcategoryItem(labelKey: 'paddy_seeder',     imagePath: 'assets/sub_ctg/KrishiX_App-24.jpg'),
          SubcategoryItem(labelKey: 'fertilizer_drill', imagePath: 'assets/sub_ctg/KrishiX_App-28.jpg'),
        ],
      ),
      SubcategoryGroup(
        titleKey: 'crop_protection',
        items: [
          SubcategoryItem(labelKey: 'power_sprayer',   imagePath: 'assets/sub_ctg/KrishiX_App-29.jpg'),
          SubcategoryItem(labelKey: 'battery_sprayer', imagePath: 'assets/sub_ctg/KrishiX_App-25.jpg'),
          SubcategoryItem(labelKey: 'boom_sprayer',    imagePath: 'assets/sub_ctg/KrishiX_App-29.jpg'),
          SubcategoryItem(labelKey: 'fogging_machine', imagePath: 'assets/sub_ctg/KrishiX_App-25.jpg'),
        ],
      ),
      SubcategoryGroup(
        titleKey: 'harvesting_equipment',
        items: [
          SubcategoryItem(labelKey: 'harvester',         imagePath: 'assets/sub_ctg/KrishiX_App-23.jpg'),
          SubcategoryItem(labelKey: 'mini_harvester',    imagePath: 'assets/sub_ctg/KrishiX_App-23.jpg'),
          SubcategoryItem(labelKey: 'reaper',            imagePath: 'assets/sub_ctg/KrishiX_App-23.jpg'),
          SubcategoryItem(labelKey: 'combine_harvester', imagePath: 'assets/sub_ctg/KrishiX_App-23.jpg'),
          SubcategoryItem(labelKey: 'drone_harvester',   imagePath: 'assets/sub_ctg/KrishiX_App-23.jpg'),
        ],
      ),
      SubcategoryGroup(
        titleKey: 'post_harvest',
        items: [
          SubcategoryItem(labelKey: 'thresher',      imagePath: 'assets/sub_ctg/KrishiX_App-26.jpg'),
          SubcategoryItem(labelKey: 'baler',         imagePath: 'assets/sub_ctg/KrishiX_App-26.jpg'),
          SubcategoryItem(labelKey: 'grain_cleaner', imagePath: 'assets/sub_ctg/KrishiX_App-26.jpg'),
          SubcategoryItem(labelKey: 'winnower',      imagePath: 'assets/sub_ctg/KrishiX_App-26.jpg'),
        ],
      ),
      SubcategoryGroup(
        titleKey: 'irrigation_equipment',
        items: [
          SubcategoryItem(labelKey: 'water_pump',       imagePath: 'assets/sub_ctg/KrishiX_App-29.jpg'),
          SubcategoryItem(labelKey: 'solar_pump',       imagePath: 'assets/sub_ctg/KrishiX_App-29.jpg'),
          SubcategoryItem(labelKey: 'drip_system',      imagePath: 'assets/sub_ctg/KrishiX_App-25.jpg'),
          SubcategoryItem(labelKey: 'sprinkler_system', imagePath: 'assets/sub_ctg/KrishiX_App-25.jpg'),
        ],
      ),
      SubcategoryGroup(
        titleKey: 'power_equipment',
        items: [
          SubcategoryItem(labelKey: 'power_weeder', imagePath: 'assets/sub_ctg/KrishiX_App-30.jpg'),
          SubcategoryItem(labelKey: 'power_tiller', imagePath: 'assets/sub_ctg/KrishiX_App-30.jpg'),
          SubcategoryItem(labelKey: 'mini_tiller',  imagePath: 'assets/sub_ctg/KrishiX_App-30.jpg'),
        ],
      ),
    ],
  ),

  // ── Tractors — BUY (routes to TractorPickerScreen) ───────
  CategorySectionId.tractorsBuy: CategoryDetail(
    emoji: '🚜',
    titleKey: 'tractors',
    listingCategory: ListingCategory.tractors,
    groups: [
      SubcategoryGroup(
        titleKey: 'horse_power_hp',
        items: [
          SubcategoryItem(labelKey: 'under_20_hp', imagePath: 'assets/sub_ctg/KrishiX_App-17.jpg'),
          SubcategoryItem(labelKey: 'hp_21_30',    imagePath: 'assets/sub_ctg/KrishiX_App-18.jpg'),
          SubcategoryItem(labelKey: 'hp_31_40',    imagePath: 'assets/sub_ctg/KrishiX_App-19.jpg'),
          SubcategoryItem(labelKey: 'hp_41_50',    imagePath: 'assets/sub_ctg/KrishiX_App-20.jpg'),
          SubcategoryItem(labelKey: 'hp_51_60',    imagePath: 'assets/sub_ctg/KrishiX_App-17.jpg'),
          SubcategoryItem(labelKey: 'above_60_hp', imagePath: 'assets/sub_ctg/KrishiX_App-18.jpg'),
        ],
      ),
      SubcategoryGroup(
        titleKey: 'tractor_brands',
        items: [
          SubcategoryItem(labelKey: 'mahindra',        imagePath: 'assets/sub_ctg/KrishiX_App-17.jpg'),
          SubcategoryItem(labelKey: 'swaraj',          imagePath: 'assets/sub_ctg/KrishiX_App-18.jpg'),
          SubcategoryItem(labelKey: 'sonalika',        imagePath: 'assets/sub_ctg/KrishiX_App-19.jpg'),
          SubcategoryItem(labelKey: 'john_deere',      imagePath: 'assets/sub_ctg/KrishiX_App-20.jpg'),
          SubcategoryItem(labelKey: 'massey_ferguson', imagePath: 'assets/sub_ctg/KrishiX_App-18.jpg'),
          SubcategoryItem(labelKey: 'powertrac',       imagePath: 'assets/sub_ctg/KrishiX_App-18.jpg'),
          SubcategoryItem(labelKey: 'Other',           imagePath: 'assets/sub_ctg/KrishiX_App-20.jpg'),
        ],
      ),
    ],
  ),

  // ── Tractor Parts ────────────────────────────────────────
  CategorySectionId.tractorsParts: CategoryDetail(
    emoji: '🔧',
    titleKey: 'tractor_parts',
    listingCategory: ListingCategory.tractors,
    groups: [
      SubcategoryGroup(
        titleKey: 'tractor_parts',
        items: [
          SubcategoryItem(labelKey: 'tyres',           imagePath: 'assets/sub_ctg/KrishiX_App-17.jpg'),
          SubcategoryItem(labelKey: 'batteries',       imagePath: 'assets/sub_ctg/KrishiX_App-18.jpg'),
          SubcategoryItem(labelKey: 'hydraulic_parts', imagePath: 'assets/sub_ctg/KrishiX_App-19.jpg'),
          SubcategoryItem(labelKey: 'pto_parts',       imagePath: 'assets/sub_ctg/KrishiX_App-20.jpg'),
          SubcategoryItem(labelKey: 'engine_parts',    imagePath: 'assets/sub_ctg/KrishiX_App-17.jpg'),
          SubcategoryItem(labelKey: 'tractor_seats',   imagePath: 'assets/sub_ctg/KrishiX_App-18.jpg'),
        ],
      ),
    ],
  ),

  // ════════════════════════════════════════════════════════
  // RENT CATEGORIES
  // ════════════════════════════════════════════════════════

  // ── Agriculture Land — RENT (lease only) ─────────────────
  CategorySectionId.agricultureLandLease: CategoryDetail(
    emoji: '🌿',
    titleKey: 'lease_land',
    listingCategory: ListingCategory.land,
    groups: [
      SubcategoryGroup(
        titleKey: 'land_for_lease',
        items: [
          SubcategoryItem(labelKey: 'land_for_lease',     imagePath: 'assets/sub_ctg/KrishiX_App-68.jpg'),
          SubcategoryItem(labelKey: 'partnership_farming', imagePath: 'assets/sub_ctg/KrishiX_App-65.jpg'),
        ],
      ),
    ],
  ),

  // ── Tractor Rental ───────────────────────────────────────
  CategorySectionId.tractorRental: CategoryDetail(
    emoji: '🚜',
    titleKey: 'tractor_rental',
    listingCategory: ListingCategory.rental,
    groups: [
      SubcategoryGroup(
        titleKey: 'tractor_rental',
        items: [
          SubcategoryItem(labelKey: 'hourly',   imagePath: 'assets/sub_ctg/KrishiX_App-17.jpg'),
          SubcategoryItem(labelKey: 'daily',    imagePath: 'assets/sub_ctg/KrishiX_App-18.jpg'),
          SubcategoryItem(labelKey: 'seasonal', imagePath: 'assets/sub_ctg/KrishiX_App-19.jpg'),
        ],
      ),
    //   SubcategoryGroup(
    //     titleKey: 'tractor_brands',
    //     items: [
    //       SubcategoryItem(labelKey: 'mahindra',        imagePath: 'assets/sub_ctg/KrishiX_App-17.jpg'),
    //       SubcategoryItem(labelKey: 'swaraj',          imagePath: 'assets/sub_ctg/KrishiX_App-18.jpg'),
    //       SubcategoryItem(labelKey: 'sonalika',        imagePath: 'assets/sub_ctg/KrishiX_App-19.jpg'),
    //       SubcategoryItem(labelKey: 'john_deere',      imagePath: 'assets/sub_ctg/KrishiX_App-20.jpg'),
    //       SubcategoryItem(labelKey: 'massey_ferguson', imagePath: 'assets/sub_ctg/KrishiX_App-18.jpg'),
    //       SubcategoryItem(labelKey: 'Other',           imagePath: 'assets/sub_ctg/KrishiX_App-20.jpg'),
    //     ],
    //   ),
    ],
  ),

  // ── Farm Machinery Rent ──────────────────────────────────
  CategorySectionId.farmMachineryRent: CategoryDetail(
    emoji: '⚙️',
    titleKey: 'farm_machinery_rent',
    listingCategory: ListingCategory.rental,
    groups: [
      SubcategoryGroup(
        titleKey: 'machinery_rental',
        items: [
          SubcategoryItem(labelKey: 'rotavator',  imagePath: 'assets/sub_ctg/KrishiX_App-21.jpg'),
          SubcategoryItem(labelKey: 'harvester',  imagePath: 'assets/sub_ctg/KrishiX_App-23.jpg'),
          SubcategoryItem(labelKey: 'cultivator', imagePath: 'assets/sub_ctg/KrishiX_App-22.jpg'),
          SubcategoryItem(labelKey: 'seeder',     imagePath: 'assets/sub_ctg/KrishiX_App-24.jpg'),
          SubcategoryItem(labelKey: 'sprayer',    imagePath: 'assets/sub_ctg/KrishiX_App-25.jpg'),
          SubcategoryItem(labelKey: 'thresher',   imagePath: 'assets/sub_ctg/KrishiX_App-26.jpg'),
          SubcategoryItem(labelKey: 'planter',    imagePath: 'assets/sub_ctg/KrishiX_App-28.jpg'),
        ],
      ),
      SubcategoryGroup(
        titleKey: 'labour_services',
        items: [
          SubcategoryItem(labelKey: 'harvest_labour',    imagePath: 'assets/sub_ctg/KrishiX_App-23.jpg'),
          SubcategoryItem(labelKey: 'plantation_labour', imagePath: 'assets/sub_ctg/KrishiX_App-65.jpg'),
          SubcategoryItem(labelKey: 'irrigation_labour', imagePath: 'assets/sub_ctg/KrishiX_App-66.jpg'),
        ],
      ),
    ],
  ),

  // ── JCB Rental ───────────────────────────────────────────
  CategorySectionId.jcbRental: CategoryDetail(
    emoji: '🏗️',
    titleKey: 'jcb_rental',
    listingCategory: ListingCategory.rental,
    groups: [
      SubcategoryGroup(
        titleKey: 'jcb_types',
        items: [
          SubcategoryItem(labelKey: 'jcb_backhoe',   imagePath: 'assets/sub_ctg/KrishiX_App-23.jpg'),
          SubcategoryItem(labelKey: 'jcb_excavator',  imagePath: 'assets/sub_ctg/KrishiX_App-22.jpg'),
          SubcategoryItem(labelKey: 'jcb_loader',     imagePath: 'assets/sub_ctg/KrishiX_App-21.jpg'),
          SubcategoryItem(labelKey: 'jcb_bulldozer',  imagePath: 'assets/sub_ctg/KrishiX_App-27.jpg'),
        ],
      ),
      SubcategoryGroup(
        titleKey: 'jcb_rental_duration',
        items: [
          SubcategoryItem(labelKey: 'hourly',   imagePath: 'assets/sub_ctg/KrishiX_App-17.jpg'),
          SubcategoryItem(labelKey: 'daily',    imagePath: 'assets/sub_ctg/KrishiX_App-18.jpg'),
          SubcategoryItem(labelKey: 'weekly',   imagePath: 'assets/sub_ctg/KrishiX_App-19.jpg'),
          SubcategoryItem(labelKey: 'seasonal', imagePath: 'assets/sub_ctg/KrishiX_App-20.jpg'),
        ],
      ),
    ],
  ),

  // ════════════════════════════════════════════════════════
  // LEGACY — kept for backward compatibility
  // ════════════════════════════════════════════════════════

  CategorySectionId.agricultureLand: CategoryDetail(
    emoji: '🪴',
    titleKey: 'farm_land',
    listingCategory: ListingCategory.land,
    groups: [
      SubcategoryGroup(
        titleKey: 'land_for_sale',
        items: [
          SubcategoryItem(labelKey: 'agricultural_land', imagePath: 'assets/sub_ctg/KrishiX_App-65.jpg'),
          SubcategoryItem(labelKey: 'farm_house_land',   imagePath: 'assets/sub_ctg/KrishiX_App-66.jpg'),
          SubcategoryItem(labelKey: 'orchard_land',      imagePath: 'assets/sub_ctg/KrishiX_App-69.jpg'),
        ],
      ),
    ],
  ),

  CategorySectionId.rentals: CategoryDetail(
    emoji: '🔄',
    titleKey: 'rentals',
    listingCategory: ListingCategory.rental,
    groups: [
      SubcategoryGroup(
        titleKey: 'tractor_rental',
        items: [
          SubcategoryItem(labelKey: 'hourly',   imagePath: 'assets/sub_ctg/KrishiX_App-17.jpg'),
          SubcategoryItem(labelKey: 'daily',    imagePath: 'assets/sub_ctg/KrishiX_App-18.jpg'),
          SubcategoryItem(labelKey: 'seasonal', imagePath: 'assets/sub_ctg/KrishiX_App-19.jpg'),
        ],
      ),
    ],
  ),
};