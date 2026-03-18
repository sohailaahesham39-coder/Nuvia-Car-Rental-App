import 'dart:math' as Math;

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui' as ui;

import '../../../l10n/AppLocalizations.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String bookingId;

  const PaymentSuccessScreen({super.key, required this.bookingId});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _viewEReceipt() {
    context.push('/e-receipt/${widget.bookingId}');
  }

  void _goToMyBookings() {
    context.go('/my-bookings');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Directionality(
      textDirection: l10n.localeName == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            // Gradient Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.primaryColor.withOpacity(0.1),
                    Colors.white,
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Success Icon
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade100,
                              Colors.green.shade50,
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.check_circle,
                          size: 80,
                          color: Colors.green.shade600,
                          semanticLabel: l10n.paymentSuccessful,
                        ),
                      ).animate().scale(duration: 600.ms).then().pulse(duration: 1000.ms),
                      const SizedBox(height: 32),
                      // Success Message
                      Text(
                        l10n.paymentSuccessful,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
                      const SizedBox(height: 16),
                      Text(
                        l10n.bookingConfirmedMessage,
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                      const SizedBox(height: 32),
                      // Booking Info
                      _buildBookingInfoCard(l10n)
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 300.ms),
                      const SizedBox(height: 32),
                      // Action Buttons
                      _buildActionButtons(l10n),
                    ],
                  ),
                ),
              ),
            ),
            // Confetti
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: Math.pi / 2,
                blastDirectionality: BlastDirectionality.explosive,
                particleDrag: 0.05,
                emissionFrequency: 0.05,
                numberOfParticles: 30,
                gravity: 0.2,
                shouldLoop: false,
                colors: [
                  theme.primaryColor,
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingInfoCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildBookingInfoRow(l10n.bookingId, widget.bookingId),
          const Divider(),
          _buildBookingInfoRow(l10n.car, 'Toyota Fortuner'),
          const Divider(),
          _buildBookingInfoRow(
            l10n.pickupDate,
            '${DateTime.now().add(const Duration(days: 1)).day}/${DateTime.now().add(const Duration(days: 1)).month}/${DateTime.now().add(const Duration(days: 1)).year} at 10:00 AM',
          ),
          const Divider(),
          _buildBookingInfoRow(l10n.totalAmount, '\$450.00'),
        ],
      ),
    );
  }

  Widget _buildBookingInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AppLocalizations l10n) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _viewEReceipt,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            shadowColor: Theme.of(context).primaryColor.withOpacity(0.4),
            elevation: 5,
          ),
          child: Text(
            l10n.eReceipt,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: _goToMyBookings,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: BorderSide(color: Theme.of(context).primaryColor),
          ),
          child: Text(
            l10n.goToMyBookings,
            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 500.ms),
      ],
    );
  }
}