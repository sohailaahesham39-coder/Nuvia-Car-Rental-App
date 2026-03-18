import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../data/models/booking_model.dart';
import '../../../data/models/car_model.dart';
import '../../../l10n/AppLocalizations.dart';
import '../../../providers/auth.dart';

class BookCarScreen extends StatefulWidget {
  final String carId;

  const BookCarScreen({
    super.key,
    required this.carId,
  });

  @override
  State<BookCarScreen> createState() => _BookCarScreenState();
}

class _BookCarScreenState extends State<BookCarScreen> {
  bool _isLoading = false;
  Car? _car;
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 2));
  TimeOfDay _pickupTime = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay _returnTime = const TimeOfDay(hour: 10, minute: 0);
  List<BookingExtra> _selectedExtras = [];
  bool _isProcessingPayment = false;

  // Default extras available for all cars
  final List<BookingExtra> _availableExtras = [
    BookingExtra(
      id: 'extra1',
      name: 'Full Insurance',
      description: 'Complete coverage against all damages and accidents',
      price: 20.0,
      icon: 'shield',
      quantity: 0,
    ),
    BookingExtra(
      id: 'extra2',
      name: 'Driver',
      description: 'Professional driver throughout the rental period',
      price: 50.0,
      icon: 'person',
      quantity: 0,
    ),
    BookingExtra(
      id: 'extra3',
      name: 'Child Seat',
      description: 'Safe and comfortable child seat',
      price: 10.0,
      icon: 'child_seat',
      quantity: 0,
    ),
    BookingExtra(
      id: 'extra4',
      name: 'Portable WiFi',
      description: 'Internet connection throughout the rental period',
      price: 15.0,
      icon: 'wifi',
      quantity: 0,
    ),
    BookingExtra(
      id: 'extra5',
      name: 'Delivery & Pickup',
      description: 'Deliver and pick up the car from your preferred location',
      price: 25.0,
      icon: 'delivery',
      quantity: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchCarDetails();
  }

  Future<void> _fetchCarDetails() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Define a list of dummy cars (consistent with HomeScreen and CarDetailsScreen)
    final dummyCars = [
      Car(
        id: '1',
        model: 'Fortuner',
        make: 'Toyota',
        year: '2023',
        plateNumber: 'ABC 123',
        pricePerDay: 150.0,
        imageUrls: [
          'https://i.pinimg.com/736x/3e/91/68/3e916821446689726cc45d4a13f5d8d3.jpg',
          'https://i.pinimg.com/736x/9d/8c/13/9d8c13d6ac367cc8d0aefb8008916a20.jpg',
          'https://i.pinimg.com/736x/d6/84/f4/d684f42582676fb6abc4db460ff84a9e.jpg',
        ],
        governorate: 'cairo',
        city: 'Downtown',
        location: const CarLocation(
          latitude: 30.0444,
          longitude: 31.2357,
          address: '123 Main St, Downtown',
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
      Car(
        id: '2',
        model: 'Verna',
        make: 'Hyundai',
        year: '2022',
        plateNumber: 'XYZ 789',
        pricePerDay: 80.0,
        imageUrls: [
          'https://i.pinimg.com/736x/0c/34/4d/0c344d180d4b8e80761a6b1cb0ff6bb9.jpg',
          'https://i.pinimg.com/736x/64/6b/ae/646baef070f0836a7817ab5b4950cea8.jpg',
          'https://i.pinimg.com/originals/53/28/57/5328572911f86b9f86e5051feef22e1b.jpg',
        ],
        governorate: 'cairo',
        city: 'Nasr City',
        location: const CarLocation(
          latitude: 30.0580,
          longitude: 31.3784,
          address: '456 Park Ave, Nasr City',
        ),
        specs: const CarSpecifications(
          fuelType: 'Petrol',
          transmission: 'Automatic',
          seatsCount: 5,
          engineSize: '1.6L',
          fuelEfficiency: 18.2,
          color: 'Silver',
          category: 'Sedan',
        ),
        features: [
          const CarFeature(name: 'Bluetooth', icon: 'bluetooth', isHighlighted: true),
          const CarFeature(name: 'Air Conditioning', icon: 'ac', isHighlighted: true),
          const CarFeature(name: 'Reverse Camera', icon: 'camera', isHighlighted: true),
        ],
        availability: CarAvailability(
          isAvailable: true,
          bookedDates: [],
          lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 15)),
          availabilityStatus: 'available',
        ),
        rating: 4.5,
        reviewCount: 18,
        ownerId: 'partner2',
        description: 'Economical sedan, great for city driving and daily commutes.',
        ownerInfo: OwnerInfo(
          name: 'Sarah Mohamed',
          phoneNumber: '+201987654321',
          profileImageUrl: 'https://i.pinimg.com/564x/05/eb/c0/05ebc096d787bf1abc90e5359337b6e8.jpg',
          rating: 4.4,
        ),
      ),
      Car(
        id: '3',
        model: 'X3',
        make: 'BMW',
        year: '2023',
        plateNumber: 'LMN 456',
        pricePerDay: 280.0,
        imageUrls: [
          'https://i.pinimg.com/736x/f3/78/6d/f3786d6e52d006ab37102e1a8f59a71e.jpg',
          'https://i.pinimg.com/originals/4d/64/a3/4d64a3b9c0fa7054b6e8a5e0bcc4d0de.jpg',
          'https://i.pinimg.com/originals/a2/bb/f2/a2bbf2f627d7074a7f4e0953b274e5bc.jpg',
        ],
        governorate: 'cairo',
        city: 'Zamalek',
        location: const CarLocation(
          latitude: 30.0609,
          longitude: 31.2197,
          address: '789 Island St, Zamalek',
        ),
        specs: const CarSpecifications(
          fuelType: 'Petrol',
          transmission: 'Automatic',
          seatsCount: 5,
          engineSize: '2.0L',
          fuelEfficiency: 14.3,
          color: 'Black',
          category: 'Luxury SUV',
        ),
        features: [
          const CarFeature(name: 'Bluetooth', icon: 'bluetooth', isHighlighted: true),
          const CarFeature(name: 'Air Conditioning', icon: 'ac', isHighlighted: true),
          const CarFeature(name: 'Leather Seats', icon: 'seat', isHighlighted: true),
          const CarFeature(name: 'Sunroof', icon: 'sunroof', isHighlighted: true),
        ],
        availability: CarAvailability(
          isAvailable: true,
          bookedDates: [],
          lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 10)),
          availabilityStatus: 'available',
        ),
        rating: 4.9,
        reviewCount: 32,
        ownerId: 'partner3',
        description: 'Luxury SUV with premium features, ideal for business trips.',
        ownerInfo: OwnerInfo(
          name: 'Khaled Omar',
          phoneNumber: '+201112233445',
          profileImageUrl: 'https://i.pinimg.com/564x/22/7a/69/227a69d90959886f1d0a6de3a7654661.jpg',
          rating: 4.9,
        ),
      ),
    ];

    // Find the car matching the carId
    final selectedCar = dummyCars.firstWhere(
          (car) => car.id == widget.carId,
      orElse: () => Car(
        id: widget.carId,
        model: 'Unknown',
        make: 'Unknown',
        year: 'N/A',
        plateNumber: 'N/A',
        pricePerDay: 0.0,
        imageUrls: [],
        governorate: 'N/A',
        city: 'N/A',
        location: const CarLocation(latitude: 0, longitude: 0, address: 'N/A'),
        specs: const CarSpecifications(
          fuelType: 'N/A',
          transmission: 'N/A',
          seatsCount: 0,
          engineSize: 'N/A',
          fuelEfficiency: 0,
          color: 'N/A',
          category: 'N/A',
        ),
        features: [],
        availability: CarAvailability(
          isAvailable: false,
          bookedDates: [],
          lastMaintenanceDate: DateTime.now(),
          availabilityStatus: 'N/A',
        ),
        rating: 0,
        reviewCount: 0,
        ownerId: 'N/A',
        description: 'Car not found.',
        ownerInfo: OwnerInfo(
          name: 'N/A',
          phoneNumber: 'N/A',
          profileImageUrl: '',
          rating: 0,
        ),
      ),
    );

    setState(() {
      _car = selectedCar;
      _isLoading = false;
    });
  }

  int get _rentalDays {
    return _endDate.difference(_startDate).inDays + 1;
  }

  double get _totalExtrasPrice {
    return _selectedExtras.fold(0, (sum, extra) => sum + (extra.price * extra.quantity));
  }

  double get _totalPrice {
    final carPrice = _car?.pricePerDay ?? 0;
    return (carPrice * _rentalDays) + _totalExtrasPrice;
  }

  void _toggleExtra(BookingExtra extra) {
    setState(() {
      final index = _selectedExtras.indexWhere((e) => e.id == extra.id);
      if (index >= 0) {
        _selectedExtras.removeAt(index);
      } else {
        _selectedExtras.add(
          extra.copyWith(quantity: 1),
        );
      }
    });
  }

  void _updateExtraQuantity(BookingExtra extra, int quantity) {
    setState(() {
      final index = _selectedExtras.indexWhere((e) => e.id == extra.id);
      if (index >= 0) {
        if (quantity <= 0) {
          _selectedExtras.removeAt(index);
        } else {
          _selectedExtras[index] = extra.copyWith(quantity: quantity);
        }
      } else if (quantity > 0) {
        _selectedExtras.add(
          extra.copyWith(quantity: quantity),
        );
      }
    });
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _startDate = date;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: _startDate.add(const Duration(days: 30)),
    );

    if (date != null) {
      setState(() {
        _endDate = date;
      });
    }
  }

  Future<void> _selectPickupTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _pickupTime,
    );

    if (time != null) {
      setState(() {
        _pickupTime = time;
      });
    }
  }

  Future<void> _selectReturnTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _returnTime,
    );

    if (time != null) {
      setState(() {
        _returnTime = time;
      });
    }
  }

  Future<void> _processBooking() async {
    if (_car == null) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser == null) {
      context.push('/sign-in?redirect=/book-car/${_car!.id}');
      return;
    }

    setState(() {
      _isProcessingPayment = true;
    });

    // Simulate booking creation
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isProcessingPayment = false;
      });

      // Create dummy booking ID
      final bookingId = 'BOOK-${DateTime.now().millisecondsSinceEpoch}';

      // Redirect to document upload screen
      context.push('/document-upload/$bookingId/${_car!.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.bookCar)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_car == null || _car!.model == 'Unknown') {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.bookCar)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.carNotFound,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: Text(l10n.back),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.bookCar)),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCarOverview(),
                const SizedBox(height: 24),
                Text(
                  l10n.rentalPeriod,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildDateSelector(
                  label: l10n.startDate,
                  date: _startDate,
                  onTap: _selectStartDate,
                  iconData: Icons.calendar_today,
                ),
                const SizedBox(height: 8),
                _buildTimeSelector(
                  label: l10n.pickupTime,
                  time: _pickupTime,
                  onTap: _selectPickupTime,
                  iconData: Icons.access_time,
                ),
                const SizedBox(height: 16),
                _buildDateSelector(
                  label: l10n.endDate,
                  date: _endDate,
                  onTap: _selectEndDate,
                  iconData: Icons.calendar_today,
                ),
                const SizedBox(height: 8),
                _buildTimeSelector(
                  label: l10n.returnTime,
                  time: _returnTime,
                  onTap: _selectReturnTime,
                  iconData: Icons.access_time,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.addOnsExtras,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildExtrasSection(),
                const SizedBox(height: 24),
                Text(
                  l10n.priceSummary,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildPriceSummary(),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessingPayment ? null : _processBooking,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: _isProcessingPayment
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(l10n.processing),
                    ],
                  )
                      : Text(l10n.confirmBooking),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarOverview() {
    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: _car!.imageUrls[0],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade200,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.directions_car,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_car!.make} ${_car!.model} (${_car!.specs.category})',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _car!.year,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_car!.rating} (${_car!.reviewCount})',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${_car!.pricePerDay.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.perDay,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _car!.description,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Owner Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: CachedNetworkImageProvider(
                    _car!.ownerInfo.profileImageUrl,
                  ),
                  backgroundColor: Colors.grey.shade200,
                  onBackgroundImageError: (exception, stackTrace) => const Icon(Icons.person),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _car!.ownerInfo.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _car!.ownerInfo.rating.toString(),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
    required IconData iconData,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              iconData,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('EEE, MMM d, yyyy').format(date),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Spacer(),
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

  Widget _buildTimeSelector({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
    required IconData iconData,
  }) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour < 12 ? 'AM' : 'PM';
    final formattedHour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              iconData,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$formattedHour:$minute $period',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Spacer(),
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

  Widget _buildExtrasSection() {
    return Column(
      children: _availableExtras.map((extra) {
        final isSelected = _selectedExtras.any((e) => e.id == extra.id);
        final selectedExtra = _selectedExtras.firstWhere(
              (e) => e.id == extra.id,
          orElse: () => extra.copyWith(quantity: 0),
        );

        return Card(
          elevation: 0,
          color: isSelected ? Colors.grey.shade100 : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
            ),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getExtraIcon(extra.icon),
                    color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        extra.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        extra.description ?? '',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${extra.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                isSelected
                    ? Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _updateExtraQuantity(extra, selectedExtra.quantity - 1);
                      },
                      icon: const Icon(Icons.remove),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(32, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${selectedExtra.quantity}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        _updateExtraQuantity(extra, selectedExtra.quantity + 1);
                      },
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(32, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                )
                    : ElevatedButton(
                  onPressed: () => _toggleExtra(extra),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).primaryColor,
                    side: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Text(AppLocalizations.of(context)!.add),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPriceSummary() {
    final l10n = AppLocalizations.of(context)!;
    final carPricePerDay = _car?.pricePerDay ?? 0;
    final daysTotal = carPricePerDay * _rentalDays;

    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPriceRow(
              label: l10n.carRental,
              price: daysTotal,
              details: '\$${carPricePerDay.toStringAsFixed(2)} × $_rentalDays ${l10n.days}',
            ),
            if (_selectedExtras.isNotEmpty) ...[
              const Divider(height: 24),
              ..._selectedExtras.map((extra) => _buildPriceRow(
                label: extra.name,
                price: extra.price * extra.quantity,
                details: '\$${extra.price.toStringAsFixed(2)} × ${extra.quantity}',
              )),
            ],
            const Divider(height: 24),
            _buildPriceRow(
              label: l10n.total,
              price: _totalPrice,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow({
    required String label,
    required double price,
    String? details,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                    fontSize: isTotal ? 16 : 14,
                  ),
                ),
                if (details != null && !isTotal) ...[
                  const SizedBox(height: 2),
                  Text(
                    details,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
              color: isTotal ? Theme.of(context).primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getExtraIcon(String? icon) {
    switch (icon) {
      case 'shield':
        return Icons.shield;
      case 'person':
        return Icons.person;
      case 'child_seat':
        return Icons.child_care;
      case 'wifi':
        return Icons.wifi;
      case 'delivery':
        return Icons.delivery_dining;
      default:
        return Icons.add_circle;
    }
  }
}