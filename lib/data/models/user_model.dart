class User {
  final String id;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String? profileImageUrl;
  final String? nationalId;
  final String? drivingLicenseNumber;
  final DateTime? drivingLicenseExpiry;
  final String? address;
  final String? idCardImageUrl; // New field for personal ID card image URL
  final String? driversLicenseImageUrl; // New field for driver's license image URL
  final List<String> favoriteCarIds;
  final List<String> bookingIds;
  final DateTime createdAt;
  final DateTime lastLogin;
  final bool isVerified;
  final UserSettings settings;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    this.profileImageUrl,
    this.nationalId,
    this.drivingLicenseNumber,
    this.drivingLicenseExpiry,
    this.address,
    this.idCardImageUrl,
    this.driversLicenseImageUrl,
    required this.favoriteCarIds,
    required this.bookingIds,
    required this.createdAt,
    required this.lastLogin,
    required this.isVerified,
    required this.settings,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      nationalId: json['nationalId'],
      drivingLicenseNumber: json['drivingLicenseNumber'],
      drivingLicenseExpiry: json['drivingLicenseExpiry'] != null
          ? DateTime.parse(json['drivingLicenseExpiry'])
          : null,
      address: json['address'],
      idCardImageUrl: json['idCardImageUrl'], // New field
      driversLicenseImageUrl: json['driversLicenseImageUrl'], // New field
      favoriteCarIds: List<String>.from(json['favoriteCarIds'] ?? []),
      bookingIds: List<String>.from(json['bookingIds'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      lastLogin: DateTime.parse(json['lastLogin']),
      isVerified: json['isVerified'] ?? false,
      settings: UserSettings.fromJson(json['settings'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'nationalId': nationalId,
      'drivingLicenseNumber': drivingLicenseNumber,
      'drivingLicenseExpiry': drivingLicenseExpiry?.toIso8601String(),
      'address': address,
      'idCardImageUrl': idCardImageUrl, // New field
      'driversLicenseImageUrl': driversLicenseImageUrl, // New field
      'favoriteCarIds': favoriteCarIds,
      'bookingIds': bookingIds,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'isVerified': isVerified,
      'settings': settings.toJson(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? profileImageUrl,
    String? nationalId,
    String? drivingLicenseNumber,
    DateTime? drivingLicenseExpiry,
    String? address,
    String? idCardImageUrl,
    String? driversLicenseImageUrl,
    List<String>? favoriteCarIds,
    List<String>? bookingIds,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isVerified,
    UserSettings? settings,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      nationalId: nationalId ?? this.nationalId,
      drivingLicenseNumber: drivingLicenseNumber ?? this.drivingLicenseNumber,
      drivingLicenseExpiry: drivingLicenseExpiry ?? this.drivingLicenseExpiry,
      address: address ?? this.address,
      idCardImageUrl: idCardImageUrl ?? this.idCardImageUrl,
      driversLicenseImageUrl: driversLicenseImageUrl ?? this.driversLicenseImageUrl,
      favoriteCarIds: favoriteCarIds ?? this.favoriteCarIds,
      bookingIds: bookingIds ?? this.bookingIds,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isVerified: isVerified ?? this.isVerified,
      settings: settings ?? this.settings,
    );
  }
}

class UserSettings {
  final String preferredLanguage;
  final bool darkMode;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool smsNotifications;

  UserSettings({
    required this.preferredLanguage,
    required this.darkMode,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.smsNotifications,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      preferredLanguage: json['preferredLanguage'] ?? 'en',
      darkMode: json['darkMode'] ?? false,
      emailNotifications: json['emailNotifications'] ?? true,
      pushNotifications: json['pushNotifications'] ?? true,
      smsNotifications: json['smsNotifications'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'preferredLanguage': preferredLanguage,
      'darkMode': darkMode,
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'smsNotifications': smsNotifications,
    };
  }

  UserSettings copyWith({
    String? preferredLanguage,
    bool? darkMode,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? smsNotifications,
  }) {
    return UserSettings(
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      darkMode: darkMode ?? this.darkMode,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
    );
  }
}