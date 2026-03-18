import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

import '../../l10n/AppLocalizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Animation controllers for each page
  late AnimationController _carAnimationController;
  late AnimationController _bookingAnimationController;
  late AnimationController _paymentAnimationController;

  // Animations
  late Animation<double> _carAnimation;
  late Animation<double> _wheelRotation;
  late Animation<double> _calendarAnimation;
  late Animation<double> _checkmarkAnimation;
  late Animation<double> _secureIconAnimation;
  late Animation<Offset> _cardSlideAnimation;

  // Onboarding data
  late List<Map<String, dynamic>> _onboardingData;

  @override
  void initState() {
    super.initState();

    // Initialize onboarding data
    _onboardingData = [
      {
        'animationBuilder': _buildCarAnimation,
        'titleGetter': (AppLocalizations l10n) => l10n.onboardingFindCarsTitle,
        'descriptionGetter': (AppLocalizations l10n) => l10n.onboardingFindCarsDescription,
      },
      {
        'animationBuilder': _buildBookingAnimation,
        'titleGetter': (AppLocalizations l10n) => l10n.onboardingEasyBookingTitle,
        'descriptionGetter': (AppLocalizations l10n) => l10n.onboardingEasyBookingDescription,
      },
      {
        'animationBuilder': _buildPaymentAnimation,
        'titleGetter': (AppLocalizations l10n) => l10n.onboardingSecurePaymentTitle,
        'descriptionGetter': (AppLocalizations l10n) => l10n.onboardingSecurePaymentDescription,
      },
    ];

    // Car animation
    _carAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _carAnimation = Tween<double>(begin: -0.2, end: 0.2).animate(
      CurvedAnimation(parent: _carAnimationController, curve: Curves.easeInOut),
    );

    _wheelRotation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _carAnimationController, curve: Curves.linear),
    );

    // Booking animation
    _bookingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _calendarAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _bookingAnimationController, curve: Curves.easeInOut),
    );

    _checkmarkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bookingAnimationController,
        curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Payment animation
    _paymentAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _secureIconAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _paymentAnimationController, curve: Curves.easeInOut),
    );

    _cardSlideAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: const Offset(0.3, 0),
    ).animate(
      CurvedAnimation(parent: _paymentAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _carAnimationController.dispose();
    _bookingAnimationController.dispose();
    _paymentAnimationController.dispose();
    super.dispose();
  }

  Future<void> _setFirstLaunchCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('first_launch', false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.failedToSavePreferences(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToNextScreen() {
    _setFirstLaunchCompleted();
    context.go('/sign-in');
  }

  void _navigateToNextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _navigateToNextScreen();
    }
  }

  Widget _buildCarAnimation() {
    return AnimatedBuilder(
      animation: _carAnimationController,
      builder: (context, child) {
        return Center(
          child: SizedBox(
            height: 220,
            width: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Car body
                Transform.translate(
                  offset: Offset(_carAnimation.value * 30, 0),
                  child: Container(
                    width: 160,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                // Car top
                Transform.translate(
                  offset: Offset(_carAnimation.value * 30, -30),
                  child: Container(
                    width: 100,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30),
                        bottom: Radius.circular(5),
                      ),
                    ),
                  ),
                ),
                // Left wheel
                Transform.translate(
                  offset: Offset(_carAnimation.value * 30 - 40, 30),
                  child: Transform.rotate(
                    angle: _wheelRotation.value,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
                // Right wheel
                Transform.translate(
                  offset: Offset(_carAnimation.value * 30 + 40, 30),
                  child: Transform.rotate(
                    angle: _wheelRotation.value,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
                // Windows
                Transform.translate(
                  offset: Offset(_carAnimation.value * 30, -30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 25,
                        height: 20,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      Container(
                        width: 25,
                        height: 20,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookingAnimation() {
    return AnimatedBuilder(
      animation: _bookingAnimationController,
      builder: (context, child) {
        return Center(
          child: SizedBox(
            height: 220,
            width: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Calendar background
                Transform.scale(
                  scale: _calendarAnimation.value,
                  child: Container(
                    width: 160,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 3,
                      ),
                    ),
                  ),
                ),
                // Calendar header
                Transform.scale(
                  scale: _calendarAnimation.value,
                  child: Positioned(
                    top: 15,
                    child: Container(
                      width: 140,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Center(
                        child: Text(
                          "APRIL 2025",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Calendar grid
                Transform.scale(
                  scale: _calendarAnimation.value,
                  child: Positioned(
                    top: 50,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        3,
                            (rowIndex) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            4,
                                (colIndex) {
                              final day = rowIndex * 4 + colIndex + 1;
                              final isSelected = day == 10;
                              return Container(
                                width: 30,
                                height: 30,
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "$day",
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Checkmark
                Transform.scale(
                  scale: _checkmarkAnimation.value,
                  child: Positioned(
                    bottom: 15,
                    right: 15,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentAnimation() {
    return AnimatedBuilder(
      animation: _paymentAnimationController,
      builder: (context, child) {
        return Center(
          child: SizedBox(
            height: 220,
            width: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Credit card
                SlideTransition(
                  position: _cardSlideAnimation,
                  child: Container(
                    width: 160,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Card chip
                        Positioned(
                          top: 25,
                          left: 20,
                          child: Container(
                            width: 30,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        // Card number
                        const Positioned(
                          bottom: 30,
                          left: 20,
                          child: Text(
                            "**** **** **** 1234",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        // Card holder
                        const Positioned(
                          bottom: 10,
                          left: 20,
                          child: Text(
                            "CARD HOLDER",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Lock security icon
                Positioned(
                  bottom: 25,
                  child: Transform.scale(
                    scale: _secureIconAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.lock,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                // Animated secure badges
                Positioned(
                  top: 25,
                  right: 30,
                  child: Transform.scale(
                    scale: 1 + (0.1 * math.sin(_paymentAnimationController.value * 2 * math.pi)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "SECURE",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: l10n.localeName == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: l10n.localeName == 'ar' ? Alignment.topLeft : Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                    onPressed: _navigateToNextScreen,
                    child: Text(
                      l10n.skip,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                      ),
                      semanticsLabel: l10n.skip,
                    ),
                  ),
                ),
              ),
              // Onboarding content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animation
                          Expanded(
                            flex: 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: _onboardingData[index]['animationBuilder'](),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Title
                          Text(
                            _onboardingData[index]['titleGetter'](l10n),
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          // Description
                          Text(
                            _onboardingData[index]['descriptionGetter'](l10n),
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 48),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Page indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _onboardingData.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 20 : 12,
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: _currentPage == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Next button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: _navigateToNextPage,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage < _onboardingData.length - 1 ? l10n.continueButton : l10n.getStarted,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    semanticsLabel: _currentPage < _onboardingData.length - 1
                        ? l10n.continueButton
                        : l10n.getStarted,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}