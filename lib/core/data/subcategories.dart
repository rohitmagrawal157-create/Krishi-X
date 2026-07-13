// lib/core/data/subcategories.dart
import 'package:krishix/core/constants/category_images.dart';
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

/// Shared catch-all tile appended to every subcategory group.
const kSubcategoryOthersItem = SubcategoryItem(
  labelKey:   'others',
  imagePath:  CategoryImages.subcategoryOthers,
);

SubcategoryGroup subcategoryGroup({
  required String titleKey,
  required List<SubcategoryItem> items,
}) {
  // Others tile is hidden in home browse; appended only in post/sell flow
  // via CategoryDetailScreen when postFlow is true.
  // final hasOthers = items.any((i) => i.labelKey == 'others');
  return SubcategoryGroup(
    titleKey: titleKey,
    items: items,
    // items: hasOthers ? items : [...items, kSubcategoryOthersItem],
  );
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
  static const String sellOthers          = 'sell_others';

  // ── Rent ─────────────────────────────────────────────────
  static const String agricultureLandLease = 'agriculture_land_lease'; // Rent: lease only
  static const String tractorRental        = 'tractor_rental';
  static const String farmMachineryRent    = 'farm_machinery_rent';
  static const String jcbRental            = 'jcb_rental';

  // ── Legacy (kept for backward compat) ───────────────────
  static const String agricultureLand = 'agriculture_land';
  static const String rentals         = 'rentals';
}

