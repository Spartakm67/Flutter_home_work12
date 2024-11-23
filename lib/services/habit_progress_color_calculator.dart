import 'package:flutter/material.dart';
import 'package:flutter_home_work12/data/models/habit_model.dart';

class HabitProgressColorCalculator {
  Color calculateProgressColor(Habit habit) {
    final totalDays = habit.progress.length;
    if (totalDays == 0) return Colors.red;

    final completedDays = habit.progress.values.where((v) => v).length;
    final progressPercent = completedDays / totalDays;

    if (progressPercent >= 0.75) {
      return Colors.green;
    } else if (progressPercent >= 0.5) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}