import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:qr_mobile_app/model/generated_qr_model.dart';
import 'package:qr_mobile_app/provider/qr_history_provider.dart';
import 'package:qr_mobile_app/utils/colors.dart';
import 'package:qr_mobile_app/utils/routers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/scanned_qr_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await Hive.initFlutter();
  Hive.registerAdapter(GeneratedQRModelAdapter());
  Hive.registerAdapter(ScannedQrModelAdapter());
  await Hive.openBox("generated_qr");
  await Hive.openBox("scanned_qr");
  runApp(
    ChangeNotifierProvider(
      create: (context) => QRHistoryProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.kWhiteColor,
        appBarTheme: const AppBarTheme(color: AppColors.kWhiteColor),
        textTheme: GoogleFonts.dmSansTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColors.kMainColor,
        ),
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.black.withOpacity(0.5),
        appBarTheme: const AppBarTheme(color: Colors.black),
        textTheme: GoogleFonts.dmSansTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
        ),
        colorScheme:
            ColorScheme.fromSwatch(brightness: Brightness.dark).copyWith(
          secondary: AppColors.kMainColor,
        ),
      ),
      themeMode: ThemeMode
          .system, // Automatically switches between dark and light theme
    );
  }
}

// flutter pub add go_router
// flutter pub add google_fonts
// flutter pub add shared_preferences
// flutter pub add persistent_bottom_nav_bar
// flutter pub add smooth_page_indicator
// flutter pub add qr_code_scanner
// flutter pub add intl
// flutter pub add provider

// improvements

// page transition improvements
// google font style
// copy to clipboard button
// qr save button
