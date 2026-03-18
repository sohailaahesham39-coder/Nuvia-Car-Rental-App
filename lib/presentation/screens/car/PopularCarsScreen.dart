import 'package:flutter/material.dart';

import '../../../data/models/car_model.dart';
import '../../../l10n/AppLocalizations.dart';
import '../home/CarCard.dart';
import '../home/home.dart';

class PopularCarsScreen extends StatefulWidget {
  final String governorateId;

  const PopularCarsScreen({
    super.key,
    required this.governorateId,
  });

  @override
  State<PopularCarsScreen> createState() => _PopularCarsScreenState();
}

class _PopularCarsScreenState extends State<PopularCarsScreen> {
  bool _isLoading = false;
  List<Car> _popularCars = [];
  String _sortBy = 'rating'; // Default sort by rating

  @override
  void initState() {
    super.initState();
    _fetchPopularCars();
  }

  Future<void> _fetchPopularCars() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Generate dummy cars for demo, consistent with BookCarScreen
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
        ],
        governorate: widget.governorateId,
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
        ],
        governorate: widget.governorateId,
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
        ],
        governorate: widget.governorateId,
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
      Car(
        id: '4',
        model: 'Tucson',
        make: 'Hyundai',
        year: '2022',
        plateNumber: 'DEF 789',
        pricePerDay: 120.0,
        imageUrls: [
          'https://i.pinimg.com/736x/3c/5f/9f/3c5f9f67060cba2d5c7df59d9532b3db.jpg',
        ],
        governorate: widget.governorateId,
        city: 'Maadi',
        location: const CarLocation(
          latitude: 29.9603,
          longitude: 31.2503,
          address: '123 Degla St, Maadi',
        ),
        specs: const CarSpecifications(
          fuelType: 'Petrol',
          transmission: 'Automatic',
          seatsCount: 5,
          engineSize: '2.0L',
          fuelEfficiency: 15.5,
          color: 'Blue',
          category: 'SUV',
        ),
        features: [
          const CarFeature(name: 'Bluetooth', icon: 'bluetooth', isHighlighted: true),
          const CarFeature(name: 'Air Conditioning', icon: 'ac', isHighlighted: true),
          const CarFeature(name: 'Reverse Camera', icon: 'camera', isHighlighted: true),
        ],
        availability: CarAvailability(
          isAvailable: true,
          bookedDates: [],
          lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 20)),
          availabilityStatus: 'available',
        ),
        rating: 4.4,
        reviewCount: 15,
        ownerId: 'partner2',
        description: 'Modern SUV with great fuel efficiency, perfect for families.',
        ownerInfo: OwnerInfo(
          name: 'Sarah Mohamed',
          phoneNumber: '+201987654321',
          profileImageUrl: 'https://i.pinimg.com/564x/05/eb/c0/05ebc096d787bf1abc90e5359337b6e8.jpg',
          rating: 4.4,
        ),
      ),
      Car(
        id: '5',
        model: 'Corolla',
        make: 'Toyota',
        year: '2023',
        plateNumber: 'GHI 123',
        pricePerDay: 90.0,
        imageUrls: [
          'https://i.pinimg.com/736x/56/64/22/566422a5dbaf8bdce8c87337b3935c2f.jpg',
        ],
        governorate: widget.governorateId,
        city: 'Heliopolis',
        location: const CarLocation(
          latitude: 30.0911,
          longitude: 31.3425,
          address: '456 El-Merghany St, Heliopolis',
        ),
        specs: const CarSpecifications(
          fuelType: 'Petrol',
          transmission: 'Automatic',
          seatsCount: 5,
          engineSize: '1.6L',
          fuelEfficiency: 17.8,
          color: 'White',
          category: 'Sedan',
        ),
        features: [
          const CarFeature(name: 'Bluetooth', icon: 'bluetooth', isHighlighted: true),
          const CarFeature(name: 'Air Conditioning', icon: 'ac', isHighlighted: true),
          const CarFeature(name: 'Lane Assist', icon: 'lane_assist', isHighlighted: false),
        ],
        availability: CarAvailability(
          isAvailable: true,
          bookedDates: [],
          lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 25)),
          availabilityStatus: 'available',
        ),
        rating: 4.6,
        reviewCount: 28,
        ownerId: 'partner1',
        description: 'Reliable sedan with excellent fuel economy, ideal for daily use.',
        ownerInfo: OwnerInfo(
          name: 'Ahmed Hassan',
          phoneNumber: '+201234567890',
          profileImageUrl: 'https://i.pinimg.com/564x/e8/d7/d9/e8d7d9d7861b7d4c1386a4de37eb4290.jpg',
          rating: 4.7,
        ),
      ),
    ];

    // Sort cars based on selected sort option
    _sortCars(dummyCars);

    setState(() {
      _popularCars = dummyCars;
      _isLoading = false;
    });
  }

  void _sortCars(List<Car> cars) {
    switch (_sortBy) {
      case 'rating':
        cars.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'price_low':
        cars.sort((a, b) => a.pricePerDay.compareTo(b.pricePerDay));
        break;
      case 'price_high':
        cars.sort((a, b) => b.pricePerDay.compareTo(b.pricePerDay));
        break;
      case 'newest':
        cars.sort((a, b) => b.year.compareTo(a.year));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.popularCars),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _sortBy = value;
                _sortCars(_popularCars);
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'rating',
                child: Text(localizations.topRated),
              ),
              PopupMenuItem(
                value: 'price_low',
                child: Text(localizations.priceLowToHigh),
              ),
              PopupMenuItem(
                value: 'price_high',
                child: Text(localizations.priceHighToLow),
              ),
              PopupMenuItem(
                value: 'newest',
                child: Text(localizations.newest),
              ),
            ],
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _popularCars.isEmpty
          ? Center(child: Text(localizations.noPopularCars))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _popularCars.length,
        itemBuilder: (context, index) {
          return CarCard(car: _popularCars[index]);
        },
      ),
    );
  }
}