import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_skip/firebase_options.dart';
import 'package:line_skip/screens/profile/profile_screen.dart';
import 'package:line_skip/utils/auth_screen.dart';
import 'package:line_skip/screens/auth/login_screen.dart';
import 'package:line_skip/screens/store/cart_screen.dart';
// import 'package:line_skip/screens/store/trolley_pairing_screen.dart';
import 'package:line_skip/screens/home/home_screen.dart';
import 'package:line_skip/screens/splash/splash_screen.dart';
import 'package:line_skip/screens/store/store_selection_screen.dart';
import 'package:line_skip/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: StringConstants.appFullName,
      darkTheme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF5722),
          brightness: Brightness.light,
        ),
        brightness: Brightness.light,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      initialRoute: splashRoute,
      routes: {
        authRoute: (context) => const AuthPage(),
        splashRoute: (context) => const SplashPage(),
        loginRoute: (context) => LoginPage(),
        homeRoute: (context) => const HomePage(),
        profileRoute: (context) => const ProfileScreen(),
        storeSelectionRoute: (context) => const StoreSelectionPage(),
        cartRoute: (context) => CartPage(),
        // trolleyPairingRoute: (context) => const TrolleyPairingPage(),
      },
    );
  }
}
