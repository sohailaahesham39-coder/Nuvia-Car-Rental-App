
import 'car_model.dart';

class Booking {
  final String id;
  final String userId;
  final String carId;
  final DateTime startDate;
  final DateTime endDate;
  final BookingStatus status;
  final double totalPrice;
  final PaymentDetails paymentDetails;
  final PickupDetails pickupDetails;
  final ReturnDetails? returnDetails;
  final List<BookingExtra> extras;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isReviewed;
  final String? cancellationReason;
  final Car? carDetails; // Optional to include full car details

  Booking({
    required this.id,
    required this.userId,
    required this.carId,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.totalPrice,
    required this.paymentDetails,
    required this.pickupDetails,
    this.returnDetails,
    required this.extras,
    required this.createdAt,
    required this.updatedAt,
    required this.isReviewed,
    this.cancellationReason,
    this.carDetails,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['userId'],
      carId: json['carId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      status: BookingStatus.values.firstWhere(
            (e) => e.toString() == 'BookingStatus.${json['status']}',
        orElse: () => BookingStatus.pending,
      ),
      totalPrice: json['totalPrice'].toDouble(),
      paymentDetails: PaymentDetails.fromJson(json['paymentDetails']),
      pickupDetails: PickupDetails.fromJson(json['pickupDetails']),
      returnDetails: json['returnDetails'] != null
          ? ReturnDetails.fromJson(json['returnDetails'])
          : null,
      extras: (json['extras'] as List)
          .map((extra) => BookingExtra.fromJson(extra))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isReviewed: json['isReviewed'] ?? false,
      cancellationReason: json['cancellationReason'],
      carDetails: json['carDetails'] != null ? Car.fromJson(json['carDetails']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'carId': carId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'totalPrice': totalPrice,
      'paymentDetails': paymentDetails.toJson(),
      'pickupDetails': pickupDetails.toJson(),
      'returnDetails': returnDetails?.toJson(),
      'extras': extras.map((extra) => extra.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isReviewed': isReviewed,
      'cancellationReason': cancellationReason,
      'carDetails': carDetails?.toJson(),
    };
  }

  int get durationInDays =>
      endDate.difference(startDate).inDays + 1;

  bool get isActive =>
      status == BookingStatus.confirmed || status == BookingStatus.inProgress;

  bool get isCancellable =>
      status == BookingStatus.pending || status == BookingStatus.confirmed;

  bool get isCompletable =>
      status == BookingStatus.inProgress;

  Booking copyWith({
    String? id,
    String? userId,
    String? carId,
    DateTime? startDate,
    DateTime? endDate,
    BookingStatus? status,
    double? totalPrice,
    PaymentDetails? paymentDetails,
    PickupDetails? pickupDetails,
    ReturnDetails? returnDetails,
    List<BookingExtra>? extras,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isReviewed,
    String? cancellationReason,
    Car? carDetails,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      carId: carId ?? this.carId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      pickupDetails: pickupDetails ?? this.pickupDetails,
      returnDetails: returnDetails ?? this.returnDetails,
      extras: extras ?? this.extras,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isReviewed: isReviewed ?? this.isReviewed,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      carDetails: carDetails ?? this.carDetails,
    );
  }
}

enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  inProgress,
  completed,
  rejected,
}

class PaymentDetails {
  final String paymentId;
  final String paymentMethod; // 'credit_card', 'cash', 'wallet', etc.
  final PaymentStatus status;
  final DateTime? paidAt;
  final double amount;
  final double? deposit;
  final String? transactionReference;
  final String? receiptUrl;

  PaymentDetails({
    required this.paymentId,
    required this.paymentMethod,
    required this.status,
    this.paidAt,
    required this.amount,
    this.deposit,
    this.transactionReference,
    this.receiptUrl,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      paymentId: json['paymentId'],
      paymentMethod: json['paymentMethod'],
      status: PaymentStatus.values.firstWhere(
            (e) => e.toString() == 'PaymentStatus.${json['status']}',
        orElse: () => PaymentStatus.pending,
      ),
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
      amount: json['amount'].toDouble(),
      deposit: json['deposit']?.toDouble(),
      transactionReference: json['transactionReference'],
      receiptUrl: json['receiptUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'paymentMethod': paymentMethod,
      'status': status.toString().split('.').last,
      'paidAt': paidAt?.toIso8601String(),
      'amount': amount,
      'deposit': deposit,
      'transactionReference': transactionReference,
      'receiptUrl': receiptUrl,
    };
  }
}

enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded,
  partiallyRefunded,
}

class PickupDetails {
  final DateTime scheduledTime;
  final DateTime? actualTime;
  final String? handoverNotes;
  final List<String>? handoverPhotos;
  final String? agentId;
  final bool isComplete;

