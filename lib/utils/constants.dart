import 'package:flutter/material.dart';

import 'package:line_skip/screens/quick_options/all_bills_screen.dart';
import 'package:line_skip/screens/quick_options/best_places_screen.dart';
import 'package:line_skip/screens/quick_options/favourites_screen.dart';
import 'package:line_skip/screens/quick_options/promos_screen.dart';
import 'package:line_skip/screens/splash/splash_screen.dart';
import 'package:line_skip/screens/store/trolley_pairing_screen.dart';
import 'package:line_skip/utils/auth_screen.dart';
import 'package:line_skip/screens/home/home_screen.dart';
import 'package:line_skip/screens/store/store_selection_screen.dart';

// routes
const rootRoute = '/';
const authRoute = '/auth';
const splashRoute = '/splash';
// const onboardingRoute = '/onboarding/';
const loginRoute = '/login';
const homeRoute = '/home';
const profileRoute = '/profile';
const storeSelectionRoute = '/store-selection';
const trolleyPairingRoute = '/trolley-pairing';
const cartRoute = '/cart';

const bestPlacesRoute = '/best-places';
const allBillsRoute = '/bills';
const favouritesRoute = '/favourites';
const promosRoute = '/promos';

// String Constants
class StringConstants {
  static const String appFullName = 'Line Skip';
}

Map<String, Widget Function(BuildContext)> routes = {
  authRoute: (context) => const AuthPage(),
  splashRoute: (context) => const SplashPage(),
  // loginRoute: (context) => LoginScreen(),

  // home
  homeRoute: (context) => const HomeScreen(),
  bestPlacesRoute: (context) => const BestPlacesScreen(),
  favouritesRoute: (context) => const FavouritesScreen(),
  allBillsRoute: (context) => const AllBillsScreen(),
  promosRoute: (context) => const PromosScreen(),

  // profileRoute: (context) => const ProfileScreen(),

  //store
  storeSelectionRoute: (context) => const StoreSelectionPage(),
  trolleyPairingRoute: (context) => const TrolleyPairingPage(),
};
