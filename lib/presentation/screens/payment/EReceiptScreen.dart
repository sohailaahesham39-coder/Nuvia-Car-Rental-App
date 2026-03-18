import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui' as ui;

import '../../../data/models/booking_model.dart';
import '../../../data/models/car_model.dart';
import '../../../l10n/AppLocalizations.dart';

class EReceiptScreen extends StatefulWidget {
  final String bookingId;

  const EReceiptScreen({super.key, required this.bookingId});

  @override
  State<EReceiptScreen> createState() => _EReceiptScreenState();
}

class _EReceiptScreenState extends State<EReceiptScreen> {
  bool _isLoading = true;
  Booking? _booking;
  String? _errorMessage;
  bool _isBookingDetailsExpanded = false;
  bool _isPaymentSummaryExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadBookingDetails();
  }

  Future<void> _loadBookingDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      if (widget.bookingId.isEmpty) {
        throw Exception('Invalid booking ID');
      }
      await Future.delayed(const Duration(seconds: 1));
      final dummyBooking = Booking(
        id: widget.bookingId,
        userId: 'user1',
        carId: '1',
        startDate: DateTime.now().add(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 3)),
        status: BookingStatus.confirmed,
        totalPrice: 510.0, // Updated to match payment summary
        paymentDetails: PaymentDetails(
          paymentId: 'payment1',
          paymentMethod: 'visa',
          status: PaymentStatus.completed,
          paidAt: DateTime.now(),
          amount: 510.0,
        ),
        pickupDetails: PickupDetails(
          scheduledTime: DateTime.now().add(const Duration(days: 1)),
          isComplete: false,
        ),
        extras: [
          BookingExtra(
            id: 'extra1',
            name: 'Insurance',
            description: 'Comprehensive insurance coverage',
            price: 30.0,
            icon: 'insurance_icon',
            quantity: 1,
          ),
          BookingExtra(
            id: 'extra2',
            name: 'Driver Service',
            description: 'Professional driver for your trip',
            price: 50.0,
            icon: 'driver_icon',
            quantity: 2, // For 2 days
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isReviewed: false,
        carDetails: Car(
          id: '1',
          model: 'Fortuner',
          make: 'Toyota',
          year: '2023',
          plateNumber: 'ABC 123',
          pricePerDay: 150.0,
          imageUrls: [
            'https://i.pinimg.com/736x/7c/63/8a/7c638a436beeee669e64e96314465b7a.jpg',
            'https://i.pinimg.com/736x/9d/8c/13/9d8c13d6ac367cc8d0aefb8008916a20.jpg',
            'https://i.pinimg.com/736x/d6/84/f4/d684f42582676fb6abc4db460ff84a9e.jpg',
          ],
          governorate: 'cairo',
          city: 'Downtown',
          location: const CarLocation(
            latitude: 30.0444,
            longitude: 31.2357,
            address: '123 Main St, Downtown, Cairo',
          ),
          specs: const CarSpecifications(
            fuelType: 'Petrol',
            transmission: 'Automatic',
            seatsCount: 7,
            engineSize: '4.0L',
            fuelEfficiency: 12.5,
            color: 'White',
            category: 'SUV',
          ),
          features: [
            const CarFeature(name: 'Bluetooth', icon: 'bluetooth', isHighlighted: true),
            const CarFeature(name: 'Air Conditioning', icon: 'ac', isHighlighted: true),
            const CarFeature(name: 'Parking Sensors', icon: 'sensors', isHighlighted: false),
          ],
          availability: CarAvailability(
            isAvailable: true,
            bookedDates: [],
            lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 30)),
            availabilityStatus: 'available',
          ),
          rating: 4.8,
          reviewCount: 24,
          ownerId: 'partner1',
          description: 'Perfect family SUV for long trips, spacious and reliable.',
          ownerInfo: OwnerInfo(
            name: 'Ahmed Hassan',
            phoneNumber: '+201234567890',
            profileImageUrl: 'https://i.pinimg.com/564x/e8/d7/d9/e8d7d9d7861b7d4c1386a4de37eb4290.jpg',
            rating: 4.7,
          ),
        ),
      );
      if (mounted) {
        setState(() {
          _booking = dummyBooking;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = l10n.failedToLoadReceipt(e.toString());
        });
      }
    }
  }

  void _shareReceipt() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.shareReceipt),
        content: Text(l10n.shareReceiptPrompt),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.receiptSharedSuccess)),
              );
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _downloadReceipt() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.receiptDownloadedSuccess)),
    );
  }

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: l10n.localeName == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            // Gradient Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.1),
                    Colors.white,
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  // Custom AppBar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, size: 24),
                          onPressed: () => context.pop(),
                          tooltip: l10n.back,
                        ),
                        Expanded(
                          child: Text(
                            l10n.eReceipt,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.share_outlined),
                              onPressed: _shareReceipt,
                              tooltip: l10n.shareReceipt,
                            ).animate().scale(duration: 300.ms),
                            IconButton(
                              icon: const Icon(Icons.download_outlined),
                              onPressed: _downloadReceipt,
                              tooltip: l10n.downloadReceipt,
                            ).animate().scale(duration: 300.ms),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Receipt Content
                  Expanded(child: _buildBody()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadBookingDetails,
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }
    if (_booking == null) {
      return Center(child: Text(l10n.carNotFound));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Receipt Header
          _buildReceiptHeader()
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.2, end: 0),
          const SizedBox(height: 32),
          // Receipt Details
          _buildReceiptCard(),
        ],
      ),
    );
  }

  Widget _buildReceiptHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'N',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.appName,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(
            l10n.eReceipt,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Car Image
          if (_booking!.carDetails != null && _booking!.carDetails!.imageUrls.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: _booking!.carDetails!.imageUrls.first,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade200,
                    child: Icon(Icons.car_rental, color: Colors.grey.shade400, size: 64),
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 600.ms, delay: 100.ms)
          else
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.car_rental, color: Colors.grey.shade400, size: 64),
            ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
          // Booking ID and Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoColumn(l10n.bookingId, widget.bookingId),
              _buildInfoColumn(
                l10n.paymentDate,
                _booking!.paymentDetails.paidAt != null
                    ? DateFormat('MMM d, yyyy').format(_booking!.paymentDetails.paidAt!)
                    : DateFormat('MMM d, yyyy').format(_booking!.createdAt),
              ),
            ],
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
          const SizedBox(height: 24),
          // Customer Info
          _buildSectionHeader(l10n.customerInformation),
          _buildInfoRow(l10n.name, 'John Doe'),
          _buildInfoRow(l10n.email, 'john.doe@example.com'),
          _buildInfoRow(l10n.phone, '+201234567890'),
          const SizedBox(height: 24),
          // Car Details
          _buildSectionHeader(l10n.carDetails),
          _buildInfoRow(l10n.car,
              _booking!.carDetails != null ? '${_booking!.carDetails!.make} ${_booking!.carDetails!.model} (${_booking!.carDetails!.specs.category})' : 'N/A'),
          _buildInfoRow(l10n.licensePlate, _booking!.carDetails?.plateNumber ?? 'N/A'),
          _buildInfoRow(l10n.rentalType, _hasDriverExtra() ? l10n.withDriver : l10n.selfDrive),
          const SizedBox(height: 24),
          // Rental Period
          GestureDetector(
            onTap: () => setState(() => _isBookingDetailsExpanded = !_isBookingDetailsExpanded),
            child: Row(
              children: [
                _buildSectionHeader(l10n.rentalPeriod),
                const Spacer(),
                Icon(
                  _isBookingDetailsExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Column(
              children: [
                _buildInfoRow(l10n.pickup, '${DateFormat('MMM d, yyyy').format(_booking!.startDate)} at 10:00 AM'),
                _buildInfoRow(l10n.returnLabel, '${DateFormat('MMM d, yyyy').format(_booking!.endDate)} at 10:00 AM'),
                _buildInfoRow(l10n.duration, l10n.days(_booking!.durationInDays)),
              ],
            ),
            crossFadeState: _isBookingDetailsExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          const SizedBox(height: 24),
          // Pickup & Return Location
          _buildSectionHeader(l10n.locations),
          _buildInfoRow(l10n.pickup, _booking!.carDetails?.location.address ?? 'N/A'),
          _buildInfoRow(l10n.returnLabel, _booking!.carDetails?.location.address ?? 'N/A'),
          const SizedBox(height: 24),
          // Payment Summary
          GestureDetector(
            onTap: () => setState(() => _isPaymentSummaryExpanded = !_isPaymentSummaryExpanded),
            child: Row(
              children: [
                _buildSectionHeader(l10n.paymentSummary),
                const Spacer(),
                Icon(
                  _isPaymentSummaryExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Column(
              children: [
                _buildPaymentRow(
                  l10n.carRentalDays(_booking!.durationInDays),
                  '\$${(_booking!.carDetails!.pricePerDay * _booking!.durationInDays).toStringAsFixed(2)}',
                ),
                for (final extra in _booking!.extras)
                  _buildPaymentRow(
                    '${extra.name} ${extra.quantity > 1 ? 'x${extra.quantity}' : ''}',
                    '\$${(extra.price * extra.quantity).toStringAsFixed(2)}',
                  ),
                const Divider(),
                _buildPaymentRow(
                  l10n.subTotal,
                  '\$${(_calculateSubtotal()).toStringAsFixed(2)}',
                  isBold: true,
                ),
                _buildPaymentRow(l10n.tax, '\$${(_calculateTax()).toStringAsFixed(2)}'),
                const Divider(),
                _buildPaymentRow(
                  l10n.total,
                  '\$${_booking!.totalPrice.toStringAsFixed(2)}',
                  isBold: true,
                  isTotal: true,
                ),
              ],
            ),
            crossFadeState: _isPaymentSummaryExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          const SizedBox(height: 24),
          // Payment Method
          _buildSectionHeader(l10n.paymentMethod),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.white, Colors.grey.shade100]),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.credit_card, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.visaEnding('4242'), style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(l10n.paymentStatusCompleted, style: const TextStyle(color: Colors.green)),
                ],
              ),
            ],
          ).animate().fadeIn(duration: 600.ms, delay: 600.ms),
          const SizedBox(height: 24),
          // Verification Code
          _buildVerificationCode()
              .animate()
              .fadeIn(duration: 600.ms, delay: 700.ms),
          const SizedBox(height: 24),
          // Terms and Conditions
          _buildTermsAndConditions()
              .animate()
              .fadeIn(duration: 600.ms, delay: 800.ms),
          const SizedBox(height: 32),
          // Thank You Message
          _buildThankYouMessage()
              .animate()
              .fadeIn(duration: 600.ms, delay: 900.ms),
          const SizedBox(height: 24),
          // Write Review Button
          if (!_booking!.isReviewed)
            Center(
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  context.push('/write-review/${_booking!.id}');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(l10n.writeReview, style: const TextStyle(color: Colors.white)),
              ),
            ).animate().fadeIn(duration: 600.ms, delay: 1000.ms),
        ],
      ),
    );
  }

  bool _hasDriverExtra() {
    return _booking?.extras.any((extra) => extra.name.toLowerCase().contains('driver')) ?? false;
  }

  double _calculateSubtotal() {
    if (_booking == null || _booking!.carDetails == null) return 0.0;
    double subtotal = _booking!.carDetails!.pricePerDay * _booking!.durationInDays;
    for (final extra in _booking!.extras) {
      subtotal += extra.price * extra.quantity;
    }
    return subtotal;
  }

  double _calculateTax() {
    if (_booking == null) return 0.0;
    return _booking!.totalPrice - _calculateSubtotal();
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.circle, color: Theme.of(context).primaryColor, size: 16),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(color: Colors.grey.shade600)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPaymentRow(String label, String amount, {bool isBold = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? Theme.of(context).primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationCode() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Theme.of(context).primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.confirmation_number_outlined, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                l10n.verificationCode,
                style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '123456',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 10,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.showVerificationCodeInstruction,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.termsAndConditions,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.termsAndConditionsDetails,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildThankYouMessage() {
    return Center(
      child: Column(
        children: [
          Text(
            l10n.thankYouMessage,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.customerSupportContact,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}