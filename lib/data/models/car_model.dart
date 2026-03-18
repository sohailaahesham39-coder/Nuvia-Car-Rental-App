class Car {
  final String id;
  final String model;
  final String make;
  final String year;
  final String plateNumber;
  final double pricePerDay;
  final List<String> imageUrls;
  final String governorate;
  final String city;
  final CarLocation location;
  final CarSpecifications specs;
  final List<CarFeature> features;
  final CarAvailability availability;
  final double rating;
  final int reviewCount;
  final String ownerId;
  final String description; // Added field
  final OwnerInfo ownerInfo; // Added field

  Car({
    required this.id,
    required this.model,
    required this.make,
    required this.year,
    required this.plateNumber,
    required this.pricePerDay,
    required this.imageUrls,
    required this.governorate,
    required this.city,
    required this.location,
    required this.specs,
    required this.features,
    required this.availability,
    required this.rating,
    required this.reviewCount,
    required this.ownerId,
    required this.description,
    required this.ownerInfo,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      model: json['model'],
      make: json['make'],
      year: json['year'],
      plateNumber: json['plateNumber'],
      pricePerDay: json['pricePerDay'].toDouble(),
      imageUrls: List<String>.from(json['imageUrls']),
      governorate: json['governorate'],
      city: json['city'],
      location: CarLocation.fromJson(json['location']),
      specs: CarSpecifications.fromJson(json['specs']),
      features: (json['features'] as List)
          .map((feature) => CarFeature.fromJson(feature))
          .toList(),
      availability: CarAvailability.fromJson(json['availability']),
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      ownerId: json['ownerId'],
      description: json['description'] ?? '', // Handle null case
      ownerInfo: OwnerInfo.fromJson(json['ownerInfo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'make': make,
      'year': year,
      'plateNumber': plateNumber,
      'pricePerDay': pricePerDay,
      'imageUrls': imageUrls,
      'governorate': governorate,
      'city': city,
      'location': location.toJson(),
      'specs': specs.toJson(),
      'features': features.map((feature) => feature.toJson()).toList(),
      'availability': availability.toJson(),
      'rating': rating,
      'reviewCount': reviewCount,
      'ownerId': ownerId,
      'description': description,
      'ownerInfo': ownerInfo.toJson(),
    };
  }

  Car copyWith({
    String? id,
    String? model,
    String? make,
    String? year,
    String? plateNumber,
    double? pricePerDay,
    List<String>? imageUrls,
    String? governorate,
    String? city,
    CarLocation? location,
    CarSpecifications? specs,
    List<CarFeature>? features,
    CarAvailability? availability,
    double? rating,
    int? reviewCount,
    String? ownerId,
    String? description,
    OwnerInfo? ownerInfo,
  }) {
    return Car(
      id: id ?? this.id,
      model: model ?? this.model,
      make: make ?? this.make,
      year: year ?? this.year,
      plateNumber: plateNumber ?? this.plateNumber,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      imageUrls: imageUrls ?? this.imageUrls,
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      location: location ?? this.location,
      specs: specs ?? this.specs,
      features: features ?? this.features,
      availability: availability ?? this.availability,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      ownerId: ownerId ?? this.ownerId,
      description: description ?? this.description,
      ownerInfo: ownerInfo ?? this.ownerInfo,
    );
  }
}

class CarLocation {
  final double latitude;
  final double longitude;
  final String address;

  const CarLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory CarLocation.fromJson(Map<String, dynamic> json) {
    return CarLocation(
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
}

class CarSpecifications {
  final String fuelType;
  final String transmission;
  final int seatsCount;
  final String engineSize;
  final double fuelEfficiency;
  final String color;
  final String category;

  const CarSpecifications({
    required this.fuelType,
    required this.transmission,
    required this.seatsCount,
    required this.engineSize,
    required this.fuelEfficiency,
    required this.color,
    this.category = '',
  });

  factory CarSpecifications.fromJson(Map<String, dynamic> json) {
    return CarSpecifications(
      fuelType: json['fuelType'],
      transmission: json['transmission'],
      seatsCount: json['seatsCount'],
      engineSize: json['engineSize'],
      fuelEfficiency: json['fuelEfficiency'].toDouble(),
      color: json['color'],
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fuelType': fuelType,
      'transmission': transmission,
      'seatsCount': seatsCount,
      'engineSize': engineSize,
      'fuelEfficiency': fuelEfficiency,
      'color': color,
      'category': category,
    };
  }
}

class CarFeature {
  final String name;
  final String icon;
  final bool isHighlighted;

  const CarFeature({
    required this.name,
    required this.icon,
    required this.isHighlighted,
  });

  factory CarFeature.fromJson(Map<String, dynamic> json) {
    return CarFeature(
      name: json['name'],
      icon: json['icon'],
      isHighlighted: json['isHighlighted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'isHighlighted': isHighlighted,
    };
  }
}

class CarAvailability {
  final bool isAvailable;
  final List<DateTime> bookedDates;
  final DateTime lastMaintenanceDate;
  final String availabilityStatus;

  CarAvailability({
    required this.isAvailable,
    required this.bookedDates,
    required this.lastMaintenanceDate,
    required this.availabilityStatus,
  });

  factory CarAvailability.fromJson(Map<String, dynamic> json) {
    return CarAvailability(
      isAvailable: json['isAvailable'],
      bookedDates: (json['bookedDates'] as List)
          .map((date) => DateTime.parse(date))
          .toList(),
      lastMaintenanceDate: DateTime.parse(json['lastMaintenanceDate']),
      availabilityStatus: json['availabilityStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isAvailable': isAvailable,
      'bookedDates': bookedDates.map((date) => date.toIso8601String()).toList(),
      'lastMaintenanceDate': lastMaintenanceDate.toIso8601String(),
      'availabilityStatus': availabilityStatus,
    };
  }
}

class OwnerInfo {
  final String name;
  final String phoneNumber;
  final String profileImageUrl;
  final double rating;

  OwnerInfo({
    required this.name,
    required this.phoneNumber,
    required this.profileImageUrl,
    required this.rating,
  });

  factory OwnerInfo.fromJson(Map<String, dynamic> json) {
    return OwnerInfo(
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'rating': rating,
    };
  }
}