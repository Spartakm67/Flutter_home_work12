import 'package:flutter/material.dart';
import 'package:flutter_home_work12/data/models/habit_model.dart';
import 'package:flutter_home_work12/domain/store/habit_store/habit_store.dart';
import 'package:flutter_home_work12/services/capitalize_text_formatter.dart';
import 'package:flutter_home_work12/services/date_piker_helper.dart';

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
              inputFormatters: [CapitalizeTextFormatter()],
            ),
            TextField(
              controller: frequencyController,
              decoration: const InputDecoration(labelText: 'Частота виконання'),
              inputFormatters: [CapitalizeTextFormatter()],
            ),
            GestureDetector(
              onTap: () async {
                final datePickerHelper = DatePickerHelper();
                await datePickerHelper.pickDate(context, startDateController);
              },
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
            if (nameController.text.isEmpty ||
                frequencyController.text.isEmpty ||
                startDateController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Будь ласка, заповніть усі поля.'),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
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
            }
          },
          child: const Text('Додати'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    frequencyController.dispose();
    startDateController.dispose();
    super.dispose();
  }
}
