// lib/presentation/screens/location/EnterLocationScreen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../l10n/AppLocalizations.dart';
import '../../../providers/LocationProvider.dart';

class EnterLocationScreen extends StatefulWidget {
  const EnterLocationScreen({super.key});

  @override
  State<EnterLocationScreen> createState() => _EnterLocationScreenState();
}

class _EnterLocationScreenState extends State<EnterLocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchActive = false;

  // Egypt governorates data - replace with real data from your API
  final List<Map<String, dynamic>> _governorates = [
    {
      'id': 'cairo',
      'name': 'Cairo',
      'image': 'https://i.pinimg.com/564x/11/4e/97/114e97bfb7eb5f5c374b76242b26f639.jpg',
      'carCount': 250,
    },
    {
      'id': 'alexandria',
      'name': 'Alexandria',
      'image': 'https://i.pinimg.com/564x/73/e1/78/73e178a8c5d01c18dc00808f16e2fa4a.jpg',
      'carCount': 120,
    },
    {
      'id': 'luxor',
      'name': 'Luxor',
      'image': 'https://i.pinimg.com/564x/80/30/1e/80301e05fb6a65e23b53a71f593bc298.jpg',
      'carCount': 45,
    },
    {
      'id': 'aswan',
      'name': 'Aswan',
      'image': 'https://i.pinimg.com/564x/11/5e/1c/115e1ca4c8f4297c157e0df2b034c8cb.jpg',
      'carCount': 60,
    },
    {
      'id': 'sharm',
      'name': 'Sharm El Sheikh',
      'image': 'https://i.pinimg.com/564x/50/20/a4/5020a426fa89fa0b6e3a1177a66f05b6.jpg',
      'carCount': 180,
    },
    {
      'id': 'hurghada',
      'name': 'Hurghada',
      'image': 'https://i.pinimg.com/564x/46/44/cd/4644cdba5e1aacd027effc2aa93a53bf.jpg',
      'carCount': 90,
    },
    {
      'id': 'giza',
      'name': 'Giza',
      'image': 'https://i.pinimg.com/564x/d9/a3/45/d9a34597ff91daa83df5ec329f0d3d81.jpg',
      'carCount': 210,
    },
    {
      'id': 'portSaid',
      'name': 'Port Said',
      'image': 'https://i.pinimg.com/564x/38/8a/04/388a0438ad10da59f5ce15c9cc9ca0a8.jpg',
      'carCount': 40,
    },
    {
      'id': 'dahab',
      'name': 'Dahab',
      'image': 'https://i.pinimg.com/564x/3a/bc/9e/3abc9ef1cf6bed5e2e2a11d17bfd04c1.jpg',
      'carCount': 30,
    },
    {
      'id': 'elGouna',
      'name': 'El Gouna',
      'image': 'https://i.pinimg.com/564x/8d/5c/26/8d5c26fc908071a0fb3f79c09978dfa1.jpg',
      'carCount': 55,
    },
  ];

  // Recent locations - would be stored in local storage in a real app
  final List<String> _recentLocations = [
    'Cairo',
    'Alexandria',
    'Sharm El Sheikh',
    'Giza',
  ];

  List<Map<String, dynamic>> _filteredGovernorates = [];

  @override
  void initState() {
    super.initState();
    _filteredGovernorates = List.from(_governorates);
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchActive = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredGovernorates = List.from(_governorates);
      } else {
        _filteredGovernorates = _governorates
            .where((gov) => gov['name'].toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _selectLocation(BuildContext context, Map<String, dynamic> governorate) {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    locationProvider.setSelectedGovernorate(governorate['name']);

    // Add to recent locations (would normally handle duplicates and limit list size)
    if (!_recentLocations.contains(governorate['name'])) {
      setState(() {
        _recentLocations.insert(0, governorate['name']);
        if (_recentLocations.length > 5) {
          _recentLocations.removeLast();
        }
      });
    }

    // Go back to previous screen
    context.pop();
  }

  void _clearSearch() {
    _searchController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectLocation),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: l10n.enterLocation,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isSearchActive || _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // Body Content
          Expanded(
            child: _searchController.text.isEmpty
                ? _buildDefaultView(context)
                : _buildSearchResults(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Locations
          if (_recentLocations.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Text(
                'Recent Locations',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentLocations.length,
              itemBuilder: (context, index) {
                final locationName = _recentLocations[index];
                final governorate = _governorates.firstWhere(
                      (gov) => gov['name'] == locationName,
                  orElse: () => {
                    'id': 'unknown',
                    'name': locationName,
                    'image': '',
                    'carCount': 0,
                  },
                );

                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(locationName),
                  trailing: Text(
                    '${governorate['carCount']} cars',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () => _selectLocation(context, governorate),
                );
              },
            ),
            const Divider(height: 32),
          ],

          // All Locations
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Text(
              'All Locations',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          // Governorates Grid
          GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
              return _buildGovernorateCard(context, governorate);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    if (_filteredGovernorates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No locations found for "${_searchController.text}"',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Try a different search term',
              style: TextStyle(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _filteredGovernorates.length,
      itemBuilder: (context, index) {
        final governorate = _filteredGovernorates[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(governorate['image']),
          ),
          title: Text(governorate['name']),
          subtitle: Text('${governorate['carCount']} cars available'),
          onTap: () => _selectLocation(context, governorate),
        );
      },
    );
  }

  Widget _buildGovernorateCard(BuildContext context, Map<String, dynamic> governorate) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final isSelected = locationProvider.selectedGovernorate == governorate['name'];

    return GestureDetector(
      onTap: () => _selectLocation(context, governorate),
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
          border: isSelected
              ? Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 3,
          )
              : null,
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${governorate['carCount']} cars',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
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