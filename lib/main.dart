import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_home_work12/domain/store/habit_store/habit_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:flutter_home_work12/presentation/screens/auth_screen.dart';
import 'package:flutter_home_work12/presentation/screens/habit_list_screen.dart';
import 'package:flutter_home_work12/domain/store/firebase_store/firebase_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final firebaseStore = FirebaseStore();
  await firebaseStore.initialize();
  final habitStore = HabitStore();
  runApp(
    MultiProvider(
      providers: [
        Provider<FirebaseStore>.value(value: firebaseStore),
        Provider<HabitStore>.value(value: habitStore),
      ],
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
        final habitStore = Provider.of<HabitStore>(context);
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
            '/habits': (context) {
              final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
              if (userId.isEmpty) {
                return const AuthScreen();
              }
              habitStore.fetchHabits(userId);
              return HabitListScreen(habitStore: habitStore, userId: userId);
            },
          },
        );
      },
    );
  }
}
