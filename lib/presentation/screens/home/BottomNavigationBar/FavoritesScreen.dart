// lib/presentation/screens/favorites/FavoritesScreen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../l10n/AppLocalizations.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool _isLoading = false;

  // Dummy data - replace with real data from your API
  final List<Map<String, dynamic>> _favoriteCars = [
    {
      'id': 'car1',
      'make': 'Mercedes',
      'model': 'C-Class',
      'year': '2023',
      'pricePerDay': 120.0,
      'image': 'https://i.pinimg.com/736x/23/90/a1/2390a1c4af1f57956536ae695b867499.jpg',
      'rating': 4.8,
      'reviewCount': 24,
      'location': 'Downtown, Cairo',
      'isFavorited': true,
      'features': [
        'Automatic',
        'Leather Seats',
        'Bluetooth',
        'Parking Sensors',
      ],
    },
    {
      'id': 'car2',
      'make': 'BMW',
      'model': '5 Series',
      'year': '2022',
      'pricePerDay': 150.0,
      'image': 'https://i.pinimg.com/736x/36/70/c6/3670c6674a4d098acd3a891664bf7f40.jpg',
      'rating': 4.9,
      'reviewCount': 32,
      'location': 'Nasr City, Cairo',
      'isFavorited': true,
      'features': [
        'Automatic',
        'Sunroof',
        'Navigation',
        'Premium Sound',
      ],
    },
    {
      'id': 'car3',
      'make': 'Range Rover',
      'model': 'Velar',
      'year': '2023',
      'pricePerDay': 200.0,
      'image': 'https://i.pinimg.com/736x/7f/62/58/7f625875fabe8713aa9eb97cbb8a46f0.jpg',
      'rating': 4.7,
      'reviewCount': 18,
      'location': 'Maadi, Cairo',
      'isFavorited': true,
      'features': [
        'Automatic',
        'Panoramic Roof',
        'Leather Seats',
        'Climate Control',
      ],
    },
    {
      'id': 'car4',
      'make': 'Toyota',
      'model': 'Land Cruiser',
      'year': '2022',
      'pricePerDay': 180.0,
      'image': 'https://i.pinimg.com/736x/41/63/dc/4163dc961768515212883826bfecd6ee.jpg',
      'rating': 4.8,
      'reviewCount': 42,
      'location': 'Heliopolis, Cairo',
      'isFavorited': true,
      'features': [
        '4WD',
        'Automatic',
        '7 Seats',
        'Bluetooth',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.favorites),
        actions: [
          // Filter/Sort button
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: l10n.sortBy,
            onPressed: () {
              _showSortOptionsBottomSheet(context);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteCars.isEmpty
          ? _buildEmptyFavorites(context, l10n)
          : _buildFavoritesList(context, l10n),
    );
  }

  Widget _buildEmptyFavorites(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No Favorites',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'You haven\'t added any cars to your favorites yet.',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.go('/explore');
            },
            icon: const Icon(Icons.search),
            label: const Text('Explore Cars'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(BuildContext context, AppLocalizations l10n) {
    return RefreshIndicator(
      onRefresh: _refreshFavorites,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _favoriteCars.length,
        itemBuilder: (context, index) {
          final car = _favoriteCars[index];
          return _buildFavoriteCarCard(context, car);
        },
      ),
    );
  }

  Widget _buildFavoriteCarCard(BuildContext context, Map<String, dynamic> car) {
    return Dismissible(
      key: Key(car['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          _favoriteCars.remove(car);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${car['make']} ${car['model']} removed from favorites'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                setState(() {
                  _favoriteCars.add(car);
                });
              },
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            context.push('/car-details/${car['id']}');
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Car Image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: SizedBox(
                      width: double.infinity,
                      height: 180,
                      child: CachedNetworkImage(
                        imageUrl: car['image'],
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
                  // Favorite Button
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            car['isFavorited'] = !car['isFavorited'];
                            if (!car['isFavorited']) {
                              _favoriteCars.remove(car);
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            car['isFavorited'] ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Year tag
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        car['year'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Car Details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Car Name Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${car['make']} ${car['model']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '\$${car['pricePerDay'].toStringAsFixed(0)}/day',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${car['rating']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(' (${car['reviewCount']} reviews)'),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            car['location'],
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Features
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (car['features'] as List).map((feature) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            feature,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // View car details
                              context.push('/car-details/${car['id']}');
                            },
                            icon: const Icon(Icons.visibility),
                            label: const Text('View'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Book car
                              context.push('/book-car/${car['id']}');
                            },
                            icon: const Icon(Icons.directions_car),
                            label: const Text('Book'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
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
      ),
    );
  }

  Future<void> _refreshFavorites() async {
    // Implement refresh logic - fetch updated favorites from API
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      // Update favorites data here
    });
  }

  void _showSortOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Sort By',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildSortOption(context, 'Top Rated', Icons.star, () {
                  setState(() {
                    _favoriteCars.sort((a, b) => b['rating'].compareTo(a['rating']));
                  });
                  Navigator.pop(context);
                }),
                _buildSortOption(context, 'Price: Low to High', Icons.arrow_upward, () {
                  setState(() {
                    _favoriteCars.sort((a, b) => (a['pricePerDay'] as double).compareTo(b['pricePerDay'] as double));
                  });
                  Navigator.pop(context);
                }),
                _buildSortOption(context, 'Price: High to Low', Icons.arrow_downward, () {
                  setState(() {
                    _favoriteCars.sort((a, b) => (b['pricePerDay'] as double).compareTo(a['pricePerDay'] as double));
                  });
                  Navigator.pop(context);
                }),
                _buildSortOption(context, 'Newest', Icons.av_timer, () {
                  setState(() {
                    _favoriteCars.sort((a, b) => (b['year']).compareTo(a['year']));
                  });
                  Navigator.pop(context);
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortOption(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}