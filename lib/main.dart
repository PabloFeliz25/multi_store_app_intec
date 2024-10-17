import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store_app_intec/Views/screens/authentication_screens/login_screen.dart';
import 'Views/screens/main_screen.dart';
import 'Views/screens/nav_screens/home_screen.dart';
import 'Views/widgets/product_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: "AIzaSyByuWDzf5eVtKSN2qMALC0qAUyfbmhrw9k",
          appId: "1:775563200012:android:a3dc3dc69e7d1e5a359029",
          messagingSenderId: "775563200012",
          projectId: "multi-store-app-intec",
          storageBucket: "multi-store-app-intec.appspot.com",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    runApp(ProviderScope(child: MyApp()));
  } catch (e) {
    print('Error during Firebase initialization: $e');
    // Consider showing an error screen or handling the error more gracefully
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Store App Intec',
      home: AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;

          if (user == null) {
            return LoginScreen();
          } else {
            return MainScreen();
          }
        }

        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
