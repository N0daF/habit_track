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
    final TextEditingController _progressController = TextEditingController();

    // คำนวณเปอร์เซ็นต์ Progress
    final double progressPercentage = (habit.progress / habit.goal * 100).clamp(0, 100);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Color(habit.color).withOpacity(0.2),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          habit.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${habit.detail} ${habit.goal.toStringAsFixed(0)} ${habit.unit}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Progress: ${progressPercentage.toStringAsFixed(0)} / 100%',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        leading: Container(
          width: 10,
          decoration: BoxDecoration(
            color: Color(habit.color),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
        ),
        trailing: SizedBox(
          width: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.add_circle, color: Colors.green),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Add Progress'),
                      content: TextField(
                        controller: _progressController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter progress (e.g., 200 ${habit.unit})',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (_progressController.text.isNotEmpty) {
                              final increment = double.parse(_progressController.text);
                              habitProvider.updateProgress(habit.id!, increment);
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Add'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/edit-habit',
                    arguments: habit,
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Confirm Delete',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to delete "${habit.name}"?',
                        style: TextStyle(color: Colors.black54),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            habitProvider.deleteHabit(habit.id!);
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}