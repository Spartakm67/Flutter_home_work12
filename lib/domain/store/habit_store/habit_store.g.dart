// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HabitStore on HabitStoreBase, Store {
  late final _$habitsAtom =
      Atom(name: 'HabitStoreBase.habits', context: context);

  @override
  ObservableList<Habit> get habits {
    _$habitsAtom.reportRead();
    return super.habits;
  }

  @override
  set habits(ObservableList<Habit> value) {
    _$habitsAtom.reportWrite(value, super.habits, () {
      super.habits = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'HabitStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: 'HabitStoreBase.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$fetchHabitsAsyncAction =
      AsyncAction('HabitStoreBase.fetchHabits', context: context);

  @override
  Future<void> fetchHabits(String userId) {
    return _$fetchHabitsAsyncAction.run(() => super.fetchHabits(userId));
  }

  late final _$addHabitAsyncAction =
      AsyncAction('HabitStoreBase.addHabit', context: context);

  @override
  Future<void> addHabit(Habit habit) {
    return _$addHabitAsyncAction.run(() => super.addHabit(habit));
  }

  late final _$updateProgressAsyncAction =
      AsyncAction('HabitStoreBase.updateProgress', context: context);

  @override
  Future<void> updateProgress(String habitId, String date, bool status) {
    return _$updateProgressAsyncAction
        .run(() => super.updateProgress(habitId, date, status));
  }

  late final _$updateHabitAsyncAction =
      AsyncAction('HabitStoreBase.updateHabit', context: context);

  @override
  Future<void> updateHabit(Habit updatedHabit) {
    return _$updateHabitAsyncAction.run(() => super.updateHabit(updatedHabit));
  }

  late final _$deleteHabitAsyncAction =
      AsyncAction('HabitStoreBase.deleteHabit', context: context);

  @override
  Future<void> deleteHabit(String habitId) {
    return _$deleteHabitAsyncAction.run(() => super.deleteHabit(habitId));
  }

  @override
  String toString() {
    return '''
habits: ${habits},
isLoading: ${isLoading},
errorMessage: ${errorMessage}
    ''';
  }
}
