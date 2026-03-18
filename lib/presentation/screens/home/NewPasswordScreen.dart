import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/AppLocalizations.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to sign in
        context.go('/sign-in');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.resetPassword),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Logo/Icon with theme color - using a network image from Pinterest instead of just an icon
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.network(
                          'https://i.pinimg.com/originals/13/96/e3/1396e3af2ef86850ad151a209771c64f.png', // Lock/security icon from Pinterest
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.lock_outline,
                              size: 60,
                              color: Theme.of(context).colorScheme.primary,
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'Create New Password',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Your new password must be different from previous passwords',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: l10n.newPassword,
                      hintText: 'Enter your new password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your new password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Confirm Password Field
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: l10n.confirmPassword,
                      hintText: 'Confirm your new password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: _toggleConfirmPasswordVisibility,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // Password strength indicator
                  LinearProgressIndicator(
                    value: _getPasswordStrength(),
                    backgroundColor: Colors.grey.shade200,
                    color: _getPasswordColor(),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _getPasswordStrengthText(),
                    style: TextStyle(
                      color: _getPasswordColor(),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Reset Button
                  SizedBox(
                    width: double.infinity,
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      onPressed: _resetPassword,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        l10n.resetPassword,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Password strength calculations
  double _getPasswordStrength() {
    final password = _passwordController.text;
    if (password.isEmpty) return 0.0;

    double strength = 0.0;

    // Length check
    if (password.length >= 8) strength += 0.2;

    // Contains uppercase letters
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.2;

    // Contains lowercase letters
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.2;

    // Contains numbers
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.2;

    // Contains special characters
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.2;

    return strength;
  }

  Color _getPasswordColor() {
    final strength = _getPasswordStrength();

    if (strength <= 0.2) return Colors.red;
    if (strength <= 0.4) return Colors.orange;
    if (strength <= 0.6) return Colors.yellow;
    if (strength <= 0.8) return Colors.lightGreen;
    return Colors.green;
  }

  String _getPasswordStrengthText() {
    final strength = _getPasswordStrength();

    if (strength <= 0.2) return 'Very Weak';
    if (strength <= 0.4) return 'Weak';
    if (strength <= 0.6) return 'Medium';
    if (strength <= 0.8) return 'Strong';
    return 'Very Strong';
  }
}