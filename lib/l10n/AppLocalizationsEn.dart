import 'package:flutter/material.dart';

import 'AppLocalizations.dart';

class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr() : super('ar');

  @override
  String get appName => 'تطبيق تأجير السيارات';

  @override
  String get home => 'الرئيسية';

  @override
  String get explore => 'استكشاف';

  @override
  String get bookings => 'الحجوزات';

  @override
  String get chat => 'الدردشة';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get popular => 'شائع';

  @override
  String get popularCars => 'السيارات الشائعة';

  @override
  String get noPopularCars => 'لا توجد سيارات شائعة متاحة في هذا الموقع';

  @override
  String get sortBy => 'ترتيب حسب';

  @override
  String get topRated => 'الأعلى تقييمًا';

  @override
  String get priceLowToHigh => 'السعر: من الأقل إلى الأعلى';

  @override
  String get priceHighToLow => 'السعر: من الأعلى إلى الأقل';

  @override
  String get newest => 'الأحدث';

  @override
  String get search => 'بحث';

  @override
  String get searchCarsByBrandOrModel => 'ابحث عن السيارات حسب العلامة التجارية أو الطراز';

  @override
  String noSearchResults(String searchTerm) => 'لم يتم العثور على نتائج لـ "$searchTerm"';

  @override
  String get trySearching => 'حاول البحث عن سيارة';

  @override
  String get tryChangingFilters => 'حاول تغيير الفلاتر أو مصطلح البحث';

  @override
  String get bookCar => 'حجز سيارة';

  @override
  String get bookNow => 'احجز الآن';

  @override
  String get confirmBooking => 'تأكيد الحجز';

  @override
  String get processing => 'جارٍ المعالجة...';

  @override
  String get back => 'رجوع';

  @override
  String get details => 'التفاصيل';

  @override
  String get features => 'الميزات';

  @override
  String get reviews => 'التقييمات';

  @override
  String seatsCount(int count) => '$count مقاعد';

  @override
  String get noReviews => 'لا توجد تقييمات بعد';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get day => 'يوم';

  @override
  String get perDay => 'لكل يوم';

  @override
  String get carNotFound => 'السيارة غير موجودة';

  @override
  String get enterLocation => 'أدخل الموقع';

  @override
  String get selectGovernorate => 'اختر المحافظة';

  @override
  String get chooseDifferentGovernorate => 'اختر محافظة مختلفة';

  @override
  String get selectLocation => 'اختر الموقع';

  @override
  String get confirm => 'تأكيد';

  @override
  String get noSelectedCars => 'لم يتم اختيار سيارات';

  @override
  String get brand => 'العلامة التجارية';

  // Notification strings
  @override
  String get notifications => 'الإشعارات';

  @override
  String get noNotifications => 'لا توجد إشعارات';

  @override
  String get youHaveNoNotificationsYet => 'ليس لديك إشعارات بعد';

  @override
  String get markAllAsRead => 'وضع علامة على الكل كمقروء';

  @override
  String get allNotificationsMarkedAsRead => 'تم وضع علامة على جميع الإشعارات كمقروءة';

  // Favorites and onboarding strings
  @override
  String get favorites => 'المفضلة';

  @override
  String get skip => 'تخطي';

  @override
  String get proceed => 'متابعة';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get next => 'التالي';

  @override
  String get welcomeSubtitle => 'استأجر سيارة أحلامك بسهولة';

  @override
  String get onboardingFindCarsTitle => 'ابحث عن سيارتك المثالية';

  @override
  String get onboardingFindCarsDescription =>
      'تصفح مجموعة واسعة من السيارات من مزودين موثوقين';

  @override
  String get onboardingEasyBookingTitle => 'عملية حجز سهلة';

  @override
  String get onboardingEasyBookingDescription =>
      'احجز سيارتك في خطوات بسيطة قليلة';

  @override
  String get onboardingSecurePaymentTitle => 'مدفوعات آمنة';

  @override
  String get onboardingSecurePaymentDescription =>
      'ادفع بثقة باستخدام نظام الدفع الآمن الخاص بنا';

  @override
  String failedToSavePreferences(String error) =>
      'فشل في حفظ التفضيلات: $error';

  @override
  String get imageLoadError => 'فشل في تحميل الصورة';

  @override
  String onboardingImage(int index) => 'صورة الإرشاد $index';

  // Profile-related strings
  @override
  String get completeYourProfile => 'أكمل ملفك الشخصي';

  @override
  String get profileCompletionMsg =>
      'يرجى إكمال ملفك الشخصي لمتابعة استخدام التطبيق';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get gender => 'الجنس';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get other => 'آخر';

  @override
  String get pleaseSelectDateOfBirth => 'يرجى اختيار تاريخ الميلاد';

  @override
  String get pleaseSelectGender => 'يرجى اختيار الجنس';

  @override
  String get save => 'حفظ';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get personalInformation => 'المعلومات الشخصية';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirmation => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get memberSince => 'عضو منذ';

  @override
  String get trips => 'الرحلات';

  @override
  String get rating => 'التقييم';

  @override
  String get favoritesCount => 'المفضلة';

  @override
  String get language => 'اللغة';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get helpSupport => 'المساعدة والدعم';

  @override
  String get aboutUs => 'معلومات عنا';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get enterFullName => 'أدخل اسمك الكامل';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get enterPhoneNumber => 'أدخل رقم هاتفك';

  @override
  String get invalidPhoneNumber => 'رقم الهاتف غير صالح';

  @override
  String get address => 'العنوان';

  @override
  String get enterAddress => 'أدخل عنوانك';

  @override
  String get addCardPlaceholder => 'أضف بطاقة دفع جديدة';

  @override
  String get helpSupportPlaceholder => 'تواصل مع فريق الدعم لدينا';

  @override
  String get aboutUsPlaceholder => 'تعرف على المزيد عن شركتنا';

  @override
  String get personalIdCard => 'بطاقة الهوية الشخصية';

  @override
  String get pleaseUploadIdCard => 'يرجى رفع بطاقة الهوية الخاصة بك';

  @override
  String get driversLicense => 'رخصة القيادة';

  @override
  String get pleaseUploadDriversLicense => 'يرجى رفع رخصة القيادة الخاصة بك';

  @override
  String get nationalIdNumber => 'رقم الهوية الوطنية';

  @override
  String get enterNationalIdNumber => 'أدخل رقم الهوية الوطنية';

  @override
  String get drivingLicenseNumber => 'رقم رخصة القيادة';

  @override
  String get enterDrivingLicenseNumber => 'أدخل رقم رخصة القيادة';

  @override
  String get drivingLicenseExpiry => 'تاريخ انتهاء رخصة القيادة';

  @override
  String get pleaseSelectDrivingLicenseExpiry =>
      'يرجى اختيار تاريخ انتهاء رخصة القيادة';

  @override
  String get personalIdCardImage => 'صورة بطاقة الهوية الشخصية';

  @override
  String get driversLicenseImage => 'صورة رخصة القيادة';

  @override
  String get failedToUpdateProfile => 'فشل في تحديث الملف الشخصي';

  @override
  String get notAvailable => 'غير متاح';

  @override
  String get tapToUpload => 'اضغط للرفع';

  @override
  String get completeAllFields => 'يرجى إكمال جميع الحقول';

  @override
  String get skipProfileCompletion => 'تخطي إكمال الملف الشخصي';

  @override
  String get profileUpdateFailed => 'فشل تحديث الملف الشخصي';

  // Authentication strings
  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get verifyCode => 'تأكيد الرمز';

  @override
  String get verificationCodeSent => 'تم إرسال رمز التحقق';

  @override
  String get enterCode => 'أدخل الرمز';

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  // Payment-related strings
  @override
  String get addNewCard => 'إضافة بطاقة جديدة';

  @override
  String get saveCard => 'حفظ البطاقة';

  @override
  String get cardholderName => 'اسم حامل البطاقة';

  @override
  String get cardNumber => 'رقم البطاقة';

  @override
  String get expiryDate => 'تاريخ الانتهاء';

  @override
  String get cvv => 'CVV';

  @override
  String get cardholderNameEmptyError => 'اسم حامل البطاقة لا يمكن أن يكون فارغًا';

  @override
  String get cardNumberEmptyError => 'رقم البطاقة لا يمكن أن يكون فارغًا';

  @override
  String get cardNumberInvalidError => 'رقم البطاقة غير صالح';

  @override
  String get expiryDateEmptyError => 'تاريخ الانتهاء لا يمكن أن يكون فارغًا';

  @override
  String get expiryDateInvalidError => 'تاريخ الانتهاء غير صالح';

  @override
  String get expiryDateExpiredError => 'البطاقة منتهية الصلاحية';

  @override
  String get cvvEmptyError => 'CVV لا يمكن أن يكون فارغًا';

  @override
  String get cvvInvalidError => 'CVV غير صالح';

  @override
  String get eReceipt => 'الإيصال الإلكتروني';

  @override
  String get paymentMethods => 'طرق الدفع';

  @override
  String get continueButton => 'متابعة';

  @override
  String get paymentSuccessful => 'الدفع ناجح';

  @override
  String get reviewSummary => 'مراجعة الملخص';

  @override
  String get confirmAndPay => 'تأكيد والدفع';

  @override
  String get paymentSummary => 'ملخص الدفع';

  @override
  String get subTotal => 'المجموع الفرعي';

  @override
  String get tax => 'الضريبة';

  @override
  String get total => 'الإجمالي';

  @override
  String get withDriver => 'مع سائق';

  @override
  String get selfDrive => 'قيادة ذاتية';

  @override
  String get bookingDetails => 'تفاصيل الحجز';

  @override
  String get cancellationPolicy => 'سياسة الإلغاء';

  @override
  String carRentalDays(int days) => 'تأجير السيارة ($days أيام)';

  @override
  String driverFeeDays(int days) => 'رسوم السائق ($days أيام)';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get changePaymentMethod => 'تغيير طريقة الدفع';

  @override
  String get verificationCode => 'رمز التحقق';

  @override
  String get showVerificationCodeInstruction =>
      'أظهر هذا الرمز لمزود السيارة عند الاستلام';

  @override
  String get termsAndConditions => 'الشروط والأحكام';

  @override
  String get customerInformation => 'معلومات العميل';

  @override
  String get carDetails => 'تفاصيل السيارة';

  @override
  String get rentalPeriod => 'فترة التأجير';

  @override
  String get locations => 'المواقع';

  @override
  String get thankYouMessage => 'شكرًا على حجزك!';

  @override
  String get customerSupportContact =>
      'تواصل مع فريق الدعم لدينا على support@carrental.com';

  @override
  String get shareReceipt => 'مشاركة الإيصال';

  @override
  String get shareReceiptPrompt => 'هل ترغب في مشاركة هذا الإيصال؟';

  @override
  String get downloadReceipt => 'تنزيل الإيصال';

  @override
  String get receiptSharedSuccess => 'تم مشاركة الإيصال بنجاح';

  @override
  String get receiptDownloadedSuccess => 'تم تنزيل الإيصال بنجاح';

  @override
  String get selectPaymentMethodError => 'يرجى اختيار طريقة دفع';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get bookingId => 'معرف الحجز';

  @override
  String get paymentDate => 'تاريخ الدفع';

  @override
  String get name => 'الاسم';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get phone => 'الهاتف';

  @override
  String get car => 'السيارة';

  @override
  String get licensePlate => 'لوحة الترخيص';

  @override
  String get rentalType => 'نوع التأجير';

  @override
  String get pickup => 'الاستلام';

  @override
  String get returnLabel => 'الإرجاع';

  @override
  String days(int count) => '$count أيام';

  @override
  String get paymentStatusCompleted => 'اكتمل الدفع';

  @override
  String visaEnding(String lastFour) => 'فيزا تنتهي بـ $lastFour';

  @override
  String verificationCodeValue(String code) => 'رمز التحقق: $code';

  @override
  String get termsAndConditionsDetails =>
      'بحجزك، فإنك توافق على شروطنا وأحكامنا.';

  @override
  String failedToLoadReceipt(String error) => 'فشل في تحميل الإيصال: $error';

  @override
  String get savedPaymentMethods => 'طرق الدفع المحفوظة';

  @override
  String get noPaymentMethods => 'لا توجد طرق دفع محفوظة';

  @override
  String get defaultLabel => 'الافتراضي';

  @override
  String cardNumberEnding(String last4) => 'البطاقة تنتهي بـ $last4';

  @override
  String expires(String date) => 'تنتهي في $date';

  @override
  String get wallet => 'المحفظة';

  @override
  String get nuviaWallet => 'محفظة نوفيا';

  @override
  String balance(String amount) => 'الرصيد: $amount';

  @override
  String failedToLoadSummary(String error) => 'فشل في تحميل الملخص: $error';

  @override
  String paymentFailed(String error) => 'فشل الدفع: $error';

  @override
  String get pickupLocation => 'موقع الاستلام';

  @override
  String get returnLocation => 'موقع الإرجاع';

  @override
  String get duration => 'المدة';

  @override
  String paymentStatus(String status) => 'حالة الدفع: $status';

  @override
  String get cancellationPolicyDetails =>
      'إلغاء مجاني حتى 24 ساعة قبل الاستلام';

  @override
  String get securePaymentInfo => 'معلومات الدفع الخاصة بك آمنة';

  @override
  String get saveCardForFuture => 'حفظ البطاقة للمدفوعات المستقبلية';

  @override
  String get bookingConfirmedMessage => 'تم تأكيد حجزك!';

  @override
  String get viewReceipt => 'عرض الإيصال';

  @override
  String get returnToHome => 'العودة إلى الرئيسية';

  @override
  String get bookingConfirmationDetails =>
      'ستتلقى بريدًا إلكترونيًا للتأكيد قريبًا';

  @override
  String get cardNumberRequired => 'رقم البطاقة مطلوب';

  @override
  String get cardholderNameRequired => 'اسم حامل البطاقة مطلوب';

  @override
  String get invalidCardNumber => 'رقم البطاقة غير صالح';

  @override
  String get expiryDateRequired => 'تاريخ الانتهاء مطلوب';

  @override
  String get invalidExpiryDate => 'تاريخ الانتهاء غير صالح';

  @override
  String get invalidMonth => 'شهر غير صالح';

  @override
  String get cardExpired => 'البطاقة منتهية الصلاحية';

  @override
  String get cvvRequired => 'CVV مطلوب';

  @override
  String get pickupDate => 'تاريخ الاستلام';

  @override
  String get totalAmount => 'المبلغ الإجمالي';

  @override
  String get goToMyBookings => 'الذهاب إلى حجوزاتي';

  // Filter and search strings
  @override
  String get filters => 'الفلاتر';

  @override
  String get priceRangePerDay => 'نطاق السعر (لكل يوم)';

  @override
  String get carType => 'نوع السيارة';

  @override
  String get fuelType => 'نوع الوقود';

  @override
  String get transmission => 'ناقل الحركة';

  @override
  String get applyFilters => 'تطبيق الفلاتر';

  @override
  String get resetAll => 'إعادة تعيين الكل';

  @override
  String get startSearching => 'ابدأ البحث';

  @override
  String get featuredCars => 'السيارات المميزة';

  @override
  String get popularCities => 'المدن الشائعة';

  @override
  String get writeReview => 'كتابة تقييم';

  // BookCarScreen strings
  @override
  String get pickupTime => 'وقت الاستلام';

  @override
  String get startDate => 'تاريخ البدء';

  @override
  String get endDate => 'تاريخ الانتهاء';

  @override
  String get returnTime => 'وقت الإرجاع';

  @override
  String get addOnsExtras => 'الإضافات والخدمات الإضافية';

  @override
  String get priceSummary => 'ملخص السعر';

  @override
  String get add => 'إضافة';

  @override
  String get carRental => 'تأجير السيارة';

  // CarCard strings
  @override
  String get addedToFavorites => 'تمت الإضافة إلى المفضلة';

  @override
  String get removedFromFavorites => 'تمت الإزالة من المفضلة';

  // ChatScreen strings
  @override
  String get noMessagesYet => 'لا توجد رسائل بعد';

  @override
  String get startTheConversation => 'ابدأ المحادثة';

  @override
  String get typeAMessage => 'اكتب رسالة';

  @override
  String get deleteConversation => 'حذف المحادثة';

  @override
  String get viewBooking => 'عرض الحجز';

  @override
  String get blockContact => 'حظر جهة الاتصال';

  @override
  String get reportIssue => 'الإبلاغ عن مشكلة';

  @override
  String get voiceNoteRecording => 'تسجيل ملاحظة صوتية...';

  @override
  String get voiceNoteSeconds => 'ثوانٍ';

  @override
  String get online => 'متصل'; // Added

  @override
  String get offline => 'غير متصل'; // Added

  @override
  String get calling => 'يتصل'; // Added

  // DocumentUploadScreen strings
  @override
  String get documentUpload => 'رفع المستندات';

  @override
  String get documentVerificationRequired => 'التحقق من المستندات مطلوب';

  @override
  String get documentVerificationInstructions =>
      'يرجى رفع المستندات المطلوبة للتحقق من هويتك';

  @override
  String get identityCard => 'بطاقة الهوية';

  @override
  String get driverLicense => 'رخصة القيادة';

  @override
  String get tapToUploadIdCard => 'اضغط لرفع بطاقة الهوية';

  @override
  String get tapToUploadDriverLicense => 'اضغط لرفع رخصة القيادة';

  @override
  String get requestCarDelivery => 'طلب توصيل السيارة';

  @override
  String get deliveryExplanation =>
      'اطلب توصيل السيارة إلى موقعك المفضل';

  @override
  String get deliveryLocation => 'موقع التوصيل';

  @override
  String get useCurrentLocation => 'استخدام الموقع الحالي';

  @override
  String get deliveryAddress => 'عنوان التوصيل';

  @override
  String get tapMapToSelectLocation => 'اضغط على الخريطة لاختيار الموقع';

  @override
  String get continueToPayment => 'المتابعة إلى الدفع';

  @override
  String get camera => 'الكاميرا';

  @override
  String get gallery => 'المعرض';

  // Location-related strings
  @override
  String get locationServiceDisabled => 'خدمات الموقع معطلة';

  @override
  String get locationPermissionDenied => 'تم رفض إذن الموقع';

  @override
  String get locationError => 'خطأ في استرداد الموقع';

  @override
  String get locationDataInvalid => 'بيانات الموقع غير صالحة';
}