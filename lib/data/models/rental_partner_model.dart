class RentalPartner {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? logoUrl;
  final String? coverImageUrl;
  final String? description;
  final List<String> carIds;
  final List<String> governorates;
  final RentalPartnerAddress? address;
  final RentalPartnerOperatingHours? operatingHours;
  final PartnerVerificationStatus verificationStatus;
  final String? businessRegistrationNumber;
  final double rating;
  final int reviewCount;
  final DateTime joinedDate;
  final List<PartnerAgent>? agents;
  final Map<String, dynamic>? businessDetails;
  final bool isActive;

  RentalPartner({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.logoUrl,
    this.coverImageUrl,
    this.description,
    required this.carIds,
    required this.governorates,
    this.address,
    this.operatingHours,
    required this.verificationStatus,
    this.businessRegistrationNumber,
    required this.rating,
    required this.reviewCount,
    required this.joinedDate,
    this.agents,
    this.businessDetails,
    required this.isActive,
  });

  factory RentalPartner.fromJson(Map<String, dynamic> json) {
    return RentalPartner(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      logoUrl: json['logoUrl'],
      coverImageUrl: json['coverImageUrl'],
      description: json['description'],
      carIds: List<String>.from(json['carIds'] ?? []),
      governorates: List<String>.from(json['governorates'] ?? []),
      address: json['address'] != null
          ? RentalPartnerAddress.fromJson(json['address'])
          : null,
      operatingHours: json['operatingHours'] != null
          ? RentalPartnerOperatingHours.fromJson(json['operatingHours'])
          : null,
      verificationStatus: PartnerVerificationStatus.values.firstWhere(
            (e) => e.toString() == 'PartnerVerificationStatus.${json['verificationStatus']}',
        orElse: () => PartnerVerificationStatus.pending,
      ),
      businessRegistrationNumber: json['businessRegistrationNumber'],
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      joinedDate: DateTime.parse(json['joinedDate']),
      agents: json['agents'] != null
          ? (json['agents'] as List)
          .map((agent) => PartnerAgent.fromJson(agent))
          .toList()
          : null,
      businessDetails: json['businessDetails'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'logoUrl': logoUrl,
      'coverImageUrl': coverImageUrl,
      'description': description,
      'carIds': carIds,
      'governorates': governorates,
      'address': address?.toJson(),
      'operatingHours': operatingHours?.toJson(),
      'verificationStatus': verificationStatus.toString().split('.').last,
      'businessRegistrationNumber': businessRegistrationNumber,
      'rating': rating,
      'reviewCount': reviewCount,
      'joinedDate': joinedDate.toIso8601String(),
      'agents': agents?.map((agent) => agent.toJson()).toList(),
      'businessDetails': businessDetails,
      'isActive': isActive,
    };
  }

  RentalPartner copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? logoUrl,
    String? coverImageUrl,
    String? description,
    List<String>? carIds,
    List<String>? governorates,
    RentalPartnerAddress? address,
    RentalPartnerOperatingHours? operatingHours,
    PartnerVerificationStatus? verificationStatus,
    String? businessRegistrationNumber,
    double? rating,
    int? reviewCount,
    DateTime? joinedDate,
    List<PartnerAgent>? agents,
    Map<String, dynamic>? businessDetails,
    bool? isActive,
  }) {
    return RentalPartner(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      logoUrl: logoUrl ?? this.logoUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      description: description ?? this.description,
      carIds: carIds ?? this.carIds,
      governorates: governorates ?? this.governorates,
      address: address ?? this.address,
      operatingHours: operatingHours ?? this.operatingHours,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      businessRegistrationNumber: businessRegistrationNumber ?? this.businessRegistrationNumber,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      joinedDate: joinedDate ?? this.joinedDate,
      agents: agents ?? this.agents,
      businessDetails: businessDetails ?? this.businessDetails,
      isActive: isActive ?? this.isActive,
    );
  }
}

enum PartnerVerificationStatus {
  pending,
  verified,
  rejected,
  suspended,
}

