import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/Governorate.dart';

class LocationProvider extends ChangeNotifier {
  String _selectedGovernorate = 'cairo'; // Default governorate
  List<Governorate> _governorates = [];
  bool _isLoading = true; // Start with loading state
  bool _isInitialized = false;

  // Getters
  String get selectedGovernorate => _selectedGovernorate;
  List<Governorate> get governorates => _governorates;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  // Constructor loads saved location and governorates data
  LocationProvider() {
    // Initialize with defaults immediately
    initializeWithDefaults();
    // Then start async loading
    _initialize();
  }

  // Synchronous initialization with defaults
  void initializeWithDefaults() {
    _selectedGovernorate = 'cairo';
    _governorates = [
      Governorate(
        id: 'cairo',
        nameEn: 'Cairo',
        nameAr: 'القاهرة',
        isActive: true,
        latitude: 30.0444,
        longitude: 31.2357,
        cities: [],
      ),
    ];
    _isInitialized = true;
  }

  // Initialize the provider
  Future<void> _initialize() async {
    try {
      // Sequential initialization instead of Future.wait
      await _loadSavedLocation();
      await _loadGovernorates();
      _isInitialized = true;
    } catch (e) {
      // Handle initialization errors
      debugPrint('LocationProvider initialization error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load saved location from SharedPreferences
  Future<void> _loadSavedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedGovernorate = prefs.getString('selected_governorate');

      if (savedGovernorate != null) {
        _selectedGovernorate = savedGovernorate;
      }
    } catch (e) {
      debugPrint('Error loading saved location: $e');
      // Keep using the default value
    }
  }

  // Set selected governorate
  Future<void> setSelectedGovernorate(String governorateId) async {
    _selectedGovernorate = governorateId;

    try {
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_governorate', governorateId);
    } catch (e) {
      debugPrint('Error saving selected governorate: $e');
    }

    notifyListeners();
  }

  // Load governorates data
  Future<void> _loadGovernorates() async {
    try {
      // In a real app, this would be an API call
      // For demo purposes, we'll create mock data
      await Future.delayed(const Duration(milliseconds: 500));

      _governorates = [
        Governorate(
          id: 'cairo',
          nameEn: 'Cairo',
          nameAr: 'القاهرة',
          isActive: true,
          latitude: 30.0444,
          longitude: 31.2357,
          cities: [
            City(
              id: 'downtown',
              nameEn: 'Downtown',
              nameAr: 'وسط البلد',
              governorateId: 'cairo',
              isActive: true,
            ),
            City(
              id: 'maadi',
              nameEn: 'Maadi',
              nameAr: 'المعادي',
              governorateId: 'cairo',
              isActive: true,
            ),
            City(
              id: 'zamalek',
              nameEn: 'Zamalek',
              nameAr: 'الزمالك',
              governorateId: 'cairo',
              isActive: true,
            ),
            City(
              id: 'nasr_city',
              nameEn: 'Nasr City',
              nameAr: 'مدينة نصر',
              governorateId: 'cairo',
              isActive: true,
            ),
          ],
        ),
        Governorate(
          id: 'alexandria',
          nameEn: 'Alexandria',
          nameAr: 'الإسكندرية',
          isActive: true,
          latitude: 31.2001,
          longitude: 29.9187,
          cities: [
            City(
              id: 'miami',
              nameEn: 'Miami',
              nameAr: 'ميامي',
              governorateId: 'alexandria',
              isActive: true,
            ),
            City(
              id: 'stanley',
              nameEn: 'Stanley',
              nameAr: 'ستانلي',
              governorateId: 'alexandria',
              isActive: true,
            ),
          ],
        ),
        Governorate(
          id: 'giza',
          nameEn: 'Giza',
          nameAr: 'الجيزة',
          isActive: true,
          latitude: 30.0131,
          longitude: 31.2089,
          cities: [],
        ),
        Governorate(
          id: 'sharm-el-sheikh',
          nameEn: 'Sharm El-Sheikh',
          nameAr: 'شرم الشيخ',
          isActive: true,
          latitude: 27.9158,
          longitude: 34.3300,
          cities: [],
        ),
        Governorate(
          id: 'hurghada',
          nameEn: 'Hurghada',
          nameAr: 'الغردقة',
          isActive: true,
          latitude: 27.2579,
          longitude: 33.8116,
          cities: [],
        ),
      ];
    } catch (e) {
      debugPrint('Error loading governorates: $e');
      // Already initialized with defaults, so no need to set them again
    }
  }

  // Get governorate name by id - safely
  String getGovernorateNameById(String id, bool isArabic) {
    try {
      if (_governorates.isEmpty) {
        return isArabic ? 'جاري التحميل...' : 'Loading...';
      }

      final governorate = _governorates.firstWhere(
            (gov) => gov.id == id,
        orElse: () => Governorate(
          id: id,
          nameEn: 'Unknown',
          nameAr: 'غير معروف',
          isActive: true,
          latitude: 0,
          longitude: 0,
          cities: [],
        ),
      );

      return isArabic ? governorate.nameAr : governorate.nameEn;
    } catch (e) {
      // Extra safety in case of errors
      return isArabic ? 'غير معروف' : 'Unknown';
    }
  }

  // Get governorate by id - safely
  Governorate? getGovernorateById(String id) {
    try {
      if (_governorates.isEmpty) {
        return null;
      }

      return _governorates.firstWhere(
            (gov) => gov.id == id,
        orElse: () => Governorate(
          id: id,
          nameEn: 'Unknown',
          nameAr: 'غير معروف',
          isActive: true,
          latitude: 0,
          longitude: 0,
          cities: [],
        ),
      );
    } catch (e) {
      return null;
    }
  }

  // Refresh governorates data (public method for SplashScreen to use)
  Future<void> refreshGovernorates() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadGovernorates();
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error refreshing governorates: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}