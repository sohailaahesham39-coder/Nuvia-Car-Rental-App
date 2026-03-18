import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../../data/models/car_model.dart';
import '../../../l10n/AppLocalizations.dart';
import '../../../providers/LocationProvider.dart';
import '../../../providers/auth.dart';
import 'CarCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  List<Car> _popularCars = [];
  LocationProvider? _locationProvider;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    // Initialize LocationProvider safely
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        _locationProvider = Provider.of<LocationProvider>(context, listen: false);
        _fetchPopularCars();
        _animationController.forward();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        // Log error or show snackbar if needed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing location: $e')),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchPopularCars() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Ensure LocationProvider is available
    if (_locationProvider == null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    // Dummy cars aligned with other screens
    final dummyCars = [
      Car(
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
        governorate: _locationProvider!.selectedGovernorate.isEmpty
            ? 'cairo'
            : _locationProvider!.selectedGovernorate,
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
          'https://i.pinimg.com/736x/01/8d/38/018d387a2a62192598f83456ce314899.jpg',
          'https://i.pinimg.com/736x/64/6b/ae/646baef070f0836a7817ab5b4950cea8.jpg',
          'https://i.pinimg.com/originals/53/28/57/5328572911f86b9f86e5051feef22e1b.jpg',
        ],
        governorate: _locationProvider!.selectedGovernorate.isEmpty
            ? 'cairo'
            : _locationProvider!.selectedGovernorate,
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
          'https://i.pinimg.com/736x/36/70/c6/3670c6674a4d098acd3a891664bf7f40.jpg',
          'https://i.pinimg.com/originals/4d/64/a3/4d64a3b9c0fa7054b6e8a5e0bcc4d0de.jpg',
          'https://i.pinimg.com/originals/a2/bb/f2/a2bbf2f627d7074a7f4e0953b274e5bc.jpg',
        ],
        governorate: _locationProvider!.selectedGovernorate.isEmpty
            ? 'cairo'
            : _locationProvider!.selectedGovernorate,
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

    if (mounted) {
      setState(() {
        _popularCars = dummyCars;
        _isLoading = false;
      });
    }
  }

  void _selectGovernorate() {
    context.push('/enter-location').then((_) {
      _fetchPopularCars();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locationProvider = Provider.of<LocationProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120.h,
              floating: true,
              pinned: true,
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                  ),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${authProvider.currentUser?.fullName.split(' ')[0] ?? 'User'}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: _selectGovernorate,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on, size: 16.sp, color: Colors.white70),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              locationProvider.getGovernorateNameById(
                                locationProvider.selectedGovernorate.isEmpty
                                    ? 'cairo'
                                    : locationProvider.selectedGovernorate,
                                isArabic,
                              ),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, size: 20.sp, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
                titlePadding: EdgeInsets.only(left: 16.w, bottom: 16.h, right: 16.w),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.notifications_outlined, color: Colors.white, size: 24.w),
                  onPressed: () {
                    context.push('/notifications');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.favorite_outline, color: Colors.white, size: 24.w),
                  onPressed: () {
                    context.push('/favorites');
                  },
                ),
              ],
            ),
          ];
        },
        body: _isLoading
            ? _buildLoadingView()
            : RefreshIndicator(
          onRefresh: _fetchPopularCars,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  _buildSearchBar(context),

                  SizedBox(height: 24.h),

                  // Popular Car Brands
                  _buildSectionHeader(context, l10n.popular),

                  SizedBox(height: 16.h),

                  // Brands List
                  SizedBox(
                    height: 110.h,
                    child: _buildBrandsList(),
                  ),

                  SizedBox(height: 24.h),

                  // Popular Cars Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.popularCars,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          context.push(
                            '/popular-cars?governorate=${locationProvider.selectedGovernorate.isEmpty ? 'cairo' : locationProvider.selectedGovernorate}',
                          );
                        },
                        icon: Icon(Icons.arrow_forward, size: 18.sp),
                        label: Text(
                          l10n.seeAll,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Cars List
                  _popularCars.isEmpty
                      ? _buildNoCarMessage(context, l10n)
                      : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _popularCars.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: CarCard(car: _popularCars[index]),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods for HomeScreen

  Widget _buildLoadingView() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Simulate Search Bar
            Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: 24.h),

            // Simulate Section Title
            Container(
              width: 150.w,
              height: 24.h,
              color: Colors.white,
            ),

            SizedBox(height: 16.h),

            // Simulate Brands List
            SizedBox(
              height: 110.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 16.w),
                    width: 80.w,
                    child: Column(
                      children: [
                        Container(
                          width: 60.w,
                          height: 60.h,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: 60.w,
                          height: 12.h,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 24.h),

            // Simulate Cars List
            for (int i = 0; i < 3; i++) ...[
              Container(
                margin: EdgeInsets.only(bottom: 16.h),
                height: 220.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Hero(
      tag: 'searchBar',
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              context.push('/search');
            },
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Icon(Icons.search, color: Theme.of(context).colorScheme.primary, size: 24.w),
                  SizedBox(width: 12.w),
                  Text(
                    'Search for cars...',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.sp,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.tune, color: Colors.grey, size: 20.w),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  Widget _buildBrandsList() {
    final brands = [
      {
        'name': 'Toyota',
        'logo': 'https://i.pinimg.com/736x/27/b7/de/27b7de9c188db33b73b49b79f9a9e99f.jpg',
        'color': Colors.red.shade50,
      },
      {
        'name': 'BMW',
        'logo': 'https://i.pinimg.com/736x/44/bc/e8/44bce83981415da64c1085be317ca733.jpg',
        'color': Colors.blue.shade50,
      },
      {
        'name': 'Mercedes',
        'logo': 'https://i.pinimg.com/736x/a8/b5/ea/a8b5eabb8806b45b13ba80f81993b66d.jpg',
        'color': Colors.grey.shade50,
      },
      {
        'name': 'Hyundai',
        'logo': 'https://i.pinimg.com/736x/7c/d5/54/7cd554b8a4005e7a290965e639aa8336.jpg',
        'color': Colors.blue.shade50,
      },
      {
        'name': 'Tesla',
        'logo': 'https://i.pinimg.com/736x/b2/16/2e/b2162e335ea0dc101c0defc288b5ac67.jpg',
        'color': Colors.red.shade50,
      },
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: brands.length,
      itemBuilder: (context, index) {
        final brand = brands[index];
        return _buildBrandCircle(
          brand['logo'] as String,
          brand['name'] as String,
          brand['color'] as Color,
        );
      },
    );
  }

  Widget _buildBrandCircle(String logoUrl, String brandName, Color bgColor) {
    return GestureDetector(
      onTap: () {
        context.push('/search?brand=$brandName');
      },
      child: Container(
        margin: EdgeInsets.only(right: 16.w),
        width: 80.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(12.w),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: logoUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.w,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.directions_car,
                    size: 30.w,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              brandName,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoCarMessage(BuildContext context, AppLocalizations l10n) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.directions_car_outlined,
              size: 80.w,
              color: Colors.grey.shade400,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            l10n.noPopularCars,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            '${l10n.selectGovernorate}: ${locationProvider.getGovernorateNameById(locationProvider.selectedGovernorate.isEmpty ? 'cairo' : locationProvider.selectedGovernorate, isArabic)}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 16.sp,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.trySearching,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _selectGovernorate,
                icon: Icon(Icons.location_on_outlined, size: 20.w),
                label: Text(
                  l10n.chooseDifferentGovernorate,
                  style: TextStyle(fontSize: 14.sp),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(width: 16.w),
              ElevatedButton.icon(
                onPressed: () {
                  context.push('/search');
                },
                icon: Icon(Icons.search, size: 20.w),
                label: Text(
                  l10n.search,
                  style: TextStyle(fontSize: 14.sp),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}