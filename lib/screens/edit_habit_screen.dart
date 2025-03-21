import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

class EditHabitScreen extends StatefulWidget {
  @override
  _EditHabitScreenState createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  late TextEditingController _controller;
  late int _selectedColor;

  final List<Map<String, dynamic>> _priorityColors = [
    {'name': 'High (Red)', 'color': Colors.red.value},
    {'name': 'Medium (Yellow)', 'color': Colors.yellow.value},
    {'name': 'Low (Green)', 'color': Colors.green.value},
  ];

  @override
  void initState() {
    super.initState();
    final Habit habit = ModalRoute.of(context)!.settings.arguments as Habit;
    _controller = TextEditingController(text: habit.name);
    _selectedColor = habit.color;
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final Habit habit = ModalRoute.of(context)!.settings.arguments as Habit;

    return Scaffold(
      appBar: AppBar(title: Text('Edit Habit')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Habit Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<int>(
              value: _selectedColor,
              decoration: InputDecoration(
                labelText: 'Priority Color',
                border: OutlineInputBorder(),
              ),
              items:
                  _priorityColors.map((colorOption) {
                    return DropdownMenuItem<int>(
                      value: colorOption['color'],
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            color: Color(colorOption['color']),
                          ),
                          SizedBox(width: 10),
                          Text(colorOption['name']),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedColor = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  habitProvider.editHabit(
                    habit.id!,
                    _controller.text,
                    _selectedColor,
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
