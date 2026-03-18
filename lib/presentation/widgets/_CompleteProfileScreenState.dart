import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import '../../l10n/AppLocalizations.dart';
import '../../providers/auth.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  File? _profileImage;
  File? _idCardImage;
  File? _driversLicenseImage;
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _drivingLicenseNumberController = TextEditingController();
  DateTime? _drivingLicenseExpiry;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill form with current user data
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      _fullNameController.text = authProvider.currentUser!.fullName;
      _phoneController.text = authProvider.currentUser!.phoneNumber;
      _addressController.text = authProvider.currentUser!.address ?? '';
      _nationalIdController.text = authProvider.currentUser!.nationalId ?? '';
      _drivingLicenseNumberController.text = authProvider.currentUser!.drivingLicenseNumber ?? '';
      _drivingLicenseExpiry = authProvider.currentUser!.drivingLicenseExpiry;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _nationalIdController.dispose();
    _drivingLicenseNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String type) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (type == 'profile') {
          _profileImage = File(image.path);
        } else if (type == 'idCard') {
          _idCardImage = File(image.path);
        } else if (type == 'driversLicense') {
          _driversLicenseImage = File(image.path);
        }
      });
    }
  }

  Future<void> _selectDrivingLicenseExpiry() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)), // 10 years
    );
    if (date != null) {
      setState(() {
        _drivingLicenseExpiry = date;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      // Mock URLs for uploaded images (replace with actual server upload logic)
      final profileImageUrl = _profileImage != null ? 'mock_profile_image_url' : null;
      final idCardImageUrl = _idCardImage != null ? 'mock_id_card_image_url' : null;
      final driversLicenseImageUrl =
      _driversLicenseImage != null ? 'mock_drivers_license_image_url' : null;

      final success = await authProvider.updateProfile(
        fullName: _fullNameController.text,
        phoneNumber: _phoneController.text,
        address: _addressController.text,
        profileImageUrl: profileImageUrl,
        idCardImageUrl: idCardImageUrl,
        driversLicenseImageUrl: driversLicenseImageUrl,
        nationalId: _nationalIdController.text,
        drivingLicenseNumber: _drivingLicenseNumberController.text,
        drivingLicenseExpiry: _drivingLicenseExpiry,
      );

      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)?.profileUpdated ?? 'Profile updated')),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(authProvider.error ?? AppLocalizations.of(context)?.failedToUpdateProfile ?? 'Failed to update profile')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Handle null l10n case
    if (l10n == null) {
      return const Center(child: Text('Localization not available'));
    }

    return Directionality(
      textDirection: l10n.localeName == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.completeYourProfile),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image
                  Center(
                    child: GestureDetector(
                      onTap: () => _pickImage('profile'),
                      child: Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: _profileImage != null
                                  ? Image.file(_profileImage!, fit: BoxFit.cover)
                                  : Icon(
                                Icons.person_outline,
                                size: 60,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.profileCompletionMsg,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Full Name
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: l10n.fullName,
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) => value!.isEmpty ? l10n.enterFullName : null,
                  ),
                  const SizedBox(height: 16),
                  // Phone Number
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: l10n.phoneNumber,
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value!.isEmpty ? l10n.enterPhoneNumber : null,
                  ),
                  const SizedBox(height: 16),
                  // Address
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: l10n.enterLocation,
                      prefixIcon: const Icon(Icons.home),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) => value!.isEmpty ? l10n.enterLocation : null,
                  ),
                  const SizedBox(height: 16),
                  // National ID
                  TextFormField(
                    controller: _nationalIdController,
                    decoration: InputDecoration(
                      labelText: l10n.personalIdCard,
                      prefixIcon: const Icon(Icons.badge),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) => value!.isEmpty ? l10n.pleaseUploadIdCard : null,
                  ),
                  const SizedBox(height: 16),
                  // Driving License Number
                  TextFormField(
                    controller: _drivingLicenseNumberController,
                    decoration: InputDecoration(
                      labelText: l10n.driversLicense,
                      prefixIcon: const Icon(Icons.drive_eta),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) => value!.isEmpty ? l10n.pleaseUploadDriversLicense : null,
                  ),
                  const SizedBox(height: 16),
                  // Driving License Expiry
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Driver\'s License Expiry', // Fallback until l10n key is added
                      prefixIcon: const Icon(Icons.calendar_today),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: _selectDrivingLicenseExpiry,
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    controller: TextEditingController(
                      text: _drivingLicenseExpiry != null
                          ? DateFormat('MMM d, yyyy').format(_drivingLicenseExpiry!)
                          : '',
                    ),
                    validator: (value) =>
                    _drivingLicenseExpiry == null ? 'Please select driver\'s license expiry' : null,
                  ),
                  const SizedBox(height: 16),
                  // Personal ID Card Image
                  GestureDetector(
                    onTap: () => _pickImage('idCard'),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Personal ID Card Image', // Fallback until l10n key is added
                        prefixIcon: const Icon(Icons.badge),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        errorText: _idCardImage == null && _formKey.currentState != null
                            ? l10n.pleaseUploadIdCard
                            : null,
                      ),
                      child: _idCardImage != null
                          ? Image.file(_idCardImage!, height: 100, fit: BoxFit.cover)
                          : Text(l10n.pleaseUploadIdCard),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Driver's License Image
                  GestureDetector(
                    onTap: () => _pickImage('driversLicense'),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Driver\'s License Image', // Fallback until l10n key is added
                        prefixIcon: const Icon(Icons.drive_eta),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        errorText: _driversLicenseImage == null && _formKey.currentState != null
                            ? l10n.pleaseUploadDriversLicense
                            : null,
                      ),
                      child: _driversLicenseImage != null
                          ? Image.file(_driversLicenseImage!, height: 100, fit: BoxFit.cover)
                          : Text(l10n.pleaseUploadDriversLicense),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Save Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(l10n.save, style: const TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 16),
                  // Skip Button
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(l10n.skip),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}