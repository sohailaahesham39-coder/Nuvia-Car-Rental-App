import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location; // Alias to resolve conflict
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:ui' as ui;

class DocumentUploadScreen extends StatefulWidget {
  final String bookingId;
  final String carId;

  const DocumentUploadScreen({
    super.key,
    required this.bookingId,
    required this.carId,
  });

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen>
    with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  File? _idCardImage;
  File? _driverLicenseImage;
  bool _isDeliveryRequired = false;
  bool _isUsingCurrentLocation = true;
  final TextEditingController _addressController = TextEditingController();
  LatLng? _selectedLocation;
  bool _isLoading = false;
  bool _isMapVisible = false;

  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _mapAnimation;

  // Map controller
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  // Progress tracking
  int _completedSteps = 0;
  int _totalSteps = 2; // Updated dynamically based on delivery requirement

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _mapAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    _mapController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    int completed = 0;
    if (_idCardImage != null) completed++;
    if (_driverLicenseImage != null) completed++;
    if (_isDeliveryRequired && _selectedLocation != null) completed++;

    setState(() {
      _completedSteps = completed;
      _totalSteps = _isDeliveryRequired ? 3 : 2;
    });
  }

  Future<void> _getCurrentLocation() async {
    if (_isUsingCurrentLocation) {
      final location.Location locationService = location.Location();
      bool serviceEnabled;
      location.PermissionStatus permissionGranted;

      try {
        // Check if location service is enabled
        serviceEnabled = await locationService.serviceEnabled();
        if (!serviceEnabled) {
          serviceEnabled = await locationService.requestService();
          if (!serviceEnabled) {
            _handleLocationError('Location service is disabled.');
            return;
          }
        }

        // Check if permission is granted
        permissionGranted = await locationService.hasPermission();
        if (permissionGranted == location.PermissionStatus.denied) {
          permissionGranted = await locationService.requestPermission();
          if (permissionGranted == location.PermissionStatus.deniedForever) {
            _handleLocationError(
                'Location permissions are permanently denied. Please enable them in settings.');
            return;
          }
          if (permissionGranted != location.PermissionStatus.granted) {
            _handleLocationError('Location permission denied.');
            return;
          }
        }

        // Get location
        final locationData = await locationService.getLocation();
        final double? lat = locationData.latitude;
        final double? lng = locationData.longitude;

        if (lat != null && lng != null && mounted) {
          setState(() {
            _selectedLocation = LatLng(lat, lng);
            _markers = {
              Marker(
                markerId: const MarkerId('selected_location'),
                position: _selectedLocation!,
                infoWindow: const InfoWindow(title: 'Delivery Location'),
              ),
            };
          });

          // Update address using geocoding
          await _updateAddressFromLocation(_selectedLocation!);
        } else {
          _handleLocationError('Could not get current location coordinates.');
        }
      } catch (e) {
        _handleLocationError('Error accessing location: $e');
      }
    }
  }

  Future<void> _updateAddressFromLocation(LatLng location) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (placemarks.isNotEmpty && mounted) {
        final placemark = placemarks.first;
        _addressController.text = [
          placemark.street,
          placemark.locality,
          placemark.administrativeArea,
          placemark.country
        ].where((e) => e != null && e.isNotEmpty).join(', ');
      }
    } catch (e) {
      if (mounted) {
        _addressController.text = 'Selected Location';
        _handleLocationError('Error fetching address: $e');
      }
    }
  }

  void _handleLocationError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
            left: 20,
            right: 20,
          ),
        ),
      );
      setState(() {
        _isUsingCurrentLocation = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source, bool isIdCard) async {
    setState(() => _isLoading = true);
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null && mounted) {
        final File imageFile = File(pickedFile.path);
        final compressedFile = await _compressImage(imageFile);
        setState(() {
          if (isIdCard) {
            _idCardImage = compressedFile;
          } else {
            _driverLicenseImage = compressedFile;
          }
          _updateProgress();
        });
      }
    } catch (e) {
      _handleLocationError('Error picking image: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<File> _compressImage(File file) async {
    try {
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.path,
        '${file.path}_compressed.jpg',
        quality: 70,
        minWidth: 1024,
        minHeight: 1024,
      );
      return compressedFile != null ? File(compressedFile.path) : file;
    } catch (e) {
      return file; // Fallback to original file if compression fails
    }
  }

  void _showImageSourceDialog(bool isIdCard) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isIdCard ? 'Identity Card' : 'Driver\'s License',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _imageSourceOption(
                    Icons.photo_camera,
                    'Camera',
                        () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.camera, isIdCard);
                    },
                  ),
                  _imageSourceOption(
                    Icons.photo_library,
                    'Gallery',
                        () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.gallery, isIdCard);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageSourceOption(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePreview(File image) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(image, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleMap() {
    setState(() {
      _isMapVisible = !_isMapVisible;
      if (!_isMapVisible) {
        _mapController?.dispose();
        _mapController = null;
      }
    });
    if (_isMapVisible) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: location,
          infoWindow: const InfoWindow(title: 'Delivery Location'),
        ),
      };
    });
    _updateAddressFromLocation(location);
    _updateProgress();
  }

  bool get _isFormValid {
    bool documentsValid = _idCardImage != null && _driverLicenseImage != null;
    bool locationValid =
        !_isDeliveryRequired || (_isDeliveryRequired && _selectedLocation != null);
    return documentsValid && locationValid;
  }

  Future<void> _proceedToPayment() async {
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.white),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Please upload all required documents and select a delivery location if needed.',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(20),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      // Simulate API call to upload documents
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);

        String queryParams = '';
        if (_isDeliveryRequired && _selectedLocation != null) {
          final LatLng location = _selectedLocation!;
          queryParams =
          '?delivery=true&lat=${location.latitude}&lng=${location.longitude}&address=${Uri.encodeComponent(_addressController.text)}';
        }

        context.push('/review-summary/${widget.bookingId}$queryParams');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Document Upload',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // Gradient background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    primaryColor.withOpacity(0.05),
                    Colors.white,
                  ],
                  stops: const [0.0, 0.3],
                ),
              ),
            ),
          ),

          // Progress indicator
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$_completedSteps/$_totalSteps Steps Completed',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${(_completedSteps / _totalSteps * 100).toInt()}%',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _completedSteps / _totalSteps,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 70, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Instructions
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryColor.withOpacity(0.7),
                        primaryColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.info_outline,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Document Verification Required',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Please upload clear images of your ID card and driver\'s license. Ensure all details are visible.',
                        style: TextStyle(
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ).animate()
                    .fadeIn(duration: 500.ms)
                    .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 500.ms,
                    curve: Curves.easeOutQuad),

                const SizedBox(height: 30),

                // Document Upload Section
                _buildSectionHeader('Upload Documents', Icons.document_scanner),

                const SizedBox(height: 20),

                // ID Card Upload
                _buildDocumentCard(
                  title: 'Identity Card',
                  icon: Icons.credit_card,
                  image: _idCardImage,
                  onTap: () => _showImageSourceDialog(true),
                  onRemove: () => setState(() {
                    _idCardImage = null;
                    _updateProgress();
                  }),
                  placeholderText: 'Tap to upload ID Card',
                  animationDelay: 100.ms,
                ),

                const SizedBox(height: 20),

                // Driver's License Upload
                _buildDocumentCard(
                  title: 'Driver\'s License',
                  icon: Icons.drive_eta,
                  image: _driverLicenseImage,
                  onTap: () => _showImageSourceDialog(false),
                  onRemove: () => setState(() {
                    _driverLicenseImage = null;
                    _updateProgress();
                  }),
                  placeholderText: 'Tap to upload Driver\'s License',
                  animationDelay: 200.ms,
                ),

                const SizedBox(height: 30),

                // Delivery Option
                _buildSectionHeader('Delivery Options', Icons.local_shipping),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text(
                          'Request Car Delivery',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          'Have the car delivered to your preferred location.',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                        value: _isDeliveryRequired,
                        onChanged: (value) {
                          setState(() {
                            _isDeliveryRequired = value;
                            if (value && _selectedLocation == null) {
                              _getCurrentLocation();
                            }
                            _updateProgress();
                          });
                        },
                        activeColor: primaryColor,
                        contentPadding: EdgeInsets.zero,
                        secondary: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _isDeliveryRequired
                                ? primaryColor.withOpacity(0.1)
                                : Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.local_shipping,
                            color: _isDeliveryRequired
                                ? primaryColor
                                : Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate()
                    .fadeIn(duration: 500.ms, delay: 300.ms)
                    .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 500.ms,
                    delay: 300.ms,
                    curve: Curves.easeOutQuad),

                if (_isDeliveryRequired) ...[
                  const SizedBox(height: 30),

                  // Location Selection
                  _buildSectionHeader('Delivery Location', Icons.location_on),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Current Location Switch
                        SwitchListTile(
                          title: const Text(
                            'Use Current Location',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          value: _isUsingCurrentLocation,
                          onChanged: (value) {
                            setState(() {
                              _isUsingCurrentLocation = value;
                              if (value) {
                                _getCurrentLocation();
                              } else {
                                _addressController.text = '';
                                _selectedLocation = null;
                                _markers = {};
                              }
                              _updateProgress();
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                          activeColor: primaryColor,
                          secondary: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _isUsingCurrentLocation
                                  ? primaryColor.withOpacity(0.1)
                                  : Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.my_location,
                              color: _isUsingCurrentLocation
                                  ? primaryColor
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Address Input
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'Delivery Address',
                            hintText: 'Enter delivery address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: primaryColor, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            prefixIcon: Icon(
                              Icons.location_on_outlined,
                              color: primaryColor,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isMapVisible ? Icons.close : Icons.map,

                                color: primaryColor,
                              ),
                              onPressed: _toggleMap,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          enabled: !_isUsingCurrentLocation,
                          style: TextStyle(color: Colors.grey.shade800),
                        ),

                        // Map View
                        AnimatedBuilder(
                          animation: _mapAnimation,
                          builder: (context, child) {
                            return ClipRect(
                              child: Align(
                                heightFactor: _mapAnimation.value,
                                child: child,
                              ),
                            );
                          },
                          child: _isMapVisible && _selectedLocation != null
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              Container(
                                height: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: GoogleMap(
                                    onMapCreated: _onMapCreated,
                                    initialCameraPosition: CameraPosition(
                                      target: _selectedLocation!,
                                      zoom: 15,
                                    ),
                                    markers: _markers,
                                    onTap: _isUsingCurrentLocation ? null : _onMapTap,
                                    myLocationEnabled: true,
                                    myLocationButtonEnabled: true,
                                    zoomControlsEnabled: true,
                                    compassEnabled: true,
                                  ),
                                ),
                              ),
                              if (!_isUsingCurrentLocation) ...[
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.touch_app,
                                      size: 16,
                                      color: primaryColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Tap map to select location',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ).animate()
                      .fadeIn(duration: 500.ms, delay: 400.ms)
                      .slideY(
                      begin: 0.2,
                      end: 0,
                      duration: 500.ms,
                      delay: 400.ms,
                      curve: Curves.easeOutQuad),
                ],

                const SizedBox(height: 100),
              ],
            ),
          ),

          // Bottom Button with frosted glass effect
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _proceedToPayment,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: primaryColor,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Processing...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Continue to Payment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideX(
        begin: -0.1, end: 0, duration: 500.ms, curve: Curves.easeOutQuad);
  }

  Widget _buildDocumentCard({
    required String title,
    required IconData icon,
    required File? image,
    required VoidCallback onTap,
    required VoidCallback onRemove,
    required String placeholderText,
    required Duration animationDelay,
  }) {
    final bool isUploaded = image != null;
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Semantics(
      button: true,
      label: 'Upload $title',
      child: GestureDetector(
        onTap: isUploaded ? () => _showImagePreview(image!) : onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: _isFormValid || isUploaded
                ? null
                : Border.all(color: Colors.red.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.05),
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, color: primaryColor),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 150,
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      image: isUploaded
                          ? DecorationImage(
                        image: FileImage(image!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: !isUploaded
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload_file,
                          size: 40,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          placeholderText,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                        : null,
                  ),
                ],
              ),
              if (isUploaded) ...[
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Uploaded',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onRemove,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: animationDelay).slideY(
        begin: 0.2,
        end: 0,
        duration: 500.ms,
        delay: animationDelay,
        curve: Curves.easeOutQuad);
  }
}