import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('mr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'KrishiX'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Trusted Rural Commerce'**
  String get tagline;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @browse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get browse;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search tractors, crops, livestock...'**
  String get searchHint;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @featuredListings.
  ///
  /// In en, this message translates to:
  /// **'Featured Listings'**
  String get featuredListings;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @verifiedSeller.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verifiedSeller;

  /// No description provided for @fruitsAndVegetables.
  ///
  /// In en, this message translates to:
  /// **'Fruits & Vegetables'**
  String get fruitsAndVegetables;

  /// No description provided for @cropsAndGrains.
  ///
  /// In en, this message translates to:
  /// **'Crops & Grains'**
  String get cropsAndGrains;

  /// No description provided for @seeds.
  ///
  /// In en, this message translates to:
  /// **'Seeds'**
  String get seeds;

  /// No description provided for @nearYou.
  ///
  /// In en, this message translates to:
  /// **'Near you'**
  String get nearYou;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @marathi.
  ///
  /// In en, this message translates to:
  /// **'Marathi'**
  String get marathi;

  /// No description provided for @gujarati.
  ///
  /// In en, this message translates to:
  /// **'Gujarati'**
  String get gujarati;

  /// No description provided for @welcomeFarmer.
  ///
  /// In en, this message translates to:
  /// **'Welcome, Kisan!'**
  String get welcomeFarmer;

  /// No description provided for @whatDoYouNeed.
  ///
  /// In en, this message translates to:
  /// **'What do you need today?'**
  String get whatDoYouNeed;

  /// No description provided for @categoryTractors.
  ///
  /// In en, this message translates to:
  /// **'Tractors & Machinery'**
  String get categoryTractors;

  /// No description provided for @categoryCrops.
  ///
  /// In en, this message translates to:
  /// **'Crops & Grains'**
  String get categoryCrops;

  /// No description provided for @categoryLivestock.
  ///
  /// In en, this message translates to:
  /// **'Livestock'**
  String get categoryLivestock;

  /// No description provided for @categoryLand.
  ///
  /// In en, this message translates to:
  /// **'Agricultural Land'**
  String get categoryLand;

  /// No description provided for @categoryRental.
  ///
  /// In en, this message translates to:
  /// **'Equipment Rental'**
  String get categoryRental;

  /// No description provided for @postListing.
  ///
  /// In en, this message translates to:
  /// **'Post a Listing'**
  String get postListing;

  /// No description provided for @postListingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sell or rent your farm items'**
  String get postListingSubtitle;

  /// No description provided for @listingTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get listingTitle;

  /// No description provided for @listingPrice.
  ///
  /// In en, this message translates to:
  /// **'Price (₹)'**
  String get listingPrice;

  /// No description provided for @listingLocation.
  ///
  /// In en, this message translates to:
  /// **'Village / District'**
  String get listingLocation;

  /// No description provided for @listingDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get listingDescription;

  /// No description provided for @submitListing.
  ///
  /// In en, this message translates to:
  /// **'Submit Listing'**
  String get submitListing;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon!'**
  String get comingSoon;

  /// No description provided for @trustBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Buy & sell with confidence'**
  String get trustBannerTitle;

  /// No description provided for @trustBannerBody.
  ///
  /// In en, this message translates to:
  /// **'Verified sellers, local language support, and categories built for farmers.'**
  String get trustBannerBody;

  /// No description provided for @myListings.
  ///
  /// In en, this message translates to:
  /// **'My Listings'**
  String get myListings;

  /// No description provided for @savedItems.
  ///
  /// In en, this message translates to:
  /// **'Saved Items'**
  String get savedItems;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @loginRegister.
  ///
  /// In en, this message translates to:
  /// **'Login / Register'**
  String get loginRegister;

  /// No description provided for @phoneLoginHint.
  ///
  /// In en, this message translates to:
  /// **'Enter mobile number to continue'**
  String get phoneLoginHint;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get phoneNumberLabel;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit mobile number'**
  String get invalidPhoneNumber;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get otpTitle;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit OTP sent to'**
  String get otpSentTo;

  /// No description provided for @otpEnterHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit OTP'**
  String get otpEnterHint;

  /// No description provided for @verifyOtpButton.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyOtpButton;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Incorrect OTP. Please try again.'**
  String get invalidOtp;

  /// No description provided for @otpVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified! You are logged in.'**
  String get otpVerified;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @resendOtpIn.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP in'**
  String get resendOtpIn;

  /// No description provided for @changeNumber.
  ///
  /// In en, this message translates to:
  /// **'Change number'**
  String get changeNumber;

  /// No description provided for @loggedInAs.
  ///
  /// In en, this message translates to:
  /// **'Logged in as'**
  String get loggedInAs;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @listingDetailContact.
  ///
  /// In en, this message translates to:
  /// **'Contact Seller'**
  String get listingDetailContact;

  /// No description provided for @listingDetailShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get listingDetailShare;

  /// No description provided for @noListingsYet.
  ///
  /// In en, this message translates to:
  /// **'No listings in this category yet.'**
  String get noListingsYet;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified only'**
  String get filterVerified;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @callNow.
  ///
  /// In en, this message translates to:
  /// **'Call Now'**
  String get callNow;

  /// No description provided for @whatsappNow.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Now'**
  String get whatsappNow;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @voiceSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by voice'**
  String get voiceSearchHint;

  /// No description provided for @tapToSpeak.
  ///
  /// In en, this message translates to:
  /// **'Tap to speak'**
  String get tapToSpeak;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get listening;

  /// No description provided for @speakNow.
  ///
  /// In en, this message translates to:
  /// **'Speak now'**
  String get speakNow;

  /// No description provided for @couldNotHear.
  ///
  /// In en, this message translates to:
  /// **'Could not hear you. Please try again.'**
  String get couldNotHear;

  /// No description provided for @otpAutoDetected.
  ///
  /// In en, this message translates to:
  /// **'OTP auto-detected'**
  String get otpAutoDetected;

  /// No description provided for @otpSending.
  ///
  /// In en, this message translates to:
  /// **'Sending OTP...'**
  String get otpSending;

  /// No description provided for @otpSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully'**
  String get otpSentSuccess;

  /// No description provided for @otpSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send OTP'**
  String get otpSendFailed;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get sold;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @fixedPrice.
  ///
  /// In en, this message translates to:
  /// **'Fixed Price'**
  String get fixedPrice;

  /// No description provided for @negotiable.
  ///
  /// In en, this message translates to:
  /// **'Negotiable'**
  String get negotiable;

  /// No description provided for @makeOffer.
  ///
  /// In en, this message translates to:
  /// **'Make Offer'**
  String get makeOffer;

  /// No description provided for @priceNegotiable.
  ///
  /// In en, this message translates to:
  /// **'Price negotiable'**
  String get priceNegotiable;

  /// No description provided for @selectVillage.
  ///
  /// In en, this message translates to:
  /// **'Select Village'**
  String get selectVillage;

  /// No description provided for @selectDistrict.
  ///
  /// In en, this message translates to:
  /// **'Select District'**
  String get selectDistrict;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get useCurrentLocation;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @pleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get pleaseTryAgain;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get pleaseWait;

  /// No description provided for @verifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get verifying;

  /// No description provided for @listingPostedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Listing posted successfully!'**
  String get listingPostedSuccess;

  /// No description provided for @listingUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Listing updated successfully!'**
  String get listingUpdatedSuccess;

  /// No description provided for @listingDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Listing deleted successfully!'**
  String get listingDeletedSuccess;

  /// No description provided for @rentPerDay.
  ///
  /// In en, this message translates to:
  /// **'Rent per day'**
  String get rentPerDay;

  /// No description provided for @rentPerMonth.
  ///
  /// In en, this message translates to:
  /// **'Rent per month'**
  String get rentPerMonth;

  /// No description provided for @securityDeposit.
  ///
  /// In en, this message translates to:
  /// **'Security deposit'**
  String get securityDeposit;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @breed.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get breed;

  /// No description provided for @vaccinated.
  ///
  /// In en, this message translates to:
  /// **'Vaccinated'**
  String get vaccinated;

  /// No description provided for @landArea.
  ///
  /// In en, this message translates to:
  /// **'Land area'**
  String get landArea;

  /// No description provided for @waterFacility.
  ///
  /// In en, this message translates to:
  /// **'Water facility'**
  String get waterFacility;

  /// No description provided for @electricityAvailable.
  ///
  /// In en, this message translates to:
  /// **'Electricity available'**
  String get electricityAvailable;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @hoursUsed.
  ///
  /// In en, this message translates to:
  /// **'Hours used'**
  String get hoursUsed;

  /// No description provided for @serviceHistory.
  ///
  /// In en, this message translates to:
  /// **'Service history'**
  String get serviceHistory;

  /// No description provided for @loanAvailable.
  ///
  /// In en, this message translates to:
  /// **'Loan available'**
  String get loanAvailable;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Login to your account'**
  String get loginSubtitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @loginToContinue.
  ///
  /// In en, this message translates to:
  /// **'Login to continue'**
  String get loginToContinue;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter mobile number'**
  String get enterMobileNumber;

  /// No description provided for @verifyYourMobile.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Mobile'**
  String get verifyYourMobile;

  /// No description provided for @verifyAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Verify & Continue'**
  String get verifyAndContinue;

  /// No description provided for @infoSafeWithUs.
  ///
  /// In en, this message translates to:
  /// **'Your information is safe with us'**
  String get infoSafeWithUs;

  /// No description provided for @farmersTagline.
  ///
  /// In en, this message translates to:
  /// **'From Farmers, For Farmers'**
  String get farmersTagline;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit OTP we sent'**
  String get otpSubtitle;

  /// No description provided for @otpNotReceived.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get OTP?'**
  String get otpNotReceived;

  /// No description provided for @defaultLocation.
  ///
  /// In en, this message translates to:
  /// **'Aurangabad, Maharashtra'**
  String get defaultLocation;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search (e.g. tractor, crops...)'**
  String get searchPlaceholder;

  /// No description provided for @bannerTractorTitle.
  ///
  /// In en, this message translates to:
  /// **'Tractor Buy & Sell'**
  String get bannerTractorTitle;

  /// No description provided for @bannerTractorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Easy and reliable'**
  String get bannerTractorSubtitle;

  /// No description provided for @searchNow.
  ///
  /// In en, this message translates to:
  /// **'Search now'**
  String get searchNow;

  /// No description provided for @categoryMachinery.
  ///
  /// In en, this message translates to:
  /// **'Machinery'**
  String get categoryMachinery;

  /// No description provided for @categoryFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer & Seeds'**
  String get categoryFertilizer;

  /// No description provided for @myAds.
  ///
  /// In en, this message translates to:
  /// **'My Ads'**
  String get myAds;

  /// No description provided for @dealers.
  ///
  /// In en, this message translates to:
  /// **'Dealers'**
  String get dealers;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @categoryRentOut.
  ///
  /// In en, this message translates to:
  /// **'For Rent'**
  String get categoryRentOut;

  /// No description provided for @nearbyAds.
  ///
  /// In en, this message translates to:
  /// **'Nearby Ads'**
  String get nearbyAds;

  /// No description provided for @postAd.
  ///
  /// In en, this message translates to:
  /// **'Post Ad'**
  String get postAd;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'98 7654 3210'**
  String get phoneHint;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Mobile number is required'**
  String get phoneRequired;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter valid 10-digit mobile number'**
  String get phoneInvalid;

  /// No description provided for @orText.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orText;

  /// No description provided for @googleLogin.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get googleLogin;

  /// No description provided for @newUser.
  ///
  /// In en, this message translates to:
  /// **'New here?'**
  String get newUser;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your KrishiX account'**
  String get registerSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNameHint;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get fullNameRequired;

  /// No description provided for @phoneAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This number is already registered. Please login.'**
  String get phoneAlreadyRegistered;

  /// No description provided for @phoneNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'This number is not registered. Please register first.'**
  String get phoneNotRegistered;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @loginNow.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginNow;

  /// No description provided for @selectLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get selectLanguageTitle;

  /// No description provided for @selectLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select the language you are most comfortable with. You can change it anytime in Profile.'**
  String get selectLanguageSubtitle;

  /// No description provided for @confirmLanguage.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get confirmLanguage;

  /// No description provided for @allProducts.
  ///
  /// In en, this message translates to:
  /// **'All Products'**
  String get allProducts;

  /// No description provided for @allowLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Show nearby products?'**
  String get allowLocationTitle;

  /// No description provided for @allowLocationMessage.
  ///
  /// In en, this message translates to:
  /// **'Allow location to see tractors, crops and livestock near your village.'**
  String get allowLocationMessage;

  /// No description provided for @loadingMore.
  ///
  /// In en, this message translates to:
  /// **'Loading more products...'**
  String get loadingMore;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @getVerifiedBadge.
  ///
  /// In en, this message translates to:
  /// **'Get Verified'**
  String get getVerifiedBadge;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @mobileNumberHint.
  ///
  /// In en, this message translates to:
  /// **'10-digit mobile number'**
  String get mobileNumberHint;

  /// No description provided for @mobileNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit number'**
  String get mobileNumberInvalid;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// No description provided for @inviteFriends.
  ///
  /// In en, this message translates to:
  /// **'Invite your friends to KrishiX'**
  String get inviteFriends;

  /// No description provided for @kmAway.
  ///
  /// In en, this message translates to:
  /// **'{distance} km away'**
  String kmAway(String distance);

  /// No description provided for @farm_machinery.
  ///
  /// In en, this message translates to:
  /// **'Farm Machinery'**
  String get farm_machinery;

  /// No description provided for @tillage_equipment.
  ///
  /// In en, this message translates to:
  /// **'Tillage Equipment'**
  String get tillage_equipment;

  /// No description provided for @plough.
  ///
  /// In en, this message translates to:
  /// **'Plough'**
  String get plough;

  /// No description provided for @cultivator.
  ///
  /// In en, this message translates to:
  /// **'Cultivator'**
  String get cultivator;

  /// No description provided for @rotavator.
  ///
  /// In en, this message translates to:
  /// **'Rotavator'**
  String get rotavator;

  /// No description provided for @harrow.
  ///
  /// In en, this message translates to:
  /// **'Harrow'**
  String get harrow;

  /// No description provided for @sowing_planting.
  ///
  /// In en, this message translates to:
  /// **'Sowing & Planting'**
  String get sowing_planting;

  /// No description provided for @seed_drill.
  ///
  /// In en, this message translates to:
  /// **'Seed Drill'**
  String get seed_drill;

  /// No description provided for @planter.
  ///
  /// In en, this message translates to:
  /// **'Planter'**
  String get planter;

  /// No description provided for @transplanter.
  ///
  /// In en, this message translates to:
  /// **'Transplanter'**
  String get transplanter;

  /// No description provided for @harvesting.
  ///
  /// In en, this message translates to:
  /// **'Harvesting'**
  String get harvesting;

  /// No description provided for @harvester.
  ///
  /// In en, this message translates to:
  /// **'Harvester'**
  String get harvester;

  /// No description provided for @thresher.
  ///
  /// In en, this message translates to:
  /// **'Thresher'**
  String get thresher;

  /// No description provided for @reaper.
  ///
  /// In en, this message translates to:
  /// **'Reaper'**
  String get reaper;

  /// No description provided for @chaff_cutter.
  ///
  /// In en, this message translates to:
  /// **'Chaff Cutter'**
  String get chaff_cutter;

  /// No description provided for @power_irrigation.
  ///
  /// In en, this message translates to:
  /// **'Power & Irrigation'**
  String get power_irrigation;

  /// No description provided for @power_tiller.
  ///
  /// In en, this message translates to:
  /// **'Power Tiller'**
  String get power_tiller;

  /// No description provided for @generator.
  ///
  /// In en, this message translates to:
  /// **'Generator'**
  String get generator;

  /// No description provided for @pump_set.
  ///
  /// In en, this message translates to:
  /// **'Pump Set'**
  String get pump_set;

  /// No description provided for @sprayer.
  ///
  /// In en, this message translates to:
  /// **'Sprayer'**
  String get sprayer;

  /// No description provided for @fruits_vegetables.
  ///
  /// In en, this message translates to:
  /// **'Fruits & Vegetables'**
  String get fruits_vegetables;

  /// No description provided for @vegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get vegetables;

  /// No description provided for @onion.
  ///
  /// In en, this message translates to:
  /// **'Onion'**
  String get onion;

  /// No description provided for @tomato.
  ///
  /// In en, this message translates to:
  /// **'Tomato'**
  String get tomato;

  /// No description provided for @potato.
  ///
  /// In en, this message translates to:
  /// **'Potato'**
  String get potato;

  /// No description provided for @garlic.
  ///
  /// In en, this message translates to:
  /// **'Garlic'**
  String get garlic;

  /// No description provided for @chilli.
  ///
  /// In en, this message translates to:
  /// **'Chilli'**
  String get chilli;

  /// No description provided for @brinjal.
  ///
  /// In en, this message translates to:
  /// **'Brinjal'**
  String get brinjal;

  /// No description provided for @cabbage.
  ///
  /// In en, this message translates to:
  /// **'Cabbage'**
  String get cabbage;

  /// No description provided for @cauliflower.
  ///
  /// In en, this message translates to:
  /// **'Cauliflower'**
  String get cauliflower;

  /// No description provided for @okra.
  ///
  /// In en, this message translates to:
  /// **'Okra'**
  String get okra;

  /// No description provided for @cucumber.
  ///
  /// In en, this message translates to:
  /// **'Cucumber'**
  String get cucumber;

  /// No description provided for @fruits.
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get fruits;

  /// No description provided for @mango.
  ///
  /// In en, this message translates to:
  /// **'Mango'**
  String get mango;

  /// No description provided for @banana.
  ///
  /// In en, this message translates to:
  /// **'Banana'**
  String get banana;

  /// No description provided for @pomegranate.
  ///
  /// In en, this message translates to:
  /// **'Pomegranate'**
  String get pomegranate;

  /// No description provided for @orange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get orange;

  /// No description provided for @grapes.
  ///
  /// In en, this message translates to:
  /// **'Grapes'**
  String get grapes;

  /// No description provided for @papaya.
  ///
  /// In en, this message translates to:
  /// **'Papaya'**
  String get papaya;

  /// No description provided for @guava.
  ///
  /// In en, this message translates to:
  /// **'Guava'**
  String get guava;

  /// No description provided for @watermelon.
  ///
  /// In en, this message translates to:
  /// **'Watermelon'**
  String get watermelon;

  /// No description provided for @sweet_lime.
  ///
  /// In en, this message translates to:
  /// **'Sweet Lime'**
  String get sweet_lime;

  /// No description provided for @livestock.
  ///
  /// In en, this message translates to:
  /// **'Livestock'**
  String get livestock;

  /// No description provided for @dairy_animals.
  ///
  /// In en, this message translates to:
  /// **'Dairy Animals'**
  String get dairy_animals;

  /// No description provided for @cow.
  ///
  /// In en, this message translates to:
  /// **'Cow'**
  String get cow;

  /// No description provided for @buffalo.
  ///
  /// In en, this message translates to:
  /// **'Buffalo'**
  String get buffalo;

  /// No description provided for @bull.
  ///
  /// In en, this message translates to:
  /// **'Bull'**
  String get bull;

  /// No description provided for @small_animals.
  ///
  /// In en, this message translates to:
  /// **'Small Animals'**
  String get small_animals;

  /// No description provided for @goat.
  ///
  /// In en, this message translates to:
  /// **'Goat'**
  String get goat;

  /// No description provided for @sheep.
  ///
  /// In en, this message translates to:
  /// **'Sheep'**
  String get sheep;

  /// No description provided for @poultry.
  ///
  /// In en, this message translates to:
  /// **'Poultry'**
  String get poultry;

  /// No description provided for @chicken.
  ///
  /// In en, this message translates to:
  /// **'Chicken'**
  String get chicken;

  /// No description provided for @duck.
  ///
  /// In en, this message translates to:
  /// **'Duck'**
  String get duck;

  /// No description provided for @turkey.
  ///
  /// In en, this message translates to:
  /// **'Turkey'**
  String get turkey;

  /// No description provided for @quail.
  ///
  /// In en, this message translates to:
  /// **'Quail'**
  String get quail;

  /// No description provided for @other_animals.
  ///
  /// In en, this message translates to:
  /// **'Other Animals'**
  String get other_animals;

  /// No description provided for @horse.
  ///
  /// In en, this message translates to:
  /// **'Horse'**
  String get horse;

  /// No description provided for @camel.
  ///
  /// In en, this message translates to:
  /// **'Camel'**
  String get camel;

  /// No description provided for @rabbit.
  ///
  /// In en, this message translates to:
  /// **'Rabbit'**
  String get rabbit;

  /// No description provided for @livestock_products.
  ///
  /// In en, this message translates to:
  /// **'Livestock Products'**
  String get livestock_products;

  /// No description provided for @milk_animals.
  ///
  /// In en, this message translates to:
  /// **'Milk Animals'**
  String get milk_animals;

  /// No description provided for @breeding_animals.
  ///
  /// In en, this message translates to:
  /// **'Breeding Animals'**
  String get breeding_animals;

  /// No description provided for @organic_manure.
  ///
  /// In en, this message translates to:
  /// **'Organic Manure'**
  String get organic_manure;

  /// No description provided for @farm_land.
  ///
  /// In en, this message translates to:
  /// **'Farm Land'**
  String get farm_land;

  /// No description provided for @land_for_sale.
  ///
  /// In en, this message translates to:
  /// **'Land For Sale'**
  String get land_for_sale;

  /// No description provided for @agricultural_land.
  ///
  /// In en, this message translates to:
  /// **'Agricultural Land'**
  String get agricultural_land;

  /// No description provided for @farm_house_land.
  ///
  /// In en, this message translates to:
  /// **'Farm House Land'**
  String get farm_house_land;

  /// No description provided for @orchard_land.
  ///
  /// In en, this message translates to:
  /// **'Orchard Land'**
  String get orchard_land;

  /// No description provided for @land_for_lease.
  ///
  /// In en, this message translates to:
  /// **'Land For Lease'**
  String get land_for_lease;

  /// No description provided for @short_term_lease.
  ///
  /// In en, this message translates to:
  /// **'Short Term Lease'**
  String get short_term_lease;

  /// No description provided for @long_term_lease.
  ///
  /// In en, this message translates to:
  /// **'Long Term Lease'**
  String get long_term_lease;

  /// No description provided for @farming_partnerships.
  ///
  /// In en, this message translates to:
  /// **'Farming Partnerships'**
  String get farming_partnerships;

  /// No description provided for @contract_farming.
  ///
  /// In en, this message translates to:
  /// **'Contract Farming'**
  String get contract_farming;

  /// No description provided for @partnership_farming.
  ///
  /// In en, this message translates to:
  /// **'Partnership Farming'**
  String get partnership_farming;

  /// No description provided for @revenue_sharing_farming.
  ///
  /// In en, this message translates to:
  /// **'Revenue Sharing Farming'**
  String get revenue_sharing_farming;

  /// No description provided for @rentals.
  ///
  /// In en, this message translates to:
  /// **'Rentals'**
  String get rentals;

  /// No description provided for @tractor_rental.
  ///
  /// In en, this message translates to:
  /// **'Tractor Rental'**
  String get tractor_rental;

  /// No description provided for @hourly.
  ///
  /// In en, this message translates to:
  /// **'Hourly'**
  String get hourly;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @seasonal.
  ///
  /// In en, this message translates to:
  /// **'Seasonal'**
  String get seasonal;

  /// No description provided for @machinery_rental.
  ///
  /// In en, this message translates to:
  /// **'Machinery Rental'**
  String get machinery_rental;

  /// No description provided for @seeder.
  ///
  /// In en, this message translates to:
  /// **'Seeder'**
  String get seeder;

  /// No description provided for @labour_services.
  ///
  /// In en, this message translates to:
  /// **'Labour Services'**
  String get labour_services;

  /// No description provided for @harvest_labour.
  ///
  /// In en, this message translates to:
  /// **'Harvest Labour'**
  String get harvest_labour;

  /// No description provided for @plantation_labour.
  ///
  /// In en, this message translates to:
  /// **'Plantation Labour'**
  String get plantation_labour;

  /// No description provided for @irrigation_labour.
  ///
  /// In en, this message translates to:
  /// **'Irrigation Labour'**
  String get irrigation_labour;

  /// No description provided for @seeds_and_plants.
  ///
  /// In en, this message translates to:
  /// **'Seeds & Plants'**
  String get seeds_and_plants;

  /// No description provided for @wheat_seeds.
  ///
  /// In en, this message translates to:
  /// **'Wheat Seeds'**
  String get wheat_seeds;

  /// No description provided for @soybean_seeds.
  ///
  /// In en, this message translates to:
  /// **'Soybean Seeds'**
  String get soybean_seeds;

  /// No description provided for @cotton_seeds.
  ///
  /// In en, this message translates to:
  /// **'Cotton Seeds'**
  String get cotton_seeds;

  /// No description provided for @vegetable_seeds.
  ///
  /// In en, this message translates to:
  /// **'Vegetable Seeds'**
  String get vegetable_seeds;

  /// No description provided for @plants.
  ///
  /// In en, this message translates to:
  /// **'Plants'**
  String get plants;

  /// No description provided for @fruit_plants.
  ///
  /// In en, this message translates to:
  /// **'Fruit Plants'**
  String get fruit_plants;

  /// No description provided for @nursery_plants.
  ///
  /// In en, this message translates to:
  /// **'Nursery Plants'**
  String get nursery_plants;

  /// No description provided for @tissue_culture_plants.
  ///
  /// In en, this message translates to:
  /// **'Tissue Culture Plants'**
  String get tissue_culture_plants;

  /// No description provided for @land_preparation.
  ///
  /// In en, this message translates to:
  /// **'Land Preparation'**
  String get land_preparation;

  /// No description provided for @disc_harrow.
  ///
  /// In en, this message translates to:
  /// **'Disc Harrow'**
  String get disc_harrow;

  /// No description provided for @subsoiler.
  ///
  /// In en, this message translates to:
  /// **'Subsoiler'**
  String get subsoiler;

  /// No description provided for @ridger.
  ///
  /// In en, this message translates to:
  /// **'Ridger'**
  String get ridger;

  /// No description provided for @sowing_equipment.
  ///
  /// In en, this message translates to:
  /// **'Sowing Equipment'**
  String get sowing_equipment;

  /// No description provided for @paddy_seeder.
  ///
  /// In en, this message translates to:
  /// **'Paddy Seeder'**
  String get paddy_seeder;

  /// No description provided for @fertilizer_drill.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer Drill'**
  String get fertilizer_drill;

  /// No description provided for @crop_protection.
  ///
  /// In en, this message translates to:
  /// **'Crop Protection'**
  String get crop_protection;

  /// No description provided for @power_sprayer.
  ///
  /// In en, this message translates to:
  /// **'Power Sprayer'**
  String get power_sprayer;

  /// No description provided for @battery_sprayer.
  ///
  /// In en, this message translates to:
  /// **'Battery Sprayer'**
  String get battery_sprayer;

  /// No description provided for @boom_sprayer.
  ///
  /// In en, this message translates to:
  /// **'Boom Sprayer'**
  String get boom_sprayer;

  /// No description provided for @fogging_machine.
  ///
  /// In en, this message translates to:
  /// **'Fogging Machine'**
  String get fogging_machine;

  /// No description provided for @harvesting_equipment.
  ///
  /// In en, this message translates to:
  /// **'Harvesting Equipment'**
  String get harvesting_equipment;

  /// No description provided for @mini_harvester.
  ///
  /// In en, this message translates to:
  /// **'Mini Harvester'**
  String get mini_harvester;

  /// No description provided for @combine_harvester.
  ///
  /// In en, this message translates to:
  /// **'Combine Harvester'**
  String get combine_harvester;

  /// No description provided for @post_harvest.
  ///
  /// In en, this message translates to:
  /// **'Post Harvest'**
  String get post_harvest;

  /// No description provided for @baler.
  ///
  /// In en, this message translates to:
  /// **'Baler'**
  String get baler;

  /// No description provided for @grain_cleaner.
  ///
  /// In en, this message translates to:
  /// **'Grain Cleaner'**
  String get grain_cleaner;

  /// No description provided for @winnower.
  ///
  /// In en, this message translates to:
  /// **'Winnower'**
  String get winnower;

  /// No description provided for @irrigation_equipment.
  ///
  /// In en, this message translates to:
  /// **'Irrigation Equipment'**
  String get irrigation_equipment;

  /// No description provided for @water_pump.
  ///
  /// In en, this message translates to:
  /// **'Water Pump'**
  String get water_pump;

  /// No description provided for @solar_pump.
  ///
  /// In en, this message translates to:
  /// **'Solar Pump'**
  String get solar_pump;

  /// No description provided for @drip_system.
  ///
  /// In en, this message translates to:
  /// **'Drip System'**
  String get drip_system;

  /// No description provided for @sprinkler_system.
  ///
  /// In en, this message translates to:
  /// **'Sprinkler System'**
  String get sprinkler_system;

  /// No description provided for @power_equipment.
  ///
  /// In en, this message translates to:
  /// **'Power Equipment'**
  String get power_equipment;

  /// No description provided for @power_weeder.
  ///
  /// In en, this message translates to:
  /// **'Power Weeder'**
  String get power_weeder;

  /// No description provided for @mini_tiller.
  ///
  /// In en, this message translates to:
  /// **'Mini Tiller'**
  String get mini_tiller;

  /// No description provided for @tractors.
  ///
  /// In en, this message translates to:
  /// **'Tractors'**
  String get tractors;

  /// No description provided for @used_tractors.
  ///
  /// In en, this message translates to:
  /// **'Used Tractors'**
  String get used_tractors;

  /// No description provided for @under_20_hp.
  ///
  /// In en, this message translates to:
  /// **'Under 20 HP'**
  String get under_20_hp;

  /// No description provided for @hp_21_30.
  ///
  /// In en, this message translates to:
  /// **'21–30 HP'**
  String get hp_21_30;

  /// No description provided for @hp_31_40.
  ///
  /// In en, this message translates to:
  /// **'31–40 HP'**
  String get hp_31_40;

  /// No description provided for @hp_41_50.
  ///
  /// In en, this message translates to:
  /// **'41–50 HP'**
  String get hp_41_50;

  /// No description provided for @hp_51_60.
  ///
  /// In en, this message translates to:
  /// **'51–60 HP'**
  String get hp_51_60;

  /// No description provided for @above_60_hp.
  ///
  /// In en, this message translates to:
  /// **'Above 60 HP'**
  String get above_60_hp;

  /// No description provided for @tractor_brands.
  ///
  /// In en, this message translates to:
  /// **'Tractor Brands'**
  String get tractor_brands;

  /// No description provided for @mahindra.
  ///
  /// In en, this message translates to:
  /// **'Mahindra'**
  String get mahindra;

  /// No description provided for @swaraj.
  ///
  /// In en, this message translates to:
  /// **'Swaraj'**
  String get swaraj;

  /// No description provided for @john_deere.
  ///
  /// In en, this message translates to:
  /// **'John Deere'**
  String get john_deere;

  /// No description provided for @sonalika.
  ///
  /// In en, this message translates to:
  /// **'Sonalika'**
  String get sonalika;

  /// No description provided for @new_holland.
  ///
  /// In en, this message translates to:
  /// **'New Holland'**
  String get new_holland;

  /// No description provided for @eicher.
  ///
  /// In en, this message translates to:
  /// **'Eicher'**
  String get eicher;

  /// No description provided for @massey_ferguson.
  ///
  /// In en, this message translates to:
  /// **'Massey Ferguson'**
  String get massey_ferguson;

  /// No description provided for @kubota.
  ///
  /// In en, this message translates to:
  /// **'Kubota'**
  String get kubota;

  /// No description provided for @escorts.
  ///
  /// In en, this message translates to:
  /// **'Escorts'**
  String get escorts;

  /// No description provided for @powertrac.
  ///
  /// In en, this message translates to:
  /// **'Powertrac'**
  String get powertrac;

  /// No description provided for @same_deutz_fahr.
  ///
  /// In en, this message translates to:
  /// **'Same Deutz Fahr'**
  String get same_deutz_fahr;

  /// No description provided for @preet.
  ///
  /// In en, this message translates to:
  /// **'Preet'**
  String get preet;

  /// No description provided for @tractor_parts.
  ///
  /// In en, this message translates to:
  /// **'Tractor Parts'**
  String get tractor_parts;

  /// No description provided for @tyres.
  ///
  /// In en, this message translates to:
  /// **'Tyres'**
  String get tyres;

  /// No description provided for @batteries.
  ///
  /// In en, this message translates to:
  /// **'Batteries'**
  String get batteries;

  /// No description provided for @hydraulic_parts.
  ///
  /// In en, this message translates to:
  /// **'Hydraulic Parts'**
  String get hydraulic_parts;

  /// No description provided for @pto_parts.
  ///
  /// In en, this message translates to:
  /// **'PTO Parts'**
  String get pto_parts;

  /// No description provided for @engine_parts.
  ///
  /// In en, this message translates to:
  /// **'Engine Parts'**
  String get engine_parts;

  /// No description provided for @tractor_seats.
  ///
  /// In en, this message translates to:
  /// **'Tractor Seats'**
  String get tractor_seats;

  /// No description provided for @cereals.
  ///
  /// In en, this message translates to:
  /// **'Cereals'**
  String get cereals;

  /// No description provided for @pulses.
  ///
  /// In en, this message translates to:
  /// **'Pulses'**
  String get pulses;

  /// No description provided for @oil_seeds.
  ///
  /// In en, this message translates to:
  /// **'Oil Seeds'**
  String get oil_seeds;

  /// No description provided for @commercial_crops.
  ///
  /// In en, this message translates to:
  /// **'Commercial Crops'**
  String get commercial_crops;

  /// No description provided for @wheat.
  ///
  /// In en, this message translates to:
  /// **'Wheat'**
  String get wheat;

  /// No description provided for @rice.
  ///
  /// In en, this message translates to:
  /// **'Rice'**
  String get rice;

  /// No description provided for @maize.
  ///
  /// In en, this message translates to:
  /// **'Maize'**
  String get maize;

  /// No description provided for @jowar.
  ///
  /// In en, this message translates to:
  /// **'Jowar'**
  String get jowar;

  /// No description provided for @bajra.
  ///
  /// In en, this message translates to:
  /// **'Bajra'**
  String get bajra;

  /// No description provided for @barley.
  ///
  /// In en, this message translates to:
  /// **'Barley'**
  String get barley;

  /// No description provided for @tur.
  ///
  /// In en, this message translates to:
  /// **'Tur'**
  String get tur;

  /// No description provided for @chana.
  ///
  /// In en, this message translates to:
  /// **'Chana'**
  String get chana;

  /// No description provided for @moong.
  ///
  /// In en, this message translates to:
  /// **'Moong'**
  String get moong;

  /// No description provided for @udid.
  ///
  /// In en, this message translates to:
  /// **'Udid'**
  String get udid;

  /// No description provided for @masoor.
  ///
  /// In en, this message translates to:
  /// **'Masoor'**
  String get masoor;

  /// No description provided for @soybean.
  ///
  /// In en, this message translates to:
  /// **'Soybean'**
  String get soybean;

  /// No description provided for @groundnut.
  ///
  /// In en, this message translates to:
  /// **'Groundnut'**
  String get groundnut;

  /// No description provided for @mustard.
  ///
  /// In en, this message translates to:
  /// **'Mustard'**
  String get mustard;

  /// No description provided for @sunflower.
  ///
  /// In en, this message translates to:
  /// **'Sunflower'**
  String get sunflower;

  /// No description provided for @sesame.
  ///
  /// In en, this message translates to:
  /// **'Sesame'**
  String get sesame;

  /// No description provided for @cotton.
  ///
  /// In en, this message translates to:
  /// **'Cotton'**
  String get cotton;

  /// No description provided for @sugarcane.
  ///
  /// In en, this message translates to:
  /// **'Sugarcane'**
  String get sugarcane;

  /// No description provided for @tobacco.
  ///
  /// In en, this message translates to:
  /// **'Tobacco'**
  String get tobacco;

  /// No description provided for @horse_power_hp.
  ///
  /// In en, this message translates to:
  /// **'Horse Power (HP)'**
  String get horse_power_hp;

  /// No description provided for @drone.
  ///
  /// In en, this message translates to:
  /// **'Drone'**
  String get drone;

  /// No description provided for @drone_harvester.
  ///
  /// In en, this message translates to:
  /// **'Drone Harvester'**
  String get drone_harvester;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @lease.
  ///
  /// In en, this message translates to:
  /// **'Lease Land'**
  String get lease;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// No description provided for @allBuyCategories.
  ///
  /// In en, this message translates to:
  /// **'All Buy Categories'**
  String get allBuyCategories;

  /// No description provided for @allRentCategories.
  ///
  /// In en, this message translates to:
  /// **'All Rent Categories'**
  String get allRentCategories;

  /// No description provided for @services_coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Services Coming Soon'**
  String get services_coming_soon;

  /// No description provided for @services_coming_soon_subtitle.
  ///
  /// In en, this message translates to:
  /// **'We are working on bringing farming services to you. Stay tuned!'**
  String get services_coming_soon_subtitle;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'gu', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'gu': return AppLocalizationsGu();
    case 'hi': return AppLocalizationsHi();
    case 'mr': return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
