import 'package:flutter/material.dart';

import 'AppLocalizations.dart';

class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn() : super('en');

  @override
  String get appName => 'Car Rental App';

  @override
  String get home => 'Home';

  @override
  String get explore => 'Explore';

  @override
  String get bookings => 'Bookings';

  @override
  String get chat => 'Chat';

  @override
  String get profile => 'Profile';

  @override
  String get popular => 'Popular';

  @override
  String get popularCars => 'Popular Cars';

  @override
  String get noPopularCars => 'No popular cars available in this location';

  @override
  String get sortBy => 'Sort By';

  @override
  String get topRated => 'Top Rated';

  @override
  String get priceLowToHigh => 'Price: Low to High';

  @override
  String get priceHighToLow => 'Price: High to Low';

  @override
  String get newest => 'Newest';

  @override
  String get search => 'Search';

  @override
  String get searchCarsByBrandOrModel => 'Search cars by brand or model';

  @override
  String noSearchResults(String searchTerm) => 'No results found for "$searchTerm"';

  @override
  String get trySearching => 'Try searching for a car';

  @override
  String get tryChangingFilters => 'Try changing the filters or search term';

  @override
  String get bookCar => 'Book Car';

  @override
  String get bookNow => 'Book Now';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String get processing => 'Processing...';

  @override
  String get back => 'Back';

  @override
  String get details => 'Details';

  @override
  String get features => 'Features';

  @override
  String get reviews => 'Reviews';

  @override
  String seatsCount(int count) => '$count Seats';

  @override
  String get noReviews => 'No reviews yet';

  @override
  String get seeAll => 'See All';

  @override
  String get day => 'Day';

  @override
  String get perDay => 'Per Day';

  @override
  String get carNotFound => 'Car not found';

  @override
  String get enterLocation => 'Enter Location';

  @override
  String get selectGovernorate => 'Select Governorate';

  @override
  String get chooseDifferentGovernorate => 'Choose a Different Governorate';

  @override
  String get selectLocation => 'Select Location';

  @override
  String get confirm => 'Confirm';

  @override
  String get noSelectedCars => 'No cars selected';

  @override
  String get brand => 'Brand';

  // Notification strings
  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'No Notifications';

  @override
  String get youHaveNoNotificationsYet => 'You have no notifications yet';

  @override
  String get markAllAsRead => 'Mark All as Read';

  @override
  String get allNotificationsMarkedAsRead => 'All notifications marked as read';

  // Favorites and onboarding strings
  @override
  String get favorites => 'Favorites';

  @override
  String get skip => 'Skip';

  @override
  String get proceed => 'Proceed';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get welcomeSubtitle => 'Rent your dream car with ease';

  @override
  String get onboardingFindCarsTitle => 'Find Your Perfect Car';

  @override
  String get onboardingFindCarsDescription =>
      'Browse a wide range of cars from trusted providers';

  @override
  String get onboardingEasyBookingTitle => 'Easy Booking Process';

  @override
  String get onboardingEasyBookingDescription =>
      'Book your car in just a few simple steps';

  @override
  String get onboardingSecurePaymentTitle => 'Secure Payments';

  @override
  String get onboardingSecurePaymentDescription =>
      'Pay with confidence using our secure payment system';

  @override
  String failedToSavePreferences(String error) =>
      'Failed to save preferences: $error';

  @override
  String get imageLoadError => 'Failed to load image';

  @override
  String onboardingImage(int index) => 'Onboarding Image $index';

  // Profile-related strings
  @override
  String get completeYourProfile => 'Complete Your Profile';

  @override
  String get profileCompletionMsg =>
      'Please complete your profile to continue using the app';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get other => 'Other';

  @override
  String get pleaseSelectDateOfBirth => 'Please select your date of birth';

  @override
  String get pleaseSelectGender => 'Please select your gender';

  @override
  String get save => 'Save';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get memberSince => 'Member Since';

  @override
  String get trips => 'Trips';

  @override
  String get rating => 'Rating';

  @override
  String get favoritesCount => 'Favorites';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get aboutUs => 'About Us';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterFullName => 'Enter your full name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get enterPhoneNumber => 'Enter your phone number';

  @override
  String get invalidPhoneNumber => 'Invalid phone number';

  @override
  String get address => 'Address';

  @override
  String get enterAddress => 'Enter your address';

  @override
  String get addCardPlaceholder => 'Add a new payment card';

  @override
  String get helpSupportPlaceholder => 'Contact our support team';

  @override
  String get aboutUsPlaceholder => 'Learn more about our company';

  @override
  String get personalIdCard => 'Personal ID Card';

  @override
  String get pleaseUploadIdCard => 'Please upload your ID card';

  @override
  String get driversLicense => 'Driver\'s License';

  @override
  String get pleaseUploadDriversLicense => 'Please upload your driver\'s license';

  @override
  String get nationalIdNumber => 'National ID Number';

  @override
  String get enterNationalIdNumber => 'Enter your national ID number';

  @override
  String get drivingLicenseNumber => 'Driving License Number';

  @override
  String get enterDrivingLicenseNumber => 'Enter your driving license number';

  @override
  String get drivingLicenseExpiry => 'Driving License Expiry';

  @override
  String get pleaseSelectDrivingLicenseExpiry =>
      'Please select your driving license expiry date';

  @override
  String get personalIdCardImage => 'Personal ID Card Image';

  @override
  String get driversLicenseImage => 'Driver\'s License Image';

  @override
  String get failedToUpdateProfile => 'Failed to update profile';

  @override
  String get notAvailable => 'Not Available';

  @override
  String get tapToUpload => 'Tap to Upload';

  @override
  String get completeAllFields => 'Please complete all fields';

  @override
  String get skipProfileCompletion => 'Skip Profile Completion';

  @override
  String get profileUpdateFailed => 'Profile update failed';

  // Authentication strings
  @override
  String get resetPassword => 'Reset Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get verifyCode => 'Verify Code';

  @override
  String get verificationCodeSent => 'Verification code sent';

  @override
  String get enterCode => 'Enter Code';

  @override
  String get resendCode => 'Resend Code';

  // Payment-related strings
  @override
  String get addNewCard => 'Add New Card';

  @override
  String get saveCard => 'Save Card';

  @override
  String get cardholderName => 'Cardholder Name';

  @override
  String get cardNumber => 'Card Number';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get cvv => 'CVV';

  @override
  String get cardholderNameEmptyError => 'Cardholder name cannot be empty';

  @override
  String get cardNumberEmptyError => 'Card number cannot be empty';

  @override
  String get cardNumberInvalidError => 'Invalid card number';

  @override
  String get expiryDateEmptyError => 'Expiry date cannot be empty';

  @override
  String get expiryDateInvalidError => 'Invalid expiry date';

  @override
  String get expiryDateExpiredError => 'Card has expired';

  @override
  String get cvvEmptyError => 'CVV cannot be empty';

  @override
  String get cvvInvalidError => 'Invalid CVV';

  @override
  String get eReceipt => 'E-Receipt';

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get continueButton => 'Continue';

  @override
  String get paymentSuccessful => 'Payment Successful';

  @override
  String get reviewSummary => 'Review Summary';

  @override
  String get confirmAndPay => 'Confirm and Pay';

  @override
  String get paymentSummary => 'Payment Summary';

  @override
  String get subTotal => 'Subtotal';

  @override
  String get tax => 'Tax';

  @override
  String get total => 'Total';

  @override
  String get withDriver => 'With Driver';

  @override
  String get selfDrive => 'Self Drive';

  @override
  String get bookingDetails => 'Booking Details';

  @override
  String get cancellationPolicy => 'Cancellation Policy';

  @override
  String carRentalDays(int days) => 'Car Rental ($days days)';

  @override
  String driverFeeDays(int days) => 'Driver Fee ($days days)';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get changePaymentMethod => 'Change Payment Method';

  @override
  String get verificationCode => 'Verification Code';

  @override
  String get showVerificationCodeInstruction =>
      'Show this code to the car provider at pickup';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get customerInformation => 'Customer Information';

  @override
  String get carDetails => 'Car Details';

  @override
  String get rentalPeriod => 'Rental Period';

  @override
  String get locations => 'Locations';

  @override
  String get thankYouMessage => 'Thank you for your booking!';

  @override
  String get customerSupportContact =>
      'Contact our support team at support@carrental.com';

  @override
  String get shareReceipt => 'Share Receipt';

  @override
  String get shareReceiptPrompt => 'Would you like to share this receipt?';

  @override
  String get downloadReceipt => 'Download Receipt';

  @override
  String get receiptSharedSuccess => 'Receipt shared successfully';

  @override
  String get receiptDownloadedSuccess => 'Receipt downloaded successfully';

  @override
  String get selectPaymentMethodError => 'Please select a payment method';

  @override
  String get retry => 'Retry';

  @override
  String get bookingId => 'Booking ID';

  @override
  String get paymentDate => 'Payment Date';

  @override
  String get name => 'Name';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone';

  @override
  String get car => 'Car';

  @override
  String get licensePlate => 'License Plate';

  @override
  String get rentalType => 'Rental Type';

  @override
  String get pickup => 'Pickup';

  @override
  String get returnLabel => 'Return';

  @override
  String days(int count) => '$count Days';

  @override
  String get paymentStatusCompleted => 'Payment Completed';

  @override
  String visaEnding(String lastFour) => 'Visa ending in $lastFour';

  @override
  String verificationCodeValue(String code) => 'Verification Code: $code';

  @override
  String get termsAndConditionsDetails =>
      'By booking, you agree to our terms and conditions.';

  @override
  String failedToLoadReceipt(String error) => 'Failed to load receipt: $error';

  @override
  String get savedPaymentMethods => 'Saved Payment Methods';

  @override
  String get noPaymentMethods => 'No payment methods saved';

  @override
  String get defaultLabel => 'Default';

  @override
  String cardNumberEnding(String last4) => 'Card ending in $last4';

  @override
  String expires(String date) => 'Expires $date';

  @override
  String get wallet => 'Wallet';

  @override
  String get nuviaWallet => 'Nuvia Wallet';

  @override
  String balance(String amount) => 'Balance: $amount';

  @override
  String failedToLoadSummary(String error) => 'Failed to load summary: $error';

  @override
  String paymentFailed(String error) => 'Payment failed: $error';

  @override
  String get pickupLocation => 'Pickup Location';

  @override
  String get returnLocation => 'Return Location';

  @override
  String get duration => 'Duration';

  @override
  String paymentStatus(String status) => 'Payment Status: $status';

  @override
  String get cancellationPolicyDetails =>
      'Free cancellation up to 24 hours before pickup';

  @override
  String get securePaymentInfo => 'Your payment information is secure';

  @override
  String get saveCardForFuture => 'Save card for future payments';

  @override
  String get bookingConfirmedMessage => 'Your booking has been confirmed!';

  @override
  String get viewReceipt => 'View Receipt';

  @override
  String get returnToHome => 'Return to Home';

  @override
  String get bookingConfirmationDetails =>
      'You will receive a confirmation email shortly';

  @override
  String get cardNumberRequired => 'Card number is required';

  @override
  String get cardholderNameRequired => 'Cardholder name is required';

  @override
  String get invalidCardNumber => 'Invalid card number';

  @override
  String get expiryDateRequired => 'Expiry date is required';

  @override
  String get invalidExpiryDate => 'Invalid expiry date';

  @override
  String get invalidMonth => 'Invalid month';

  @override
  String get cardExpired => 'Card has expired';

  @override
  String get cvvRequired => 'CVV is required';

  @override
  String get pickupDate => 'Pickup Date';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get goToMyBookings => 'Go to My Bookings';

  // Filter and search strings
  @override
  String get filters => 'Filters';

  @override
  String get priceRangePerDay => 'Price Range (Per Day)';

  @override
  String get carType => 'Car Type';

  @override
  String get fuelType => 'Fuel Type';

  @override
  String get transmission => 'Transmission';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get resetAll => 'Reset All';

  @override
  String get startSearching => 'Start Searching';

  @override
  String get featuredCars => 'Featured Cars';

  @override
  String get popularCities => 'Popular Cities';

  @override
  String get writeReview => 'Write Review';

  // BookCarScreen strings
  @override
  String get pickupTime => 'Pickup Time';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get returnTime => 'Return Time';

  @override
  String get addOnsExtras => 'Add-ons & Extras';

  @override
  String get priceSummary => 'Price Summary';

  @override
  String get add => 'Add';

  @override
  String get carRental => 'Car Rental';

  // CarCard strings
  @override
  String get addedToFavorites => 'Added to favorites';

  @override
  String get removedFromFavorites => 'Removed from favorites';

  // ChatScreen strings
  @override
  String get noMessagesYet => 'No messages yet';

  @override
  String get startTheConversation => 'Start the conversation';

  @override
  String get typeAMessage => 'Type a message';

  @override
  String get deleteConversation => 'Delete Conversation';

  @override
  String get viewBooking => 'View Booking';

  @override
  String get blockContact => 'Block Contact';

  @override
  String get reportIssue => 'Report Issue';

  @override
  String get voiceNoteRecording => 'Recording voice note...';

  @override
  String get voiceNoteSeconds => 'Seconds';

  @override
  String get online => 'Online'; // Added

  @override
  String get offline => 'Offline'; // Added

  @override
  String get calling => 'Calling'; // Added

  // DocumentUploadScreen strings
  @override
  String get documentUpload => 'Document Upload';

  @override
  String get documentVerificationRequired => 'Document Verification Required';

  @override
  String get documentVerificationInstructions =>
      'Please upload the required documents to verify your identity';

  @override
  String get identityCard => 'Identity Card';

  @override
  String get driverLicense => 'Driver License';

  @override
  String get tapToUploadIdCard => 'Tap to upload ID card';

  @override
  String get tapToUploadDriverLicense => 'Tap to upload driver license';

  @override
  String get requestCarDelivery => 'Request Car Delivery';

  @override
  String get deliveryExplanation =>
      'Have the car delivered to your preferred location';

  @override
  String get deliveryLocation => 'Delivery Location';

  @override
  String get useCurrentLocation => 'Use Current Location';

  @override
  String get deliveryAddress => 'Delivery Address';

  @override
  String get tapMapToSelectLocation => 'Tap map to select location';

  @override
  String get continueToPayment => 'Continue to Payment';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  // Location-related strings
  @override
  String get locationServiceDisabled => 'Location services are disabled';

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String get locationError => 'Error retrieving location';

  @override
  String get locationDataInvalid => 'Invalid location data';
}