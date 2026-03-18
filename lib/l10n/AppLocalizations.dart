import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'AppLocalizationsAr.dart';
import 'AppLocalizationsEn.dart';

abstract class AppLocalizations {
  AppLocalizations(this.localeName);

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Static getter for supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('ar', ''), // Arabic
  ];

  // Static delegate for localization
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // General application strings
  String get appName;
  String get home;
  String get explore;
  String get bookings;
  String get chat;
  String get profile;
  String get popular;
  String get popularCars;
  String get noPopularCars;
  String get sortBy;
  String get topRated;
  String get priceLowToHigh;
  String get priceHighToLow;
  String get newest;
  String get search;
  String get searchCarsByBrandOrModel;
  String noSearchResults(String searchTerm);
  String get trySearching;
  String get tryChangingFilters;
  String get bookCar;
  String get bookNow;
  String get confirmBooking;
  String get processing;
  String get back;
  String get details;
  String get features;
  String get reviews;
  String seatsCount(int count);
  String get noReviews;
  String get seeAll;
  String get day;
  String get perDay;
  String get carNotFound;
  String get enterLocation;
  String get selectGovernorate;
  String get chooseDifferentGovernorate;
  String get selectLocation;
  String get confirm;
  String get noSelectedCars;
  String get brand;

  // Notification strings
  String get notifications;
  String get noNotifications;
  String get youHaveNoNotificationsYet;
  String get markAllAsRead;
  String get allNotificationsMarkedAsRead;

  // Favorites and onboarding strings
  String get favorites;
  String get skip;
  String get proceed;
  String get getStarted;
  String get next;
  String get welcomeSubtitle;
  String get onboardingFindCarsTitle;
  String get onboardingFindCarsDescription;
  String get onboardingEasyBookingTitle;
  String get onboardingEasyBookingDescription;
  String get onboardingSecurePaymentTitle;
  String get onboardingSecurePaymentDescription;
  String failedToSavePreferences(String error);
  String get imageLoadError;
  String onboardingImage(int index);

  // Profile-related strings
  String get completeYourProfile;
  String get profileCompletionMsg;
  String get dateOfBirth;
  String get gender;
  String get male;
  String get female;
  String get other;
  String get pleaseSelectDateOfBirth;
  String get pleaseSelectGender;
  String get save;
  String get editProfile;
  String get personalInformation;
  String get logout;
  String get logoutConfirmation;
  String get cancel;
  String get memberSince;
  String get trips;
  String get rating;
  String get favoritesCount;
  String get language;
  String get selectLanguage;
  String get lightMode;
  String get darkMode;
  String get helpSupport;
  String get aboutUs;
  String get profileUpdated;
  String get fullName;
  String get enterFullName;
  String get phoneNumber;
  String get enterPhoneNumber;
  String get invalidPhoneNumber;
  String get address;
  String get enterAddress;
  String get addCardPlaceholder;
  String get helpSupportPlaceholder;
  String get aboutUsPlaceholder;
  String get personalIdCard;
  String get pleaseUploadIdCard;
  String get driversLicense;
  String get pleaseUploadDriversLicense;
  String get nationalIdNumber;
  String get enterNationalIdNumber;
  String get drivingLicenseNumber;
  String get enterDrivingLicenseNumber;
  String get drivingLicenseExpiry;
  String get pleaseSelectDrivingLicenseExpiry;
  String get personalIdCardImage;
  String get driversLicenseImage;
  String get failedToUpdateProfile;
  String get notAvailable;
  String get tapToUpload;
  String get completeAllFields;
  String get skipProfileCompletion;
  String get profileUpdateFailed;

  // Authentication strings
  String get resetPassword;
  String get newPassword;
  String get confirmPassword;
  String get verifyCode;
  String get verificationCodeSent;
  String get enterCode;
  String get resendCode;

  // Payment-related strings
  String get addNewCard;
  String get saveCard;
  String get cardholderName;
  String get cardNumber;
  String get expiryDate;
  String get cvv;
  String get cardholderNameEmptyError;
  String get cardNumberEmptyError;
  String get cardNumberInvalidError;
  String get expiryDateEmptyError;
  String get expiryDateInvalidError;
  String get expiryDateExpiredError;
  String get cvvEmptyError;
  String get cvvInvalidError;
  String get eReceipt;
  String get paymentMethods;
  String get continueButton;
  String get paymentSuccessful;
  String get reviewSummary;
  String get confirmAndPay;
  String get paymentSummary;
  String get subTotal;
  String get tax;
  String get total;
  String get withDriver;
  String get selfDrive;
  String get bookingDetails;
  String get cancellationPolicy;
  String carRentalDays(int days);
  String driverFeeDays(int days);
  String get paymentMethod;
  String get changePaymentMethod;
  String get verificationCode;
  String get showVerificationCodeInstruction;
  String get termsAndConditions;
  String get customerInformation;
  String get carDetails;
  String get rentalPeriod;
  String get locations;
  String get thankYouMessage;
  String get customerSupportContact;
  String get shareReceipt;
  String get shareReceiptPrompt;
  String get downloadReceipt;
  String get receiptSharedSuccess;
  String get receiptDownloadedSuccess;
  String get selectPaymentMethodError;
  String get retry;
  String get bookingId;
  String get paymentDate;
  String get name;
  String get email;
  String get phone;
  String get car;
  String get licensePlate;
  String get rentalType;
  String get pickup;
  String get returnLabel;
  String days(int count);
  String get paymentStatusCompleted;
  String visaEnding(String lastFour);
  String verificationCodeValue(String code);
  String get termsAndConditionsDetails;
  String failedToLoadReceipt(String error);
  String get savedPaymentMethods;
  String get noPaymentMethods;
  String get defaultLabel;
  String cardNumberEnding(String last4);
  String expires(String date);
  String get wallet;
  String get nuviaWallet;
  String balance(String amount);
  String failedToLoadSummary(String error);
  String paymentFailed(String error);
  String get pickupLocation;
  String get returnLocation;
  String get duration;
  String paymentStatus(String status);
  String get cancellationPolicyDetails;
  String get securePaymentInfo;
  String get saveCardForFuture;
  String get bookingConfirmedMessage;
  String get viewReceipt;
  String get returnToHome;
  String get bookingConfirmationDetails;
  String get cardNumberRequired;
  String get cardholderNameRequired;
  String get invalidCardNumber;
  String get expiryDateRequired;
  String get invalidExpiryDate;
  String get invalidMonth;
  String get cardExpired;
  String get cvvRequired;
  String get pickupDate;
  String get totalAmount;
  String get goToMyBookings;

  // Filter and search strings
  String get filters;
  String get priceRangePerDay;
  String get carType;
  String get fuelType;
  String get transmission;
  String get applyFilters;
  String get resetAll;
  String get startSearching;
  String get featuredCars;
  String get popularCities;
  String get writeReview;

  // BookCarScreen strings
  String get pickupTime;
  String get startDate;
  String get endDate;
  String get returnTime;
  String get addOnsExtras;
  String get priceSummary;
  String get add;
  String get carRental;

  // CarCard strings
  String get addedToFavorites;
  String get removedFromFavorites;

  // ChatScreen strings
  String get noMessagesYet;
  String get startTheConversation;
  String get typeAMessage;
  String get deleteConversation;
  String get viewBooking;
  String get blockContact;
  String get reportIssue;
  String get voiceNoteRecording;
  String get voiceNoteSeconds;
  String get online; // Added
  String get offline; // Added
  String get calling; // Added

  // DocumentUploadScreen strings
  String get documentUpload;
  String get documentVerificationRequired;
  String get documentVerificationInstructions;
  String get identityCard;
  String get driverLicense;
  String get tapToUploadIdCard;
  String get tapToUploadDriverLicense;
  String get requestCarDelivery;
  String get deliveryExplanation;
  String get deliveryLocation;
  String get useCurrentLocation;
  String get deliveryAddress;
  String get tapMapToSelectLocation;
  String get continueToPayment;
  String get camera;
  String get gallery;

  // Location-related strings
  String get locationServiceDisabled;
  String get locationPermissionDenied;
  String get locationError;
  String get locationDataInvalid;
}

// Delegate class for AppLocalizations
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    if (locale.languageCode == 'ar') {
      return AppLocalizationsAr();
    }
    return AppLocalizationsEn();
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}