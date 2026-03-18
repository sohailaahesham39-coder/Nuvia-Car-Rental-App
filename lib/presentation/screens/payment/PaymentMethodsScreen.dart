import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui' as ui;

import '../../../l10n/AppLocalizations.dart';

class PaymentMethodsScreen extends StatefulWidget {
  final String bookingId;
  final String? selectedPaymentMethodId;

  const PaymentMethodsScreen({
    super.key,
    required this.bookingId,
    this.selectedPaymentMethodId,
  });

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String? _selectedPaymentMethod;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'card1',
      'type': 'card',
      'cardType': 'Visa',
      'last4': '4242',
      'expiryDate': '12/25',
      'holderName': 'John Doe',
      'isDefault': true,
    },
    {
      'id': 'card2',
      'type': 'card',
      'cardType': 'Mastercard',
      'last4': '5555',
      'expiryDate': '08/24',
      'holderName': 'John Doe',
      'isDefault': false,
    },
    {
      'id': 'wallet',
      'type': 'wallet',
      'balance': 350.0,
      'isDefault': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializePaymentMethod();
  }

  void _initializePaymentMethod() {
    // Use the passed selectedPaymentMethodId if provided
    if (widget.selectedPaymentMethodId != null &&
        _paymentMethods.any((method) => method['id'] == widget.selectedPaymentMethodId)) {
      _selectedPaymentMethod = widget.selectedPaymentMethodId;
    } else {
      // Otherwise, select the default payment method
      for (final method in _paymentMethods) {
        if (method['isDefault'] == true) {
          _selectedPaymentMethod = method['id'];
          break;
        }
      }
      // If no default, select the first method if available
      if (_selectedPaymentMethod == null && _paymentMethods.isNotEmpty) {
        _selectedPaymentMethod = _paymentMethods.first['id'];
      }
    }
  }

  void _addNewCard() {
    context.push('/add-card').then((value) {
      if (value == true) {
        setState(() {
          _paymentMethods.add({
            'id': 'card${_paymentMethods.length + 1}',
            'type': 'card',
            'cardType': 'Visa',
            'last4': '1234',
            'expiryDate': '04/28',
            'holderName': 'John Doe',
            'isDefault': false,
          });
          _selectedPaymentMethod = _paymentMethods.last['id'];
        });
      }
    });
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
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios, size: 24.w, color: Colors.black87),
                          onPressed: () => context.pop(),
                        ),
                        Expanded(
                          child: Text(
                            l10n.paymentMethods,
                            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: 48.w), // Balance back button
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      children: [
                        // Add New Card
                        _buildAddNewCard(l10n)
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.2, end: 0),
                        SizedBox(height: 24.h),
                        Text(
                          l10n.savedPaymentMethods,
                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
                        SizedBox(height: 16.h),
                        if (_paymentMethods.isEmpty)
                          Center(
                            child: Text(
                              l10n.noPaymentMethods,
                              style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
                            ),
                          ).animate().fadeIn(duration: 600.ms, delay: 200.ms)
                        else
                          ..._paymentMethods.asMap().entries.map((entry) {
                            final index = entry.key;
                            final method = entry.value;
                            final isSelected = _selectedPaymentMethod == method['id'];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: method['type'] == 'card'
                                  ? _buildCreditCardTile(method, isSelected)
                                  .animate()
                                  .fadeIn(duration: 600.ms, delay: (200 + index * 100).ms)
                                  : _buildWalletTile(method, isSelected)
                                  .animate()
                                  .fadeIn(duration: 600.ms, delay: (200 + index * 100).ms),
                            );
                          }),
                      ],
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

  Widget _buildAddNewCard(AppLocalizations l10n) {
    return GestureDetector(
      onTap: _addNewCard,
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).primaryColor,
                    size: 20.w,
                  ),
                ),
                SizedBox(width: 16.w),
                Text(
                  l10n.addNewCard,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreditCardTile(Map<String, dynamic> card, bool isSelected) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = card['id']),
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.5) : Colors.white.withOpacity(0.3),
                width: isSelected ? 2.w : 1.w,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.credit_card,
                    color: card['cardType'] == 'Visa' ? Colors.blue : Colors.red,
                    size: 20.w,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            card['cardType'],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                          ),
                          if (card['isDefault'])
                            Container(
                              margin: EdgeInsets.only(left: 8.w),
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                l10n.defaultLabel,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        l10n.cardNumberEnding(card['last4']),
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
                      ),
                      Text(
                        l10n.expires(card['expiryDate']),
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                Radio(
                  value: card['id'],
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) => setState(() => _selectedPaymentMethod = value as String),
                  activeColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWalletTile(Map<String, dynamic> wallet, bool isSelected) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = wallet['id']),
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.5) : Colors.white.withOpacity(0.3),
                width: isSelected ? 2.w : 1.w,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance_wallet,
                    color: Colors.green.shade700,
                    size: 20.w,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.nuviaWallet,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                      ),
                      Text(
                        l10n.balance(wallet['balance'].toStringAsFixed(2)),
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: Colors.green),
                      ),
                    ],
                  ),
                ),
                Radio(
                  value: wallet['id'],
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) => setState(() => _selectedPaymentMethod = value as String),
                  activeColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(AppLocalizations l10n) {
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2))),
          ),
          child: ElevatedButton(
            onPressed: _isLoading
                ? null
                : () {
              setState(() {
                _isLoading = true;
              });
              // Simulate saving process
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                  context.pop(_selectedPaymentMethod);
                }
              });
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              shadowColor: Theme.of(context).primaryColor.withOpacity(0.4),
              elevation: 5,
            ),
            child: _isLoading
                ? SizedBox(
              width: 20.w,
              height: 20.h,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                color: Colors.white,
              ),
            )
                : Text(
              l10n.save,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 700.ms);
  }
}