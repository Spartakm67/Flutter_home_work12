import 'package:flutter/material.dart';
import 'package:flutter_home_work12/data/models/habit_model.dart';
import 'package:flutter_home_work12/domain/store/habit_store/habit_store.dart';

class AddHabitDialog extends StatefulWidget {
  final HabitStore habitStore;
  final String userId;

  const AddHabitDialog({
    super.key,
    required this.habitStore,
    required this.userId,
  });

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController frequencyController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Додати нову звичку'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Назва звички'),
            ),
            TextField(
              controller: frequencyController,
              decoration: const InputDecoration(labelText: 'Частота виконання'),
            ),
            GestureDetector(
              onTap: () => _pickDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: startDateController,
                  decoration: const InputDecoration(
                    labelText: 'Дата початку (YYYY-MM-DD)',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Скасувати'),
        ),
        TextButton(
          onPressed: () {
            final newHabit = Habit(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: nameController.text,
              frequency: frequencyController.text,
              startDate: startDateController.text,
              progress: {},
              userId: widget.userId,
            );
            widget.habitStore.addHabit(newHabit);
            Navigator.of(context).pop();
          },
          child: const Text('Додати'),
        ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        startDateController.text = pickedDate.toIso8601String().split('T')[0];
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    frequencyController.dispose();
    startDateController.dispose();
    super.dispose();
  }
}
