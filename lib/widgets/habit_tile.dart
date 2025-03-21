import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;

  HabitTile({required this.habit});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(habit.name),
        subtitle: Text('Progress: ${habit.progress.toStringAsFixed(1)}%'),
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.add_circle, color: Colors.green),
                onPressed: () {
                  double newProgress = habit.progress + 10;
                  if (newProgress > 100) newProgress = 100;
                  habitProvider.updateProgress(habit.id!, newProgress);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
