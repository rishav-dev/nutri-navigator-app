import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Splash Screen providing branded app launch experience
/// Handles initialization and navigation routing for Nutri Navigator
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _taglineController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _taglineFadeAnimation;

  bool _isInitialized = false;
  bool _hasError = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  /// Setup logo and tagline animations
  void _setupAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _taglineFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _taglineController,
      curve: Curves.easeIn,
    ));

    // Start animations
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _taglineController.forward();
      }
    });
  }

  /// Initialize app services and determine navigation path
  Future<void> _initializeApp() async {
    try {
      // Simulate critical initialization tasks
      await Future.wait([
        _checkAuthenticationStatus(),
        _loadUserPreferences(),
        _syncCalendarPermissions(),
        _prepareCachedData(),
      ]);

      setState(() {
        _isInitialized = true;
        _hasError = false;
      });

      // Wait for minimum splash duration
      await Future.delayed(const Duration(milliseconds: 2500));

      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isInitialized = false;
      });

      if (_retryCount < _maxRetries) {
        _retryCount++;
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          _initializeApp();
        }
      } else {
        // Show retry option after max retries
        await Future.delayed(const Duration(seconds: 5));
        if (mounted) {
          _showRetryOption();
        }
      }
    }
  }

  /// Check user authentication status
  Future<void> _checkAuthenticationStatus() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock authentication check
  }

  /// Load user preferences from storage
  Future<void> _loadUserPreferences() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock preference loading
  }

  /// Sync Google Calendar permissions
  Future<void> _syncCalendarPermissions() async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Mock calendar sync
  }

  /// Prepare cached dining data
  Future<void> _prepareCachedData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Mock data preparation
  }

  /// Navigate to appropriate screen based on user state
  void _navigateToNextScreen() {
    // Mock navigation logic - in real app would check actual user state
    final isAuthenticated = true; // Mock authenticated user
    final hasCompletedOnboarding = true; // Mock completed onboarding
    final needsCalendarPermission = false; // Mock calendar permission status

    if (!isAuthenticated || !hasCompletedOnboarding) {
      // Navigate to onboarding flow (not implemented in this spec)
      Navigator.pushReplacementNamed(context, '/main-dashboard');
    } else if (needsCalendarPermission) {
      Navigator.pushReplacementNamed(context, '/schedule-integration');
    } else {
      Navigator.pushReplacementNamed(context, '/main-dashboard');
    }
  }

  /// Show retry option after initialization failures
  void _showRetryOption() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Connection Issue',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Unable to initialize the app. Please check your internet connection and try again.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _retryCount = 0;
              setState(() {
                _hasError = false;
              });
              _initializeApp();
            },
            child: Text(
              'Retry',
              style: TextStyle(color: AppTheme.lightTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Hide system status bar for immersive experience
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFF4B942),
      ),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _buildGradientBackground(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildAnimatedLogo(),
                    SizedBox(height: 4.h),
                    _buildAnimatedTagline(),
                  ],
                ),
              ),
              _buildLoadingSection(),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  /// Build warm yellow gradient background
  BoxDecoration _buildGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFF4B942), // Primary brand yellow
          Color(0xFFFF8C42), // Supporting orange
        ],
        stops: [0.0, 1.0],
      ),
    );
  }

  /// Build animated Nutri-Navigator logo
  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Opacity(
            opacity: _logoFadeAnimation.value,
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Fork icon
                  Positioned(
                    left: 8.w,
                    child: CustomIconWidget(
                      iconName: 'restaurant',
                      color: const Color(0xFFF4B942),
                      size: 8.w,
                    ),
                  ),
                  // Spoon icon
                  Positioned(
                    right: 8.w,
                    child: Transform.rotate(
                      angle: 0.5,
                      child: CustomIconWidget(
                        iconName: 'restaurant',
                        color: const Color(0xFFFF8C42),
                        size: 8.w,
                      ),
                    ),
                  ),
                  // Center nutrition icon
                  CustomIconWidget(
                    iconName: 'local_dining',
                    color: const Color(0xFFF4B942),
                    size: 6.w,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build animated tagline text
  Widget _buildAnimatedTagline() {
    return AnimatedBuilder(
      animation: _taglineController,
      builder: (context, child) {
        return Opacity(
          opacity: _taglineFadeAnimation.value,
          child: Column(
            children: [
              Text(
                'NUTRI-NAVIGATOR',
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                  fontSize: 18.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'SMART FUEL FOR YOUR SCHEDULE',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                  fontSize: 12.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build loading indicator section
  Widget _buildLoadingSection() {
    return Column(
      children: [
        if (_hasError)
          Column(
            children: [
              CustomIconWidget(
                iconName: 'error_outline',
                color: Colors.white,
                size: 6.w,
              ),
              SizedBox(height: 2.h),
              Text(
                'Initialization failed. Retrying...',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 11.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )
        else if (!_isInitialized)
          Column(
            children: [
              SizedBox(
                width: 6.w,
                height: 6.w,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Preparing your meal recommendations...',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 11.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )
        else
          Column(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: Colors.white,
                size: 6.w,
              ),
              SizedBox(height: 2.h),
              Text(
                'Ready to navigate your nutrition!',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 11.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
      ],
    );
  }
}
