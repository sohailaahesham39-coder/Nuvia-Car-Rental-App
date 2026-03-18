import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/car_model.dart';
import '../../../l10n/AppLocalizations.dart';
import '../../../providers/LocationProvider.dart';
import '../home/CarCard.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  List<Car> _searchResults = [];
  Map<String, bool> _filterCategories = {};
  RangeValues _priceRange = const RangeValues(0, 1000);
  final double _maxPrice = 1000;
  String _selectedFuelType = '';
  String _selectedTransmission = '';
  String _selectedBrand = '';

  @override
  void initState() {
    super.initState();
    _initializeFilters();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults = [];
      });
    }
  }

  void _initializeFilters() {
    _filterCategories = {
      'SUV': false,
      'Sedan': false,
      'Luxury SUV': false,
      'Economy': false,
    };
    _selectedFuelType = '';
    _selectedTransmission = '';
    _selectedBrand = '';
    _priceRange = const RangeValues(0, 1000);
  }

  Future<void> _searchCars() async {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Generate dummy search results based on the query
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);

    final List<Car> dummyResults = [
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
        governorate: locationProvider.selectedGovernorate.isEmpty
            ? 'cairo'
            : locationProvider.selectedGovernorate,
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
        governorate: locationProvider.selectedGovernorate.isEmpty
            ? 'cairo'
            : locationProvider.selectedGovernorate,
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
        governorate: locationProvider.selectedGovernorate.isEmpty
            ? 'cairo'
            : locationProvider.selectedGovernorate,
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
          'https://i.pinimg.com/736x/0a/8b/5a/0a8b5a0f8b3d5e7b3e5a8f3e5b3c5d7.jpg',
          'https://i.pinimg.com/736x/1b/9c/6f/1b9c6f4b3c5d7e8b9f0a1b2c3d4e5f6.jpg',
        ],
        governorate: locationProvider.selectedGovernorate.isEmpty
            ? 'cairo'
            : locationProvider.selectedGovernorate,
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
        governorate: locationProvider.selectedGovernorate.isEmpty
            ? 'cairo'
            : locationProvider.selectedGovernorate,
        city: 'Heliopolis',
        location: const CarLocation(
          latitude: 30.0911,
          longitude: 31.3425,
          address: '456 El-Merghany St, Heliopolis',
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
          lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 25)),
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

    // Apply filters
    final filteredResults = dummyResults.where((car) {
      final matchesQuery = car.make.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          car.model.toLowerCase().contains(_searchController.text.toLowerCase());
      final matchesPriceRange = car.pricePerDay >= _priceRange.start && car.pricePerDay <= _priceRange.end;
      final matchesFuelType = _selectedFuelType.isEmpty || car.specs.fuelType == _selectedFuelType;
      final matchesTransmission = _selectedTransmission.isEmpty || car.specs.transmission == _selectedTransmission;
      final matchesBrand = _selectedBrand.isEmpty || car.make == _selectedBrand;
      final matchesCategory = _filterCategories.entries.where((entry) => entry.value).isEmpty ||
          _filterCategories[car.specs.category] == true;

      return matchesQuery &&
          matchesPriceRange &&
          matchesFuelType &&
          matchesTransmission &&
          matchesBrand &&
          matchesCategory;
    }).toList();

    setState(() {
      _searchResults = filteredResults;
      _isLoading = false;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 0.9,
              minChildSize: 0.5,
              expand: false,
              builder: (context, scrollController) {
                final l10n = AppLocalizations.of(context)!;
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.filters,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            TextButton(
                              onPressed: () {
                                setModalState(() {
                                  _initializeFilters();
                                });
                              },
                              child: Text(l10n.resetAll),
                            ),
                          ],
                        ),
                        const Divider(),
                        // Price Range Filter
                        Text(
                          l10n.priceRangePerDay,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        RangeSlider(
                          values: _priceRange,
                          min: 0,
                          max: _maxPrice,
                          divisions: 20,
                          labels: RangeLabels(
                            '\$${(_priceRange.start.round())}',
                            '\$${(_priceRange.end.round())}',
                          ),
                          onChanged: (values) {
                            setModalState(() {
                              _priceRange = values;
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('\$0'),
                            Text('\$${_maxPrice.toInt()}'),
                          ],
                        ),
                        const Divider(),
                        // Car Type Filter
                        Text(
                          l10n.carType,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _filterCategories.keys.map((category) {
                            return FilterChip(
                              label: Text(category),
                              selected: _filterCategories[category]!,
                              onSelected: (selected) {
                                setModalState(() {
                                  _filterCategories[category] = selected;
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const Divider(),
                        // Fuel Type Filter
                        Text(
                          l10n.fuelType,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ['Petrol', 'Diesel', 'Electric', 'Hybrid'].map((fuel) {
                            return ChoiceChip(
                              label: Text(fuel),
                              selected: _selectedFuelType == fuel,
                              onSelected: (selected) {
                                setModalState(() {
                                  _selectedFuelType = selected ? fuel : '';
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const Divider(),
                        // Transmission Filter
                        Text(
                          l10n.transmission,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ['Automatic', 'Manual'].map((transmission) {
                            return ChoiceChip(
                              label: Text(transmission),
                              selected: _selectedTransmission == transmission,
                              onSelected: (selected) {
                                setModalState(() {
                                  _selectedTransmission = selected ? transmission : '';
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const Divider(),
                        // Brand Filter
                        Text(
                          l10n.brand,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ['Toyota', 'Hyundai', 'BMW', 'Mercedes'].map((brand) {
                            return ChoiceChip(
                              label: Text(brand),
                              selected: _selectedBrand == brand,
                              onSelected: (selected) {
                                setModalState(() {
                                  _selectedBrand = selected ? brand : '';
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const Divider(),
                        // Apply Button
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _searchCars();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(l10n.applyFilters),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.search),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
            tooltip: l10n.filters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar and Location
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.searchCarsByBrandOrModel,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onSubmitted: (_) => _searchCars(),
                ),
                const SizedBox(height: 12),
                Row(
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
                        // TODO: Implement navigation to location selection screen
                        // Example: context.push('/location');
                      },
                      child: Text(l10n.chooseDifferentGovernorate),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Results
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchController.text.isEmpty
                        ? l10n.startSearching
                        : l10n.noSearchResults(_searchController.text),
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  if (_searchController.text.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.tryChangingFilters,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: CarCard(car: _searchResults[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}