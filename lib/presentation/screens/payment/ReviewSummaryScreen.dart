import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui' as ui;

import '../../../data/models/booking_model.dart';
import '../../../data/models/car_model.dart';
import '../../../l10n/AppLocalizations.dart';



class ReviewSummaryScreen extends StatefulWidget {
  final String bookingId;

  const ReviewSummaryScreen({super.key, required this.bookingId});

  @override
  State<ReviewSummaryScreen> createState() => _ReviewSummaryScreenState();
}

class _ReviewSummaryScreenState extends State<ReviewSummaryScreen> {
  bool _isLoading = true;
  bool _isProcessingPayment = false;
  Booking? _booking;
  String? _errorMessage;
  String? _selectedPaymentMethod;
  bool _isPaymentExpanded = false;

  // Payment method data for display
  Map<String, dynamic>? _currentPaymentMethod;

  // Sample payment methods data (in a real app, this would come from a service)
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'card1',
      'type': 'card',
      'cardType': 'Visa',
      'last4': '4242',
      'expiryDate': '12/25',
      'holderName': 'John Doe',
      'isDefault': true,
    },
    {
      'id': 'card2',
      'type': 'card',
      'cardType': 'Mastercard',
      'last4': '5555',
      'expiryDate': '08/24',
      'holderName': 'John Doe',
      'isDefault': false,
    },
    {
      'id': 'wallet',
      'type': 'wallet',
      'balance': 350.0,
      'isDefault': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uri = GoRouterState.of(context).uri;
      _selectedPaymentMethod = uri.queryParameters['paymentMethod'];
      _initializePaymentMethod();
      _loadBookingSummary();
    });
  }

  void _initializePaymentMethod() {
    // Find default payment method or the selected one
    if (_selectedPaymentMethod != null) {
      _currentPaymentMethod = _paymentMethods.firstWhere(
            (method) => method['id'] == _selectedPaymentMethod,
        orElse: () => _paymentMethods.firstWhere(
              (method) => method['isDefault'] == true,
          orElse: () => _paymentMethods.first,
        ),
      );
    } else {
      _currentPaymentMethod = _paymentMethods.firstWhere(
            (method) => method['isDefault'] == true,
        orElse: () => _paymentMethods.first,
      );
    }
    _selectedPaymentMethod = _currentPaymentMethod!['id'];
  }

  Future<void> _loadBookingSummary() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await Future.delayed(const Duration(seconds: 1));
      final pinterestCarImageUrl =
          'https://i.pinimg.com/736x/27/b7/de/27b7de9c188db33b73b49b79f9a9e99f.jpg';
      final dummyBooking = Booking(
        id: widget.bookingId,
        userId: 'user1',
        carId: 'car1',
        startDate: DateTime.now().add(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 3)),
        status: BookingStatus.pending,
        totalPrice: 450.0,
        paymentDetails: PaymentDetails(
          paymentId: 'payment1',
          paymentMethod: _selectedPaymentMethod ?? 'visa',
          status: PaymentStatus.pending,
          amount: 450.0,
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
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isReviewed: false,
        carDetails: Car(
          id: 'car1',
          model: 'Fortuner',
          make: 'Toyota',
          year: '2023',
          plateNumber: 'ABC 123',
          pricePerDay: 150.0,
          imageUrls: [pinterestCarImageUrl],
          governorate: 'Cairo',
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
            engineSize: '2.7L',
            fuelEfficiency: 10.5,
            color: 'White',
          ),
          features: [
            const CarFeature(name: 'Air Conditioning', icon: 'ac_icon', isHighlighted: true),
            const CarFeature(name: 'Bluetooth', icon: 'bluetooth_icon', isHighlighted: false),
          ],
          availability: CarAvailability(
            isAvailable: true,
            bookedDates: [],
            lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 30)),
            availabilityStatus: 'available',
          ),
          rating: 4.8,
          reviewCount: 24,
          ownerId: 'owner1',
          description: 'A spacious and reliable SUV perfect for family trips or off-road adventures.',
          ownerInfo:OwnerInfo(
            name: 'Ahmed Hassan',
            phoneNumber: '+201234567890',
            profileImageUrl: 'https://i.pinimg.com/564x/e8/d7/d9/e8d7d9d7861b7d4c1386a4de37eb4290.jpg',
            rating: 4.7,
          ),
        ),
      );
      setState(() {
        _booking = dummyBooking;
        _isLoading = false;
      });
    } catch (e) {
      final l10n = AppLocalizations.of(context);
      setState(() {
        _isLoading = false;
        _errorMessage = l10n?.failedToLoadSummary(e.toString()) ?? 'Failed to load summary: $e';
      });
    }
  }

  Future<void> _confirmAndPay() async {
    setState(() => _isProcessingPayment = true);
    try {
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isProcessingPayment = false);
      if (mounted) {
        context.push('/payment-success/${widget.bookingId}');
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context);
      setState(() => _isProcessingPayment = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n?.paymentFailed(e.toString()) ?? 'Payment failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Method to handle payment method selection from PaymentMethodsScreen
  void _onPaymentMethodSelected(String? paymentMethodId) {
    if (paymentMethodId != null) {
      final selectedMethod = _paymentMethods.firstWhere(
            (method) => method['id'] == paymentMethodId,
        orElse: () => _currentPaymentMethod!,
      );

      setState(() {
        _selectedPaymentMethod = paymentMethodId;
        _currentPaymentMethod = selectedMethod;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Center(child: Text('Localization not available'));
    }

    return Directionality(
      textDirection: l10n.localeName == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
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
                        ),
                        Expanded(
                          child: Text(
                            l10n.reviewSummary,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  Expanded(child: _buildBody(l10n)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
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
              onPressed: _loadBookingSummary,
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }
    if (_booking == null) {
      return Center(child: Text(l10n.carNotFound));
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Car Details
                _buildCarDetailsCard(l10n)
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 24),
                // Booking Details
                _buildSectionHeader(l10n.bookingDetails),
                _buildDetailItem(
                  Icons.calendar_today_outlined,
                  l10n.pickup,
                  '${DateFormat('dd/MM/yyyy').format(_booking!.startDate)} at 10:00 AM',
                ),
                _buildDetailItem(
                  Icons.calendar_today_outlined,
                  l10n.returnLabel,
                  '${DateFormat('dd/MM/yyyy').format(_booking!.endDate)} at 10:00 AM',
                ),
                _buildDetailItem(
                  Icons.timelapse_outlined,
                  l10n.duration,
                  l10n.days(_booking!.durationInDays),
                ),
                _buildDetailItem(
                  Icons.location_on_outlined,
                  l10n.pickupLocation,
                  _booking!.carDetails?.location.address ?? 'N/A',
                ),
                _buildDetailItem(
                  Icons.location_on_outlined,
                  l10n.returnLocation,
                  _booking!.carDetails?.location.address ?? 'N/A',
                ),
                const SizedBox(height: 24),
                // Payment Summary
                _buildPaymentSummary(l10n),
                const SizedBox(height: 24),
                // Payment Method
                _buildSectionHeader(l10n.paymentMethod),
                _buildPaymentMethodCard(l10n)
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 600.ms),
                const SizedBox(height: 24),
                // Cancellation Policy
                _buildCancellationPolicy(l10n)
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 700.ms),
              ],
            ),
          ),
        ),
        // Confirm and Pay Button
        _buildConfirmButton(l10n),
      ],
    );
  }

  Widget _buildCarDetailsCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _booking!.carDetails?.imageUrls.isNotEmpty == true
                  ? CachedNetworkImage(
                imageUrl: _booking!.carDetails!.imageUrls.first,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade200,
                  child: Icon(Icons.car_rental, color: Colors.grey.shade400, size: 50),
                ),
              )
                  : Container(
                color: Colors.grey.shade200,
                child: Icon(Icons.car_rental, color: Colors.grey.shade400, size: 50),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _booking!.carDetails != null
                      ? '${_booking!.carDetails!.make} ${_booking!.carDetails!.model}'
                      : 'N/A',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${_booking!.carDetails?.rating ?? 4.8}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(' (${_booking!.carDetails?.reviewCount ?? 24})'),
                    const SizedBox(width: 16),
                    Icon(Icons.circle, size: 8, color: Colors.grey.shade400),
                    const SizedBox(width: 8),
                    Text(
                      _hasDriverExtra() ? l10n.withDriver : l10n.selfDrive,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${(_booking!.carDetails?.pricePerDay ?? 150.0).toStringAsFixed(2)} ${l10n.perDay}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildPaymentSummary(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _isPaymentExpanded = !_isPaymentExpanded),
          child: Row(
            children: [
              _buildSectionHeader(l10n.paymentSummary),
              const Spacer(),
              Icon(
                _isPaymentExpanded ? Icons.expand_less : Icons.expand_more,
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
              if (_hasDriverExtra())
                _buildPaymentRow(
                  l10n.driverFeeDays(_booking!.durationInDays),
                  '\$${(50.0 * _booking!.durationInDays).toStringAsFixed(2)}',
                ),
              for (final extra in _booking!.extras)
                _buildPaymentRow(
                  extra.name,
                  '\$${extra.price.toStringAsFixed(2)}',
                ),
              const Divider(),
              _buildPaymentRow(
                l10n.subTotal,
                '\$${(_booking!.totalPrice - 20.0).toStringAsFixed(2)}',
                isBold: true,
              ),
              _buildPaymentRow(l10n.tax, '\$20.00'),
              const Divider(),
              _buildPaymentRow(
                l10n.total,
                '\$${_booking!.totalPrice.toStringAsFixed(2)}',
                isBold: true,
                isTotal: true,
              ),
            ],
          ),
          crossFadeState: _isPaymentExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }

  Widget _buildPaymentRow(String label, String amount, {bool isBold = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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

  Widget _buildPaymentMethodCard(AppLocalizations l10n) {
    final paymentMethod = _currentPaymentMethod;

    return GestureDetector(
      onTap: () async {
        final result = await context.push<String>(
          '/payment-methods/${widget.bookingId}',
          extra: {'selectedPaymentMethod': _selectedPaymentMethod},
        );
        if (result != null) {
          _onPaymentMethodSelected(result);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey.shade100],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                paymentMethod?['type'] == 'wallet'
                    ? Icons.account_balance_wallet
                    : Icons.credit_card,
                color: paymentMethod?['type'] == 'wallet'
                    ? Colors.green.shade700
                    : paymentMethod?['cardType'] == 'Visa'
                    ? Colors.blue
                    : Colors.red,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paymentMethod?['type'] == 'wallet'
                        ? l10n.nuviaWallet
                        : '${paymentMethod?['cardType'] ?? 'Card'} •••• ${paymentMethod?['last4'] ?? '****'}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    paymentMethod?['type'] == 'wallet'
                        ? l10n.balance(paymentMethod?['balance'].toStringAsFixed(2) ?? '0.00')
                        : l10n.expires(paymentMethod?['expiryDate'] ?? '00/00'),
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancellationPolicy(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade50,
            Colors.orange.shade100.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange, size: 24),
              const SizedBox(width: 8),
              Text(
                l10n.cancellationPolicy,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.cancellationPolicyDetails,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(AppLocalizations l10n) {
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2))),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    l10n.total,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Spacer(),
                  Text(
                    '\$${_booking!.totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isProcessingPayment ? null : _confirmAndPay,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  shadowColor: Theme.of(context).primaryColor.withOpacity(0.4),
                  elevation: 5,
                ),
                child: _isProcessingPayment
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                  l10n.confirmAndPay,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 800.ms);
  }

  bool _hasDriverExtra() {
    return _booking?.extras.any((extra) => extra.name.toLowerCase().contains('driver')) ?? false;
  }
}