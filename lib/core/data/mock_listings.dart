import 'package:krishix/core/models/listing.dart';

abstract final class MockListings {
  static const List<Listing> all = [
    Listing(
  id: '1',
  title: 'Mahindra 575 DI Tractor (2019)',
  titleHi: 'महिंद्रा 575 DI ट्रैक्टर (2019)',
  price: 450000,
  location: 'Paithan, Chhatrapati Sambhajinagar, Maharashtra',
  category: ListingCategory.tractors,
  type: ListingType.sell,
  isVerified: true,
  sellerName: 'Ramesh Patil',
  imageEmoji: '🚜',
  description: 'Well maintained, 3200 hours, new tyres.',
  descriptionHi: 'अच्छी हालत में, 3200 घंटे, नए टायर।',
),
Listing(
  id: '2',
  title: 'Fresh Onion - 50 Quintal',
  titleHi: 'ताज़ा प्याज - 50 क्विंटल',
  price: 1800,
  location: 'Vaijapur, Chhatrapati Sambhajinagar, Maharashtra',
  category: ListingCategory.crops,
  type: ListingType.sell,
  isVerified: true,
  sellerName: 'Sunita Devi',
  imageEmoji: '🧅',
  description: 'Grade A red onion, ready for pickup.',
  descriptionHi: 'ग्रेड ए लाल प्याज, उठाने के लिए तैयार।',
),
Listing(
  id: '3',
  title: 'Murrah Buffalo - High Milk Yield',
  titleHi: 'मुर्रा भैंस - अधिक दूध',
  price: 85000,
  location: 'Gangapur, Chhatrapati Sambhajinagar, Maharashtra',
  category: ListingCategory.livestock,
  type: ListingType.sell,
  isVerified: false,
  sellerName: 'Vikram Singh',
  imageEmoji: '🐃',
  description: '12L daily milk, vaccinated, healthy.',
  descriptionHi: '12 लीटर दैनिक दूध, टीकाकृत, स्वस्थ।',
),
Listing(
  id: '4',
  title: '2 Acre Irrigated Farm Land',
  titleHi: '2 एकड़ सिंचित कृषि भूमि',
  price: 2400000,
  location: 'Sillod, Chhatrapati Sambhajinagar, Maharashtra',
  category: ListingCategory.land,
  type: ListingType.sell,
  isVerified: true,
  sellerName: 'Anil Jadhav',
  imageEmoji: '🌾',
  description: 'Canal water, clear title, road access.',
  descriptionHi: 'नहर का पानी, साफ़ पट्टा, सड़क पहुँच।',
),
Listing(
  id: '5',
  title: 'Rotavator on Rent - Daily',
  titleHi: 'रोटावेटर किराए पर - दैनिक',
  price: 1200,
  location: 'Phulambri, Chhatrapati Sambhajinagar, Maharashtra',
  category: ListingCategory.rental,
  type: ListingType.rent,
  isVerified: true,
  sellerName: 'Krishi Seva Kendra',
  imageEmoji: '⚙️',
  description: 'Delivery available within 20 km.',
  descriptionHi: '20 किमी के भीतर डिलीवरी उपलब्ध।',
),
Listing(
  id: '6',
  title: 'Swaraj 744 FE Tractor',
  titleHi: 'स्वराज 744 FE ट्रैक्टर',
  price: 380000,
  location: 'Kannad, Chhatrapati Sambhajinagar, Maharashtra',
  category: ListingCategory.tractors,
  type: ListingType.sell,
  isVerified: false,
  sellerName: 'Harpreet Kaur',
  imageEmoji: '🚜',
  description: 'Single owner, full service history.',
  descriptionHi: 'एक मालिक, पूर्ण सर्विस रिकॉर्ड।',
),
  ];

  static List<Listing> byCategory(ListingCategory category) {
    return all.where((listing) => listing.category == category).toList();
  }

  static Listing? byId(String id) {
    try {
      return all.firstWhere((listing) => listing.id == id);
    } catch (_) {
      return null;
    }
  }
}
