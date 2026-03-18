class Payment {
  final String id;
  final String userId;
  final String? bookingId;
  final double amount;
  final PaymentStatus status;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? refundedAt;
  final String? transactionId;
  final String? receiptUrl;
  final Map<String, dynamic>? metadata;
  final String currency;
  final PaymentPurpose purpose;
  final String? referenceNumber;
  final List<PaymentItem>? items;
  final double? refundAmount;
  final String? refundReason;

  Payment({
    required this.id,
    required this.userId,
    this.bookingId,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
    this.completedAt,
    this.refundedAt,
    this.transactionId,
    this.receiptUrl,
    this.metadata,
    required this.currency,
    required this.purpose,
    this.referenceNumber,
    this.items,
    this.refundAmount,
    this.refundReason,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      userId: json['userId'],
      bookingId: json['bookingId'],
      amount: json['amount'].toDouble(),
      status: PaymentStatus.values.firstWhere(
            (e) => e.toString() == 'PaymentStatus.${json['status']}',
        orElse: () => PaymentStatus.pending,
      ),
      paymentMethod: json['paymentMethod'],
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      refundedAt: json['refundedAt'] != null
          ? DateTime.parse(json['refundedAt'])
          : null,
      transactionId: json['transactionId'],
      receiptUrl: json['receiptUrl'],
      metadata: json['metadata'],
      currency: json['currency'] ?? 'EGP',
      purpose: PaymentPurpose.values.firstWhere(
            (e) => e.toString() == 'PaymentPurpose.${json['purpose']}',
        orElse: () => PaymentPurpose.booking,
      ),
      referenceNumber: json['referenceNumber'],
      items: json['items'] != null
          ? (json['items'] as List)
          .map((item) => PaymentItem.fromJson(item))
          .toList()
          : null,
      refundAmount: json['refundAmount']?.toDouble(),
      refundReason: json['refundReason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'bookingId': bookingId,
      'amount': amount,
      'status': status.toString().split('.').last,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'refundedAt': refundedAt?.toIso8601String(),
      'transactionId': transactionId,
      'receiptUrl': receiptUrl,
      'metadata': metadata,
      'currency': currency,
      'purpose': purpose.toString().split('.').last,
      'referenceNumber': referenceNumber,
      'items': items?.map((item) => item.toJson()).toList(),
      'refundAmount': refundAmount,
      'refundReason': refundReason,
    };
  }

  Payment copyWith({
    String? id,
    String? userId,
    String? bookingId,
    double? amount,
    PaymentStatus? status,
    String? paymentMethod,
    DateTime? createdAt,
    DateTime? completedAt,
    DateTime? refundedAt,
    String? transactionId,
    String? receiptUrl,
    Map<String, dynamic>? metadata,
    String? currency,
    PaymentPurpose? purpose,
    String? referenceNumber,
    List<PaymentItem>? items,
    double? refundAmount,
    String? refundReason,
  }) {
    return Payment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bookingId: bookingId ?? this.bookingId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      refundedAt: refundedAt ?? this.refundedAt,
      transactionId: transactionId ?? this.transactionId,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      metadata: metadata ?? this.metadata,
      currency: currency ?? this.currency,
      purpose: purpose ?? this.purpose,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      items: items ?? this.items,
      refundAmount: refundAmount ?? this.refundAmount,
      refundReason: refundReason ?? this.refundReason,
    );
  }
}

enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded,
  partiallyRefunded,
  cancelled,
}

enum PaymentPurpose {
  booking,
  deposit,
  damage,
  fine,
  extension,
  subscription,
  other,
}

class PaymentItem {
  final String id;
  final String name;
  final String? description;
  final double amount;
  final int quantity;
  final String? imageUrl;

  PaymentItem({
    required this.id,
    required this.name,
    this.description,
    required this.amount,
    required this.quantity,
    this.imageUrl,
  });

  factory PaymentItem.fromJson(Map<String, dynamic> json) {
    return PaymentItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      amount: json['amount'].toDouble(),
      quantity: json['quantity'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'amount': amount,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  double get totalAmount => amount * quantity;
}

class PaymentMethod {
  final String id;
  final String userId;
  final String type; // 'credit_card', 'debit_card', 'wallet', etc.
  final String title; // User-friendly name
  final bool isDefault;
  final Map<String, dynamic> details; // Card details, wallet info, etc.
  final DateTime createdAt;
  final DateTime? lastUsed;

  PaymentMethod({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.isDefault,
    required this.details,
    required this.createdAt,
    this.lastUsed,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      userId: json['userId'],
      type: json['type'],
      title: json['title'],
      isDefault: json['isDefault'] ?? false,
      details: json['details'] ?? {},
      createdAt: DateTime.parse(json['createdAt']),
      lastUsed: json['lastUsed'] != null ? DateTime.parse(json['lastUsed']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'title': title,
      'isDefault': isDefault,
      'details': details,
      'createdAt': createdAt.toIso8601String(),
      'lastUsed': lastUsed?.toIso8601String(),
    };
  }

  // Helper methods to extract card info
  String? get cardNumber => details['cardNumber'] as String?;
  String? get cardHolder => details['cardHolder'] as String?;
  String? get expiryDate => details['expiryDate'] as String?;
  String? get cardType => details['cardType'] as String?; // Visa, MasterCard, etc.
  String? get last4Digits => cardNumber != null ? cardNumber!.substring(cardNumber!.length - 4) : null;
}