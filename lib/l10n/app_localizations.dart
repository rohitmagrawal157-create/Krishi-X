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

  /// Veg - Onion
  ///
  /// In en, this message translates to:
  /// **'Onion'**
  String get onion;

  /// No description provided for @tomato.
  ///
  /// In en, this message translates to:
  /// **'Tomato'**
  String get tomato;

  /// Veg - Potato
  ///
  /// In en, this message translates to:
  /// **'Potato'**
  String get potato;

  /// Crop - Garlic
  ///
  /// In en, this message translates to:
  /// **'Garlic'**
  String get garlic;

  /// Crop - Chilli
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

  /// Veg - Okra
  ///
  /// In en, this message translates to:
  /// **'Okra'**
  String get okra;

  /// Veg - Cucumber
  ///
  /// In en, this message translates to:
  /// **'Cucumber'**
  String get cucumber;

  /// No description provided for @fruits.
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get fruits;

  /// Fruit - Mango
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

  /// Fruit - Papaya
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

  /// Seeds & Plants section title
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

  /// Group - Vegetable Seeds
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

  /// Plants - Nursery
  ///
  /// In en, this message translates to:
  /// **'Nursery Plants'**
  String get nursery_plants;

  /// Plants - Tissue Culture
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

  /// Group - Oil Seeds
  ///
  /// In en, this message translates to:
  /// **'Oil Seeds'**
  String get oil_seeds;

  /// No description provided for @commercial_crops.
  ///
  /// In en, this message translates to:
  /// **'Commercial Crops'**
  String get commercial_crops;

  /// Crop - Wheat
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

  /// Crop - Soybean
  ///
  /// In en, this message translates to:
  /// **'Soybean'**
  String get soybean;

  /// Crop - Groundnut
  ///
  /// In en, this message translates to:
  /// **'Groundnut'**
  String get groundnut;

  /// Crop - Mustard
  ///
  /// In en, this message translates to:
  /// **'Mustard'**
  String get mustard;

  /// No description provided for @sunflower.
  ///
  /// In en, this message translates to:
  /// **'Sunflower'**
  String get sunflower;

  /// Crop - Sesame
  ///
  /// In en, this message translates to:
  /// **'Sesame'**
  String get sesame;

  /// Crop - Cotton
  ///
  /// In en, this message translates to:
  /// **'Cotton'**
  String get cotton;

  /// Crop - Sugarcane
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

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortNewest;

  /// No description provided for @sortPriceLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get sortPriceLowToHigh;

  /// No description provided for @sortPriceHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get sortPriceHighToLow;

  /// No description provided for @filterDealType.
  ///
  /// In en, this message translates to:
  /// **'Deal Type'**
  String get filterDealType;

  /// No description provided for @filterPriceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get filterPriceRange;

  /// No description provided for @filterBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get filterBrand;

  /// No description provided for @filterHpRange.
  ///
  /// In en, this message translates to:
  /// **'HP Range'**
  String get filterHpRange;

  /// No description provided for @filterCondition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get filterCondition;

  /// No description provided for @filterAnimalType.
  ///
  /// In en, this message translates to:
  /// **'Animal Type'**
  String get filterAnimalType;

  /// No description provided for @filterBreed.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get filterBreed;

  /// No description provided for @filterAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get filterAge;

  /// No description provided for @filterMilkYield.
  ///
  /// In en, this message translates to:
  /// **'Milk Yield / Day'**
  String get filterMilkYield;

  /// No description provided for @filterColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get filterColor;

  /// No description provided for @filterArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get filterArea;

  /// No description provided for @filterSoilType.
  ///
  /// In en, this message translates to:
  /// **'Soil Type'**
  String get filterSoilType;

  /// No description provided for @filterWaterSource.
  ///
  /// In en, this message translates to:
  /// **'Water Source'**
  String get filterWaterSource;

  /// No description provided for @filterLegalDeed.
  ///
  /// In en, this message translates to:
  /// **'Legal / Deed'**
  String get filterLegalDeed;

  /// No description provided for @filterCropType.
  ///
  /// In en, this message translates to:
  /// **'Crop Type'**
  String get filterCropType;

  /// No description provided for @filterQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get filterQuantity;

  /// No description provided for @filterGrade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get filterGrade;

  /// No description provided for @filterHarvest.
  ///
  /// In en, this message translates to:
  /// **'Harvest'**
  String get filterHarvest;

  /// No description provided for @filterProduceType.
  ///
  /// In en, this message translates to:
  /// **'Produce Type'**
  String get filterProduceType;

  /// No description provided for @filterSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get filterSize;

  /// No description provided for @filterFreshness.
  ///
  /// In en, this message translates to:
  /// **'Freshness'**
  String get filterFreshness;

  /// No description provided for @filterEquipmentType.
  ///
  /// In en, this message translates to:
  /// **'Equipment Type'**
  String get filterEquipmentType;

  /// No description provided for @filterRentalDuration.
  ///
  /// In en, this message translates to:
  /// **'Rental Duration'**
  String get filterRentalDuration;

  /// No description provided for @filterVerifiedOnly.
  ///
  /// In en, this message translates to:
  /// **'Verified Sellers Only'**
  String get filterVerifiedOnly;

  /// No description provided for @filterNearbyOnly.
  ///
  /// In en, this message translates to:
  /// **'Nearby Only'**
  String get filterNearbyOnly;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @filtersCount.
  ///
  /// In en, this message translates to:
  /// **'Filters ({count})'**
  String filtersCount(String count);

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @forSale.
  ///
  /// In en, this message translates to:
  /// **'For Sale'**
  String get forSale;

  /// No description provided for @forRent.
  ///
  /// In en, this message translates to:
  /// **'For Rent'**
  String get forRent;

  /// No description provided for @conditionNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get conditionNew;

  /// No description provided for @conditionUsed.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get conditionUsed;

  /// No description provided for @hpUnder20.
  ///
  /// In en, this message translates to:
  /// **'Under 20 HP'**
  String get hpUnder20;

  /// No description provided for @hp2130.
  ///
  /// In en, this message translates to:
  /// **'21–30 HP'**
  String get hp2130;

  /// No description provided for @hp3140.
  ///
  /// In en, this message translates to:
  /// **'31–40 HP'**
  String get hp3140;

  /// No description provided for @hp4150.
  ///
  /// In en, this message translates to:
  /// **'41–50 HP'**
  String get hp4150;

  /// No description provided for @hp5160.
  ///
  /// In en, this message translates to:
  /// **'51–60 HP'**
  String get hp5160;

  /// No description provided for @hpAbove60.
  ///
  /// In en, this message translates to:
  /// **'Above 60 HP'**
  String get hpAbove60;

  /// No description provided for @animalHenPoultry.
  ///
  /// In en, this message translates to:
  /// **'Hen / Poultry'**
  String get animalHenPoultry;

  /// No description provided for @animalOxBullock.
  ///
  /// In en, this message translates to:
  /// **'Ox / Bullock'**
  String get animalOxBullock;

  /// No description provided for @animalPig.
  ///
  /// In en, this message translates to:
  /// **'Pig'**
  String get animalPig;

  /// No description provided for @breedGir.
  ///
  /// In en, this message translates to:
  /// **'Gir'**
  String get breedGir;

  /// No description provided for @breedSahiwal.
  ///
  /// In en, this message translates to:
  /// **'Sahiwal'**
  String get breedSahiwal;

  /// No description provided for @breedMurrah.
  ///
  /// In en, this message translates to:
  /// **'Murrah'**
  String get breedMurrah;

  /// No description provided for @breedHF.
  ///
  /// In en, this message translates to:
  /// **'HF / Holstein'**
  String get breedHF;

  /// No description provided for @breedJersey.
  ///
  /// In en, this message translates to:
  /// **'Jersey'**
  String get breedJersey;

  /// No description provided for @breedOsmanabadi.
  ///
  /// In en, this message translates to:
  /// **'Osmanabadi'**
  String get breedOsmanabadi;

  /// No description provided for @breedSangamneri.
  ///
  /// In en, this message translates to:
  /// **'Sangamneri'**
  String get breedSangamneri;

  /// No description provided for @breedOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get breedOther;

  /// No description provided for @age01Year.
  ///
  /// In en, this message translates to:
  /// **'0–1 year'**
  String get age01Year;

  /// No description provided for @age13Years.
  ///
  /// In en, this message translates to:
  /// **'1–3 years'**
  String get age13Years;

  /// No description provided for @age36Years.
  ///
  /// In en, this message translates to:
  /// **'3–6 years'**
  String get age36Years;

  /// No description provided for @ageAbove6.
  ///
  /// In en, this message translates to:
  /// **'Above 6 years'**
  String get ageAbove6;

  /// No description provided for @milk05.
  ///
  /// In en, this message translates to:
  /// **'0–5 L/day'**
  String get milk05;

  /// No description provided for @milk510.
  ///
  /// In en, this message translates to:
  /// **'5–10 L/day'**
  String get milk510;

  /// No description provided for @milk1015.
  ///
  /// In en, this message translates to:
  /// **'10–15 L/day'**
  String get milk1015;

  /// No description provided for @milkAbove15.
  ///
  /// In en, this message translates to:
  /// **'Above 15 L/day'**
  String get milkAbove15;

  /// No description provided for @colorBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get colorBlack;

  /// No description provided for @colorWhite.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get colorWhite;

  /// No description provided for @colorBrown.
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get colorBrown;

  /// No description provided for @colorBlackWhite.
  ///
  /// In en, this message translates to:
  /// **'Black & White'**
  String get colorBlackWhite;

  /// No description provided for @colorGrey.
  ///
  /// In en, this message translates to:
  /// **'Grey'**
  String get colorGrey;

  /// No description provided for @colorMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get colorMixed;

  /// No description provided for @areaUnder1Acre.
  ///
  /// In en, this message translates to:
  /// **'Under 1 Acre'**
  String get areaUnder1Acre;

  /// No description provided for @area13Acres.
  ///
  /// In en, this message translates to:
  /// **'1–3 Acres'**
  String get area13Acres;

  /// No description provided for @area35Acres.
  ///
  /// In en, this message translates to:
  /// **'3–5 Acres'**
  String get area35Acres;

  /// No description provided for @area510Acres.
  ///
  /// In en, this message translates to:
  /// **'5–10 Acres'**
  String get area510Acres;

  /// No description provided for @areaAbove10.
  ///
  /// In en, this message translates to:
  /// **'Above 10 Acres'**
  String get areaAbove10;

  /// No description provided for @soilBlack.
  ///
  /// In en, this message translates to:
  /// **'Black Soil'**
  String get soilBlack;

  /// No description provided for @soilRed.
  ///
  /// In en, this message translates to:
  /// **'Red Soil'**
  String get soilRed;

  /// No description provided for @soilAlluvial.
  ///
  /// In en, this message translates to:
  /// **'Alluvial'**
  String get soilAlluvial;

  /// No description provided for @soilLaterite.
  ///
  /// In en, this message translates to:
  /// **'Laterite'**
  String get soilLaterite;

  /// No description provided for @soilSandy.
  ///
  /// In en, this message translates to:
  /// **'Sandy'**
  String get soilSandy;

  /// No description provided for @soilLoamy.
  ///
  /// In en, this message translates to:
  /// **'Loamy'**
  String get soilLoamy;

  /// No description provided for @waterBorewell.
  ///
  /// In en, this message translates to:
  /// **'Borewell'**
  String get waterBorewell;

  /// No description provided for @waterCanal.
  ///
  /// In en, this message translates to:
  /// **'Canal'**
  String get waterCanal;

  /// No description provided for @waterOpenWell.
  ///
  /// In en, this message translates to:
  /// **'Open Well'**
  String get waterOpenWell;

  /// No description provided for @waterTank.
  ///
  /// In en, this message translates to:
  /// **'Tank'**
  String get waterTank;

  /// No description provided for @waterRainfed.
  ///
  /// In en, this message translates to:
  /// **'Rainfed Only'**
  String get waterRainfed;

  /// No description provided for @deed712.
  ///
  /// In en, this message translates to:
  /// **'7/12 Available'**
  String get deed712;

  /// No description provided for @deedClear.
  ///
  /// In en, this message translates to:
  /// **'Clear Title'**
  String get deedClear;

  /// No description provided for @deedLease.
  ///
  /// In en, this message translates to:
  /// **'Lease Land'**
  String get deedLease;

  /// No description provided for @cropTurDal.
  ///
  /// In en, this message translates to:
  /// **'Tur Dal'**
  String get cropTurDal;

  /// No description provided for @qtyUnder100kg.
  ///
  /// In en, this message translates to:
  /// **'Under 100 kg'**
  String get qtyUnder100kg;

  /// No description provided for @qty100500kg.
  ///
  /// In en, this message translates to:
  /// **'100–500 kg'**
  String get qty100500kg;

  /// No description provided for @qty500kg1ton.
  ///
  /// In en, this message translates to:
  /// **'500 kg–1 Ton'**
  String get qty500kg1ton;

  /// No description provided for @qty15tons.
  ///
  /// In en, this message translates to:
  /// **'1–5 Tons'**
  String get qty15tons;

  /// No description provided for @qtyAbove5tons.
  ///
  /// In en, this message translates to:
  /// **'Above 5 Tons'**
  String get qtyAbove5tons;

  /// No description provided for @gradeA.
  ///
  /// In en, this message translates to:
  /// **'Grade A'**
  String get gradeA;

  /// No description provided for @gradeB.
  ///
  /// In en, this message translates to:
  /// **'Grade B'**
  String get gradeB;

  /// No description provided for @gradeC.
  ///
  /// In en, this message translates to:
  /// **'Grade C'**
  String get gradeC;

  /// No description provided for @harvestFreshWeek.
  ///
  /// In en, this message translates to:
  /// **'Fresh (this week)'**
  String get harvestFreshWeek;

  /// No description provided for @harvestThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get harvestThisMonth;

  /// No description provided for @harvestThisSeason.
  ///
  /// In en, this message translates to:
  /// **'This season'**
  String get harvestThisSeason;

  /// No description provided for @harvestStored.
  ///
  /// In en, this message translates to:
  /// **'Stored'**
  String get harvestStored;

  /// No description provided for @produceSpinach.
  ///
  /// In en, this message translates to:
  /// **'Spinach'**
  String get produceSpinach;

  /// No description provided for @sizeSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get sizeSmall;

  /// No description provided for @sizeMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get sizeMedium;

  /// No description provided for @sizeLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get sizeLarge;

  /// No description provided for @sizeExtraLarge.
  ///
  /// In en, this message translates to:
  /// **'Extra Large'**
  String get sizeExtraLarge;

  /// No description provided for @freshnessToday.
  ///
  /// In en, this message translates to:
  /// **'Harvested Today'**
  String get freshnessToday;

  /// No description provided for @freshness23Days.
  ///
  /// In en, this message translates to:
  /// **'2–3 Days Old'**
  String get freshness23Days;

  /// No description provided for @freshnessThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get freshnessThisWeek;

  /// No description provided for @freshnessColdStored.
  ///
  /// In en, this message translates to:
  /// **'Cold Stored'**
  String get freshnessColdStored;

  /// No description provided for @rentalJCB.
  ///
  /// In en, this message translates to:
  /// **'JCB / Excavator'**
  String get rentalJCB;

  /// No description provided for @rentalWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get rentalWeekly;

  /// No description provided for @rentalMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get rentalMonthly;

  /// No description provided for @rentalFullSeason.
  ///
  /// In en, this message translates to:
  /// **'Full Season'**
  String get rentalFullSeason;

  /// No description provided for @sortNearestFirst.
  ///
  /// In en, this message translates to:
  /// **'Nearest first'**
  String get sortNearestFirst;

  /// No description provided for @sortLowestPrice.
  ///
  /// In en, this message translates to:
  /// **'Lowest price'**
  String get sortLowestPrice;

  /// No description provided for @sortHighestPrice.
  ///
  /// In en, this message translates to:
  /// **'Highest price'**
  String get sortHighestPrice;

  /// No description provided for @sortLowestRent.
  ///
  /// In en, this message translates to:
  /// **'Lowest rent'**
  String get sortLowestRent;

  /// No description provided for @sortHighestRent.
  ///
  /// In en, this message translates to:
  /// **'Highest rent'**
  String get sortHighestRent;

  /// No description provided for @priceTractorLow.
  ///
  /// In en, this message translates to:
  /// **'Under ₹4L'**
  String get priceTractorLow;

  /// No description provided for @priceTractorMid.
  ///
  /// In en, this message translates to:
  /// **'₹4L–₹6L'**
  String get priceTractorMid;

  /// No description provided for @priceTractorHigh.
  ///
  /// In en, this message translates to:
  /// **'Above ₹6L'**
  String get priceTractorHigh;

  /// No description provided for @priceCropLow.
  ///
  /// In en, this message translates to:
  /// **'Under ₹2K'**
  String get priceCropLow;

  /// No description provided for @priceCropMid.
  ///
  /// In en, this message translates to:
  /// **'₹2K–₹10K'**
  String get priceCropMid;

  /// No description provided for @priceCropHigh.
  ///
  /// In en, this message translates to:
  /// **'Above ₹10K'**
  String get priceCropHigh;

  /// No description provided for @priceLivestockLow.
  ///
  /// In en, this message translates to:
  /// **'Under ₹50K'**
  String get priceLivestockLow;

  /// No description provided for @priceLivestockMid.
  ///
  /// In en, this message translates to:
  /// **'₹50K–₹1L'**
  String get priceLivestockMid;

  /// No description provided for @priceLivestockHigh.
  ///
  /// In en, this message translates to:
  /// **'Above ₹1L'**
  String get priceLivestockHigh;

  /// No description provided for @priceLandLow.
  ///
  /// In en, this message translates to:
  /// **'Under ₹15L'**
  String get priceLandLow;

  /// No description provided for @priceLandMid.
  ///
  /// In en, this message translates to:
  /// **'₹15L–₹30L'**
  String get priceLandMid;

  /// No description provided for @priceLandHigh.
  ///
  /// In en, this message translates to:
  /// **'Above ₹30L'**
  String get priceLandHigh;

  /// No description provided for @priceRentalLow.
  ///
  /// In en, this message translates to:
  /// **'Under ₹1K/day'**
  String get priceRentalLow;

  /// No description provided for @priceRentalMid.
  ///
  /// In en, this message translates to:
  /// **'₹1K–₹3K/day'**
  String get priceRentalMid;

  /// No description provided for @priceRentalHigh.
  ///
  /// In en, this message translates to:
  /// **'Above ₹3K/day'**
  String get priceRentalHigh;

  /// No description provided for @priceAllLow.
  ///
  /// In en, this message translates to:
  /// **'Under ₹10K'**
  String get priceAllLow;

  /// No description provided for @priceAllMid.
  ///
  /// In en, this message translates to:
  /// **'₹10K–₹1L'**
  String get priceAllMid;

  /// No description provided for @priceAllHigh.
  ///
  /// In en, this message translates to:
  /// **'Above ₹1L'**
  String get priceAllHigh;

  /// No description provided for @resultsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} results'**
  String resultsCount(String count);

  /// Group - Cereal Crops
  ///
  /// In en, this message translates to:
  /// **'Cereal Crops'**
  String get cereal_crops;

  /// Group - Pulse Crops
  ///
  /// In en, this message translates to:
  /// **'Pulse Crops'**
  String get pulse_crops;

  /// Group - Cash Crops
  ///
  /// In en, this message translates to:
  /// **'Cash Crops'**
  String get cash_crops;

  /// Group - Spice Crops
  ///
  /// In en, this message translates to:
  /// **'Spice Crops'**
  String get spice_crops;

  /// Group - Fruit Crops
  ///
  /// In en, this message translates to:
  /// **'Fruit Crops'**
  String get fruit_crops;

  /// Group - Fodder Crops
  ///
  /// In en, this message translates to:
  /// **'Fodder Crops'**
  String get fodder_crops;

  /// Group - Plants & Saplings
  ///
  /// In en, this message translates to:
  /// **'Plants & Saplings'**
  String get plants_and_saplings;

  /// Crop - Rice / Paddy
  ///
  /// In en, this message translates to:
  /// **'Rice / Paddy'**
  String get rice_paddy;

  /// Crop - Sorghum / Jowar
  ///
  /// In en, this message translates to:
  /// **'Sorghum (Jowar)'**
  String get sorghum_jowar;

  /// Crop - Pearl Millet / Bajra
  ///
  /// In en, this message translates to:
  /// **'Pearl Millet (Bajra)'**
  String get pearl_millet_bajra;

  /// Crop - Maize / Corn
  ///
  /// In en, this message translates to:
  /// **'Maize / Corn'**
  String get maize_corn;

  /// Crop - Barnyard Millet / Bhagar
  ///
  /// In en, this message translates to:
  /// **'Barnyard Millet (Bhagar)'**
  String get barnyard_millet_bhagar;

  /// Crop - Pigeon Pea / Tur
  ///
  /// In en, this message translates to:
  /// **'Pigeon Pea (Tur)'**
  String get pigeon_pea_tur;

  /// Crop - Chickpea / Chana
  ///
  /// In en, this message translates to:
  /// **'Chickpea (Chana)'**
  String get chickpea_chana;

  /// Crop - Green Gram / Moong
  ///
  /// In en, this message translates to:
  /// **'Green Gram (Moong)'**
  String get green_gram_moong;

  /// Crop - Black Gram / Urad
  ///
  /// In en, this message translates to:
  /// **'Black Gram (Urad)'**
  String get black_gram_urad;

  /// Crop - Lentil / Masoor
  ///
  /// In en, this message translates to:
  /// **'Lentil (Masoor)'**
  String get lentil_masoor;

  /// Crop - Field Pea / Vatana
  ///
  /// In en, this message translates to:
  /// **'Field Pea (Vatana)'**
  String get field_pea_vatana;

  /// Crop - Cowpea / Chawli
  ///
  /// In en, this message translates to:
  /// **'Cowpea (Chawli)'**
  String get cowpea_chawli;

  /// Crop - Kidney Bean / Rajma
  ///
  /// In en, this message translates to:
  /// **'Kidney Bean (Rajma)'**
  String get kidney_bean_rajma;

  /// Crop - Safflower / Kardai
  ///
  /// In en, this message translates to:
  /// **'Safflower (Kardai)'**
  String get safflower;

  /// Crop - Linseed / Flaxseed
  ///
  /// In en, this message translates to:
  /// **'Linseed (Flaxseed)'**
  String get linseed;

  /// Crop - Castor
  ///
  /// In en, this message translates to:
  /// **'Castor'**
  String get castor;

  /// Crop - Turmeric
  ///
  /// In en, this message translates to:
  /// **'Turmeric'**
  String get turmeric;

  /// Crop - Ginger
  ///
  /// In en, this message translates to:
  /// **'Ginger'**
  String get ginger;

  /// Crop - Coriander
  ///
  /// In en, this message translates to:
  /// **'Coriander'**
  String get coriander;

  /// Crop - Fenugreek / Methi
  ///
  /// In en, this message translates to:
  /// **'Fenugreek (Methi)'**
  String get fenugreek;

  /// Crop - Onion Seed
  ///
  /// In en, this message translates to:
  /// **'Onion Seed'**
  String get onion_seed;

  /// Veg - Ridge Gourd / Dodka
  ///
  /// In en, this message translates to:
  /// **'Ridge Gourd (Dodka)'**
  String get ridge_gourd;

  /// Veg - Bitter Gourd / Karela
  ///
  /// In en, this message translates to:
  /// **'Bitter Gourd (Karela)'**
  String get bitter_gourd;

  /// Veg - Bottle Gourd / Dudhi
  ///
  /// In en, this message translates to:
  /// **'Bottle Gourd (Dudhi)'**
  String get bottle_gourd;

  /// Veg - Dill / Shepu
  ///
  /// In en, this message translates to:
  /// **'Dill (Shepu)'**
  String get dill;

  /// Fruit - Custard Apple / Sitaphal
  ///
  /// In en, this message translates to:
  /// **'Custard Apple (Sitaphal)'**
  String get custard_apple;

  /// Fruit - Jamun / Java Plum
  ///
  /// In en, this message translates to:
  /// **'Jamun (Java Plum)'**
  String get jamun;

  /// Fodder - Maize
  ///
  /// In en, this message translates to:
  /// **'Fodder Maize'**
  String get fodder_maize;

  /// Fodder - Sorghum
  ///
  /// In en, this message translates to:
  /// **'Fodder Sorghum'**
  String get fodder_sorghum;

  /// Fodder - Pearl Millet
  ///
  /// In en, this message translates to:
  /// **'Fodder Pearl Millet'**
  String get fodder_pearl_millet;

  /// Sapling - Mango
  ///
  /// In en, this message translates to:
  /// **'Mango Sapling'**
  String get mango_sapling;

  /// Sapling - Pomegranate
  ///
  /// In en, this message translates to:
  /// **'Pomegranate Sapling'**
  String get pomegranate_sapling;

  /// Sapling - Sweet Lime
  ///
  /// In en, this message translates to:
  /// **'Sweet Lime Sapling'**
  String get sweet_lime_sapling;

  /// Sapling - Orange
  ///
  /// In en, this message translates to:
  /// **'Orange Sapling'**
  String get orange_sapling;

  /// Sapling - Cashew
  ///
  /// In en, this message translates to:
  /// **'Cashew Sapling'**
  String get cashew_sapling;

  /// Sapling - Coconut
  ///
  /// In en, this message translates to:
  /// **'Coconut Sapling'**
  String get coconut_sapling;

  /// Sapling - Teak
  ///
  /// In en, this message translates to:
  /// **'Teak Sapling'**
  String get teak_sapling;

  /// Sapling - Bamboo
  ///
  /// In en, this message translates to:
  /// **'Bamboo Sapling'**
  String get bamboo_sapling;

  /// No description provided for @listingRentPerDay.
  ///
  /// In en, this message translates to:
  /// **'Rent per day'**
  String get listingRentPerDay;

  /// No description provided for @listingFixedPrice.
  ///
  /// In en, this message translates to:
  /// **'Fixed price'**
  String get listingFixedPrice;

  /// No description provided for @listingForRent.
  ///
  /// In en, this message translates to:
  /// **'For Rent'**
  String get listingForRent;

  /// No description provided for @listingForSale.
  ///
  /// In en, this message translates to:
  /// **'For Sale'**
  String get listingForSale;

  /// No description provided for @listingDetails.
  ///
  /// In en, this message translates to:
  /// **'Listing Details'**
  String get listingDetails;

  /// No description provided for @listingCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get listingCategory;

  /// No description provided for @listingType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get listingType;

  /// No description provided for @listingCondition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get listingCondition;

  /// No description provided for @listingPostedOn.
  ///
  /// In en, this message translates to:
  /// **'Posted On'**
  String get listingPostedOn;

  /// No description provided for @listingViews.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get listingViews;

  /// No description provided for @listingMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since 2024'**
  String get listingMemberSince;

  /// No description provided for @listingCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get listingCall;

  /// No description provided for @listingWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get listingWhatsApp;

  /// No description provided for @listingChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get listingChat;

  /// No description provided for @locationScopeVillage.
  ///
  /// In en, this message translates to:
  /// **'Village'**
  String get locationScopeVillage;

  /// No description provided for @locationScopeCityNearby.
  ///
  /// In en, this message translates to:
  /// **'City & nearby villages'**
  String get locationScopeCityNearby;

  /// No description provided for @locationScopeState.
  ///
  /// In en, this message translates to:
  /// **'Whole state'**
  String get locationScopeState;

  /// No description provided for @showingListingsIn.
  ///
  /// In en, this message translates to:
  /// **'Showing {scope} listings in {location}'**
  String showingListingsIn(String scope, String location);

  /// No description provided for @dealerResultsIn.
  ///
  /// In en, this message translates to:
  /// **'{count} results in {location}'**
  String dealerResultsIn(int count, String location);

  /// No description provided for @noDealersFound.
  ///
  /// In en, this message translates to:
  /// **'No dealers found'**
  String get noDealersFound;

  /// No description provided for @agriDealers.
  ///
  /// In en, this message translates to:
  /// **'Agri Dealers'**
  String get agriDealers;

  /// No description provided for @dealerCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'{category} Dealers'**
  String dealerCategoryTitle(String category);

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @sortByOption.
  ///
  /// In en, this message translates to:
  /// **'Sort by · {option}'**
  String sortByOption(String option);

  /// No description provided for @dealerSortTopRated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get dealerSortTopRated;

  /// No description provided for @dealerSortNearest.
  ///
  /// In en, this message translates to:
  /// **'Nearest'**
  String get dealerSortNearest;

  /// No description provided for @dealerSortNameAz.
  ///
  /// In en, this message translates to:
  /// **'A – Z'**
  String get dealerSortNameAz;

  /// No description provided for @filterCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get filterCategory;

  /// No description provided for @dealerCatFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer'**
  String get dealerCatFertilizer;

  /// No description provided for @dealerCatSeeds.
  ///
  /// In en, this message translates to:
  /// **'Seeds'**
  String get dealerCatSeeds;

  /// No description provided for @dealerCatMachinery.
  ///
  /// In en, this message translates to:
  /// **'Machinery'**
  String get dealerCatMachinery;

  /// No description provided for @dealerCatPesticides.
  ///
  /// In en, this message translates to:
  /// **'Pesticides'**
  String get dealerCatPesticides;

  /// No description provided for @productsAndServices.
  ///
  /// In en, this message translates to:
  /// **'Products & Services'**
  String get productsAndServices;

  /// No description provided for @productsLabel.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsLabel;

  /// No description provided for @servicesLabel.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesLabel;

  /// No description provided for @overviewTab.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overviewTab;

  /// No description provided for @photosTab.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photosTab;

  /// No description provided for @sendEnquiry.
  ///
  /// In en, this message translates to:
  /// **'Send Enquiry'**
  String get sendEnquiry;

  /// No description provided for @bestPrice.
  ///
  /// In en, this message translates to:
  /// **'Best Price'**
  String get bestPrice;

  /// No description provided for @getBestPrice.
  ///
  /// In en, this message translates to:
  /// **'Get Best Price'**
  String get getBestPrice;

  /// No description provided for @lookingForDealers.
  ///
  /// In en, this message translates to:
  /// **'Looking for {title}?'**
  String lookingForDealers(String title);

  /// No description provided for @searchDealersHint.
  ///
  /// In en, this message translates to:
  /// **'Search dealers…'**
  String get searchDealersHint;

  /// No description provided for @veryResponsive.
  ///
  /// In en, this message translates to:
  /// **'Very Responsive'**
  String get veryResponsive;

  /// No description provided for @yearsInBusiness.
  ///
  /// In en, this message translates to:
  /// **'{years} Years in Business'**
  String yearsInBusiness(int years);

  /// No description provided for @ratingsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Ratings'**
  String ratingsCount(int count);

  /// No description provided for @alsoServesAreas.
  ///
  /// In en, this message translates to:
  /// **'{city} • Also Serves {areas}'**
  String alsoServesAreas(String city, String areas);

  /// No description provided for @openNowUntil.
  ///
  /// In en, this message translates to:
  /// **'Open Now: until {time}'**
  String openNowUntil(String time);

  /// No description provided for @primaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get primaryLabel;

  /// No description provided for @mapViewComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Map view coming soon'**
  String get mapViewComingSoon;

  /// No description provided for @photosCount.
  ///
  /// In en, this message translates to:
  /// **'Photos ({count})'**
  String photosCount(int count);

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @locationSection.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationSection;

  /// No description provided for @nearLocation.
  ///
  /// In en, this message translates to:
  /// **'Near {location}'**
  String nearLocation(String location);

  /// No description provided for @enquirySentTo.
  ///
  /// In en, this message translates to:
  /// **'Enquiry sent to {name}'**
  String enquirySentTo(String name);

  /// No description provided for @priceRequestSentTo.
  ///
  /// In en, this message translates to:
  /// **'Price request sent to {name}'**
  String priceRequestSentTo(String name);

  /// No description provided for @foundOnKrishiXDealers.
  ///
  /// In en, this message translates to:
  /// **'Found on KrishiX Dealers'**
  String get foundOnKrishiXDealers;

  /// No description provided for @shareProductLabel.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get shareProductLabel;

  /// No description provided for @shareLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get shareLocationLabel;

  /// No description provided for @shareQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get shareQuantityLabel;

  /// No description provided for @shareAppDownload.
  ///
  /// In en, this message translates to:
  /// **'Download KrishiX'**
  String get shareAppDownload;

  /// No description provided for @directionLabel.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get directionLabel;

  /// No description provided for @enquiryLabel.
  ///
  /// In en, this message translates to:
  /// **'Enquiry'**
  String get enquiryLabel;

  /// No description provided for @enquiryFastBadge.
  ///
  /// In en, this message translates to:
  /// **'FAST ⚡'**
  String get enquiryFastBadge;

  /// No description provided for @topSearchBadge.
  ///
  /// In en, this message translates to:
  /// **'Top Search'**
  String get topSearchBadge;

  /// No description provided for @topRatedBadge.
  ///
  /// In en, this message translates to:
  /// **'Top rated'**
  String get topRatedBadge;

  /// No description provided for @askForPrice.
  ///
  /// In en, this message translates to:
  /// **'Ask for Price'**
  String get askForPrice;

  /// No description provided for @productsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Products Available'**
  String get productsAvailable;

  /// No description provided for @dealerLabel.
  ///
  /// In en, this message translates to:
  /// **'Dealer'**
  String get dealerLabel;

  /// No description provided for @verifiedListingBadge.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verifiedListingBadge;

  /// No description provided for @listYourItem.
  ///
  /// In en, this message translates to:
  /// **'List Your Item'**
  String get listYourItem;

  /// No description provided for @listYourItemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to list your item on KrishiX'**
  String get listYourItemSubtitle;

  /// No description provided for @sellListingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'List items for a one-time sale'**
  String get sellListingSubtitle;

  /// No description provided for @rentListingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'List items for hire or rental'**
  String get rentListingSubtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @postAdListingDetails.
  ///
  /// In en, this message translates to:
  /// **'Post Ad – Listing Details'**
  String get postAdListingDetails;

  /// No description provided for @postAdSellerDetails.
  ///
  /// In en, this message translates to:
  /// **'Post Ad – Seller Details'**
  String get postAdSellerDetails;

  /// No description provided for @postStepListing.
  ///
  /// In en, this message translates to:
  /// **'Listing'**
  String get postStepListing;

  /// No description provided for @postStepSeller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get postStepSeller;

  /// No description provided for @postTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get postTitleRequired;

  /// No description provided for @postPriceRequired.
  ///
  /// In en, this message translates to:
  /// **'Price is required'**
  String get postPriceRequired;

  /// No description provided for @postDescRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get postDescRequired;

  /// No description provided for @postPhotosLabel.
  ///
  /// In en, this message translates to:
  /// **'Photos *'**
  String get postPhotosLabel;

  /// No description provided for @postPhotosHint.
  ///
  /// In en, this message translates to:
  /// **'Minimum 1 photo required · up to 5 photos'**
  String get postPhotosHint;

  /// No description provided for @postDescLabel.
  ///
  /// In en, this message translates to:
  /// **'Description *'**
  String get postDescLabel;

  /// No description provided for @postDescInputHint.
  ///
  /// In en, this message translates to:
  /// **'Write a detailed description…'**
  String get postDescInputHint;

  /// No description provided for @postNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get postNext;

  /// No description provided for @postSubmitListing.
  ///
  /// In en, this message translates to:
  /// **'Submit Listing'**
  String get postSubmitListing;

  /// No description provided for @postReviewNote.
  ///
  /// In en, this message translates to:
  /// **'Your listing will be reviewed before going live.'**
  String get postReviewNote;

  /// No description provided for @postExpectedPrice.
  ///
  /// In en, this message translates to:
  /// **'Expected Price *'**
  String get postExpectedPrice;

  /// No description provided for @postRentalPrice.
  ///
  /// In en, this message translates to:
  /// **'Rental Price *'**
  String get postRentalPrice;

  /// No description provided for @postPriceHintSell.
  ///
  /// In en, this message translates to:
  /// **'e.g. 18000'**
  String get postPriceHintSell;

  /// No description provided for @postPriceHintRent.
  ///
  /// In en, this message translates to:
  /// **'e.g. 4500  (per day)'**
  String get postPriceHintRent;

  /// No description provided for @postSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get postSelectCategory;

  /// No description provided for @postSellOrRent.
  ///
  /// In en, this message translates to:
  /// **'Sell or Rent?'**
  String get postSellOrRent;

  /// No description provided for @postPhotoRequiredContinue.
  ///
  /// In en, this message translates to:
  /// **'Please add at least 1 photo before continuing'**
  String get postPhotoRequiredContinue;

  /// No description provided for @postPhotoRequiredSubmit.
  ///
  /// In en, this message translates to:
  /// **'Please add at least 1 photo before submitting'**
  String get postPhotoRequiredSubmit;

  /// No description provided for @postAdSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Ad submitted! It will go live after review.'**
  String get postAdSubmitted;

  /// No description provided for @postSellerInfoNote.
  ///
  /// In en, this message translates to:
  /// **'These details will be shown to buyers. Phone number is fetched from your account.'**
  String get postSellerInfoNote;

  /// No description provided for @postYourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name *'**
  String get postYourName;

  /// No description provided for @postFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get postFullNameHint;

  /// No description provided for @postNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get postNameRequired;

  /// No description provided for @postLocation.
  ///
  /// In en, this message translates to:
  /// **'Location *'**
  String get postLocation;

  /// No description provided for @postLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Village / Taluka / District where the item is located'**
  String get postLocationHint;

  /// No description provided for @postLocationRequired.
  ///
  /// In en, this message translates to:
  /// **'Location is required'**
  String get postLocationRequired;

  /// No description provided for @postContactNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get postContactNumber;

  /// No description provided for @postPhoneNote.
  ///
  /// In en, this message translates to:
  /// **'Fetched from your account — cannot be changed here'**
  String get postPhoneNote;

  /// No description provided for @postListingSummary.
  ///
  /// In en, this message translates to:
  /// **'Listing Summary'**
  String get postListingSummary;

  /// No description provided for @postSummaryCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get postSummaryCategory;

  /// No description provided for @postSummaryType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get postSummaryType;

  /// No description provided for @postSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get postSummaryTitle;

  /// No description provided for @postSummaryPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get postSummaryPrice;

  /// No description provided for @postSelectOption.
  ///
  /// In en, this message translates to:
  /// **'Select option'**
  String get postSelectOption;

  /// No description provided for @postSelectUnit.
  ///
  /// In en, this message translates to:
  /// **'Select unit'**
  String get postSelectUnit;

  /// No description provided for @postPhotosAdded.
  ///
  /// In en, this message translates to:
  /// **'{count} / 5 photos added'**
  String postPhotosAdded(int count);

  /// No description provided for @postClearAllPhotos.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get postClearAllPhotos;

  /// No description provided for @postAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo *'**
  String get postAddPhoto;

  /// No description provided for @postPhotoRequiredError.
  ///
  /// In en, this message translates to:
  /// **'At least 1 photo is required'**
  String get postPhotoRequiredError;

  /// No description provided for @postPhotoPromo.
  ///
  /// In en, this message translates to:
  /// **'Add at least 1 photo (required) — listings with photos get 5× more responses'**
  String get postPhotoPromo;

  /// No description provided for @postPhotoCover.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get postPhotoCover;

  /// No description provided for @postPhotoNumber.
  ///
  /// In en, this message translates to:
  /// **'Photo {number}'**
  String postPhotoNumber(int number);

  /// No description provided for @postTitleGeneric.
  ///
  /// In en, this message translates to:
  /// **'Listing Title *'**
  String get postTitleGeneric;

  /// No description provided for @postTitleCropGrain.
  ///
  /// In en, this message translates to:
  /// **'Crop or Grain Name *'**
  String get postTitleCropGrain;

  /// No description provided for @postTitleSeedPlant.
  ///
  /// In en, this message translates to:
  /// **'Seed or Plant Name *'**
  String get postTitleSeedPlant;

  /// No description provided for @postTitleFruitVeg.
  ///
  /// In en, this message translates to:
  /// **'Fruit or Vegetable Name *'**
  String get postTitleFruitVeg;

  /// No description provided for @postTitleLivestock.
  ///
  /// In en, this message translates to:
  /// **'Livestock Name *'**
  String get postTitleLivestock;

  /// No description provided for @postTitleTractor.
  ///
  /// In en, this message translates to:
  /// **'Tractor Name *'**
  String get postTitleTractor;

  /// No description provided for @postTitleFarmLand.
  ///
  /// In en, this message translates to:
  /// **'Farm Land Name *'**
  String get postTitleFarmLand;

  /// No description provided for @postTitleEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment Name *'**
  String get postTitleEquipment;

  /// No description provided for @postTitleFarmMachinery.
  ///
  /// In en, this message translates to:
  /// **'Farm Machinery Name *'**
  String get postTitleFarmMachinery;

  /// No description provided for @postTitleTractorPart.
  ///
  /// In en, this message translates to:
  /// **'Tractor Part Name *'**
  String get postTitleTractorPart;

  /// No description provided for @postTitleMachineryName.
  ///
  /// In en, this message translates to:
  /// **'Machinery Name *'**
  String get postTitleMachineryName;

  /// No description provided for @postTitleJcb.
  ///
  /// In en, this message translates to:
  /// **'JCB / Excavator Name *'**
  String get postTitleJcb;

  /// No description provided for @postTitleTractorRental.
  ///
  /// In en, this message translates to:
  /// **'Tractor Name *'**
  String get postTitleTractorRental;

  /// No description provided for @postCatTractorsMachinery.
  ///
  /// In en, this message translates to:
  /// **'Tractors & Machinery'**
  String get postCatTractorsMachinery;

  /// No description provided for @postCatLandBuySell.
  ///
  /// In en, this message translates to:
  /// **'Farm Land – Buy/Sell'**
  String get postCatLandBuySell;

  /// No description provided for @postCatLandLease.
  ///
  /// In en, this message translates to:
  /// **'Farm Land – Lease/Rent'**
  String get postCatLandLease;

  /// No description provided for @postCatRentalEquipment.
  ///
  /// In en, this message translates to:
  /// **'Rental Equipment'**
  String get postCatRentalEquipment;

  /// No description provided for @postTitleHintGeneric.
  ///
  /// In en, this message translates to:
  /// **'Enter listing title'**
  String get postTitleHintGeneric;

  /// No description provided for @postTitleHintCropsGrains.
  ///
  /// In en, this message translates to:
  /// **'e.g. Wheat – 20 Quintal, A-Grade'**
  String get postTitleHintCropsGrains;

  /// No description provided for @postTitleHintSeedsPlants.
  ///
  /// In en, this message translates to:
  /// **'e.g. Hybrid Tomato Seeds – 500g Pack'**
  String get postTitleHintSeedsPlants;

  /// No description provided for @postTitleHintFruitsVeg.
  ///
  /// In en, this message translates to:
  /// **'e.g. Fresh Alphonso Mangoes – 10 Dozen'**
  String get postTitleHintFruitsVeg;

  /// No description provided for @postTitleHintLivestock.
  ///
  /// In en, this message translates to:
  /// **'e.g. Murrah Buffalo – High Milk Yield'**
  String get postTitleHintLivestock;

  /// No description provided for @postTitleHintTractors.
  ///
  /// In en, this message translates to:
  /// **'e.g. Mahindra 575 DI – 2019 Model'**
  String get postTitleHintTractors;

  /// No description provided for @postTitleHintLandBuy.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5 Acre Irrigated Farm Land for Sale'**
  String get postTitleHintLandBuy;

  /// No description provided for @postTitleHintLandRent.
  ///
  /// In en, this message translates to:
  /// **'e.g. 3 Acre Farm Land Available for Lease'**
  String get postTitleHintLandRent;

  /// No description provided for @postTitleHintRental.
  ///
  /// In en, this message translates to:
  /// **'e.g. JCB 3DX Backhoe – Available Daily'**
  String get postTitleHintRental;

  /// No description provided for @postDescHintGeneric.
  ///
  /// In en, this message translates to:
  /// **'Describe your listing in detail…'**
  String get postDescHintGeneric;

  /// No description provided for @postDescHintCropsGrains.
  ///
  /// In en, this message translates to:
  /// **'Describe crop quality, packaging, storage, any certifications…'**
  String get postDescHintCropsGrains;

  /// No description provided for @postDescHintSeedsPlants.
  ///
  /// In en, this message translates to:
  /// **'Describe germination rate, source, any certifications, storage advice…'**
  String get postDescHintSeedsPlants;

  /// No description provided for @postDescHintFruitsVeg.
  ///
  /// In en, this message translates to:
  /// **'Describe freshness, packaging, delivery options, minimum order…'**
  String get postDescHintFruitsVeg;

  /// No description provided for @postDescHintLivestock.
  ///
  /// In en, this message translates to:
  /// **'Describe health condition, vaccination history, feeding habits…'**
  String get postDescHintLivestock;

  /// No description provided for @postDescHintTractors.
  ///
  /// In en, this message translates to:
  /// **'Describe service history, attachments included, any repairs done…'**
  String get postDescHintTractors;

  /// No description provided for @postDescHintLandBuy.
  ///
  /// In en, this message translates to:
  /// **'Describe road access, irrigation, nearby facilities, legal status…'**
  String get postDescHintLandBuy;

  /// No description provided for @postDescHintLandRent.
  ///
  /// In en, this message translates to:
  /// **'Describe current land condition, who bears water/electricity cost, access road…'**
  String get postDescHintLandRent;

  /// No description provided for @postDescHintRental.
  ///
  /// In en, this message translates to:
  /// **'Describe availability, included operator, service area, terms…'**
  String get postDescHintRental;

  /// No description provided for @postFldQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get postFldQuantity;

  /// No description provided for @postFldGradeQuality.
  ///
  /// In en, this message translates to:
  /// **'Grade / Quality'**
  String get postFldGradeQuality;

  /// No description provided for @postFldHarvestDate.
  ///
  /// In en, this message translates to:
  /// **'Harvest Date'**
  String get postFldHarvestDate;

  /// No description provided for @postFldCropPlantType.
  ///
  /// In en, this message translates to:
  /// **'Crop / Plant Type'**
  String get postFldCropPlantType;

  /// No description provided for @postFldQuantityPackSize.
  ///
  /// In en, this message translates to:
  /// **'Quantity / Pack Size'**
  String get postFldQuantityPackSize;

  /// No description provided for @postFldSeedBrand.
  ///
  /// In en, this message translates to:
  /// **'Seed / Plant Brand'**
  String get postFldSeedBrand;

  /// No description provided for @postFldSowingSeason.
  ///
  /// In en, this message translates to:
  /// **'Sowing Season'**
  String get postFldSowingSeason;

  /// No description provided for @postFldVariety.
  ///
  /// In en, this message translates to:
  /// **'Variety'**
  String get postFldVariety;

  /// No description provided for @postFldQuantityAvailable.
  ///
  /// In en, this message translates to:
  /// **'Quantity Available'**
  String get postFldQuantityAvailable;

  /// No description provided for @postFldHarvestAvailable.
  ///
  /// In en, this message translates to:
  /// **'Harvest / Available From'**
  String get postFldHarvestAvailable;

  /// No description provided for @postFldBreed.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get postFldBreed;

  /// No description provided for @postFldAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get postFldAge;

  /// No description provided for @postFldMilkYield.
  ///
  /// In en, this message translates to:
  /// **'Milk Yield (if applicable)'**
  String get postFldMilkYield;

  /// No description provided for @postFldBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get postFldBrand;

  /// No description provided for @postFldYearManufacture.
  ///
  /// In en, this message translates to:
  /// **'Year of Manufacture'**
  String get postFldYearManufacture;

  /// No description provided for @postFldHorsePower.
  ///
  /// In en, this message translates to:
  /// **'Horse Power (HP)'**
  String get postFldHorsePower;

  /// No description provided for @postFldCondition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get postFldCondition;

  /// No description provided for @postFldTotalArea.
  ///
  /// In en, this message translates to:
  /// **'Total Area'**
  String get postFldTotalArea;

  /// No description provided for @postFldSurveyNumber.
  ///
  /// In en, this message translates to:
  /// **'Survey Number'**
  String get postFldSurveyNumber;

  /// No description provided for @postFldSoilType.
  ///
  /// In en, this message translates to:
  /// **'Soil Type'**
  String get postFldSoilType;

  /// No description provided for @postFldWaterSource.
  ///
  /// In en, this message translates to:
  /// **'Water Source'**
  String get postFldWaterSource;

  /// No description provided for @postFldRoadAccess.
  ///
  /// In en, this message translates to:
  /// **'Road Access'**
  String get postFldRoadAccess;

  /// No description provided for @postFldLegalStatus.
  ///
  /// In en, this message translates to:
  /// **'Legal Status'**
  String get postFldLegalStatus;

  /// No description provided for @postFldTotalAreaAvailable.
  ///
  /// In en, this message translates to:
  /// **'Total Area Available'**
  String get postFldTotalAreaAvailable;

  /// No description provided for @postFldLeaseDuration.
  ///
  /// In en, this message translates to:
  /// **'Lease Duration'**
  String get postFldLeaseDuration;

  /// No description provided for @postFldExistingCrop.
  ///
  /// In en, this message translates to:
  /// **'Existing Crop (if any)'**
  String get postFldExistingCrop;

  /// No description provided for @postFldLeaseTerms.
  ///
  /// In en, this message translates to:
  /// **'Lease Terms'**
  String get postFldLeaseTerms;

  /// No description provided for @postFldEquipmentType.
  ///
  /// In en, this message translates to:
  /// **'Equipment Type'**
  String get postFldEquipmentType;

  /// No description provided for @postFldRentalDuration.
  ///
  /// In en, this message translates to:
  /// **'Rental Duration'**
  String get postFldRentalDuration;

  /// No description provided for @postFldDeliveryAvailable.
  ///
  /// In en, this message translates to:
  /// **'Delivery Available?'**
  String get postFldDeliveryAvailable;

  /// No description provided for @postFldMachineType.
  ///
  /// In en, this message translates to:
  /// **'Machine Type'**
  String get postFldMachineType;

  /// No description provided for @postFldOperatorIncluded.
  ///
  /// In en, this message translates to:
  /// **'Operator Included?'**
  String get postFldOperatorIncluded;

  /// No description provided for @postHintQuantity.
  ///
  /// In en, this message translates to:
  /// **'e.g. 20'**
  String get postHintQuantity;

  /// No description provided for @postHintGradeQuality.
  ///
  /// In en, this message translates to:
  /// **'e.g. A-Grade, Premium, Mixed'**
  String get postHintGradeQuality;

  /// No description provided for @postHintHarvestDate.
  ///
  /// In en, this message translates to:
  /// **'e.g. June 2026'**
  String get postHintHarvestDate;

  /// No description provided for @postHintCropPlantType.
  ///
  /// In en, this message translates to:
  /// **'e.g. Tomato, Brinjal, Onion, Mango sapling'**
  String get postHintCropPlantType;

  /// No description provided for @postHintQuantityPackSize.
  ///
  /// In en, this message translates to:
  /// **'e.g. 500'**
  String get postHintQuantityPackSize;

  /// No description provided for @postHintSeedBrand.
  ///
  /// In en, this message translates to:
  /// **'e.g. Mahyco, Syngenta, Local variety'**
  String get postHintSeedBrand;

  /// No description provided for @postHintSowingSeason.
  ///
  /// In en, this message translates to:
  /// **'e.g. Kharif, Rabi, Any season'**
  String get postHintSowingSeason;

  /// No description provided for @postHintVariety.
  ///
  /// In en, this message translates to:
  /// **'e.g. Alphonso, Devgad, Cherry Tomato'**
  String get postHintVariety;

  /// No description provided for @postHintQuantityAvailable.
  ///
  /// In en, this message translates to:
  /// **'e.g. 50'**
  String get postHintQuantityAvailable;

  /// No description provided for @postHintHarvestAvailable.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ready now, July 2026'**
  String get postHintHarvestAvailable;

  /// No description provided for @postHintBreed.
  ///
  /// In en, this message translates to:
  /// **'e.g. Murrah, HF, Gir, Sahiwal'**
  String get postHintBreed;

  /// No description provided for @postHintAge.
  ///
  /// In en, this message translates to:
  /// **'e.g. 3 years, 18 months'**
  String get postHintAge;

  /// No description provided for @postHintMilkYield.
  ///
  /// In en, this message translates to:
  /// **'e.g. 14'**
  String get postHintMilkYield;

  /// No description provided for @postHintBrand.
  ///
  /// In en, this message translates to:
  /// **'e.g. Mahindra, Swaraj, John Deere'**
  String get postHintBrand;

  /// No description provided for @postHintYearManufacture.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2019'**
  String get postHintYearManufacture;

  /// No description provided for @postHintHorsePower.
  ///
  /// In en, this message translates to:
  /// **'e.g. 45'**
  String get postHintHorsePower;

  /// No description provided for @postHintCondition.
  ///
  /// In en, this message translates to:
  /// **'e.g. Good, Excellent, Needs Repair'**
  String get postHintCondition;

  /// No description provided for @postHintTotalArea.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5'**
  String get postHintTotalArea;

  /// No description provided for @postHintSurveyNumber.
  ///
  /// In en, this message translates to:
  /// **'e.g. 142/3 (optional)'**
  String get postHintSurveyNumber;

  /// No description provided for @postHintSoilType.
  ///
  /// In en, this message translates to:
  /// **'e.g. Black, Red, Alluvial'**
  String get postHintSoilType;

  /// No description provided for @postHintWaterSource.
  ///
  /// In en, this message translates to:
  /// **'e.g. Borewell, Canal, Rain-fed'**
  String get postHintWaterSource;

  /// No description provided for @postHintRoadAccess.
  ///
  /// In en, this message translates to:
  /// **'e.g. Yes – 10ft road, No'**
  String get postHintRoadAccess;

  /// No description provided for @postHintLegalStatus.
  ///
  /// In en, this message translates to:
  /// **'e.g. Clear title, NA converted'**
  String get postHintLegalStatus;

  /// No description provided for @postHintTotalAreaAvailable.
  ///
  /// In en, this message translates to:
  /// **'e.g. 3'**
  String get postHintTotalAreaAvailable;

  /// No description provided for @postHintLeaseDuration.
  ///
  /// In en, this message translates to:
  /// **'e.g. 1 year, Season-wise, 3 years'**
  String get postHintLeaseDuration;

  /// No description provided for @postHintExistingCrop.
  ///
  /// In en, this message translates to:
  /// **'e.g. Sugarcane, Cotton, Fallow'**
  String get postHintExistingCrop;

  /// No description provided for @postHintLeaseTerms.
  ///
  /// In en, this message translates to:
  /// **'e.g. Negotiable, Fixed rent ₹8000/acre/yr'**
  String get postHintLeaseTerms;

  /// No description provided for @postHintEquipmentType.
  ///
  /// In en, this message translates to:
  /// **'e.g. Rotavator, JCB, Sprayer, Harvester'**
  String get postHintEquipmentType;

  /// No description provided for @postHintRentalDuration.
  ///
  /// In en, this message translates to:
  /// **'e.g. Per Hour, Per Day, Weekly'**
  String get postHintRentalDuration;

  /// No description provided for @postHintDeliveryAvailable.
  ///
  /// In en, this message translates to:
  /// **'e.g. Yes – within 20 km, No – self pickup'**
  String get postHintDeliveryAvailable;

  /// No description provided for @postHintMachineType.
  ///
  /// In en, this message translates to:
  /// **'e.g. JCB 3DX, Excavator, Loader, Bulldozer'**
  String get postHintMachineType;

  /// No description provided for @postHintOperatorIncluded.
  ///
  /// In en, this message translates to:
  /// **'e.g. Yes – with operator, No – machine only'**
  String get postHintOperatorIncluded;

  /// No description provided for @postSuffixLitersPerDay.
  ///
  /// In en, this message translates to:
  /// **'L/day'**
  String get postSuffixLitersPerDay;

  /// No description provided for @postSuffixAcres.
  ///
  /// In en, this message translates to:
  /// **'Acres'**
  String get postSuffixAcres;

  /// No description provided for @postSuffixHp.
  ///
  /// In en, this message translates to:
  /// **'HP'**
  String get postSuffixHp;

  /// No description provided for @unitQuintal.
  ///
  /// In en, this message translates to:
  /// **'Quintal'**
  String get unitQuintal;

  /// No description provided for @unitKg.
  ///
  /// In en, this message translates to:
  /// **'Kg'**
  String get unitKg;

  /// No description provided for @unitTon.
  ///
  /// In en, this message translates to:
  /// **'Ton'**
  String get unitTon;

  /// No description provided for @unitMan.
  ///
  /// In en, this message translates to:
  /// **'Man'**
  String get unitMan;

  /// No description provided for @unitBag.
  ///
  /// In en, this message translates to:
  /// **'Bag'**
  String get unitBag;

  /// No description provided for @unitDozen.
  ///
  /// In en, this message translates to:
  /// **'Dozen'**
  String get unitDozen;

  /// No description provided for @unitCrate.
  ///
  /// In en, this message translates to:
  /// **'Crate'**
  String get unitCrate;

  /// No description provided for @unitBox.
  ///
  /// In en, this message translates to:
  /// **'Box'**
  String get unitBox;

  /// No description provided for @unitGrams.
  ///
  /// In en, this message translates to:
  /// **'grams'**
  String get unitGrams;

  /// No description provided for @unitPacket.
  ///
  /// In en, this message translates to:
  /// **'Packet'**
  String get unitPacket;

  /// No description provided for @unitPiece.
  ///
  /// In en, this message translates to:
  /// **'Piece'**
  String get unitPiece;

  /// No description provided for @unitAcre.
  ///
  /// In en, this message translates to:
  /// **'Acre'**
  String get unitAcre;

  /// No description provided for @unitHectare.
  ///
  /// In en, this message translates to:
  /// **'Hectare'**
  String get unitHectare;

  /// No description provided for @unitGuntha.
  ///
  /// In en, this message translates to:
  /// **'Guntha'**
  String get unitGuntha;

  /// No description provided for @postForSaleListing.
  ///
  /// In en, this message translates to:
  /// **'For sale listing'**
  String get postForSaleListing;

  /// No description provided for @postRentalListing.
  ///
  /// In en, this message translates to:
  /// **'Rental listing'**
  String get postRentalListing;
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