  PickupDetails({
    required this.scheduledTime,
    this.actualTime,
    this.handoverNotes,
    this.handoverPhotos,
    this.agentId,
    required this.isComplete,
  });

  factory PickupDetails.fromJson(Map<String, dynamic> json) {
    return PickupDetails(
      scheduledTime: DateTime.parse(json['scheduledTime']),
      actualTime:
      json['actualTime'] != null ? DateTime.parse(json['actualTime']) : null,
      handoverNotes: json['handoverNotes'],
      handoverPhotos: json['handoverPhotos'] != null
          ? List<String>.from(json['handoverPhotos'])
          : null,
      agentId: json['agentId'],
      isComplete: json['isComplete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduledTime': scheduledTime.toIso8601String(),
      'actualTime': actualTime?.toIso8601String(),
      'handoverNotes': handoverNotes,
      'handoverPhotos': handoverPhotos,
      'agentId': agentId,
      'isComplete': isComplete,
    };
  }
}

class ReturnDetails {
  final DateTime scheduledTime;
  final DateTime? actualTime;
  final String? returnNotes;
  final List<String>? returnPhotos;
  final String? agentId;
  final bool isComplete;
  final double? additionalCharges;
  final String? additionalChargesReason;
  final FuelLevel fuelLevel;
  final int? odometerReading;
  final List<CarDamage>? damages;

  ReturnDetails({
    required this.scheduledTime,
    this.actualTime,
    this.returnNotes,
    this.returnPhotos,
    this.agentId,
    required this.isComplete,
    this.additionalCharges,
    this.additionalChargesReason,
    required this.fuelLevel,
    this.odometerReading,
    this.damages,
  });

  factory ReturnDetails.fromJson(Map<String, dynamic> json) {
    return ReturnDetails(
      scheduledTime: DateTime.parse(json['scheduledTime']),
      actualTime:
      json['actualTime'] != null ? DateTime.parse(json['actualTime']) : null,
      returnNotes: json['returnNotes'],
      returnPhotos: json['returnPhotos'] != null
          ? List<String>.from(json['returnPhotos'])
          : null,
      agentId: json['agentId'],
      isComplete: json['isComplete'] ?? false,
      additionalCharges: json['additionalCharges']?.toDouble(),
      additionalChargesReason: json['additionalChargesReason'],
      fuelLevel: FuelLevel.values.firstWhere(
            (e) => e.toString() == 'FuelLevel.${json['fuelLevel']}',
        orElse: () => FuelLevel.full,
      ),
      odometerReading: json['odometerReading'],
      damages: json['damages'] != null
          ? (json['damages'] as List)
          .map((damage) => CarDamage.fromJson(damage))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduledTime': scheduledTime.toIso8601String(),
      'actualTime': actualTime?.toIso8601String(),
      'returnNotes': returnNotes,
      'returnPhotos': returnPhotos,
      'agentId': agentId,
      'isComplete': isComplete,
      'additionalCharges': additionalCharges,
      'additionalChargesReason': additionalChargesReason,
      'fuelLevel': fuelLevel.toString().split('.').last,
      'odometerReading': odometerReading,
      'damages': damages?.map((damage) => damage.toJson()).toList(),
    };
  }
}

enum FuelLevel {
  empty,
  quarter,
  half,
  threeQuarters,
  full,
}

class CarDamage {
  final String id;
  final String description;
  final String severity; // 'minor', 'moderate', 'severe'
  final List<String> photos;
  final double? repairCost;

  CarDamage({
    required this.id,
    required this.description,
    required this.severity,
    required this.photos,
    this.repairCost,
  });

  factory CarDamage.fromJson(Map<String, dynamic> json) {
    return CarDamage(
      id: json['id'],
      description: json['description'],
      severity: json['severity'],
      photos: List<String>.from(json['photos']),
      repairCost: json['repairCost']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'severity': severity,
      'photos': photos,
      'repairCost': repairCost,
    };
  }
}

class BookingExtra {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String? icon;
  final int quantity;

  BookingExtra({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.icon,
    required this.quantity,
  });

  factory BookingExtra.fromJson(Map<String, dynamic> json) {
    return BookingExtra(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      icon: json['icon'] as String?,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'icon': icon,
      'quantity': quantity,
    };
  }

  BookingExtra copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? icon,
    int? quantity,
  }) {
    return BookingExtra(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      icon: icon ?? this.icon,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => price * quantity;
}