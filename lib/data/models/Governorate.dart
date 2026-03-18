class Governorate {
  final String id;
  final String nameEn;
  final String nameAr;
  final bool isActive;
  final List<City>? cities;
  final double? latitude;
  final double? longitude;

  Governorate({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.isActive,
    this.cities,
    this.latitude,
    this.longitude,
  });

  factory Governorate.fromJson(Map<String, dynamic> json) {
    return Governorate(
      id: json['id'],
      nameEn: json['nameEn'],
      nameAr: json['nameAr'],
      isActive: json['isActive'] ?? true,
      cities: json['cities'] != null
          ? (json['cities'] as List).map((city) => City.fromJson(city)).toList()
          : null,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameAr': nameAr,
      'isActive': isActive,
      'cities': cities?.map((city) => city.toJson()).toList(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class City {
  final String id;
  final String nameEn;
  final String nameAr;
  final String governorateId;
  final bool isActive;
  final double? latitude;
  final double? longitude;
  final List<Area>? areas;

  City({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.governorateId,
    required this.isActive,
    this.latitude,
    this.longitude,
    this.areas,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      nameEn: json['nameEn'],
      nameAr: json['nameAr'],
      governorateId: json['governorateId'],
      isActive: json['isActive'] ?? true,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      areas: json['areas'] != null
          ? (json['areas'] as List).map((area) => Area.fromJson(area)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameAr': nameAr,
      'governorateId': governorateId,
      'isActive': isActive,
      'latitude': latitude,
      'longitude': longitude,
      'areas': areas?.map((area) => area.toJson()).toList(),
    };
  }
}

class Area {
  final String id;
  final String nameEn;
  final String nameAr;
  final String cityId;
  final bool isActive;
  final double? latitude;
  final double? longitude;

  Area({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.cityId,
    required this.isActive,
    this.latitude,
    this.longitude,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'],
      nameEn: json['nameEn'],
      nameAr: json['nameAr'],
      cityId: json['cityId'],
      isActive: json['isActive'] ?? true,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameAr': nameAr,
      'cityId': cityId,
      'isActive': isActive,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class UserLocation {
  final double latitude;
  final double longitude;
  final String? address;
  final String? governorateId;
  final String? cityId;
  final String? areaId;
  final String? street;
  final String? building;
  final String? floor;
  final String? apartment;
  final String? landmark;
  final bool isFavorite;
  final String? label; // "Home", "Work", etc.

  UserLocation({
    required this.latitude,
    required this.longitude,
    this.address,
    this.governorateId,
    this.cityId,
    this.areaId,
    this.street,
    this.building,
    this.floor,
    this.apartment,
    this.landmark,
    required this.isFavorite,
    this.label,
  });

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      address: json['address'],
      governorateId: json['governorateId'],
      cityId: json['cityId'],
      areaId: json['areaId'],
      street: json['street'],
      building: json['building'],
      floor: json['floor'],
      apartment: json['apartment'],
      landmark: json['landmark'],
      isFavorite: json['isFavorite'] ?? false,
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'governorateId': governorateId,
      'cityId': cityId,
      'areaId': areaId,
      'street': street,
      'building': building,
      'floor': floor,
      'apartment': apartment,
      'landmark': landmark,
      'isFavorite': isFavorite,
      'label': label,
    };
  }
}