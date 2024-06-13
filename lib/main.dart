import 'package:eco_clean/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDhM_96j9639hytewvPLeP6AMTj8bRQD1Y",
          appId: "1:522077375634:web:a2e485020dcec22f316a4b",
          messagingSenderId: "522077375634",
          projectId: "ecoclean-firebase"),
    );
  }
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "EcoClean",
      home: SplashScreen(),
    );
  }
}
