import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../l10n/AppLocalizations.dart';
import '../../../providers/auth.dart';

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill form with current user data
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      _fullNameController.text = authProvider.currentUser!.fullName;
      _phoneController.text = authProvider.currentUser!.phoneNumber ?? '';
      _addressController.text = authProvider.currentUser!.address ?? '';
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String type) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
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

  Future<String?> _uploadImage(File image, String type) async {
    // TODO: Implement real image upload logic (e.g., Firebase Storage)
    // For now, return a mock URL
    await Future.delayed(const Duration(seconds: 1)); // Simulate upload
    return 'mock_${type}_image_url';
  }

  Future<void> _saveProfile() async {
    final l10n = AppLocalizations.of(context)!; // Define l10n here
    if (_formKey.currentState!.validate() && _idCardImage != null && _driversLicenseImage != null) {
      setState(() => _isLoading = true);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      try {
        // Upload images and get URLs
        final profileImageUrl = _profileImage != null ? await _uploadImage(_profileImage!, 'profile') : null;
        final idCardImageUrl = _idCardImage != null ? await _uploadImage(_idCardImage!, 'idCard') : null;
        final driversLicenseImageUrl =
        _driversLicenseImage != null ? await _uploadImage(_driversLicenseImage!, 'driversLicense') : null;

        final success = await authProvider.updateProfile(
          fullName: _fullNameController.text,
          phoneNumber: _phoneController.text,
          address: _addressController.text,
          profileImageUrl: profileImageUrl,
          idCardImageUrl: idCardImageUrl,
          driversLicenseImageUrl: driversLicenseImageUrl,
        );

        setState(() => _isLoading = false);

        if (success) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.profileUpdated)),
          );
          context.pop();
        } else {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authProvider.error ?? l10n.profileUpdateFailed)),
          );
        }
      } catch (e) {
        setState(() => _isLoading = false);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileUpdateFailed)),
        );
      }
    } else {
      setState(() {}); // Trigger validation UI update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.completeAllFields)),
      );
    }
  }

  void _showSkipConfirmationDialog() {
    final l10n = AppLocalizations.of(context)!; // Define l10n here
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.skip),
        content: Text(l10n.skipProfileCompletion),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(l10n.skip),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Directionality(
      textDirection: l10n.localeName == 'ar' ? TextDirection.rtl : TextDirection.ltr,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.enterFullName;
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.enterPhoneNumber;
                      }
                      if (!RegExp(r'^\+?\d{10,15}$').hasMatch(value)) {
                        return l10n.invalidPhoneNumber;
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.enterLocation;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Personal ID Card
                  GestureDetector(
                    onTap: () => _pickImage('idCard'),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: l10n.personalIdCard,
                        prefixIcon: const Icon(Icons.badge),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        errorText: _idCardImage == null ? l10n.pleaseUploadIdCard : null,
                      ),
                      child: _idCardImage != null
                          ? Image.file(_idCardImage!, height: 100, fit: BoxFit.cover)
                          : Text(l10n.tapToUpload),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Driver's License
                  GestureDetector(
                    onTap: () => _pickImage('driversLicense'),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: l10n.driversLicense,
                        prefixIcon: const Icon(Icons.drive_eta),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        errorText: _driversLicenseImage == null ? l10n.pleaseUploadDriversLicense : null,
                      ),
                      child: _driversLicenseImage != null
                          ? Image.file(_driversLicenseImage!, height: 100, fit: BoxFit.cover)
                          : Text(l10n.tapToUpload),
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
                    onPressed: _showSkipConfirmationDialog,
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