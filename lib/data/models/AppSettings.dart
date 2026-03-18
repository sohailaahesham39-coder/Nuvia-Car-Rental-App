class AppSettings {
  final TermsAndConditions termsAndConditions;
  final PrivacyPolicy privacyPolicy;
  final Map<String, String> supportContacts;
  final Map<String, String> aboutUs;
  final Map<String, dynamic> appVersionInfo;
  final List<FAQ> faqs;
  final List<CarCategory> carCategories;
  final List<CarBrand> carBrands;
  final List<String> featuredCarIds;
  final Map<String, dynamic> promotions;
  final Map<String, dynamic> appConfig;
  final List<String> governorateIds;
  final Map<String, String> socialMediaLinks;

  AppSettings({
    required this.termsAndConditions,
    required this.privacyPolicy,
    required this.supportContacts,
    required this.aboutUs,
    required this.appVersionInfo,
    required this.faqs,
    required this.carCategories,
    required this.carBrands,
    required this.featuredCarIds,
    required this.promotions,
    required this.appConfig,
    required this.governorateIds,
    required this.socialMediaLinks,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      termsAndConditions: TermsAndConditions.fromJson(json['termsAndConditions']),
      privacyPolicy: PrivacyPolicy.fromJson(json['privacyPolicy']),
      supportContacts: Map<String, String>.from(json['supportContacts'] ?? {}),
      aboutUs: Map<String, String>.from(json['aboutUs'] ?? {}),
      appVersionInfo: json['appVersionInfo'] ?? {},
      faqs: (json['faqs'] as List? ?? [])
          .map((faq) => FAQ.fromJson(faq))
          .toList(),
      carCategories: (json['carCategories'] as List? ?? [])
          .map((category) => CarCategory.fromJson(category))
          .toList(),
      carBrands: (json['carBrands'] as List? ?? [])
          .map((brand) => CarBrand.fromJson(brand))
          .toList(),
      featuredCarIds: List<String>.from(json['featuredCarIds'] ?? []),
      promotions: json['promotions'] ?? {},
      appConfig: json['appConfig'] ?? {},
      governorateIds: List<String>.from(json['governorateIds'] ?? []),
      socialMediaLinks: Map<String, String>.from(json['socialMediaLinks'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'termsAndConditions': termsAndConditions.toJson(),
      'privacyPolicy': privacyPolicy.toJson(),
      'supportContacts': supportContacts,
      'aboutUs': aboutUs,
      'appVersionInfo': appVersionInfo,
      'faqs': faqs.map((faq) => faq.toJson()).toList(),
      'carCategories': carCategories.map((category) => category.toJson()).toList(),
      'carBrands': carBrands.map((brand) => brand.toJson()).toList(),
      'featuredCarIds': featuredCarIds,
      'promotions': promotions,
      'appConfig': appConfig,
      'governorateIds': governorateIds,
      'socialMediaLinks': socialMediaLinks,
    };
  }
}

class TermsAndConditions {
  final String version;
  final DateTime lastUpdated;
  final Map<String, String> content; // Key is language code, value is content

  TermsAndConditions({
    required this.version,
    required this.lastUpdated,
    required this.content,
  });

  factory TermsAndConditions.fromJson(Map<String, dynamic> json) {
    return TermsAndConditions(
      version: json['version'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
      content: Map<String, String>.from(json['content'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'lastUpdated': lastUpdated.toIso8601String(),
      'content': content,
    };
  }
}

class PrivacyPolicy {
  final String version;
  final DateTime lastUpdated;
  final Map<String, String> content; // Key is language code, value is content

  PrivacyPolicy({
    required this.version,
    required this.lastUpdated,
    required this.content,
  });

  factory PrivacyPolicy.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicy(
      version: json['version'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
      content: Map<String, String>.from(json['content'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'lastUpdated': lastUpdated.toIso8601String(),
      'content': content,
    };
  }
}

class FAQ {
  final String id;
  final Map<String, String> question; // Key is language code, value is question
  final Map<String, String> answer; // Key is language code, value is answer
  final String category;
  final int order;

  FAQ({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    required this.order,
  });

  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      id: json['id'],
      question: Map<String, String>.from(json['question'] ?? {}),
      answer: Map<String, String>.from(json['answer'] ?? {}),
      category: json['category'],
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'category': category,
      'order': order,
    };
  }
}

class CarCategory {
  final String id;
  final Map<String, String> name; // Key is language code, value is name
  final String? iconUrl;
  final String? imageUrl;
  final int order;
  final bool isActive;

  CarCategory({
    required this.id,
    required this.name,
    this.iconUrl,
    this.imageUrl,
    required this.order,
    required this.isActive,
  });

  factory CarCategory.fromJson(Map<String, dynamic> json) {
    return CarCategory(
      id: json['id'],
      name: Map<String, String>.from(json['name'] ?? {}),
      iconUrl: json['iconUrl'],
      imageUrl: json['imageUrl'],
      order: json['order'] ?? 0,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconUrl': iconUrl,
      'imageUrl': imageUrl,
      'order': order,
      'isActive': isActive,
    };
  }
}

class CarBrand {
  final String id;
  final String name;
  final String? logoUrl;
  final int order;
  final bool isPopular;
  final bool isActive;
  final List<CarModel>? models;

  CarBrand({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.order,
    required this.isPopular,
    required this.isActive,
    this.models,
  });

  factory CarBrand.fromJson(Map<String, dynamic> json) {
    return CarBrand(
      id: json['id'],
      name: json['name'],
      logoUrl: json['logoUrl'],
      order: json['order'] ?? 0,
      isPopular: json['isPopular'] ?? false,
      isActive: json['isActive'] ?? true,
      models: json['models'] != null
          ? (json['models'] as List).map((model) => CarModel.fromJson(model)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'order': order,
      'isPopular': isPopular,
      'isActive': isActive,
      'models': models?.map((model) => model.toJson()).toList(),
    };
  }
}

class CarModel {
  final String id;
  final String name;
  final String brandId;
  final String? imageUrl;
  final bool isActive;
  final List<String>? categoryIds;

  CarModel({
    required this.id,
    required this.name,
    required this.brandId,
    this.imageUrl,
    required this.isActive,
    this.categoryIds,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      name: json['name'],
      brandId: json['brandId'],
      imageUrl: json['imageUrl'],
      isActive: json['isActive'] ?? true,
      categoryIds: json['categoryIds'] != null
          ? List<String>.from(json['categoryIds'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brandId': brandId,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'categoryIds': categoryIds,
    };
  }
}

