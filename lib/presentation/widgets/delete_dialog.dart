import 'package:flutter/material.dart';
import 'package:flutter_home_work12/domain/store/habit_store/habit_store.dart';
import 'package:flutter_home_work12/data/models/habit_model.dart';

class DeleteDialog extends StatelessWidget {
  final Habit habit;
  final HabitStore habitStore;

  const DeleteDialog({
    super.key,
    required this.habit,
    required this.habitStore,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Підтвердження видалення'),
      content: const Text('Ви впевнені, що хочете видалити цю звичку?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Скасувати'),
        ),
        TextButton(
          onPressed: () {
            habitStore.deleteHabit(habit.id);
            Navigator.of(context).pop();
          },
          child: const Text('Видалити'),
        ),
      ],
    );
  }
}
