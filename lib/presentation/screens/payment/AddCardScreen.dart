import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui' as ui;

import '../../../l10n/AppLocalizations.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardholderNameController = TextEditingController();
  bool _saveCard = true;
  bool _isLoading = false;
  String _cardType = 'Unknown';

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _cardholderNameController.dispose();
    super.dispose();
  }

  void _saveCardDetails() {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.lightImpact();
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isLoading = false);
          context.pop(true);
        }
      });
    }
  }

  String _detectCardType(String cardNumber) {
    cardNumber = cardNumber.replaceAll(' ', '');
    if (cardNumber.startsWith('4')) return 'Visa';
    if (cardNumber.startsWith(RegExp(r'5[1-5]'))) return 'Mastercard';
    if (cardNumber.startsWith(RegExp(r'3[47]'))) return 'Amex';
    return 'Unknown';
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
              child: Column(
                children: [
                  // Custom AppBar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, size: 24),
                          onPressed: () => context.pop(),
                          tooltip: l10n.back,
                        ),
                        Expanded(
                          child: Text(
                            l10n.addNewCard,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  // Card Form
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Card Illustration
                            _buildCardIllustration()
                                .animate()
                                .fadeIn(duration: 600.ms)
                                .slideY(begin: 0.2, end: 0),
                            const SizedBox(height: 32),
                            // Cardholder Name
                            _buildTextField(
                              controller: _cardholderNameController,
                              label: l10n.cardholderName,
                              icon: Icons.person_outline,
                              textCapitalization: TextCapitalization.words,
                              validator: (value) =>
                              value == null || value.isEmpty ? l10n.cardholderNameRequired : null,
                            ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
                            const SizedBox(height: 16),
                            // Card Number
                            _buildTextField(
                              controller: _cardNumberController,
                              label: l10n.cardNumber,
                              icon: Icons.credit_card_outlined,
                              hintText: '0000 0000 0000 0000',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(16),
                                _CardNumberFormatter(),
                              ],
                              onChanged: (value) => setState(() => _cardType = _detectCardType(value)),
                              validator: (value) {
                                if (value == null || value.isEmpty) return l10n.cardNumberRequired;
                                if (value.replaceAll(' ', '').length < 16) return l10n.invalidCardNumber;
                                return null;
                              },
                            ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                            const SizedBox(height: 16),
                            // Expiry Date and CVV
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _expiryDateController,
                                    label: l10n.expiryDate,
                                    icon: Icons.calendar_today_outlined,
                                    hintText: 'MM/YY',
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                      _ExpiryDateFormatter(),
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return l10n.expiryDateRequired;
                                      if (value.length < 5) return l10n.invalidExpiryDate;
                                      final parts = value.split('/');
                                      final month = int.tryParse(parts[0]);
                                      if (month == null || month < 1 || month > 12) return l10n.invalidMonth;
                                      final year = int.tryParse('20${parts[1]}');
                                      final now = DateTime.now();
                                      if (year == null ||
                                          year < now.year ||
                                          (year == now.year && month < now.month)) {
                                        return l10n.cardExpired;
                                      }
                                      return null;
                                    },
                                  ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _cvvController,
                                    label: l10n.cvv,
                                    icon: Icons.security_outlined,
                                    hintText: '123',
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                    obscureText: true,
                                    validator: (value) =>
                                    value == null || value.isEmpty ? l10n.cvvRequired : null,
                                  ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Save Card Toggle
                            _buildSaveCardToggle(l10n)
                                .animate()
                                .fadeIn(duration: 600.ms, delay: 500.ms),
                            const SizedBox(height: 16),
                            // Security Notice
                            _buildSecurityNotice(l10n)
                                .animate()
                                .fadeIn(duration: 600.ms, delay: 600.ms),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Save Button
                  _buildSaveButton(l10n),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardIllustration() {
    return Container(
      height: 220,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.5],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _cardType,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.credit_card, color: Colors.white, size: 30),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _cardNumberController.text.isEmpty
                          ? '•••• •••• •••• ••••'
                          : _formatCardNumber(_cardNumberController.text),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w500,
                      ),
                    ).animate().fadeIn(duration: 300.ms),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Card Holder',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            Text(
                              _cardholderNameController.text.isEmpty
                                  ? 'YOUR NAME'
                                  : _cardholderNameController.text.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ).animate().fadeIn(duration: 300.ms),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Expires',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            Text(
                              _expiryDateController.text.isEmpty
                                  ? 'MM/YY'
                                  : _expiryDateController.text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ).animate().fadeIn(duration: 300.ms),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      validator: validator,
      autocorrect: false,
      enableSuggestions: false,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildSaveCardToggle(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.saveCardForFuture,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          Switch(
            value: _saveCard,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              setState(() => _saveCard = value);
            },
            activeColor: Theme.of(context).primaryColor,
            activeTrackColor: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityNotice(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade100,
            Colors.grey.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.security, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.securePaymentInfo,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(AppLocalizations l10n) {
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2))),
          ),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveCardDetails,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              shadowColor: Theme.of(context).primaryColor.withOpacity(0.4),
              elevation: 5,
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.saveCard,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 700.ms);
  }

  String _formatCardNumber(String input) {
    final digitsOnly = input.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digitsOnly[i]);
    }
    return buffer.toString();
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    final formattedText = buffer.toString();
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll('/', '');
    String formattedText = text;
    if (text.length > 2) {
      formattedText = '${text.substring(0, 2)}/${text.substring(2)}';
    }
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}