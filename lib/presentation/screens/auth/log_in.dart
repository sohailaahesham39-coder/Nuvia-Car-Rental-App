import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../../l10n/AppLocalizations.dart';
import '../../../providers/auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  String? _errorMessage;
  bool _rememberMe = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final credentials = await authProvider.getPreviousCredentials();

      if (mounted) {
        setState(() {
          _emailController.text = credentials['email'] ?? '';
        });
      }
    } catch (e) {
      // Handle error silently
      debugPrint('Error loading credentials: $e');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        _navigateAfterSignIn();
      } else if (mounted) {
        setState(() {
          _errorMessage = authProvider.error ?? 'Sign in failed. Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isGoogleLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signInWithGoogle();

      if (success && mounted) {
        _navigateAfterSignIn();
      } else if (mounted) {
        setState(() {
          _errorMessage = authProvider.error ?? 'Google sign in failed. Please try again.';
          _isGoogleLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isGoogleLoading = false;
        });
      }
    }
  }

  void _navigateAfterSignIn() async {
    // Check if user profile is complete before navigating
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isProfileComplete = await authProvider.isProfileComplete();

    if (!isProfileComplete && mounted) {
      context.go('/complete-profile');
    } else if (mounted) {
      // Otherwise go to home
      context.go('/home');
    }
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your email address to reset password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.requestPasswordReset(
        _emailController.text.trim(),
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password reset link sent to ${_emailController.text}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 4),
            ),
          );
        } else {
          setState(() {
            _errorMessage = authProvider.error ?? 'Failed to send reset email. Please try again.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Logo
                  Hero(
                    tag: 'app_logo',
                    child: Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.r),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.directions_car,
                                size: 60.sp,
                                color: theme.colorScheme.primary,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Welcome Text
                  Text(
                    'Welcome Back',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    'Sign in to continue',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 32.h),

                  // Error message if any
                  if (_errorMessage != null) ...[
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.red.withOpacity(0.2)),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.red.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20.h),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _signIn(),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ?
                          Icons.visibility_outlined :
                          Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16.h),

                  // Remember Me & Forgot Password
                  Row(
                    children: [
                      // Remember Me
                      Row(
                        children: [
                          SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? true;
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Remember me',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onBackground.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Forgot Password
                      TextButton(
                        onPressed: _resetPassword,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Forgot Password?',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 32.h),

                  // Sign In Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _signIn,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      disabledBackgroundColor: theme.colorScheme.primary.withOpacity(0.6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.onPrimary,
                        strokeWidth: 2.5,
                      ),
                    )
                        : Text(
                      'Sign In',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // OR divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: theme.colorScheme.onBackground.withOpacity(0.2),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          'OR',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onBackground.withOpacity(0.5),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: theme.colorScheme.onBackground.withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Social Login Button
                  OutlinedButton.icon(
                    onPressed: _isGoogleLoading ? null : _signInWithGoogle,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    icon: _isGoogleLoading
                        ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.primary,
                      ),
                    )
                        : Image.asset(
                      'assets/icons/google.png',
                      width: 24.w,
                      height: 24.h,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.g_mobiledata, size: 24.sp);
                      },
                    ),
                    label: Text(
                      'Continue with Google',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/sign-up'),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Sign Up',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}