import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_home_work12/data/models/habit_model.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_home_work12/domain/store/habit_store/habit_store.dart';
import 'package:flutter_home_work12/domain/store/auth_store/auth_store.dart';


class HabitListScreen extends StatelessWidget {
  final HabitStore habitStore;
  final String userId;

  const HabitListScreen({
    super.key,
    required this.habitStore,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ваші звички'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddHabitDialog(context, habitStore, userId),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                Provider.of<AuthStore>(context, listen: false).signOut(),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (habitStore.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: MasonryGridView.builder(
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              itemCount: habitStore.habits.length,
              itemBuilder: (context, index) {
                final habit = habitStore.habits[index];
                final today = DateTime.now().toIso8601String().split('T')[0];
                final isDone = habit.progress[today] ?? false;

                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(habit.name),
                        subtitle: Text('Частота: ${habit.frequency}'),
                        trailing: Checkbox(
                          value: isDone,
                          onChanged: (value) {
                            habitStore.updateProgress(
                              habit.id,
                              today,
                              value ?? false,
                            );
                          },
                        ),
                      ),
                      LinearPercentIndicator(
                        percent: habit.progress.values.where((v) => v).length /
                            (habit.progress.isEmpty
                                ? 1
                                : habit.progress.length),
                        lineHeight: 8.0,
                        progressColor: Colors.blue,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showAddHabitDialog(
      BuildContext context, HabitStore habitStore, String userId,) {
    final nameController = TextEditingController();
    final frequencyController = TextEditingController();
    final startDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                  decoration:
                  const InputDecoration(labelText: 'Частота виконання'),
                ),
                TextField(
                  controller: startDateController,
                  decoration: const InputDecoration(
                    labelText: 'Дата початку (YYYY-MM-DD)',
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
                  userId: userId,
                );
                habitStore.addHabit(newHabit);
                Navigator.of(context).pop();
              },
              child: const Text('Додати'),
            ),
          ],
        );
      },
    );
  }
}
