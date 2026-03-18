import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../../../data/models/car_model.dart';
import '../../../data/models/review_model.dart';
import '../../../l10n/AppLocalizations.dart';
import '../../../providers/auth.dart';

class CarDetailsScreen extends StatefulWidget {
  final String carId;

  const CarDetailsScreen({
    super.key,
    required this.carId,
  });

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  Car? _car;
  late TabController _tabController;
  List<Review> _reviews = [];
  bool _isFavorite = false;
  final PageController _imagePageController = PageController();
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchCarDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _imagePageController.dispose();
    super.dispose();
  }

  Future<void> _fetchCarDetails() async {
    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // محاكاة طلب API
    await Future.delayed(const Duration(seconds: 1));

    // قائمة السيارات الوهمية (نفس القائمة من HomeScreen)
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

    // جلب السيارة بناءً على carId
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

    // جلب تقييمات وهمية متنوعة لكل سيارة
    final dummyReviews = [
      Review(
        id: '1',
        userId: 'user1',
        userName: 'Ahmed Mohamed',
        userPhotoUrl: 'https://i.pinimg.com/564x/e8/d7/d9/e8d7d9d7861b7d4c1386a4de37eb4290.jpg',
        carId: widget.carId,
        bookingId: 'booking1',
        rating: widget.carId == '1' ? 5.0 : widget.carId == '2' ? 4.5 : 4.8,
        comment: widget.carId == '1'
            ? 'Great car and very clean. Highly recommended for family trips.'
            : widget.carId == '2'
            ? 'Perfect for city driving, very fuel-efficient.'
            : 'Luxurious and powerful, worth every penny.',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        isVerifiedRental: true,
        categoryRatings: {
          'cleanliness': widget.carId == '1' ? 5.0 : 4.5,
          'comfort': widget.carId == '1' ? 4.8 : 4.5,
          'performance': widget.carId == '1' ? 4.9 : 4.7,
          'value': widget.carId == '1' ? 4.7 : 4.3,
        },
      ),
      Review(
        id: '2',
        userId: 'user2',
        userName: 'Jasmine Ali',
        userPhotoUrl: 'https://i.pinimg.com/564x/05/eb/c0/05ebc096d787bf1abc90e5359337b6e8.jpg',
        carId: widget.carId,
        bookingId: 'booking2',
        rating: widget.carId == '1' ? 4.5 : widget.carId == '2' ? 4.0 : 4.7,
        comment: widget.carId == '1'
            ? 'Comfortable ride, but had minor scratches.'
            : widget.carId == '2'
            ? 'Good car, but interior could be cleaner.'
            : 'Amazing experience, very smooth drive.',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        isVerifiedRental: true,
        categoryRatings: {
          'cleanliness': widget.carId == '1' ? 4.0 : 3.8,
          'comfort': widget.carId == '1' ? 4.5 : 4.0,
          'performance': widget.carId == '1' ? 4.8 : 4.5,
          'value': widget.carId == '1' ? 4.2 : 4.0,
        },
      ),
    ];

    setState(() {
      _car = selectedCar;
      _reviews = dummyReviews;
      _isFavorite = authProvider.currentUser?.favoriteCarIds.contains(widget.carId) ?? false;
      _isLoading = false;
    });
  }

  void _toggleFavorite() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      setState(() {
        _isFavorite = !_isFavorite;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isFavorite ? 'Added to favorites' : 'Removed from favorites',
          ),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please login to add car to favorites'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_car == null || _car!.model == 'Unknown') {
      return Scaffold(
        appBar: AppBar(),
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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar with Car Images
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildCarImagesCarousel(),
              ),
              actions: [
                IconButton(
                  icon: AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    firstChild: const Icon(Icons.favorite, color: Colors.red),
                    secondChild: const Icon(Icons.favorite_outline),
                    crossFadeState: _isFavorite ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  ),
                  onPressed: _toggleFavorite,
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Share this car'),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                ),
              ],
            ),

            // Car Details
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Car Name and Rating
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_car!.make} ${_car!.model} ${_car!.year}',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      _car!.location.address,
                                      style: const TextStyle(color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _car!.rating.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${_car!.reviewCount})',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Image indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_car!.imageUrls.length, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _currentImageIndex == index ? 24 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: _currentImageIndex == index
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade300,
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 24),

                    // Price and Book Now
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.1),
                            Colors.grey.shade50,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$${_car!.pricePerDay.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Text(
                                '/ ${l10n.day}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              context.push('/book-car/${_car!.id}');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  l10n.bookNow,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Availability Badge
                    if (_car!.availability.isAvailable)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade700,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Available Now',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Tabs
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Colors.grey,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        tabs: [
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.info_outline, size: 18),
                                const SizedBox(width: 6),
                                Text(l10n.details),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle_outline, size: 18),
                                const SizedBox(width: 6),
                                Text(l10n.features),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.star_outline, size: 18),
                                const SizedBox(width: 6),
                                Text(l10n.reviews),
                              ],
                            ),
                          ),
                        ],
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tab Content
            SliverFillRemaining(
              hasScrollBody: true,
              fillOverscroll: false,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDetailsTab(),
                  _buildFeaturesTab(),
                  _buildReviewsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/book-car/${_car!.id}');
        },
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        label: Text(l10n.bookNow),
        icon: const Icon(Icons.calendar_today),
      ),
    );
  }

  Widget _buildCarImagesCarousel() {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),
        PageView.builder(
          controller: _imagePageController,
          itemCount: _car!.imageUrls.length,
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return Hero(
              tag: '${_car!.id}_image_$index',
              child: CachedNetworkImage(
                imageUrl: _car!.imageUrls[index],
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        if (_currentImageIndex > 0)
          Positioned(
            left: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    _imagePageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        if (_currentImageIndex < _car!.imageUrls.length - 1)
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    _imagePageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${_currentImageIndex + 1}/${_car!.imageUrls.length}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Car Description
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.description,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                _car!.description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Owner Info
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Owner Information',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: CachedNetworkImageProvider(
                      _car!.ownerInfo.profileImageUrl,
                    ),
                    backgroundColor: Colors.grey.shade200,
                    onBackgroundImageError: (exception, stackTrace) {
                      // Handle error
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _car!.ownerInfo.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _car!.ownerInfo.phoneNumber,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _car!.ownerInfo.rating.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Contacting ${_car!.ownerInfo.name}...'),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                icon: const Icon(Icons.message),
                label: const Text('Contact Owner'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Car Specifications
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.car_repair,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Specifications',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildSpecItem(Icons.event_seat_outlined, 'Seats', '${_car!.specs.seatsCount}'),
                  _buildSpecItem(Icons.settings_outlined, 'Transmission', _car!.specs.transmission),
                  _buildSpecItem(Icons.local_gas_station_outlined, 'Fuel Type', _car!.specs.fuelType),
                  _buildSpecItem(Icons.speed_outlined, 'Engine', _car!.specs.engineSize),
                  _buildSpecItem(Icons.invert_colors_outlined, 'Color', _car!.specs.color),
                  _buildSpecItem(Icons.eco_outlined, 'Fuel Efficiency', '${_car!.specs.fuelEfficiency} km/l'),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Location Section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Location',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                  ),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: 'https://i.pinimg.com/736x/a7/4d/90/a74d9040d75881eeae361ae11a65430c.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(
                            Icons.map,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_car!.city}, ${_car!.governorate}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _car!.location.address,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Opening map...'),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                icon: const Icon(Icons.directions),
                label: const Text('Get Directions'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Last Maintenance Date
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.build_circle_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Maintenance',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last Maintenance',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          _formatDate(_car!.availability.lastMaintenanceDate),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 80), // Extra padding for FloatingActionButton
      ],
    );
  }

  Widget _buildFeaturesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Highlighted Features',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _car!.features
                      .where((feature) => feature.isHighlighted)
                      .map((feature) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getIconData(feature.icon),
                          color: Theme.of(context).primaryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          feature.name,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.list_alt,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'All Features',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _car!.features.length,
                  itemBuilder: (context, index) {
                    final feature = _car!.features[index];
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: feature.isHighlighted
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getIconData(feature.icon),
                          color: feature.isHighlighted ? Theme.of(context).primaryColor : Colors.grey,
                          size: 24,
                        ),
                      ),
                      title: Text(
                        feature.name,
                        style: TextStyle(
                          fontWeight: feature.isHighlighted ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: feature.isHighlighted
                          ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Included',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                          : null,
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 100), // Increased padding for FloatingActionButton
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Rating Summary Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _car!.rating.toString(),
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < _car!.rating.floor()
                                ? Icons.star
                                : index < _car!.rating
                                ? Icons.star_half
                                : Icons.star_outline,
                            color: Colors.amber,
                            size: 16,
                          );
                        }),
                      ),
                      Text(
                        'Based on ${_car!.reviewCount} reviews',
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
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildCategoryRating('Cleanliness', _reviews.isNotEmpty ? _reviews[0].categoryRatings!['cleanliness']! : 4.8),
                  ),
                  Expanded(
                    child: _buildCategoryRating('Comfort', _reviews.isNotEmpty ? _reviews[0].categoryRatings!['comfort']! : 4.7),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildCategoryRating('Performance', _reviews.isNotEmpty ? _reviews[0].categoryRatings!['performance']! : 4.9),
                  ),
                  Expanded(
                    child: _buildCategoryRating('Value', _reviews.isNotEmpty ? _reviews[0].categoryRatings!['value']! : 4.6),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Reviews Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Reviews',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                // Show all reviews
              },
              icon: const Icon(Icons.list_alt),
              label: Text(l10n.seeAll),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Reviews List
        _reviews.isEmpty
            ? Center(
          child: Column(
            children: [
              Icon(
                Icons.rate_review_outlined,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.noReviews,
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        )
            : ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _reviews.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final review = _reviews[index];
            return _buildReviewItem(review);
          },
        ),
        const SizedBox(height: 100), // Increased padding for FloatingActionButton
      ],
    );
  }

  Widget _buildCategoryRating(String category, double rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: rating / 5,
                  backgroundColor: Colors.grey.shade200,
                  color: _getRatingColor(rating),
                  minHeight: 6,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              rating.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.5) return Colors.green;
    if (rating >= 3.5) return Colors.amber;
    if (rating >= 2.5) return Colors.orange;
    return Colors.red;
  }

  Widget _buildSpecItem(IconData icon, String label, String value) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 12,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "$label: ",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          TextSpan(
                            text: value,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(Review review) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info and Rating
          Row(
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  review.userPhotoUrl ?? 'https://i.pinimg.com/564x/5f/40/6a/5f406ab25e8942cbe0da6485afd26b71.jpg',
                ),
                radius: 24,
                onBackgroundImageError: (exception, stackTrace) {
                  // Handle error
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _formatDate(review.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getRatingColor(review.rating).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: _getRatingColor(review.rating),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      review.rating.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getRatingColor(review.rating),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Verified Rental Badge
          if (review.isVerifiedRental)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.green.shade200,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified,
                    size: 14,
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Verified Rental',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

          // Review Content
          Text(
            review.comment,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),

          // Category Ratings
          if (review.categoryRatings != null && review.categoryRatings!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: review.categoryRatings!.entries.map((entry) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getCategoryName(entry.key),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getRatingColor(entry.value).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          entry.value.toString(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _getRatingColor(entry.value),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final difference = DateTime.now().difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year(s) ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month(s) ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day(s) ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour(s) ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute(s) ago';
    } else {
      return 'Just now';
    }
  }

  String _getCategoryName(String key) {
    switch (key) {
      case 'cleanliness':
        return 'Cleanliness';
      case 'comfort':
        return 'Comfort';
      case 'performance':
        return 'Performance';
      case 'value':
        return 'Value';
      default:
        return key;
    }
  }

  IconData _getIconData(String icon) {
    switch (icon) {
      case 'bluetooth':
        return Icons.bluetooth;
      case 'ac':
        return Icons.ac_unit;
      case 'sensors':
        return Icons.sensors;
      case 'speed':
        return Icons.speed;
      case 'navigation':
        return Icons.navigation;
      case 'seat':
        return Icons.event_seat;
      case 'sunroof':
        return Icons.wb_sunny;
      case 'camera':
        return Icons.camera_alt;
      default:
        return Icons.check_circle;
    }
  }
}