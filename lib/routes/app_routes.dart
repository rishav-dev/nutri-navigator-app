import 'package:flutter/material.dart';
import '../presentation/main_dashboard/main_dashboard.dart';
import '../presentation/meal_history/meal_history.dart';
import '../presentation/schedule_integration/schedule_integration.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/meal_recommendations/meal_recommendations.dart';
import '../presentation/dining_location_details/dining_location_details.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String mainDashboard = '/main-dashboard';
  static const String mealHistory = '/meal-history';
  static const String scheduleIntegration = '/schedule-integration';
  static const String splash = '/splash-screen';
  static const String mealRecommendations = '/meal-recommendations';
  static const String diningLocationDetails = '/dining-location-details';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    mainDashboard: (context) => const MainDashboard(),
    mealHistory: (context) => const MealHistory(),
    scheduleIntegration: (context) => const ScheduleIntegration(),
    splash: (context) => const SplashScreen(),
    mealRecommendations: (context) => const MealRecommendations(),
    diningLocationDetails: (context) => const DiningLocationDetails(),
    // TODO: Add your other routes here
  };
}
