import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/booking_model.dart';
import '../../../../l10n/AppLocalizations.dart';

// Booking model for strong typing
class Booking {
  final String id;
  final String carName;
  final String carImage;
  final DateTime startDate;
  final DateTime endDate;
  final double? totalAmount; // Nullable to handle missing data
  final BookingStatus status;
  final bool isDriverIncluded;
  final String location;
  final String licensePlate;
  final List<String> features;
  final double rating;
  final bool? isReviewed;
  final String? cancellationReason;

  Booking({
    required this.id,
    required this.carName,
    required this.carImage,
    required this.startDate,
    required this.endDate,
    this.totalAmount,
    required this.status,
    required this.isDriverIncluded,
    required this.location,
    required this.licensePlate,
    required this.features,
    required this.rating,
    this.isReviewed,
    this.cancellationReason,
  });
}

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGridView = false;
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _scrollController.addListener(_onScroll);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_showBackToTop) {
      setState(() {
        _showBackToTop = true;
      });
    } else if (_scrollController.offset <= 200 && _showBackToTop) {
      setState(() {
        _showBackToTop = false;
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Dummy bookings data - replace with real API data
  final List<Booking> _upcomingBookings = [
    Booking(
      id: 'booking1',
      carName: 'Toyota Fortuner',
      carImage: 'https://i.pinimg.com/736x/94/43/0b/94430b7bd3ff5f966892d8f3ba073f2d.jpg',
      startDate: DateTime.now().add(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 5)),
      totalAmount: 450.0,
      status: BookingStatus.confirmed,
      isDriverIncluded: false,
      location: 'Downtown, Cairo',
      licensePlate: 'ABC 123',
      features: ['GPS', 'Bluetooth', 'Cruise Control'],
      rating: 4.8,
    ),
    Booking(
      id: 'booking2',
      carName: 'Mercedes C-Class',
      carImage: 'https://i.pinimg.com/736x/82/45/80/824580d6925bcbabe5aceaf90b537185.jpg',
      startDate: DateTime.now().add(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 10)),
      totalAmount: 680.0,
      status: BookingStatus.pending,
      isDriverIncluded: true,
      location: 'Nasr City, Cairo',
      licensePlate: 'XYZ 789',
      features: ['Leather Seats', 'Sunroof', 'Backup Camera'],
      rating: 4.9,
    ),
  ];

  final List<Booking> _ongoingBookings = [
    Booking(
      id: 'booking3',
      carName: 'BMW 5 Series',
      carImage: 'https://i.pinimg.com/736x/8f/da/a0/8fdaa0b12cb79c6720677d557bd57445.jpg',
      startDate: DateTime.now().subtract(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 2)),
      totalAmount: 550.0,
      status: BookingStatus.inProgress,
      isDriverIncluded: false,
      location: 'Downtown, Cairo',
      licensePlate: 'DEF 456',
      features: ['Navigation', 'Heated Seats', 'Parking Sensors'],
      rating: 4.7,
    ),
  ];

  final List<Booking> _previousBookings = [
    Booking(
      id: 'booking4',
      carName: 'Hyundai Tucson',
      carImage: 'https://i.pinimg.com/736x/67/a6/cc/67a6cce6b5ef282592a30f679023adcc.jpg',
      startDate: DateTime.now().subtract(const Duration(days: 15)),
      endDate: DateTime.now().subtract(const Duration(days: 12)),
      totalAmount: 360.0,
      status: BookingStatus.completed,
      isDriverIncluded: false,
      location: 'Maadi, Cairo',
      licensePlate: 'GHI 789',
      features: ['Apple CarPlay', 'Android Auto', 'Lane Assist'],
      rating: 4.5,
      isReviewed: true,
    ),
    Booking(
      id: 'booking5',
      carName: 'Kia Sportage',
      carImage: 'https://i.pinimg.com/736x/35/89/bc/3589bcf7df9a276223a0d817ec2a3872.jpg',
      startDate: DateTime.now().subtract(const Duration(days: 25)),
      endDate: DateTime.now().subtract(const Duration(days: 22)),
      totalAmount: 320.0,
      status: BookingStatus.completed,
      isDriverIncluded: true,
      location: 'Heliopolis, Cairo',
      licensePlate: 'JKL 012',
      features: ['AWD', 'Panoramic Roof', 'Premium Sound'],
      rating: 4.6,
      isReviewed: false,
    ),
    Booking(
      id: 'booking6',
      carName: 'Toyota Corolla',
      carImage: 'https://i.pinimg.com/736x/52/aa/05/52aa050771ab6c34dcd5ec6708798b44.jpg',
      startDate: DateTime.now().subtract(const Duration(days: 40)),
      endDate: DateTime.now().subtract(const Duration(days: 38)),
      totalAmount: 240.0,
      status: BookingStatus.cancelled,
      isDriverIncluded: false,
      location: 'Giza',
      licensePlate: 'MNO 345',
      features: ['Basic Package', 'Manual Transmission'],
      rating: 4.3,
      cancellationReason: 'Changed travel plans',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          // Background decoration
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 240,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Custom AppBar with animation
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.bookings,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
                      _buildViewToggle()
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 200.ms)
                          .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
                    ],
                  ),
                ),

                // Enhanced TabBar with animation
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    dividerColor: Colors.transparent,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.white,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    tabs: [
                      _buildTab('Upcoming', _upcomingBookings.length),
                      _buildTab('Ongoing', _ongoingBookings.length),
                      _buildTab('Previous', _previousBookings.length),
                    ],
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.2, end: 0),

                // TabBarView with custom animations
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildAnimatedBookingsList(
                            context,
                            _upcomingBookings,
                            l10n,
                            _handleUpcomingBookingAction,
                            emptyMessage: 'No upcoming bookings',
                            emptyIcon: Icons.upcoming,
                          ),
                          _buildAnimatedBookingsList(
                            context,
                            _ongoingBookings,
                            l10n,
                            _handleOngoingBookingAction,
                            emptyMessage: 'No ongoing bookings',
                            emptyIcon: Icons.directions_car,
                          ),
                          _buildAnimatedBookingsList(
                            context,
                            _previousBookings,
                            l10n,
                            _handlePreviousBookingAction,
                            emptyMessage: 'No previous bookings',
                            emptyIcon: Icons.history,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Back to top button
          if (_showBackToTop)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                mini: true,
                onPressed: _scrollToTop,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(Icons.arrow_upward),
              ),
            ).animate().fadeIn().scale(begin: const Offset(0, 0), end: const Offset(1, 1)),
        ],
      ),
    );
  }

  Widget _buildViewToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => setState(() => _isGridView = false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: !_isGridView ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.view_list,
                color: !_isGridView ? Theme.of(context).primaryColor : Colors.white,
                size: 20,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _isGridView = true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _isGridView ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.grid_view,
                color: _isGridView ? Theme.of(context).primaryColor : Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int count) {
    return Tab(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 100), // Limit total width
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Add this to shrink to content
          children: [
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14), // Slightly smaller font size
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 4), // Reduced from 8
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), // Reduced padding
                decoration: BoxDecoration(
                  color: _tabController.index == (_getTabIndex(title))
                      ? Theme.of(context).primaryColor.withOpacity(0.2)
                      : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    fontSize: 11, // Reduced from 12
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  int _getTabIndex(String title) {
    switch (title) {
      case 'Upcoming':
        return 0;
      case 'Ongoing':
        return 1;
      case 'Previous':
        return 2;
      default:
        return 0;
    }
  }

  Widget _buildAnimatedBookingsList(
      BuildContext context,
      List<Booking> bookings,
      AppLocalizations l10n,
      Function(BuildContext, Booking) onActionPressed, {
        required String emptyMessage,
        required IconData emptyIcon,
      }) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                emptyIcon,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your bookings will appear here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
    }

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Implement real API refresh logic
        await Future.delayed(const Duration(seconds: 1));
      },
      color: Theme.of(context).primaryColor,
      child: _isGridView
          ? GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return _buildGridBookingCard(context, booking, l10n, onActionPressed)
              .animate()
              .fadeIn(duration: 600.ms, delay: (index * 100).ms)
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
        },
      )
          : ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return _buildListBookingCard(context, booking, l10n, onActionPressed)
              .animate()
              .fadeIn(duration: 600.ms, delay: (index * 100).ms)
              .slideX(begin: 0.2, end: 0);
        },
      ),
    );
  }

  Widget _buildListBookingCard(
      BuildContext context,
      Booking booking,
      AppLocalizations l10n,
      Function(BuildContext, Booking) onActionPressed,
      ) {
    final durationDays = booking.endDate.difference(booking.startDate).inDays + 1;
    final statusColor = _getStatusColor(booking.status);
    final statusText = _getStatusText(booking.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shadowColor: Theme.of(context).primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: statusColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Status Bar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      statusColor.withOpacity(0.1),
                      statusColor.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildAnimatedStatusDot(statusColor),
                    const SizedBox(width: 8),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Car Info Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'car_${booking.id}',
                          child: Container(
                            width: 120,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: booking.carImage,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey.shade200,
                                  child: const Center(child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey.shade200,
                                  child: Icon(Icons.car_rental, size: 40, color: Colors.grey.shade400),
                                ),
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
                                booking.carName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.confirmation_number, size: 14, color: Colors.grey.shade600),
                                  const SizedBox(width: 4),
                                  Text(
                                    booking.licensePlate,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    booking.isDriverIncluded ? Icons.person : Icons.time_to_leave,
                                    size: 14,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    booking.isDriverIncluded ? l10n.withDriver : l10n.selfDrive,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Date & Duration info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoColumn(
                                  Icons.calendar_today,
                                  'Pickup',
                                  DateFormat('MMM d, yyyy').format(booking.startDate),
                                  context,
                                ),
                              ),
                              Container(height: 40, width: 1, color: Colors.grey.shade300),
                              Expanded(
                                child: _buildInfoColumn(
                                  Icons.event_available,
                                  'Return',
                                  DateFormat('MMM d, yyyy').format(booking.endDate),
                                  context,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(height: 1, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoColumn(
                                  Icons.timelapse,
                                  'Duration',
                                  '$durationDays days',
                                  context,
                                ),
                              ),
                              Container(height: 40, width: 1, color: Colors.grey.shade300),
                              Expanded(
                                child: _buildInfoColumn(
                                  Icons.attach_money,
                                  'Total',
                                  booking.totalAmount != null
                                      ? '\$${booking.totalAmount!.toStringAsFixed(2)}'
                                      : 'N/A',
                                  context,
                                  valueColor: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Location
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.map,
                            size: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            booking.location,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => context.push('/booking-details/${booking.id}'),
                          icon: const Icon(Icons.visibility, size: 18),
                          label: const Text('View Details'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => onActionPressed(context, booking),
                          icon: Icon(_getActionIcon(booking.status), size: 18),
                          label: Text(_getActionButtonText(booking.status, booking)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            backgroundColor: _getActionButtonColor(context, booking.status),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
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

  Widget _buildGridBookingCard(
      BuildContext context,
      Booking booking,
      AppLocalizations l10n,
      Function(BuildContext, Booking) onActionPressed,
      ) {
    final statusColor = _getStatusColor(booking.status);
    final statusText = _getStatusText(booking.status);

    return Card(
      elevation: 4,
      shadowColor: Theme.of(context).primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Car Image
              Stack(
                children: [
                  Hero(
                    tag: 'car_${booking.id}',
                    child: CachedNetworkImage(
                      imageUrl: booking.carImage,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade200,
                        child: Icon(Icons.car_rental, size: 40, color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        statusText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Car Name & Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.carName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            booking.totalAmount != null
                                ? '\$${booking.totalAmount!.toStringAsFixed(0)}'
                                : 'N/A',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),

                      // Date Range
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${DateFormat('MMM d').format(booking.startDate)} - '
                                  '${DateFormat('MMM d').format(booking.endDate)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Action Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => onActionPressed(context, booking),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getActionButtonColor(context, booking.status),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(
                            _getActionButtonText(booking.status, booking),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
    );
  }

  Widget _buildInfoColumn(
      IconData icon,
      String label,
      String value,
      BuildContext context, {
        Color? valueColor,
      }) {
    // Debug logging to catch incorrect calls
    debugPrint('buildInfoColumn: icon=$icon, label=$label, value=$value, context=$context, valueColor=$valueColor');
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).primaryColor.withOpacity(0.7),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedStatusDot(Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.6 * value),
                blurRadius: 8 * value,
                spreadRadius: 2 * value,
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.blue;
      case BookingStatus.inProgress:
        return Colors.green;
      case BookingStatus.completed:
        return Colors.green.shade700;
      case BookingStatus.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  IconData _getActionIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Icons.cancel;
      case BookingStatus.confirmed:
        return Icons.edit;
      case BookingStatus.inProgress:
        return Icons.assignment_return;
      case BookingStatus.completed:
        return Icons.rate_review;
      default:
        return Icons.visibility;
    }
  }

  Color _getActionButtonColor(BuildContext context, BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.red;
      case BookingStatus.confirmed:
        return Theme.of(context).primaryColor;
      case BookingStatus.inProgress:
        return Colors.green;
      case BookingStatus.completed:
        return Colors.blue;
      default:
        return Theme.of(context).primaryColor;
    }
  }

  String _getActionButtonText(BookingStatus status, Booking booking) {
    switch (status) {
      case BookingStatus.pending:
        return 'Cancel';
      case BookingStatus.confirmed:
        return 'Modify';
      case BookingStatus.inProgress:
        return 'Return Car';
      case BookingStatus.completed:
        return booking.isReviewed == true ? 'View Receipt' : 'Write Review';
      default:
        return 'View';
    }
  }

  void _handleUpcomingBookingAction(BuildContext context, Booking booking) {
    if (booking.status == BookingStatus.pending) {
      _showCancelBookingDialog(context, booking);
    } else if (booking.status == BookingStatus.confirmed) {
      context.push('/modify-booking/${booking.id}');
    }
  }

  void _handleOngoingBookingAction(BuildContext context, Booking booking) {
    context.push('/return-car/${booking.id}');
  }

  void _handlePreviousBookingAction(BuildContext context, Booking booking) {
    if (booking.status == BookingStatus.completed) {
      if (booking.isReviewed == true) {
        context.push('/e-receipt/${booking.id}');
      } else {
        context.push('/write-review/${booking.id}');
      }
    }
  }

  void _showCancelBookingDialog(BuildContext context, Booking booking) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) {
        final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Cancel Booking',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Are you sure you want to cancel this booking?',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Cancellation fees may apply based on our policy.',
                            style: TextStyle(fontSize: 14, color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'No, keep it',
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.white),
                            const SizedBox(width: 12),
                            const Text('Booking cancelled successfully'),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.all(16),
                      ),
                    );

                    setState(() {
                      final updatedBooking = Booking(
                        id: booking.id,
                        carName: booking.carName,
                        carImage: booking.carImage,
                        startDate: booking.startDate,
                        endDate: booking.endDate,
                        totalAmount: booking.totalAmount,
                        status: BookingStatus.cancelled,
                        isDriverIncluded: booking.isDriverIncluded,
                        location: booking.location,
                        licensePlate: booking.licensePlate,
                        features: booking.features,
                        rating: booking.rating,
                        isReviewed: booking.isReviewed,
                        cancellationReason: 'User cancelled',
                      );
                      _upcomingBookings.removeWhere((b) => b.id == booking.id);
                      _previousBookings.add(updatedBooking);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'Yes, Cancel',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}