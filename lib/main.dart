import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:flutter_home_work12/presentation/screens/auth_screen.dart';
import 'package:flutter_home_work12/presentation/screens/habits_screen.dart';
import 'package:flutter_home_work12/domain/store/firebase_store/firebase_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final firebaseStore = FirebaseStore();
  await firebaseStore.initialize();
  runApp(
    Provider<FirebaseStore>.value(
      value: firebaseStore,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final firebaseStore = Provider.of<FirebaseStore>(context);
        if (!firebaseStore.isInitialized) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter HW12',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: '/auth',
          routes: {
            '/auth': (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Firebase initialized successfully!'),
                  ),
                );
              });
              return const AuthScreen();
            },
            '/habits': (context) => const HabitsScreen(),
          },
        );
      },
    );
  }
}
