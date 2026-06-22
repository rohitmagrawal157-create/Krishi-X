// lib/core/data/mock_listings.dart

import 'package:krishix/core/models/listing.dart';

abstract final class MockListings {
  static final List<Listing> all = [   // ← const → final (DateTime is not const)

    // ════════════════════════════════════════════════════════
    // TRACTORS — Ramesh Patil has 2 ads
    // ════════════════════════════════════════════════════════
    Listing(
      id:            '1',
      title:         'Mahindra 575 DI Tractor (2019)',
      titleHi:       'महिंद्रा 575 DI ट्रैक्टर (2019)',
      titleMr:       'महिंद्रा 575 DI ट्रॅक्टर (2019)',
      titleGu:       'મહિન્દ્રા 575 DI ટ્રેક્ટર (2019)',
      price:         450000,
      location:      'Paithan, Chhatrapati Sambhajinagar, Maharashtra',
      category:      ListingCategory.tractors,
      type:          ListingType.sell,
      isVerified:    true,
      sellerName:    'Ramesh Patil',
      sellerId:      'seller_ramesh_patil',
      sellerPhone:   '+91 98765 43210',
      sellerMemberSince: DateTime(2026, 1, 1),
      viewCount:     248,
      likeCount:     34,
      postedOn:      DateTime(2026, 1, 12),
      imageEmoji:    '🚜',
      description:   'Well maintained, 3200 hours, new tyres.',
      descriptionHi: 'अच्छी हालत में, 3200 घंटे, नए टायर।',
      descriptionMr: 'चांगल्या स्थितीत, 3200 तास, नवीन टायर.',
      descriptionGu: 'સારી હાલતમાં, 3200 કલાક, નવા ટાયર.',
      brand:         'Mahindra',
      condition:     'Used',
      year:          2019,
      hoursUsed:     3200,
      horsePower:    45,
      fuelType:      'Diesel',
    ),

    Listing(
      id:            '7',
      title:         'Mahindra Rotavator - 6 Feet',
      titleHi:       'महिंद्रा रोटावेटर - 6 फीट',
      titleMr:       'महिंद्रा रोटाव्हेटर - 6 फूट',
      titleGu:       'મહિન્દ્રા રોટાવેટર - 6 ફૂટ',
      price:         65000,
      location:      'Paithan, Chhatrapati Sambhajinagar, Maharashtra',
      category:      ListingCategory.tractors,
      type:          ListingType.sell,
      isVerified:    true,
      sellerName:    'Ramesh Patil',
      sellerId:      'seller_ramesh_patil',
      sellerPhone:   '+91 98765 43210',
      sellerMemberSince: DateTime(2026, 1, 1),
      viewCount:     136,
      likeCount:     21,
      postedOn:      DateTime(2026, 3, 2),
      imageEmoji:    '⚙️',
      description:   'Barely used rotavator, works perfectly.',
      descriptionHi: 'बहुत कम इस्तेमाल किया हुआ रोटावेटर, बढ़िया काम करता है।',
      descriptionMr: 'फार कमी वापरलेले रोटाव्हेटर, उत्तम काम करते.',
      descriptionGu: 'ખૂબ ઓછું વपरायेल રોટাવેटर, સरस काम करे छे.',
      brand:         'Mahindra',
      condition:     'Used',
      year:          2022,
    ),

    // ════════════════════════════════════════════════════════
    // CROPS
    // ════════════════════════════════════════════════════════
    Listing(
      id:            '2',
      title:         'Fresh Onion - 50 Quintal',
      titleHi:       'ताज़ा प्याज - 50 क्विंटल',
      titleMr:       'ताजा कांदा - 50 क्विंटल',
      titleGu:       'તાજી ડુંગળી - 50 ક્વિન્ટલ',
      price:         1800,
      location:      'Vaijapur, Chhatrapati Sambhajinagar, Maharashtra',
      category:      ListingCategory.crops,
      type:          ListingType.sell,
      isVerified:    true,
      sellerName:    'Sunita Devi',
      sellerId:      'seller_sunita_devi',
      sellerPhone:   '+91 97654 32109',
      sellerMemberSince: DateTime(2026, 6, 1),
      viewCount:     189,
      likeCount:     27,
      postedOn:      DateTime(2026, 6, 10),
      imageEmoji:    '🧅',
      description:   'Grade A red onion, ready for pickup.',
      descriptionHi: 'ग्रेड ए लाल प्याज, उठाने के लिए तैयार।',
      descriptionMr: 'ग्रेड ए लाल कांदा, उचलण्यासाठी तयार.',
      descriptionGu: 'ગ્રેડ એ લાલ ડુંગળી, ઉपाडवा माटे तैयार.',
      quantity:      50,
      unit:          'Quintal',
      grade:         'Grade A',
      harvestDate:   'This week',
    ),

    // ════════════════════════════════════════════════════════
    // LIVESTOCK
    // ════════════════════════════════════════════════════════
    Listing(
      id:            '3',
      title:         'Murrah Buffalo - High Milk Yield',
      titleHi:       'मुर्रा भैंस - अधिक दूध',
      titleMr:       'मुर्हा म्हैस - जास्त दूध',
      titleGu:       'મુર્રાહ ભેંસ - વધુ દૂધ',
      price:         85000,
      location:      'Gangapur, Chhatrapati Sambhajinagar, Maharashtra',
      category:      ListingCategory.livestock,
      type:          ListingType.sell,
      isVerified:    false,
      sellerName:    'Vikram Singh',
      sellerId:      'seller_vikram_singh',
      sellerPhone:   '+91 96543 21098',
      sellerMemberSince: DateTime(2026, 5, 1),
      viewCount:     96,
      likeCount:     12,
      postedOn:      DateTime(2026, 5, 28),
      imageEmoji:    '🐃',
      description:   '12L daily milk, vaccinated, healthy.',
      descriptionHi: '12 लीटर दैनिक दूध, टीकाकृत, स्वस्थ।',
      descriptionMr: '12 लिटर रोजचे दूध, लसीकरण झालेले, निरोगी.',
      descriptionGu: '12 લिटर दैनिक दूध, रसीकरण थयेल, स्वस्थ.',
      breed:           'Murrah',
      age:             '3 years',
      milkYieldLitres: 12,
      animalColor:     'Black',
    ),

    // ════════════════════════════════════════════════════════
    // LAND
    // ════════════════════════════════════════════════════════
    Listing(
      id:            '4',
      title:         '2 Acre Irrigated Farm Land',
      titleHi:       '2 एकड़ सिंचित कृषि भूमि',
      titleMr:       '2 एकर सिंचित शेतजमीन',
      titleGu:       '2 એकर સिंचाईवाळी खेतीनी जमीन',
      price:         2400000,
      location:      'Sillod, Chhatrapati Sambhajinagar, Maharashtra',
      category:      ListingCategory.land,
      type:          ListingType.sell,
      isVerified:    true,
      sellerName:    'Anil Jadhav',
      sellerId:      'seller_anil_jadhav',
      sellerPhone:   '+91 95432 10987',
      sellerMemberSince: DateTime(2026, 4, 1),
      viewCount:     221,
      likeCount:     31,
      postedOn:      DateTime(2026, 4, 18),
      imageEmoji:    '🌾',
      description:   'Canal water, clear title, road access.',
      descriptionHi: 'नहर का पानी, साफ़ पट्टा, सड़क पहुँच।',
      descriptionMr: 'कालव्याचे पाणी, स्पष्ट मालकी, रस्ता उपलब्ध.',
      descriptionGu: 'નहेरनु पाणी, स्पष्ट मालकी, रस्तानी सगवड.',
      areaAcres:   2,
      soilType:    'Black Soil',
      waterSource: 'Canal',
      landDeed:    'Clear Title',
    ),

    // ════════════════════════════════════════════════════════
    // RENTAL
    // ════════════════════════════════════════════════════════
    Listing(
      id:            '5',
      title:         'Rotavator on Rent - Daily',
      titleHi:       'रोटावेटर किराए पर - दैनिक',
      titleMr:       'रोटाव्हेटर भाड्याने - दैनिक',
      titleGu:       'રોટાવેटर ભाडे - दैनिक',
      price:         1200,
      location:      'Phulambri, Chhatrapati Sambhajinagar, Maharashtra',
      category:      ListingCategory.rental,
      type:          ListingType.rent,
      isVerified:    true,
      sellerName:    'Krishi Seva Kendra',
      sellerId:      'seller_krishi_seva_kendra',
      sellerPhone:   '+91 94321 09876',
      sellerMemberSince: DateTime(2026, 6, 1),
      viewCount:     172,
      likeCount:     19,
      postedOn:      DateTime(2026, 6, 1),
      imageEmoji:    '⚙️',
      description:   'Delivery available within 20 km.',
      descriptionHi: '20 किमी के भीतर डिलीवरी उपलब्ध।',
      descriptionMr: '20 किमी च्या आत डिलिव्हरी उपलब्ध.',
      descriptionGu: '20 કिमीनी अंदर डिलिवरी उपलब्ध.',
      equipmentType:     'Rotavator',
      rentalDuration:    'Daily',
      deliveryAvailable: true,
    ),

    // ════════════════════════════════════════════════════════
    // TRACTORS — Harpreet Kaur
    // ════════════════════════════════════════════════════════
    Listing(
      id:            '6',
      title:         'Swaraj 744 FE Tractor',
      titleHi:       'स्वराज 744 FE ट्रैक्टर',
      titleMr:       'स्वराज 744 FE ट्रॅक्टर',
      titleGu:       'સ્વराज 744 FE ट्रेक्टर',
      price:         380000,
      location:      'Kannad, Chhatrapati Sambhajinagar, Maharashtra',
      category:      ListingCategory.tractors,
      type:          ListingType.sell,
      isVerified:    false,
      sellerName:    'Harpreet Kaur',
      sellerId:      'seller_harpreet_kaur',
      sellerPhone:   '+91 93210 98765',
      sellerMemberSince: DateTime(2026, 2, 1),
      viewCount:     144,
      likeCount:     16,
      postedOn:      DateTime(2026, 2, 22),
      imageEmoji:    '🚜',
      description:   'Single owner, full service history.',
      descriptionHi: 'एक मालिक, पूर्ण सर्विस रिकॉर्ड।',
      descriptionMr: 'एकच मालक, संपूर्ण सर्व्हिस रेकॉर्ड.',
      descriptionGu: 'એक मालिक, संपूर्ण सर्विस रेकोर्ड.',
      brand:         'Swaraj',
      condition:     'Used',
      year:          2020,
      hoursUsed:     1800,
      horsePower:    48,
      fuelType:      'Diesel',
    ),
  ];

  static List<Listing> byCategory(ListingCategory category) =>
      all.where((l) => l.category == category).toList();

  static Listing? byId(String id) {
    try { return all.firstWhere((l) => l.id == id); }
    catch (_) { return null; }
  }

  static List<Listing> bySeller(String sellerId) =>
      all.where((l) => l.sellerId == sellerId).toList();
}
