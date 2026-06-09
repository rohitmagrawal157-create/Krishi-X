# KrishiX

**Trusted Rural Commerce Platform** — a Flutter mobile app for Indian farmers to buy, sell, and rent agricultural goods.

## Vision

KrishiX is built for rural India where existing platforms like OLX fall short:

- Too generic — not agriculture-focused
- Poor local language support
- Weak trust and verification
- Hard for non-educated farmers to use

## Target Users

| User | Needs |
|------|-------|
| **Farmers** (primary) | Simple UI, Hindi/local languages, voice-friendly |
| **Dealers & traders** | Verified listings, machinery & livestock categories |

## Marketplace Categories

1. **Tractors & Farm Machinery** — buy/sell used equipment
2. **Crops & Produce** — vegetables, fruits, grains
3. **Livestock** — cow, buffalo, goat, poultry
4. **Agricultural Land** — buy/sell/rent farmland
5. **Equipment Rental** — rent tractors, rotavators, harvesters

## What's Built (MVP Foundation)

- Flutter 3.x project with Android & iOS support
- **Hindi + English** localization (defaults to Hindi)
- Farmer-friendly UI — large touch targets, icon-heavy navigation
- Home screen with category grid and featured listings
- Browse with category & verified-seller filters
- Listing detail, post listing, and profile screens
- Verified seller badges and trust banner
- Mock data for demo listings

## Project Structure

```
lib/
├── app.dart                 # App root + locale state
├── main.dart
├── core/
│   ├── constants/           # Colors, spacing
│   ├── data/                # Mock listings
│   ├── models/              # Listing, categories
│   ├── theme/               # Farmer-friendly theme
│   └── widgets/             # Reusable UI components
├── features/
│   ├── home/                # Dashboard
│   ├── browse/              # Search & filter listings
│   ├── listings/            # Listing detail
│   ├── post/                # Create listing
│   ├── profile/             # Login, language, settings
│   └── shell/               # Bottom navigation
└── l10n/                    # English & Hindi strings
```

## Getting Started

### Prerequisites

- Flutter SDK 3.24+ ([install guide](https://docs.flutter.dev/get-started/install))
- Android Studio / Xcode for device emulators

### Run the app

```bash
flutter pub get
flutter run
```

### Run tests

```bash
flutter test
```

## Roadmap

### Phase 1 — Core MVP
- [ ] Phone OTP authentication (Firebase / MSG91)
- [ ] Real backend API (Firebase / Supabase / custom)
- [ ] Image upload for listings
- [ ] Location-based search (GPS + pincode)

### Phase 2 — Trust & Growth
- [ ] Seller verification (Aadhaar / phone KYC)
- [ ] Ratings & reviews
- [ ] In-app chat & call masking
- [ ] Push notifications for nearby listings

### Phase 3 — Scale
- [ ] More languages (Marathi, Telugu, Punjabi, Tamil)
- [ ] Voice search (speech-to-text in local languages)
- [ ] Dealer/business accounts
- [ ] Payment escrow for high-value items

## Tech Stack

| Layer | Choice |
|-------|--------|
| Framework | Flutter 3.x |
| Language | Dart |
| Localization | flutter gen-l10n (ARB files) |
| Fonts | Google Fonts (Noto Sans — Devanagari support) |
| State management | TBD (Riverpod / Bloc recommended) |
| Backend | TBD (Firebase / Supabase) |

## License

Private — All rights reserved.
