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
      color: Color(habit.color).withOpacity(0.2), // พื้นหลังสีตามความสำคัญ
      elevation: 4, // เพิ่มเงาให้การ์ด
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // ขอบโค้งมน
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
        subtitle: Text(
          'Progress: ${habit.progress.toStringAsFixed(1)}%',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        leading: Container(
          width: 10,
          decoration: BoxDecoration(
            color: Color(habit.color), // แถบสีข้างซ้าย
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
                  double newProgress = habit.progress + 10;
                  if (newProgress > 100) newProgress = 100;
                  habitProvider.updateProgress(habit.id!, newProgress);
                },
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  Navigator.pushNamed(context, '/edit-habit', arguments: habit);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
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