final Map<String, CategoryDetail> kCategoryDetails = {

  // ════════════════════════════════════════════════════════
  // BUY CATEGORIES
  // ════════════════════════════════════════════════════════

  // ── Crops & Grains ───────────────────────────────────────
  CategorySectionId.cropsAndGrains: CategoryDetail(
    emoji: '🌾',
    titleKey: 'cropsAndGrains',
    listingCategory: ListingCategory.crops,
    groups: [
      subcategoryGroup(
        titleKey: 'cereals',
        items: [
          SubcategoryItem(labelKey: 'wheat',  imagePath: 'assets/new_ctg/KrishiX_App-31.jpg'),
          SubcategoryItem(labelKey: 'rice',   imagePath: 'assets/new_ctg/KrishiX_App-32.jpg'),
          SubcategoryItem(labelKey: 'maize',  imagePath: 'assets/new_ctg/KrishiX_App-33.jpg'),
          SubcategoryItem(labelKey: 'jowar',  imagePath: 'assets/new_ctg/KrishiX_App-40.jpg'),
          SubcategoryItem(labelKey: 'bajra',  imagePath: 'assets/new_ctg/KrishiX_App-76.jpg'),
          // SubcategoryItem(labelKey: 'barley', imagePath: 'assets/new_ctg/KrishiX_App-31.jpg'),
        ],
      ),
      subcategoryGroup(
        titleKey: 'pulses',
        items: [
          SubcategoryItem(labelKey: 'tur',    imagePath: 'assets/new_ctg/KrishiX_App-36.jpg'),
          SubcategoryItem(labelKey: 'chana',  imagePath: 'assets/new_ctg/KrishiX_App-37.jpg'),
          SubcategoryItem(labelKey: 'moong',  imagePath: 'assets/new_ctg/KrishiX_App-79.jpg'),
          SubcategoryItem(labelKey: 'udid',   imagePath: 'assets/new_ctg/KrishiX_App-80.jpg'),
          SubcategoryItem(labelKey: 'masoor', imagePath: 'assets/new_ctg/KrishiX_App-81.jpg'),
        ],
      ),
      subcategoryGroup(
        titleKey: 'oil_seeds',
        items: [
          SubcategoryItem(labelKey: 'soybean',   imagePath: 'assets/new_ctg/KrishiX_App-128.jpg'),
          SubcategoryItem(labelKey: 'groundnut', imagePath: 'assets/new_ctg/KrishiX_App-126.jpg'),
          SubcategoryItem(labelKey: 'mustard',   imagePath: 'assets/new_ctg/KrishiX_App-127.jpg'),
          SubcategoryItem(labelKey: 'sunflower', imagePath: 'assets/new_ctg/KrishiX_App-129.jpg'),
          SubcategoryItem(labelKey: 'sesame',    imagePath: 'assets/new_ctg/KrishiX_App-128.jpg'),
        ],
      ),
      subcategoryGroup(
        titleKey: 'commercial_crops',
        items: [
          SubcategoryItem(labelKey: 'cotton',    imagePath: 'assets/new_ctg/KrishiX_App-34.jpg'),
          SubcategoryItem(labelKey: 'sugarcane', imagePath: 'assets/new_ctg/KrishiX_App-39.jpg'),
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
      subcategoryGroup(
        titleKey: 'vegetables',
        items: [
          SubcategoryItem(labelKey: 'onion',       imagePath: 'assets/new_ctg/KrishiX_App-42.jpg'),
          SubcategoryItem(labelKey: 'tomato',      imagePath: 'assets/new_ctg/KrishiX_App-43.jpg'),
          SubcategoryItem(labelKey: 'potato',      imagePath: 'assets/new_ctg/KrishiX_App-139.jpg'),
          SubcategoryItem(labelKey: 'garlic',      imagePath: 'assets/new_ctg/KrishiX_App-44.jpg'),
          SubcategoryItem(labelKey: 'Ginger',    imagePath: 'assets/new_ctg/KrishiX_App-133.jpg'),
          SubcategoryItem(labelKey: 'chilli',      imagePath: 'assets/new_ctg/KrishiX_App-45.jpg'),
          SubcategoryItem(labelKey: 'brinjal',     imagePath: 'assets/new_ctg/KrishiX_App-46.jpg'),
          SubcategoryItem(labelKey: 'cabbage',     imagePath: 'assets/new_ctg/KrishiX_App-85.jpg'),
          SubcategoryItem(labelKey: 'cauliflower', imagePath: 'assets/new_ctg/KrishiX_App-86.jpg'),
          SubcategoryItem(labelKey: 'okra',        imagePath: 'assets/new_ctg/KrishiX_App-87.jpg'),
          SubcategoryItem(labelKey: 'cucumber',    imagePath: 'assets/new_ctg/KrishiX_App-88.jpg'),
          SubcategoryItem(labelKey: 'dill leaves',    imagePath: 'assets/new_ctg/KrishiX_App-144.jpg'),
          SubcategoryItem(labelKey: 'spinach',    imagePath: 'assets/new_ctg/KrishiX_App-145.jpg'),
          SubcategoryItem(labelKey: 'Safflower',    imagePath: 'assets/new_ctg/KrishiX_App-146.jpg'),
          SubcategoryItem(labelKey: 'Fenugreek',    imagePath: 'assets/new_ctg/KrishiX_App-147.jpg'),
         SubcategoryItem(labelKey: 'coriander leaves',    imagePath: 'assets/new_ctg/KrishiX_App-148.jpg'),
           SubcategoryItem(labelKey: 'carrot',    imagePath: 'assets/new_ctg/KrishiX_App-210.jpg'),
           SubcategoryItem(labelKey: 'Radish',    imagePath: 'assets/new_ctg/KrishiX_App-211.jpg'),
           SubcategoryItem(labelKey: 'Beetroot',    imagePath: 'assets/new_ctg/KrishiX_App-212.jpg'),
           SubcategoryItem(labelKey: 'Curry Leaves',    imagePath: 'assets/new_ctg/KrishiX_App-213.jpg'),
           SubcategoryItem(labelKey: 'Spring Onion	',    imagePath: 'assets/new_ctg/KrishiX_App-214.jpg'),
           SubcategoryItem(labelKey: 'Cluster Beans',    imagePath: 'assets/new_ctg/KrishiX_App-215.jpg'),
           SubcategoryItem(labelKey: 'Cowpea',    imagePath: 'assets/new_ctg/KrishiX_App-216.jpg'),
           SubcategoryItem(labelKey: 'Field Beans',    imagePath: 'assets/new_ctg/KrishiX_App-219.jpg'),

        ],
      ),
      subcategoryGroup(
        titleKey: 'fruits',
        items: [
          SubcategoryItem(labelKey: 'mango',       imagePath: 'assets/new_ctg/KrishiX_App-48.jpg'),
          SubcategoryItem(labelKey: 'banana',      imagePath: 'assets/new_ctg/KrishiX_App-49.jpg'),
          SubcategoryItem(labelKey: 'pomegranate', imagePath: 'assets/new_ctg/KrishiX_App-50.jpg'),
          SubcategoryItem(labelKey: 'orange',      imagePath: 'assets/new_ctg/KrishiX_App-51.jpg'),
          SubcategoryItem(labelKey: 'grapes',      imagePath: 'assets/new_ctg/KrishiX_App-52.jpg'),
          SubcategoryItem(labelKey: 'papaya',      imagePath: 'assets/new_ctg/KrishiX_App-53.jpg'),
          SubcategoryItem(labelKey: 'guava',       imagePath: 'assets/new_ctg/KrishiX_App-154.jpg'),
          SubcategoryItem(labelKey: 'watermelon',  imagePath: 'assets/new_ctg/KrishiX_App-152.jpg'),
          SubcategoryItem(labelKey: 'Lemon',  imagePath: 'assets/new_ctg/KrishiX_App-157.jpg'),
          SubcategoryItem(labelKey: 'custard_apple',  imagePath: 'assets/new_ctg/KrishiX_App-158.jpg'),
          SubcategoryItem(labelKey: 'Apple',  imagePath: 'assets/new_ctg/KrishiX_App-149.jpg'),
          SubcategoryItem(labelKey: 'Sapota',  imagePath: 'assets/new_ctg/KrishiX_App-150.jpg'),
          SubcategoryItem(labelKey: 'Guava',  imagePath: 'assets/new_ctg/KrishiX_App-154.jpg'),
          SubcategoryItem(labelKey: 'Java Plum',  imagePath: 'assets/new_ctg/KrishiX_App-156.jpg'),
          SubcategoryItem(labelKey: 'Indian jujube',  imagePath: 'assets/new_ctg/KrishiX_App-155.jpg'),
          SubcategoryItem(labelKey: 'fig',  imagePath: 'assets/new_ctg/KrishiX_App-159.jpg'),
          SubcategoryItem(labelKey: 'Dragon Fruit',  imagePath: 'assets/new_ctg/KrishiX_App-221.jpg'),
          SubcategoryItem(labelKey: 'Avocado',  imagePath: 'assets/new_ctg/KrishiX_App-222.jpg'),
          SubcategoryItem(labelKey: 'Lychee',  imagePath: 'assets/new_ctg/KrishiX_App-223.jpg'),
          SubcategoryItem(labelKey: 'Strawberry',  imagePath: 'assets/new_ctg/KrishiX_App-224.jpg'),
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
      subcategoryGroup(
        titleKey: 'Animals',
        items: [
          SubcategoryItem(labelKey: 'cow',     imagePath: 'assets/new_ctg/KrishiX_App-54.jpg'),
          SubcategoryItem(labelKey: 'buffalo', imagePath: 'assets/new_ctg/KrishiX_App-56.jpg'),
          SubcategoryItem(labelKey: 'bull',    imagePath: 'assets/new_ctg/KrishiX_App-57.jpg'),
          SubcategoryItem(labelKey: 'goat',    imagePath: 'assets/new_ctg/KrishiX_App-59.jpg'),
          SubcategoryItem(labelKey: 'sheep',   imagePath: 'assets/new_ctg/KrishiX_App-60.jpg'),
        ],
      ),
      subcategoryGroup(
        titleKey: 'poultry',
        items: [
          SubcategoryItem(labelKey: 'chicken', imagePath: 'assets/new_ctg/KrishiX_App-61.jpg'),
          SubcategoryItem(labelKey: 'duck',    imagePath: 'assets/new_ctg/KrishiX_App-63.jpg'),
          SubcategoryItem(labelKey: 'turkey',  imagePath: 'assets/new_ctg/KrishiX_App-58.jpg'),
          SubcategoryItem(labelKey: 'quail',   imagePath: 'assets/new_ctg/KrishiX_App-64.jpg'),
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
      subcategoryGroup(
        titleKey: 'land_for_sale',
        items: [
          SubcategoryItem(labelKey: 'agricultural_land', imagePath: 'assets/new_ctg/KrishiX_App-65.jpg'),
          SubcategoryItem(labelKey: 'farm_house_land',   imagePath: 'assets/new_ctg/KrishiX_App-66.jpg'),
          SubcategoryItem(labelKey: 'orchard_land',      imagePath: 'assets/new_ctg/KrishiX_App-69.jpg'),
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
    subcategoryGroup(
      titleKey: 'cereal_crops',
      items: [
        SubcategoryItem(labelKey: 'wheat',                  imagePath: 'assets/new_ctg/KrishiX_App-185.jpeg'),
        // SubcategoryItem(labelKey: 'rice_paddy',             imagePath: 'assets/new_ctg/KrishiX_App-186.jpeg'),
        SubcategoryItem(labelKey: 'sorghum_jowar',          imagePath: 'assets/new_ctg/KrishiX_App-186.jpeg'),
        SubcategoryItem(labelKey: 'pearl_millet_bajra',     imagePath: 'assets/new_ctg/KrishiX_App-187.jpeg'),
        SubcategoryItem(labelKey: 'maize_corn',             imagePath: 'assets/new_ctg/KrishiX_App-188.jpeg'),
        SubcategoryItem(labelKey: 'barnyard_millet_bhagar', imagePath: 'assets/new_ctg/KrishiX_App-189.jpeg'),
      ],
    ),

    // ── PULSE CROPS ───────────────────────────────────────
    subcategoryGroup(
      titleKey: 'pulse_crops',
      items: [
        SubcategoryItem(labelKey: 'pigeon_pea_tur',     imagePath: 'assets/new_ctg/KrishiX_App-190.jpeg'),
        SubcategoryItem(labelKey: 'chickpea_chana',     imagePath: 'assets/new_ctg/KrishiX_App-191.jpeg'),
        SubcategoryItem(labelKey: 'green_gram_moong',   imagePath: 'assets/new_ctg/KrishiX_App-192.jpeg'),
        SubcategoryItem(labelKey: 'black_gram_urad',    imagePath: 'assets/new_ctg/KrishiX_App-193.jpeg'),
        SubcategoryItem(labelKey: 'lentil_masoor',      imagePath: 'assets/new_ctg/KrishiX_App-194.jpeg'),
        SubcategoryItem(labelKey: 'field_pea_vatana',   imagePath: 'assets/new_ctg/KrishiX_App-195.jpeg'),
        SubcategoryItem(labelKey: 'cowpea_chawli',      imagePath: 'assets/new_ctg/KrishiX_App-196.jpeg'),
        SubcategoryItem(labelKey: 'kidney_bean_rajma',  imagePath: 'assets/new_ctg/KrishiX_App-197.jpeg'),
      ],
    ),

    // ── OIL SEEDS ─────────────────────────────────────────
    subcategoryGroup(
      titleKey: 'oil_seeds',
      items: [
        SubcategoryItem(labelKey: 'groundnut',  imagePath: 'assets/new_ctg/KrishiX_App-126.jpg'),
        SubcategoryItem(labelKey: 'mustard',    imagePath: 'assets/new_ctg/KrishiX_App-127.jpg'),
        SubcategoryItem(labelKey: 'sesame',     imagePath: 'assets/new_ctg/KrishiX_App-128.jpg'),
        SubcategoryItem(labelKey: 'safflower',  imagePath: 'assets/new_ctg/KrishiX_App-129.jpg'),
        // SubcategoryItem(labelKey: 'linseed',    imagePath: 'assets/new_ctg/KrishiX_App-72.jpg'),
        // SubcategoryItem(labelKey: 'castor',     imagePath: 'assets/new_ctg/KrishiX_App-72.jpg'),
      ],
    ),

    // ── CASH CROPS ────────────────────────────────────────
    // subcategoryGroup(
    //   titleKey: 'cash_crops',
    //   items: [
    //     SubcategoryItem(labelKey: 'sugarcane', imagePath: 'assets/new_ctg/KrishiX_App-72.jpg'),
    //     SubcategoryItem(labelKey: 'turmeric',  imagePath: 'assets/new_ctg/KrishiX_App-132.jpg'),
    //     SubcategoryItem(labelKey: 'ginger',    imagePath: 'assets/new_ctg/KrishiX_App-133.jpg'),
    //     SubcategoryItem(labelKey: 'cotton',    imagePath: 'assets/new_ctg/KrishiX_App-136.jpg'),
    //     SubcategoryItem(labelKey: 'soybean',   imagePath: 'assets/new_ctg/KrishiX_App-72.jpg'),
    //   ],
    // ),

    // ── SPICE CROPS ───────────────────────────────────────
    subcategoryGroup(
      titleKey: 'spice_crops',
      items: [
        SubcategoryItem(labelKey: 'turmeric',   imagePath: 'assets/new_ctg/KrishiX_App-199.jpeg'),
        SubcategoryItem(labelKey: 'ginger',     imagePath: 'assets/new_ctg/KrishiX_App-198.jpeg'),
        SubcategoryItem(labelKey: 'garlic',     imagePath: 'assets/new_ctg/KrishiX_App-201.jpg'),
        SubcategoryItem(labelKey: 'onion_seed',     imagePath: 'assets/new_ctg/KrishiX_App-202.jpg'),
        // SubcategoryItem(labelKey: 'coriander',  imagePath: 'assets/new_ctg/KrishiX_App-203.jpg'),
        // SubcategoryItem(labelKey: 'fenugreek',  imagePath: 'assets/new_ctg/KrishiX_App-204.jpg'),
        // SubcategoryItem(labelKey: 'onion_seed', imagePath: 'assets/new_ctg/KrishiX_App-205.jpg'),
      ],
    ),

    // ── VEGETABLE SEEDS ───────────────────────────────────
    subcategoryGroup(
      titleKey: 'vegetable_seeds',
      items: [
        SubcategoryItem(labelKey: 'onion',        imagePath: 'assets/new_ctg/KrishiX_App-202.jpg'),
        SubcategoryItem(labelKey: 'potato',       imagePath: 'assets/new_ctg/KrishiX_App-203.jpg'),
        SubcategoryItem(labelKey: 'okra',         imagePath: 'assets/new_ctg/KrishiX_App-204.jpg'),
        SubcategoryItem(labelKey: 'chilli',       imagePath: 'assets/new_ctg/KrishiX_App-205.jpg'),
        SubcategoryItem(labelKey: 'cucumber',     imagePath: 'assets/new_ctg/KrishiX_App-206.jpg'),
        SubcategoryItem(labelKey: 'ridge_gourd',  imagePath: 'assets/new_ctg/KrishiX_App-207.jpg'),
        SubcategoryItem(labelKey: 'bitter_gourd', imagePath: 'assets/new_ctg/KrishiX_App-208.jpg'),
        SubcategoryItem(labelKey: 'bottle_gourd', imagePath: 'assets/new_ctg/KrishiX_App-209.jpg'),
        // SubcategoryItem(labelKey: 'dill',         imagePath: 'assets/new_ctg/KrishiX_App-210.jpg'),
      ],
    ),

    // ── FRUIT CROPS ───────────────────────────────────────
    // subcategoryGroup(
    //   titleKey: 'fruit_crops',
    //   items: [
    //     SubcategoryItem(labelKey: 'mango',          imagePath: 'assets/new_ctg/KrishiX_App-73.jpg'),
    //     SubcategoryItem(labelKey: 'custard_apple',  imagePath: 'assets/new_ctg/KrishiX_App-73.jpg'),
    //     SubcategoryItem(labelKey: 'papaya',         imagePath: 'assets/new_ctg/KrishiX_App-73.jpg'),
    //     SubcategoryItem(labelKey: 'jamun',          imagePath: 'assets/new_ctg/KrishiX_App-73.jpg'),
    //   ],
    // ),

    // ── FODDER CROPS ──────────────────────────────────────
    // subcategoryGroup(
    //   titleKey: 'fodder_crops',
    //   items: [
    //     SubcategoryItem(labelKey: 'fodder_maize',        imagePath: 'assets/new_ctg/KrishiX_App-71.jpg'),
    //     SubcategoryItem(labelKey: 'fodder_sorghum',      imagePath: 'assets/new_ctg/KrishiX_App-71.jpg'),
    //     SubcategoryItem(labelKey: 'fodder_pearl_millet', imagePath: 'assets/new_ctg/KrishiX_App-71.jpg'),
    //   ],
    // ),

    // ── PLANTS & SAPLINGS ─────────────────────────────────
    subcategoryGroup(
      titleKey: 'plants_and_saplings',
      items: [
        SubcategoryItem(labelKey: 'mango_sapling',       imagePath: 'assets/new_ctg/KrishiX_App-176.jpeg'),
        SubcategoryItem(labelKey: 'pomegranate_sapling', imagePath: 'assets/new_ctg/KrishiX_App-177.jpeg'),
        SubcategoryItem(labelKey: 'sweet_lime_sapling',  imagePath: 'assets/new_ctg/KrishiX_App-178.jpeg'),
        SubcategoryItem(labelKey: 'orange_sapling',      imagePath: 'assets/new_ctg/KrishiX_App-179.jpeg'),
        SubcategoryItem(labelKey: 'cashew_sapling',      imagePath: 'assets/new_ctg/KrishiX_App-180.jpeg'),
        SubcategoryItem(labelKey: 'coconut_sapling',     imagePath: 'assets/new_ctg/KrishiX_App-181.jpeg'),
        SubcategoryItem(labelKey: 'teak_sapling',        imagePath: 'assets/new_ctg/KrishiX_App-182.jpeg'),
        SubcategoryItem(labelKey: 'bamboo_sapling',      imagePath: 'assets/new_ctg/KrishiX_App-183.jpeg'),
        SubcategoryItem(labelKey: 'tissue_culture_plants', imagePath: 'assets/new_ctg/KrishiX_App-184.jpeg'),
        // SubcategoryItem(labelKey: 'nursery_plants',      imagePath: 'assets/new_ctg/KrishiX_App-185.jpeg'),
      ],
    ),

  ],
),
  // ── Sell Others ────────────────────────────────────────────
  CategorySectionId.sellOthers: CategoryDetail(
    emoji: '📦',
    titleKey: 'others',
    listingCategory: ListingCategory.crops,
    groups: [
      subcategoryGroup(
        titleKey: 'others',
        items: [
          SubcategoryItem(
            labelKey:  'other_animals',
            imagePath: CategoryImages.subcategoryOthers,
          ),
          SubcategoryItem(
            labelKey:  'services',
            imagePath: CategoryImages.subcategoryOthers,
          ),
          SubcategoryItem(
            labelKey:  'others',
            imagePath: CategoryImages.subcategoryOthers,
          ),
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
      subcategoryGroup(
        titleKey: 'land_preparation',
        items: [
          SubcategoryItem(labelKey: 'rotavator',   imagePath: 'assets/new_ctg/KrishiX_App-21.jpg'),
          SubcategoryItem(labelKey: 'cultivator',  imagePath: 'assets/new_ctg/KrishiX_App-22.jpg'),
          SubcategoryItem(labelKey: 'disc_harrow', imagePath: 'assets/new_ctg/KrishiX_App-92.jpg'),
          SubcategoryItem(labelKey: 'plough',      imagePath: 'assets/new_ctg/KrishiX_App-27.jpg'),
           SubcategoryItem(labelKey: 'subsoiler',   imagePath: 'assets/new_ctg/KrishiX_App-94.jpg'),
          SubcategoryItem(labelKey: 'ridger',      imagePath: 'assets/new_ctg/KrishiX_App-95.jpg'),
        ],
      ),
      subcategoryGroup(
        titleKey: 'sowing_equipment',
        items: [
          SubcategoryItem(labelKey: 'seed_drill',       imagePath: 'assets/new_ctg/KrishiX_App-25.jpg'),
          SubcategoryItem(labelKey: 'planter',          imagePath: 'assets/new_ctg/KrishiX_App-96.jpg'),
          SubcategoryItem(labelKey: 'paddy_seeder',     imagePath: 'assets/new_ctg/KrishiX_App-97.jpg'),
          SubcategoryItem(labelKey: 'fertilizer_drill', imagePath: 'assets/new_ctg/KrishiX_App-28.jpg'),
        ],
      ),
      subcategoryGroup(
        titleKey: 'crop_protection',
        items: [
          SubcategoryItem(labelKey: 'power_sprayer',   imagePath: 'assets/new_ctg/KrishiX_App-100.jpg'),
          SubcategoryItem(labelKey: 'battery_sprayer', imagePath: 'assets/new_ctg/KrishiX_App-101.jpg'),
          SubcategoryItem(labelKey: 'boom_sprayer',    imagePath: 'assets/new_ctg/KrishiX_App-98.jpg'),
          SubcategoryItem(labelKey: 'fogging_machine', imagePath: 'assets/new_ctg/KrishiX_App-99.jpg'),
          SubcategoryItem(labelKey: 'drone_harvester',   imagePath: 'assets/new_ctg/KrishiX_App-105.jpg'),

        ],
      ),
      subcategoryGroup(
        titleKey: 'harvesting_equipment',
        items: [
          SubcategoryItem(labelKey: 'harvester',         imagePath: 'assets/new_ctg/KrishiX_App-23.jpg'),
          SubcategoryItem(labelKey: 'mini_harvester',    imagePath: 'assets/new_ctg/KrishiX_App-103.jpg'),
          SubcategoryItem(labelKey: 'reaper',            imagePath: 'assets/new_ctg/KrishiX_App-28.jpg'),
          SubcategoryItem(labelKey: 'combine_harvester', imagePath: 'assets/new_ctg/KrishiX_App-102.jpg'),
        ],
      ),
      subcategoryGroup(
        titleKey: 'post_harvest',
        items: [
          SubcategoryItem(labelKey: 'thresher',      imagePath: 'assets/new_ctg/KrishiX_App-106.jpg'),
          SubcategoryItem(labelKey: 'baler',         imagePath: 'assets/new_ctg/KrishiX_App-29.jpg'),
          SubcategoryItem(labelKey: 'grain_cleaner', imagePath: 'assets/new_ctg/KrishiX_App-107.jpg'),
          SubcategoryItem(labelKey: 'winnower',      imagePath: 'assets/new_ctg/KrishiX_App-108.jpg'),
        ],
      ),
      subcategoryGroup(
        titleKey: 'irrigation_equipment',
        items: [
          SubcategoryItem(labelKey: 'water_pump',       imagePath: 'assets/new_ctg/KrishiX_App-109.jpg'),
          SubcategoryItem(labelKey: 'solar_pump',       imagePath: 'assets/new_ctg/KrishiX_App-110.jpg'),
          SubcategoryItem(labelKey: 'drip_system',      imagePath: 'assets/new_ctg/KrishiX_App-169.jpeg'),
          SubcategoryItem(labelKey: 'sprinkler_system', imagePath: 'assets/new_ctg/KrishiX_App-111.jpg'),
        ],
      ),
      subcategoryGroup(
        titleKey: 'power_equipment',
        items: [
          SubcategoryItem(labelKey: 'power_weeder', imagePath: 'assets/new_ctg/KrishiX_App-108.jpg'),
          SubcategoryItem(labelKey: 'power_tiller', imagePath: 'assets/new_ctg/KrishiX_App-112.jpg'),
          SubcategoryItem(labelKey: 'mini_tiller',  imagePath: 'assets/new_ctg/KrishiX_App-113.jpg'),
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
      subcategoryGroup(
        titleKey: 'horse_power_hp',
        items: [
          SubcategoryItem(labelKey: 'under_20_hp', imagePath: 'assets/new_ctg/KrishiX_App-160.jpeg'),
          SubcategoryItem(labelKey: 'hp_21_30',    imagePath: 'assets/new_ctg/KrishiX_App-161.jpeg'),
          SubcategoryItem(labelKey: 'hp_31_40',    imagePath: 'assets/new_ctg/KrishiX_App-162.jpeg'),
          SubcategoryItem(labelKey: 'hp_41_50',    imagePath: 'assets/new_ctg/KrishiX_App-163.jpeg'),
          SubcategoryItem(labelKey: 'hp_51_60',    imagePath: 'assets/new_ctg/KrishiX_App-164.jpeg'),
          SubcategoryItem(labelKey: 'above_60_hp', imagePath: 'assets/new_ctg/KrishiX_App-165.jpeg'),
        ],
      ),
      subcategoryGroup(
        titleKey: 'tractor_brands',
        items: [
          SubcategoryItem(labelKey: 'mahindra',        imagePath: 'assets/new_ctg/KrishiX_App-114.jpg'),
          SubcategoryItem(labelKey: 'swaraj',          imagePath: 'assets/new_ctg/KrishiX_App-115.jpg'),
          SubcategoryItem(labelKey: 'sonalika',        imagePath: 'assets/new_ctg/KrishiX_App-116.jpg'),
          SubcategoryItem(labelKey: 'john_deere',      imagePath: 'assets/new_ctg/KrishiX_App-117.jpg'),
          SubcategoryItem(labelKey: 'massey_ferguson', imagePath: 'assets/new_ctg/KrishiX_App-119.jpg'),
          SubcategoryItem(labelKey: 'farmtrac',       imagePath: 'assets/new_ctg/KrishiX_App-118.jpg'),
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
      subcategoryGroup(
        titleKey: 'tractor_parts',
        items: [
          SubcategoryItem(labelKey: 'tyres',           imagePath: 'assets/new_ctg/KrishiX_App-17.jpg'),
          SubcategoryItem(labelKey: 'batteries',       imagePath: 'assets/new_ctg/KrishiX_App-18.jpg'),
          SubcategoryItem(labelKey: 'hydraulic_parts', imagePath: 'assets/new_ctg/KrishiX_App-19.jpg'),
          SubcategoryItem(labelKey: 'pto_parts',       imagePath: 'assets/new_ctg/KrishiX_App-20.jpg'),
          SubcategoryItem(labelKey: 'engine_parts',    imagePath: 'assets/new_ctg/KrishiX_App-17.jpg'),
          SubcategoryItem(labelKey: 'tractor_seats',   imagePath: 'assets/new_ctg/KrishiX_App-18.jpg'),
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
      subcategoryGroup(
        titleKey: 'land_for_lease',
        items: [
          SubcategoryItem(labelKey: 'land_for_lease',     imagePath: 'assets/new_ctg/KrishiX_App-68.jpg'),
          SubcategoryItem(labelKey: 'partnership_farming', imagePath: 'assets/new_ctg/KrishiX_App-65.jpg'),
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
      subcategoryGroup(
        titleKey: 'tractor_brands',
        items: [
          SubcategoryItem(labelKey: 'mahindra',        imagePath: 'assets/new_ctg/KrishiX_App-17.jpg'),
          SubcategoryItem(labelKey: 'swaraj',          imagePath: 'assets/new_ctg/KrishiX_App-18.jpg'),
          SubcategoryItem(labelKey: 'sonalika',        imagePath: 'assets/new_ctg/KrishiX_App-19.jpg'),
          SubcategoryItem(labelKey: 'john_deere',      imagePath: 'assets/new_ctg/KrishiX_App-20.jpg'),
          SubcategoryItem(labelKey: 'massey_ferguson', imagePath: 'assets/new_ctg/KrishiX_App-18.jpg'),
          SubcategoryItem(labelKey: 'powertrac',       imagePath: 'assets/new_ctg/KrishiX_App-18.jpg'),
        ],
      ),
    ],
  ),

  // ── Farm Machinery Rent ──────────────────────────────────
  CategorySectionId.farmMachineryRent: CategoryDetail(
    emoji: '⚙️',
    titleKey: 'farm_machinery_rent',
    listingCategory: ListingCategory.rental,
    groups: [
      subcategoryGroup(
        titleKey: 'machinery_rental',
        items: [
          SubcategoryItem(labelKey: 'rotavator',  imagePath: 'assets/new_ctg/KrishiX_App-21.jpg'),
          SubcategoryItem(labelKey: 'harvester',  imagePath: 'assets/new_ctg/KrishiX_App-23.jpg'),
          SubcategoryItem(labelKey: 'cultivator', imagePath: 'assets/new_ctg/KrishiX_App-22.jpg'),
          SubcategoryItem(labelKey: 'seeder',     imagePath: 'assets/new_ctg/KrishiX_App-24.jpg'),
          SubcategoryItem(labelKey: 'sprayer',    imagePath: 'assets/new_ctg/KrishiX_App-25.jpg'),
          SubcategoryItem(labelKey: 'thresher',   imagePath: 'assets/new_ctg/KrishiX_App-26.jpg'),
          SubcategoryItem(labelKey: 'planter',    imagePath: 'assets/new_ctg/KrishiX_App-28.jpg'),
        ],
      ),
      subcategoryGroup(
        titleKey: 'labour_services',
        items: [
          SubcategoryItem(labelKey: 'harvest_labour',    imagePath: 'assets/new_ctg/KrishiX_App-23.jpg'),
          SubcategoryItem(labelKey: 'plantation_labour', imagePath: 'assets/new_ctg/KrishiX_App-65.jpg'),
          SubcategoryItem(labelKey: 'irrigation_labour', imagePath: 'assets/new_ctg/KrishiX_App-66.jpg'),
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
      subcategoryGroup(
        titleKey: 'jcb_types',
        items: [
          SubcategoryItem(labelKey: 'jcb_backhoe',   imagePath: 'assets/new_ctg/KrishiX_App-172.jpeg'),
          SubcategoryItem(labelKey: 'jcb_excavator',  imagePath: 'assets/new_ctg/KrishiX_App-170.jpeg'),
          SubcategoryItem(labelKey: 'jcb_pockland',     imagePath: 'assets/new_ctg/KrishiX_App-171.jpeg'),
          SubcategoryItem(labelKey: 'mini_Excavator',  imagePath: 'assets/new_ctg/KrishiX_App-174.jpeg'),
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
      subcategoryGroup(
        titleKey: 'land_for_sale',
        items: [
          SubcategoryItem(labelKey: 'agricultural_land', imagePath: 'assets/new_ctg/KrishiX_App-65.jpg'),
          SubcategoryItem(labelKey: 'farm_house_land',   imagePath: 'assets/new_ctg/KrishiX_App-66.jpg'),
          SubcategoryItem(labelKey: 'orchard_land',      imagePath: 'assets/new_ctg/KrishiX_App-69.jpg'),
        ],
      ),
    ],
  ),

  CategorySectionId.rentals: CategoryDetail(
    emoji: '🔄',
    titleKey: 'rentals',
    listingCategory: ListingCategory.rental,
    groups: [
      subcategoryGroup(
        titleKey: 'tractor_rental',
        items: [
          SubcategoryItem(labelKey: 'hourly',   imagePath: 'assets/new_ctg/KrishiX_App-17.jpg'),
          SubcategoryItem(labelKey: 'daily',    imagePath: 'assets/new_ctg/KrishiX_App-18.jpg'),
          SubcategoryItem(labelKey: 'seasonal', imagePath: 'assets/new_ctg/KrishiX_App-19.jpg'),
        ],
      ),
    ],
  ),
};