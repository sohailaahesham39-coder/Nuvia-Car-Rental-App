// lib/presentation/screens/auth/verify_code_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/AppLocalizations.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;

  const VerifyCodeScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final List<TextEditingController> _codeControllers = List.generate(
    6,
        (index) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(
    6,
        (index) => FocusNode(),
  );

  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Move to next field
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      }
    }
  }

  String _getCompleteCode() {
    return _codeControllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyCode() async {
    final code = _getCompleteCode();
    if (code.length == 6) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        // Navigate to new password screen
        context.go('/new-password');
      }
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter the complete code'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _resendCode() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification code resent'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.verifyCode),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              // Icon
              Icon(
                Icons.mail_outline,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(height: 24),

              // Message
              Text(
                '${l10n.verificationCodeSent} ${widget.email}',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                l10n.enterCode,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Code input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                      (index) => SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _codeControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: '',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      onChanged: (value) => _onCodeChanged(value, index),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Verify Button
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _verifyCode,
                child: Text(l10n.verifyCode),
              ),

              const SizedBox(height: 24),

              // Resend Code
              TextButton(
                onPressed: _resendCode,
                child: Text(l10n.resendCode),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

