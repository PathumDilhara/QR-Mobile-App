import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:qr_mobile_app/model/generated_qr_model.dart';
import 'package:qr_mobile_app/provider/settings_provider.dart';
import 'package:qr_mobile_app/provider/qr_history_provider.dart';
import 'package:qr_mobile_app/utils/routers.dart';
import 'package:qr_mobile_app/utils/theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/scanned_qr_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await Hive.initFlutter();
  Hive.registerAdapter(GeneratedQRModelAdapter());
  Hive.registerAdapter(ScannedQrModelAdapter()); // data type ScannedQrModel
  await Hive.openBox("generated_qr");
  await Hive.openBox("scanned_qr");
  await Hive.openBox(
      "settings"); // no need to register adapter bca setting contains primitive data type
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => QRHistoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsProvider(),
        ),
      ],
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
    return Consumer<SettingsProvider>(
      builder: (BuildContext context, SettingsProvider themeProvider,
          Widget? child) {
        return MaterialApp.router(
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
          theme: CustomThemeData.lightTheme(context),
          darkTheme: CustomThemeData.darkTheme(context),
          themeMode:
              themeProvider.currentTheme, // load using "theme" & "darkTheme"
          // themeMode: ThemeMode
          //     .system, // Automatically switches between dark and light theme
        );
      },
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
// flutter pub add url_launcher
// flutter pub add package_info_plus

// improvements

// page transition improvements
// google font style
// copy to clipboard button
// qr save button
// if scanned on url open browser
// change splash screen
// URL opening error

// App updating using google play store console https://www.youtube.com/watch?v=Hfn_PvKMyIs
