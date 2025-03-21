import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';

class AddHabitScreen extends StatefulWidget {
  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _controller = TextEditingController();
  int _selectedColor = Colors.red.value; // ค่าเริ่มต้นเป็นสีแดง

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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Habit Name (e.g., Drink Water)',
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
                if (_controller.text.isNotEmpty) {
                  habitProvider.addHabit(_controller.text, _selectedColor);
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