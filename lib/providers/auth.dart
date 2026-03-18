// Updated AuthProvider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../data/models/user_model.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  authenticating,
  error,
}

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  User? _currentUser;
  String? _error;

  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  // Getters
  AuthStatus get status => _status;
  User? get currentUser => _currentUser;
  String? get token => _auth.currentUser?.getIdToken() as String?;
  String? get error => _error;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.authenticating;

  AuthProvider() {
    // Initialize auth state from Firebase
    _initAuthState();
  }

  // Initialize the authentication state by checking Firebase
  Future<void> _initAuthState() async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    try {
      // Set up auth state listener
      _auth.authStateChanges().listen((firebase_auth.User? firebaseUser) {
        if (firebaseUser != null) {
          _loadUserData(firebaseUser);
          _status = AuthStatus.authenticated;
        } else {
          _currentUser = null;
          _status = AuthStatus.unauthenticated;
        }
        notifyListeners();
      });
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
    }
  }

  // Load user data from Firebase and SharedPreferences
  Future<void> _loadUserData(firebase_auth.User firebaseUser) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if we have additional user data in SharedPreferences
      final userId = firebaseUser.uid;
      final userDataExists = prefs.containsKey('user_${userId}_fullName');

      if (userDataExists) {
        // Load additional data from SharedPreferences
        final fullName = prefs.getString('user_${userId}_fullName') ?? firebaseUser.displayName ?? 'User';
        final phoneNumber = prefs.getString('user_${userId}_phoneNumber') ?? firebaseUser.phoneNumber ?? '';
        final profileImageUrl = prefs.getString('user_${userId}_profileImageUrl') ?? firebaseUser.photoURL;
        final nationalId = prefs.getString('user_${userId}_nationalId');
        final drivingLicenseNumber = prefs.getString('user_${userId}_drivingLicenseNumber');
        final drivingLicenseExpiryMillis = prefs.getInt('user_${userId}_drivingLicenseExpiry');
        final address = prefs.getString('user_${userId}_address');
        final idCardImageUrl = prefs.getString('user_${userId}_idCardImageUrl');
        final driversLicenseImageUrl = prefs.getString('user_${userId}_driversLicenseImageUrl');
        final createdAtMillis = prefs.getInt('user_${userId}_createdAt');
        final isVerified = prefs.getBool('user_${userId}_isVerified') ?? false;

        // Create user object
        _currentUser = User(
          id: userId,
          email: firebaseUser.email ?? '',
          fullName: fullName,
          phoneNumber: phoneNumber,
          profileImageUrl: profileImageUrl,
          nationalId: nationalId,
          drivingLicenseNumber: drivingLicenseNumber,
          drivingLicenseExpiry: drivingLicenseExpiryMillis != null
              ? DateTime.fromMillisecondsSinceEpoch(drivingLicenseExpiryMillis)
              : null,
          address: address,
          idCardImageUrl: idCardImageUrl,
          driversLicenseImageUrl: driversLicenseImageUrl,
          favoriteCarIds: prefs.getStringList('user_${userId}_favoriteCarIds') ?? [],
          bookingIds: prefs.getStringList('user_${userId}_bookingIds') ?? [],
          createdAt: createdAtMillis != null
              ? DateTime.fromMillisecondsSinceEpoch(createdAtMillis)
              : DateTime.fromMillisecondsSinceEpoch(firebaseUser.metadata.creationTime?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch),
          lastLogin: DateTime.fromMillisecondsSinceEpoch(firebaseUser.metadata.lastSignInTime?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch),
          isVerified: isVerified,
          settings: UserSettings(
            preferredLanguage: prefs.getString('user_${userId}_preferredLanguage') ?? 'en',
            darkMode: prefs.getBool('user_${userId}_darkMode') ?? false,
            emailNotifications: prefs.getBool('user_${userId}_emailNotifications') ?? true,
            pushNotifications: prefs.getBool('user_${userId}_pushNotifications') ?? true,
            smsNotifications: prefs.getBool('user_${userId}_smsNotifications') ?? false,
          ),
        );
      } else {
        // Create a new user record from Firebase data
        _currentUser = User(
          id: userId,
          email: firebaseUser.email ?? '',
          fullName: firebaseUser.displayName ?? 'User',
          phoneNumber: firebaseUser.phoneNumber ?? '',
          profileImageUrl: firebaseUser.photoURL,
          favoriteCarIds: [],
          bookingIds: [],
          createdAt: DateTime.fromMillisecondsSinceEpoch(firebaseUser.metadata.creationTime?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch),
          lastLogin: DateTime.fromMillisecondsSinceEpoch(firebaseUser.metadata.lastSignInTime?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch),
          isVerified: firebaseUser.emailVerified,
          settings: UserSettings(
            preferredLanguage: 'en',
            darkMode: false,
            emailNotifications: true,
            pushNotifications: true,
            smsNotifications: false,
          ),
        );

        // Save the basic user data to SharedPreferences
        await _saveUserData();
      }
    } catch (e) {
      _error = e.toString();
    }
  }

  // Save current user data to SharedPreferences
  Future<void> _saveUserData() async {
    if (_currentUser == null) return;

    final userId = _currentUser!.id;
    final prefs = await SharedPreferences.getInstance();

    // Save user basic info with user ID prefix for multi-user support
    await prefs.setString('user_${userId}_fullName', _currentUser!.fullName);
    await prefs.setString('user_${userId}_phoneNumber', _currentUser!.phoneNumber);

    // Save optional fields
    if (_currentUser!.profileImageUrl != null) {
      await prefs.setString('user_${userId}_profileImageUrl', _currentUser!.profileImageUrl!);
    } else {
      await prefs.remove('user_${userId}_profileImageUrl');
    }
    if (_currentUser!.nationalId != null) {
      await prefs.setString('user_${userId}_nationalId', _currentUser!.nationalId!);
    } else {
      await prefs.remove('user_${userId}_nationalId');
    }
    if (_currentUser!.drivingLicenseNumber != null) {
      await prefs.setString('user_${userId}_drivingLicenseNumber', _currentUser!.drivingLicenseNumber!);
    } else {
      await prefs.remove('user_${userId}_drivingLicenseNumber');
    }
    if (_currentUser!.drivingLicenseExpiry != null) {
      await prefs.setInt(
          'user_${userId}_drivingLicenseExpiry', _currentUser!.drivingLicenseExpiry!.millisecondsSinceEpoch);
    } else {
      await prefs.remove('user_${userId}_drivingLicenseExpiry');
    }
    if (_currentUser!.address != null) {
      await prefs.setString('user_${userId}_address', _currentUser!.address!);
    } else {
      await prefs.remove('user_${userId}_address');
    }
    if (_currentUser!.idCardImageUrl != null) {
      await prefs.setString('user_${userId}_idCardImageUrl', _currentUser!.idCardImageUrl!);
    } else {
      await prefs.remove('user_${userId}_idCardImageUrl');
    }
    if (_currentUser!.driversLicenseImageUrl != null) {
      await prefs.setString('user_${userId}_driversLicenseImageUrl', _currentUser!.driversLicenseImageUrl!);
    } else {
      await prefs.remove('user_${userId}_driversLicenseImageUrl');
    }

    // Save arrays
    await prefs.setStringList('user_${userId}_favoriteCarIds', _currentUser!.favoriteCarIds);
    await prefs.setStringList('user_${userId}_bookingIds', _currentUser!.bookingIds);

    // Save dates
    await prefs.setInt('user_${userId}_createdAt', _currentUser!.createdAt.millisecondsSinceEpoch);

    // Save booleans
    await prefs.setBool('user_${userId}_isVerified', _currentUser!.isVerified);

    // Save settings
    await prefs.setString('user_${userId}_preferredLanguage', _currentUser!.settings.preferredLanguage);
    await prefs.setBool('user_${userId}_darkMode', _currentUser!.settings.darkMode);
    await prefs.setBool('user_${userId}_emailNotifications', _currentUser!.settings.emailNotifications);
    await prefs.setBool('user_${userId}_pushNotifications', _currentUser!.settings.pushNotifications);
    await prefs.setBool('user_${userId}_smsNotifications', _currentUser!.settings.smsNotifications);

    // UPDATED: Always set profile as completed to avoid redirect to complete-profile screen
    await prefs.setBool('profile_completed', true);
  }

  // UPDATED: Always consider profile as complete
  bool _isProfileComplete() {
    // Always return true to bypass the profile completion check
    return true;
  }

  // UPDATED: Always return true for profile completion
  Future<bool> isProfileComplete() async {
    // Always return true to bypass the profile completion check
    return true;
  }

  // Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    _status = AuthStatus.authenticating;
    _error = null;
    notifyListeners();

    try {
      // Sign in with Firebase
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Auth state listener will handle the rest
        return true;
      } else {
        _error = 'Unknown authentication error';
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred during sign in';

      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password';
          break;
        default:
          errorMessage = e.message ?? errorMessage;
      }

      _error = errorMessage;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Sign up with email and password
  Future<bool> signUp(String email, String password, String fullName, [String phoneNumber = '']) async {
    _status = AuthStatus.authenticating;
    _error = null;
    notifyListeners();

    try {
      // Create user with Firebase
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Update display name in Firebase
        await userCredential.user!.updateDisplayName(fullName);

        // Create a user with provided details
        _currentUser = User(
          id: userCredential.user!.uid,
          email: email,
          fullName: fullName,
          phoneNumber: phoneNumber,
          profileImageUrl: userCredential.user!.photoURL,
          favoriteCarIds: [],
          bookingIds: [],
          createdAt: DateTime.fromMillisecondsSinceEpoch(userCredential.user!.metadata.creationTime?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch),
          lastLogin: DateTime.fromMillisecondsSinceEpoch(userCredential.user!.metadata.lastSignInTime?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch),
          isVerified: userCredential.user!.emailVerified,
          settings: UserSettings(
            preferredLanguage: 'en',
            darkMode: false,
            emailNotifications: true,
            pushNotifications: true,
            smsNotifications: false,
          ),
        );

        // Save user data to SharedPreferences
        await _saveUserData();

        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _error = 'Unknown error during sign up';
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred during sign up';

      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'The email address is already in use';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak';
          break;
        default:
          errorMessage = e.message ?? errorMessage;
      }

      _error = errorMessage;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  // UPDATED: Google Sign In with enhanced debugging
  Future<bool> signInWithGoogle() async {
    _status = AuthStatus.authenticating;
    _error = null;
    notifyListeners();

    try {
      // Begin interactive sign in process
      print("Starting Google Sign In process...");
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in process
        print("User canceled the sign-in process");
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }

      print("Google Sign In successful for: ${googleUser.email}");

      // Obtain auth details from request
      print("Getting Google Auth details...");
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print("Got access token: ${googleAuth.accessToken != null}");
      print("Got ID token: ${googleAuth.idToken != null}");

      // Create credential for Firebase
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      print("Signing in with Firebase...");
      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        print("Firebase sign in successful!");
        // Auth state listener will handle the rest
        return true;
      } else {
        _error = 'Unknown error during Google sign in';
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("Error during Google sign in: $e");
      _error = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    try {
      // Sign out from Google if signed in with Google
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      // Sign out from Firebase
      await _auth.signOut();

      // Auth state listener will handle the rest
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? profileImageUrl,
    String? address,
    String? nationalId,
    String? drivingLicenseNumber,
    DateTime? drivingLicenseExpiry,
    String? idCardImageUrl,
    String? driversLicenseImageUrl,
  }) async {
    if (_currentUser == null || _auth.currentUser == null) {
      _error = 'User not logged in';
      return false;
    }

    try {
      // Update display name in Firebase if provided
      if (fullName != null && fullName != _currentUser!.fullName) {
        await _auth.currentUser!.updateDisplayName(fullName);
      }

      // Update photo URL in Firebase if provided
      if (profileImageUrl != null && profileImageUrl != _currentUser!.profileImageUrl) {
        await _auth.currentUser!.updatePhotoURL(profileImageUrl);
      }

      // Update current user with new values
      _currentUser = _currentUser!.copyWith(
        fullName: fullName ?? _currentUser!.fullName,
        phoneNumber: phoneNumber ?? _currentUser!.phoneNumber,
        profileImageUrl: profileImageUrl ?? _currentUser!.profileImageUrl,
        address: address ?? _currentUser!.address,
        nationalId: nationalId ?? _currentUser!.nationalId,
        drivingLicenseNumber: drivingLicenseNumber ?? _currentUser!.drivingLicenseNumber,
        drivingLicenseExpiry: drivingLicenseExpiry ?? _currentUser!.drivingLicenseExpiry,
        idCardImageUrl: idCardImageUrl ?? _currentUser!.idCardImageUrl,
        driversLicenseImageUrl: driversLicenseImageUrl ?? _currentUser!.driversLicenseImageUrl,
      );

      // Save updated user data
      await _saveUserData();

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  // Toggle car favorite status
  Future<bool> toggleFavorite(String carId) async {
    if (_currentUser == null) {
      _error = 'User not logged in';
      return false;
    }

    try {
      // Create a copy of current favorite IDs
      final List<String> updatedFavorites = List.from(_currentUser!.favoriteCarIds);

      // Toggle the car favorite status
      if (updatedFavorites.contains(carId)) {
        updatedFavorites.remove(carId);
      } else {
        updatedFavorites.add(carId);
      }

      // Update current user with new favorites
      _currentUser = _currentUser!.copyWith(
        favoriteCarIds: updatedFavorites,
      );

      // Save updated favorites
      await _saveUserData();

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  // Request password reset
  Future<bool> requestPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on firebase_auth.FirebaseAuthException catch (e) {
      String errorMessage = 'Failed to send password reset email';

      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email';
          break;
        default:
          errorMessage = e.message ?? errorMessage;
      }

      _error = errorMessage;
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  // Get current user's email for auto-fill
  Future<Map<String, String>> getPreviousCredentials() async {
    final Map<String, String> credentials = {
      'email': _auth.currentUser?.email ?? '',
      'fullName': _auth.currentUser?.displayName ?? '',
      'phoneNumber': _auth.currentUser?.phoneNumber ?? '',
    };

    return credentials;
  }

  // Check if the user has logged in before
  Future<bool> hasLoggedInBefore() async {
    return _auth.currentUser != null;
  }

  // Reset error
  void resetError() {
    _error = null;
    notifyListeners();
  }
}