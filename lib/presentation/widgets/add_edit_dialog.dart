import 'package:flutter/material.dart';
import 'package:flutter_home_work12/data/models/habit_model.dart';
import 'package:flutter_home_work12/domain/store/habit_store/habit_store.dart';
import 'package:flutter_home_work12/services/capitalize_text_formatter.dart';

class AddEditDialog extends StatefulWidget {
  final HabitStore habitStore;
  final Habit habit;

  const AddEditDialog({
    super.key,
    required this.habitStore,
    required this.habit,
  });

  @override
  State<AddEditDialog> createState() => _AddEditDialogState();
}

class _AddEditDialogState extends State<AddEditDialog> {
  late final TextEditingController nameController;
  late final TextEditingController frequencyController;
  late final TextEditingController startDateController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.habit.name);
    frequencyController = TextEditingController(text: widget.habit.frequency);
    startDateController = TextEditingController(text: widget.habit.startDate);
  }

  @override
  void dispose() {
    nameController.dispose();
    frequencyController.dispose();
    startDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Редагувати звичку'),
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
              decoration:
              const InputDecoration(labelText: 'Частота виконання'),
              inputFormatters: [CapitalizeTextFormatter()],
            ),
            GestureDetector(
              onTap: () => _pickDate(context, startDateController),
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
            final updatedHabit = widget.habit.copyWith(
              name: nameController.text,
              frequency: frequencyController.text,
              startDate: startDateController.text,
            );
            widget.habitStore.updateHabit(updatedHabit);
            Navigator.of(context).pop();
          },
          child: const Text('Зберегти'),
        ),
      ],
    );
  }

  Future<void> _pickDate(
      BuildContext context, TextEditingController controller,) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      controller.text = pickedDate.toIso8601String().split('T')[0];
    }
  }
}
