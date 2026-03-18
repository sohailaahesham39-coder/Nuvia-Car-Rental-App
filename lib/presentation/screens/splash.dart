import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/AppLocalizations.dart';
import '../../providers/auth.dart';
import '../../providers/LocationProvider.dart';
import '../../providers/LocaleProvider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _providersInitialized = false;
  bool _initializationStarted = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize providers after dependencies are available
    // but only start once
    if (!_initializationStarted) {
      _initializationStarted = true;
      _initializeProviders();
    }
  }

  Future<void> _initializeProviders() async {
    try {
      // Get the providers
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

      // Initialize sequentially instead of using Future.wait
      try {
        await _waitForProviderInitialization(locationProvider)
            .timeout(const Duration(seconds: 5), onTimeout: () {
          debugPrint('LocationProvider initialization timed out');
        });

        await _waitForLocaleInitialization(localeProvider)
            .timeout(const Duration(seconds: 5), onTimeout: () {
          debugPrint('LocaleProvider initialization timed out');
        });
      } catch (e) {
        debugPrint('Provider initialization error: $e');
      }

      if (mounted) {
        setState(() {
          _providersInitialized = true;
        });
      }

      // Wait for animation to complete before navigating
      final remainingAnimationTime = (3000 - (_animationController.value * 1500)).toInt();
      if (remainingAnimationTime > 0) {
        await Future.delayed(Duration(milliseconds: remainingAnimationTime));
      }

      // Now navigate
      if (mounted) {
        _checkFirstLaunch();
      }
    } catch (e) {
      debugPrint('Error during provider initialization: $e');

      // Even with errors, try to navigate after a delay
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        _checkFirstLaunch();
      }
    }
  }

  // Helper to wait for LocationProvider initialization
  Future<void> _waitForProviderInitialization(LocationProvider provider) async {
    // If already initialized or not loading, return immediately
    if (provider.isInitialized || (!provider.isLoading && provider.governorates.isNotEmpty)) {
      return;
    }

    // Set up a timeout for safety
    int attempts = 0;
    const maxAttempts = 50; // 5 seconds with 100ms checks

    while (provider.isLoading && attempts < maxAttempts) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }

    // If still loading or not initialized, force initialization
    if (provider.isLoading || !provider.isInitialized) {
      await provider.refreshGovernorates();
    }
  }

  // Helper to wait for LocaleProvider initialization
  Future<void> _waitForLocaleInitialization(LocaleProvider provider) async {
    // If already loaded, return immediately
    if (provider.isLoaded) {
      return;
    }

    // Set up a timeout for safety
    int attempts = 0;
    const maxAttempts = 50; // 5 seconds with 100ms checks

    while (!provider.isLoaded && attempts < maxAttempts) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }
  }

  Future<void> _checkFirstLaunch() async {
    if (!mounted) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final isFirstLaunch = prefs.getBool('first_launch') ?? true;

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (isFirstLaunch) {
        // First launch, navigate to onboarding
        if (mounted) {
          context.go('/onboarding');
        }
      } else if (authProvider.isAuthenticated) {
        // User is logged in, navigate to home
        if (mounted) {
          context.go('/home');
        }
      } else {
        // User is not logged in, navigate to sign in
        if (mounted) {
          context.go('/sign-in');
        }
      }
    } catch (e) {
      debugPrint('Error checking first launch: $e');
      // Default to onboarding in case of errors
      if (mounted) {
        context.go('/onboarding');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      'https://i.pinimg.com/originals/0f/cb/db/0fcbdbeda2693ea75ef7da3517446f25.png',
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            'N',
                            style: TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // App name - safely access AppLocalizations
                Builder(
                  builder: (context) {
                    // Safe access to localizations
                    final l10n = AppLocalizations.of(context);
                    return Text(
                      l10n?.appName ?? 'Nuvia',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                // Tagline
                Builder(
                  builder: (context) {
                    // Safe access to localizations
                    final l10n = AppLocalizations.of(context);
                    return Text(
                      l10n?.welcomeSubtitle ?? 'Your Car Rental App',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Loading indicator
                if (!_providersInitialized)
                  const CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}