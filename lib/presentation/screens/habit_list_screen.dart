import 'package:flutter/material.dart';
import 'package:flutter_home_work12/presentation/widgets/add_habit_dialog.dart';
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
    final AuthStore authStore = AuthStore();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ваші звички'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AddHabitDialog(
                habitStore: habitStore,
                userId: userId,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final navigator = Navigator.of(context);
              await authStore.signOut();
              navigator.pushReplacementNamed('/auth');
            },
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
              gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
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
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Частота: ${habit.frequency}'),
                            const SizedBox(height: 4.0),
                            Text('Старт: ${habit.startDate}'),
                          ],
                        ),
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
}
