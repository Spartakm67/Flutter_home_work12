import 'package:flutter/material.dart';
import 'package:flutter_home_work12/presentation/widgets/add_habit_dialog.dart';
import 'package:flutter_home_work12/presentation/widgets/add_edit_dialog.dart';
import 'package:flutter_home_work12/presentation/widgets/delete_dialog.dart';
import 'package:flutter_home_work12/presentation/widgets/custom_app_bar.dart';
import 'package:flutter_home_work12/services/habit_progress_color_calculator.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_home_work12/domain/store/habit_store/habit_store.dart';
import 'package:flutter_home_work12/domain/store/auth_store/auth_store.dart';
import 'package:flutter_home_work12/domain/store/scroll_store/scroll_store.dart';
import 'package:flutter_home_work12/presentation/styles/text_styles.dart';

class HabitListScreen extends StatefulWidget {
  final HabitStore habitStore;
  final String userId;

  const HabitListScreen({
    super.key,
    required this.habitStore,
    required this.userId,
  });

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  final ScrollController _scrollController = ScrollController();
  final ScrollStore scrollStore = ScrollStore();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      scrollStore.updateScrollPosition(_scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthStore authStore = AuthStore();
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Ваші звички',
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AddHabitDialog(
                habitStore: widget.habitStore,
                userId: widget.userId,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
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
          if (widget.habitStore.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (widget.habitStore.habits.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Вітаємо! Ще немає записів, натисніть "+" щоб додати першу звичку',
                  textAlign: TextAlign.center,
                  style: TextStyles.greetingsText,
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: MasonryGridView.builder(
              controller: _scrollController,
              gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              itemCount: widget.habitStore.habits.length,
              itemBuilder: (context, index) {
                final habit = widget.habitStore.habits[index];
                final today = DateTime.now().toIso8601String().split('T')[0];
                final isDone = habit.progress[today] ?? false;

                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          habit.name,
                          style: TextStyles.habitKeyText,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Частота: ',
                                    style: TextStyles.spanKeyText,
                                  ),
                                  TextSpan(
                                    text: ' \n${habit.frequency}',
                                    style: TextStyles.spanTitleText,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Старт:  ',
                                    style: TextStyles.spanKeyText,
                                  ),
                                  TextSpan(
                                    text: habit.startDate,
                                    style: TextStyles.spanTitleText,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isDone,
                              onChanged: (value) {
                                widget.habitStore.updateProgress(
                                  habit.id,
                                  today,
                                  value ?? false,
                                );
                              },
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AddEditDialog(
                                    habitStore: widget.habitStore,
                                    habit: habit,
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => DeleteDialog(
                                    habit: habit,
                                    habitStore: widget.habitStore,
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.deepOrangeAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LinearPercentIndicator(
                          percent:
                              habit.progress.values.where((v) => v).length /
                                  (habit.progress.isEmpty
                                      ? 1
                                      : habit.progress.length),
                          lineHeight: 8.0,
                          progressColor: HabitProgressColorCalculator()
                              .calculateProgressColor(habit),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: Observer(
        builder: (_) {
          return scrollStore.showScrollToTopButton
              ? FloatingActionButton(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    _scrollController.animateTo(
                      0.0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                    );
                  },
                  child: const Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: Colors.white,
                  ),
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
