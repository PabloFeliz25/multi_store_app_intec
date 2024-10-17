import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'AuthScreen/VendorAuthScreen.dart';
import 'VendorRegistrationScreen.dart';
import 'landing_screen.dart';

import 'main_vendor_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de Firebase para ambas plataformas
  await Firebase.initializeApp(
    options: Platform.isAndroid
        ? const FirebaseOptions(
      apiKey: "AIzaSyByuWDzf5eVtKSN2qMALC0qAUyfbmhrw9k",
      appId: "1:775563200012:android:a67b5616c4977d1d359029",
      messagingSenderId: "775563200012",
      projectId: "multi-store-app-intec",
      storageBucket: "multi-store-app-intec.appspot.com",
    )
        : const FirebaseOptions(
      apiKey: "API_KEY_IOS", // Cambia esto por las credenciales de iOS si las tienes
      appId: "APP_ID_IOS",
      messagingSenderId: "SENDER_ID_IOS",
      projectId: "PROJECT_ID_IOS",
      storageBucket: "BUCKET_IOS",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VendorAuthScreen(), // Cambia la pantalla inicial a LandingScreen
      routes: {
        '/auth': (context) => VendorAuthScreen(),
        '/register': (context) => VendorRegistrationScreen(),
        '/main': (context) => MainVendorScreen(),
      },
    );
  }
}
