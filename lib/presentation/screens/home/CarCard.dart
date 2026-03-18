import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/models/car_model.dart';
import '../../../l10n/AppLocalizations.dart';
import '../../../providers/auth.dart';

class CarCard extends StatefulWidget {
  final Car car;

  const CarCard({
    super.key,
    required this.car,
  });

  @override
  _CarCardState createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> {
  late bool _isFavorite; // Track favorite state locally

  @override
  void initState() {
    super.initState();
    // Initialize _isFavorite based on AuthProvider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _isFavorite = authProvider.currentUser?.favoriteCarIds.contains(widget.car.id) ?? false;
  }

  void _toggleFavorite(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser == null) {
      // Optionally, navigate to login if user is not authenticated
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to manage favorites'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isFavorite = !_isFavorite;
    });

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite ? l10n.addedToFavorites : l10n.removedFromFavorites,
        ),
        duration: const Duration(seconds: 1),
      ),
    );

    // In a real app, update the user's favorites in AuthProvider and persist to backend
    // For now, we're just simulating the toggle locally
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        context.push('/car-details/${widget.car.id}');
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image and Favorite Button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  child: widget.car.imageUrls.isNotEmpty
                      ? Image.network(
                    widget.car.imageUrls[0],
                    height: 180.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180.h,
                        color: Colors.grey.shade200,
                        child: Center(
                          child: Icon(
                            Icons.directions_car,
                            size: 80.w,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  )
                      : Container(
                    height: 180.h,
                    color: Colors.grey.shade200,
                    child: Center(
                      child: Icon(
                        Icons.directions_car,
                        size: 80.w,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: GestureDetector(
                    onTap: () => _toggleFavorite(context),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_outline,
                        color: _isFavorite ? Colors.red : Colors.grey,
                        size: 20.w,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Car Details
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Car Name and Rating
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${widget.car.make} ${widget.car.model}',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontSize: 18.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16.w,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            widget.car.rating.toString(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Car Specs
                  Row(
                    children: [
                      _buildSpecItem(
                        Icons.event_seat_outlined,
                        l10n.seatsCount(widget.car.specs.seatsCount),
                      ),
                      _buildSpecItem(
                        Icons.settings_outlined,
                        widget.car.specs.transmission,
                      ),
                      _buildSpecItem(
                        Icons.local_gas_station_outlined,
                        widget.car.specs.fuelType,
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Price and Book Button
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${widget.car.pricePerDay.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            l10n.perDay,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          context.push('/book-car/${widget.car.id}');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                        ),
                        child: Text(
                          l10n.bookNow,
                          style: TextStyle(fontSize: 14.sp),
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

  Widget _buildSpecItem(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: 16.w,
            color: Colors.grey,
          ),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}