import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Habits')),
      body: const Center(child: Text('Welcome to your habits!')),
    );
  }
}