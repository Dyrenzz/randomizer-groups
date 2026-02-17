// import 'dart:developer';
// import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/pages/navigaton_provider.dart';
// import 'package:flutter_application_1/scaffold_with_nav.dart';
import 'package:flutter_application_1/theme/dark_theme.dart';
import 'package:flutter_application_1/theme/light_theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/theme/theme_manager.dart';
import 'package:provider/provider.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:path_provider/path_provider.dart';


final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async{
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, 
  ));

  final themeManager = ThemeManager();
  await themeManager.init(); // ✅ Inisialisasi ThemeManager

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => themeManager),
        ChangeNotifierProvider(create: (context) => HomeNavigatonProvider()),
    ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    // log("Theme mode: ${themeManager.themeMode}");

    return MaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      title: 'Flutter Application',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeManager.themeMode,
      home: HomePage(),
    );  
  }
} 