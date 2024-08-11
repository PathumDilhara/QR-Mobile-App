import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/home_page/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(color: Colors.white),
        textTheme: GoogleFonts.dmSansTextTheme(Theme.of(context).textTheme),
      ),
      home: const HomePage(),
    );
  }
}

// flutter pub add go_router
// flutter pub add google_fonts
// flutter pub add shared_preferences
// flutter pub add persistent_bottom_nav_bar

// improvements

// page transition improvements
