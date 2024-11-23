import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_home_work12/data/models/habit_model.dart';

part 'habit_store.g.dart';

class HabitStore = HabitStoreBase with _$HabitStore;

abstract class HabitStoreBase with Store {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @observable
  ObservableList<Habit> habits = ObservableList<Habit>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  Future<void> fetchHabits(String userId) async {
    try {
      isLoading = true;
      final snapshot = await _firestore
          .collection('habits')
          .where('userId', isEqualTo: userId)
          .get();

      final fetchedHabits =
          snapshot.docs.map((doc) => Habit.fromFirestore(doc.data())).toList();

      habits = ObservableList.of(fetchedHabits);
    } catch (e) {
      errorMessage = 'Error fetching habits: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> addHabit(Habit habit) async {
    try {
      await _firestore
          .collection('habits')
          .doc(habit.id)
          .set(habit.toFirestore());
      habits.add(habit);
    } catch (e) {
      errorMessage = 'Error adding habit: $e';
    }
  }

  @action
  Future<void> updateProgress(String habitId, String date, bool status) async {
    try {
      final habitIndex = habits.indexWhere((h) => h.id == habitId);
      if (habitIndex == -1) return;

      final updatedHabit = habits[habitIndex];
      updatedHabit.progress[date] = status;

      habits = ObservableList.of(habits);

      await _firestore.collection('habits').doc(habitId).update({
        'progress.$date': status,
      });
    } catch (e) {
      errorMessage = 'Error updating progress: $e';
    }
  }

  @action
  Future<void> updateHabit(Habit updatedHabit) async {
    try {
      await _firestore
          .collection('habits')
          .doc(updatedHabit.id)
          .update(updatedHabit.toFirestore());

      final index = habits.indexWhere((h) => h.id == updatedHabit.id);
      if (index != -1) {
        habits[index] = updatedHabit;
        habits = ObservableList.of(habits);
      }
    } catch (e) {
      errorMessage = 'Error updating habit: $e';
    }
  }

  @action
  Future<void> deleteHabit(String habitId) async {
    try {
      await _firestore.collection('habits').doc(habitId).delete();
      habits.removeWhere((habit) => habit.id == habitId);
    } catch (e) {
      errorMessage = 'Error deleting habit: $e';
    }
  }

}
