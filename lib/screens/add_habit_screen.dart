import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';

class AddHabitScreen extends StatefulWidget {
  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  int _selectedColor = Colors.red.value;

  final List<Map<String, dynamic>> _priorityColors = [
    {'name': 'High (Red)', 'color': Colors.red.value},
    {'name': 'Medium (Yellow)', 'color': Colors.yellow.value},
    {'name': 'Low (Green)', 'color': Colors.green.value},
  ];

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Habit'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Habit Name (e.g., Drinkwater)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _detailController,
              decoration: InputDecoration(
                labelText: 'Detail (e.g., drink water)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _goalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Goal (e.g., 800)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _unitController,
              decoration: InputDecoration(
                labelText: 'Unit (e.g., ml)',
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
              items: _priorityColors.map((colorOption) {
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
                if (_nameController.text.isNotEmpty &&
                    _goalController.text.isNotEmpty &&
                    _detailController.text.isNotEmpty &&
                    _unitController.text.isNotEmpty) {
                  final goal = double.parse(_goalController.text);
                  habitProvider.addHabit(
                    _nameController.text,
                    _selectedColor,
                    goal,
                    _detailController.text,
                    _unitController.text,
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('Add Habit'),
            ),
          ],
        ),
      ),
    );
  }
}