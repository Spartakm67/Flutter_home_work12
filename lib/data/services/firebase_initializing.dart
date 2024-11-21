import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_home_work12/firebase_options.dart';

class FirebaseInitializer {
  static bool _isFirebaseInitialized = false;

  static Future<void> initializeFirebase(BuildContext context) async {
    if (_isFirebaseInitialized) return;

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _isFirebaseInitialized = true;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Firebase initialized successfully!',
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error initializing Firebase: $e'),
          ),
        );
      }
    }
  }
}