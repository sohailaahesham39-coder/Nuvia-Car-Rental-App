import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/models/car_model.dart';
import '../../../l10n/AppLocalizations.dart';
import '../../../providers/LocationProvider.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  // Example data for governorates
  final List<Map<String, dynamic>> _governorates = [
    {
      'id': 'cairo',
      'name': 'Cairo',
      'image': 'https://i.pinimg.com/736x/60/b1/6b/60b16b763392334059c9d9612e894331.jpg',
      'carCount': 250,
    },
    {
      'id': 'alexandria',
      'name': 'Alexandria',
      'image': 'https://i.pinimg.com/736x/b4/d2/c3/b4d2c3e6392ff6f4e5ca42d3a5b353f0.jpg',
      'carCount': 120,
    },
    {
      'id': 'luxor',
      'name': 'Luxor',
      'image': 'https://i.pinimg.com/736x/3c/b8/50/3cb85022556725e5afce66c006d20c9d.jpg',
      'carCount': 45,
    },
    {
      'id': 'aswan',
      'name': 'Aswan',
      'image': 'https://i.pinimg.com/736x/ad/bb/35/adbb35813bb3741f821c63fd9529aac2.jpg',
      'carCount': 60,
    },
    {
      'id': 'sharm',
      'name': 'Sharm El Sheikh',
      'image': 'https://i.pinimg.com/736x/ea/77/e6/ea77e6b28d3c330c8da3e2c565cb3da3.jpg',
      'carCount': 180,
    },
    {
      'id': 'hurghada',
      'name': 'Hurghada',
      'image': 'https://i.pinimg.com/736x/e2/b9/f7/e2b9f7a40fb251619f5af6f9038f37e7.jpg',
      'carCount': 90,
    },
  ];

  // Updated car types to match available categories
  final List<Map<String, dynamic>> _carTypes = [
    {
      'id': 'suv',
      'name': 'SUV',
      'image': 'https://i.pinimg.com/736x/f0/c8/c0/f0c8c043eb195ec41e751c5fad912987.jpg',
    },
    {
      'id': 'sedan',
      'name': 'Sedan',
      'image': 'https://i.pinimg.com/736x/2c/fc/7e/2cfc7e2474266d55148a562f0349f5e7.jpg',
    },
    {
      'id': 'luxury_suv',
      'name': 'Luxury SUV',
      'image': 'https://i.pinimg.com/736x/7a/72/a8/7a72a867b1d0938fce630c83fe564188.jpg',
    },
    {
      'id': 'luxury',
      'name': 'Luxury',
      'image': 'https://i.pinimg.com/736x/61/cf/65/61cf6501cba7009b31ad4505fc0e214a.jpg',
    },
  ];

  // Updated featured cars with required fields
  final List<Car> _featuredCars = [
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
        lastMaintenanceDate: DateTime(2025, 3, 15),
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
        lastMaintenanceDate: DateTime(2025, 4, 1),
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
    Car(
      id: '5',
      model: 'C-Class',
      make: 'Mercedes',
      year: '2023',
      plateNumber: 'GHI 123',
      pricePerDay: 300.0,
      imageUrls: [
        'https://i.pinimg.com/736x/5a/3b/2c/5a3b2c4d5e6f7a8b9c0d1e2f3a4b5c6.jpg',
        'https://i.pinimg.com/736x/6b/4c/3d/6b4c3d5e6f7a8b9c0d1e2f3a4b5c6d7.jpg',
        'https://i.pinimg.com/736x/7c/5d/4e/7c5d4e5f6a7b8c9d0e1f2a3b4c5d6e7.jpg',
      ],
      governorate: 'sharm',
      city: 'Naama Bay',
      location: const CarLocation(
        latitude: 27.9158,
        longitude: 34.3299,
        address: '789 Naama Bay, Sharm El Sheikh',
      ),
      specs: const CarSpecifications(
        fuelType: 'Hybrid',
        transmission: 'Automatic',
        seatsCount: 5,
        engineSize: '2.0L',
        fuelEfficiency: 20.0,
        color: 'Silver',
        category: 'Luxury',
      ),
      features: [
        const CarFeature(name: 'Bluetooth', icon: 'bluetooth', isHighlighted: true),
        const CarFeature(name: 'Air Conditioning', icon: 'ac', isHighlighted: true),
        const CarFeature(name: 'Leather Seats', icon: 'seat', isHighlighted: true),
        const CarFeature(name: 'Lane Assist', icon: 'lane_assist', isHighlighted: true),
      ],
      availability: CarAvailability(
        isAvailable: true,
        bookedDates: [],
        lastMaintenanceDate: DateTime(2025, 2, 28),
        availabilityStatus: 'available',
      ),
      rating: 4.7,
      reviewCount: 20,
      ownerId: 'partner4',
      description: 'Luxury sedan with advanced technology, perfect for premium rentals.',
      ownerInfo: OwnerInfo(
        name: 'Mona Ibrahim',
        phoneNumber: '+201556677889',
        profileImageUrl: 'https://i.pinimg.com/564x/9a/8b/7c/9a8b7c4d5e6f7a8b9c0d1e2f3a4b5c6.jpg',
        rating: 4.8,
      ),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Center(child: Text('Localization not available'));
    }
    final locationProvider = Provider.of<LocationProvider>(context);

    return Directionality(
      textDirection: l10n.localeName == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.explore),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                context.push('/search');
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                // TODO: Navigate to filter screen or show filter dialog
                context.push('/filters');
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _isLoading = true;
            });
            // Simulate refresh logic
            await Future.delayed(const Duration(seconds: 1));
            setState(() {
              _isLoading = false;
            });
          },
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
            children: [
              // Location Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        locationProvider.selectedGovernorate.isEmpty
                            ? l10n.selectLocation
                            : locationProvider.selectedGovernorate,
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.push('/enter-location');
                      },
                      child: Text(l10n.chooseDifferentGovernorate),
                    ),
                  ],
                ),
              ),

              // Car Type Categories
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.carType,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _carTypes.length,
                        itemBuilder: (context, index) {
                          final carType = _carTypes[index];
                          return _buildCarTypeCard(context, carType);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Featured Cars
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.featuredCars,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextButton(
                          onPressed: () {
                            context.push('/featured-cars');
                          },
                          child: Text(l10n.seeAll),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _featuredCars.length,
                      itemBuilder: (context, index) {
                        final car = _featuredCars[index];
                        return _buildFeaturedCarCard(context, car);
                      },
                    ),
                  ],
                ),
              ),

              // Popular Cities / Governorates
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.popularCities,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.1,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _governorates.length,
                      itemBuilder: (context, index) {
                        final governorate = _governorates[index];
                        return _buildGovernorateCard(context, governorate, locationProvider);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarTypeCard(BuildContext context, Map<String, dynamic> carType) {
    return GestureDetector(
      onTap: () {
        // Navigate to search with car type filter
        context.push('/search?carType=${carType['id']}');
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: carType['image'],
                width: 80,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 80,
                  height: 60,
                  color: Colors.grey[200],
                  child: const Icon(Icons.car_rental, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              carType['name'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCarCard(BuildContext context, Car car) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        // Navigate to car details
        context.push('/car-details/${car.id}');
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image
            SizedBox(
              height: 180,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: car.imageUrls.isNotEmpty ? car.imageUrls[0] : 'https://via.placeholder.com/300',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.car_rental, size: 60, color: Colors.grey),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Car Name and Year
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${car.make} ${car.model} (${car.specs.category})',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          car.year,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Rating and Price
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        car.rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(' (${car.reviewCount} ${l10n.reviews})'),
                      const Spacer(),
                      Text(
                        '\$${car.pricePerDay.toStringAsFixed(2)}/${l10n.day}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_pin, size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          car.location.address,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGovernorateCard(
      BuildContext context,
      Map<String, dynamic> governorate,
      LocationProvider locationProvider,
      ) {
    return GestureDetector(
      onTap: () {
        // Set selected governorate and navigate to popular cars
        locationProvider.setSelectedGovernorate(governorate['name']);
        context.push('/popular-cars?governorate=${governorate['id']}');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: CachedNetworkImageProvider(governorate['image']),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    governorate['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${governorate['carCount']} cars',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (locationProvider.selectedGovernorate == governorate['name'])
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}