class RentalPartnerAddress {
  final String street;
  final String city;
  final String governorate;
  final String? building;
  final String? floor;
  final String? apartment;
  final String? landmark;
  final double latitude;
  final double longitude;
  final String? postalCode;

  RentalPartnerAddress({
    required this.street,
    required this.city,
    required this.governorate,
    this.building,
    this.floor,
    this.apartment,
    this.landmark,
    required this.latitude,
    required this.longitude,
    this.postalCode,
  });

  factory RentalPartnerAddress.fromJson(Map<String, dynamic> json) {
    return RentalPartnerAddress(
      street: json['street'],
      city: json['city'],
      governorate: json['governorate'],
      building: json['building'],
      floor: json['floor'],
      apartment: json['apartment'],
      landmark: json['landmark'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      postalCode: json['postalCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'governorate': governorate,
      'building': building,
      'floor': floor,
      'apartment': apartment,
      'landmark': landmark,
      'latitude': latitude,
      'longitude': longitude,
      'postalCode': postalCode,
    };
  }
}

class RentalPartnerOperatingHours {
  final Map<String, DayHours> weekdays;
  final List<HolidayClosure>? holidays;

  RentalPartnerOperatingHours({
    required this.weekdays,
    this.holidays,
  });

  factory RentalPartnerOperatingHours.fromJson(Map<String, dynamic> json) {
    Map<String, DayHours> weekdaysMap = {};

    if (json['weekdays'] != null) {
      json['weekdays'].forEach((key, value) {
        weekdaysMap[key] = DayHours.fromJson(value);
      });
    }

    return RentalPartnerOperatingHours(
      weekdays: weekdaysMap,
      holidays: json['holidays'] != null
          ? (json['holidays'] as List)
          .map((holiday) => HolidayClosure.fromJson(holiday))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> weekdaysJson = {};

    weekdays.forEach((key, value) {
      weekdaysJson[key] = value.toJson();
    });

    return {
      'weekdays': weekdaysJson,
      'holidays': holidays?.map((holiday) => holiday.toJson()).toList(),
    };
  }
}

class DayHours {
  final String? openTime;
  final String? closeTime;
  final bool isClosed;

  DayHours({
    this.openTime,
    this.closeTime,
    required this.isClosed,
  });

  factory DayHours.fromJson(Map<String, dynamic> json) {
    return DayHours(
      openTime: json['openTime'],
      closeTime: json['closeTime'],
      isClosed: json['isClosed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'openTime': openTime,
      'closeTime': closeTime,
      'isClosed': isClosed,
    };
  }
}

class HolidayClosure {
  final DateTime date;
  final String? reason;
  final bool isFullDay;
  final String? alternateOpenTime;
  final String? alternateCloseTime;

  HolidayClosure({
    required this.date,
    this.reason,
    required this.isFullDay,
    this.alternateOpenTime,
    this.alternateCloseTime,
  });

  factory HolidayClosure.fromJson(Map<String, dynamic> json) {
    return HolidayClosure(
      date: DateTime.parse(json['date']),
      reason: json['reason'],
      isFullDay: json['isFullDay'] ?? true,
      alternateOpenTime: json['alternateOpenTime'],
      alternateCloseTime: json['alternateCloseTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'reason': reason,
      'isFullDay': isFullDay,
      'alternateOpenTime': alternateOpenTime,
      'alternateCloseTime': alternateCloseTime,
    };
  }
}

class PartnerAgent {
  final String id;
  final String name;
  final String? photoUrl;
  final String phoneNumber;
  final String role; // 'manager', 'agent', 'admin'
  final bool isActive;

  PartnerAgent({
    required this.id,
    required this.name,
    this.photoUrl,
    required this.phoneNumber,
    required this.role,
    required this.isActive,
  });

  factory PartnerAgent.fromJson(Map<String, dynamic> json) {
    return PartnerAgent(
      id: json['id'],
      name: json['name'],
      photoUrl: json['photoUrl'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'role': role,
      'isActive': isActive,
    };
  }
}