import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../screens/edit_habit_screen.dart';
import 'package:intl/intl.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final DateTime selectedDate;

  HabitTile({required this.habit, required this.selectedDate});

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'water_drop':
        return Icons.water_drop;
      case 'book':
        return Icons.book;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'bed':
        return Icons.bed;
      case 'lightbulb':
        return Icons.lightbulb;
      case 'check_circle':
      default:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);

    return Card(
  color: Color(habit.color),
  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: FutureBuilder<double>(
      future: habitProvider.getProgressForDate(habit.id!, selectedDate),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 16),
              Text(
                habit.name,
                style: TextStyle(color: Colors.white),  
              ),
            ],
          );
        }
        final progress = snapshot.data ?? 0.0;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              _getIconData(habit.icon),
              color: Colors.white, 
              size: 40,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    habit.detail,
                    style: TextStyle(
                      color: Colors.white,  
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Goal: ${habit.goal} ${habit.unit} (Current: ${progress.toStringAsFixed(1)})',
                    style: TextStyle(
                      color: Colors.white,  
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress / habit.goal,
                    backgroundColor: Colors.grey[900],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),  
                    minHeight: 8,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),  
                  onPressed: () async {
                    final TextEditingController progressController = TextEditingController();
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.grey[900],
                          title: Text('Add Progress', style: TextStyle(color: Colors.white)),
                          content: TextField(
                            controller: progressController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.white),  
                            decoration: InputDecoration(
                              labelText: 'Enter Progress',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel', style: TextStyle(color: Colors.white)),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (progressController.text.isNotEmpty) {
                                  final increment = double.parse(progressController.text);
                                  await habitProvider.updateProgress(habit.id!, increment, selectedDate);
                                  Navigator.pop(context);
                                  (context as Element).markNeedsBuild();
                                }
                              },
                              child: Text('Add', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),  
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/edit-habit',
                      arguments: habit,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),  
                  onPressed: () async {
                    await habitProvider.deleteHabit(habit.id!);
                  },
                ),
              ],
            ),
          ],
        );
      },
    ),
  ),
);
  }
}