class ReviewResponse {
  final String id;
  final String responderId;
  final String responderName;
  final String responderType; // 'owner', 'admin', 'rental_partner'
  final String response;
  final DateTime createdAt;

  ReviewResponse({
    required this.id,
    required this.responderId,
    required this.responderName,
    required this.responderType,
    required this.response,
    required this.createdAt,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      id: json['id'],
      responderId: json['responderId'],
      responderName: json['responderName'],
      responderType: json['responderType'],
      response: json['response'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'responderId': responderId,
      'responderName': responderName,
      'responderType': responderType,
      'response': response,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class Review {
  final String id;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final String carId;
  final String? bookingId;
  final double rating;
  final String comment;
  final List<String>? photos;
  final DateTime createdAt;
  final bool isVerifiedRental;
  final List<ReviewResponse>? responses;
  final Map<String, double>? categoryRatings;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.carId,
    this.bookingId,
    required this.rating,
    required this.comment,
    this.photos,
    required this.createdAt,
    required this.isVerifiedRental,
    this.responses,
    this.categoryRatings,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userPhotoUrl: json['userPhotoUrl'],
      carId: json['carId'],
      bookingId: json['bookingId'],
      rating: json['rating'].toDouble(),
      comment: json['comment'],
      photos: json['photos'] != null ? List<String>.from(json['photos']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      isVerifiedRental: json['isVerifiedRental'] ?? false,
      responses: json['responses'] != null
          ? (json['responses'] as List)
          .map((response) => ReviewResponse.fromJson(response))
          .toList()
          : null,
      categoryRatings: json['categoryRatings'] != null
          ? Map<String, double>.from(
        json['categoryRatings'].map(
              (key, value) => MapEntry(key, value.toDouble()),
        ),
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'carId': carId,
      'bookingId': bookingId,
      'rating': rating,
      'comment': comment,
      'photos': photos,
      'createdAt': createdAt.toIso8601String(),
      'isVerifiedRental': isVerifiedRental,
      'responses': responses?.map((response) => response.toJson()).toList(),
      'categoryRatings': categoryRatings,
    };
  }

  Review copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userPhotoUrl,
    String? carId,
    String? bookingId,
    double? rating,
    String? comment,
    List<String>? photos,
    DateTime? createdAt,
    bool? isVerifiedRental,
    List<ReviewResponse>? responses,
    Map<String, double>? categoryRatings,
  }) {
    return Review(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      carId: carId ?? this.carId,
      bookingId: bookingId ?? this.bookingId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      photos: photos ?? this.photos,
      createdAt: createdAt ?? this.createdAt,
      isVerifiedRental: isVerifiedRental ?? this.isVerifiedRental,
      responses: responses ?? this.responses,
      categoryRatings: categoryRatings ?? this.categoryRatings,
    );
  }
}