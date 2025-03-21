import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

class EditHabitScreen extends StatefulWidget {
  @override
  _EditHabitScreenState createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  late TextEditingController _nameController;
  late TextEditingController _goalController;
  late TextEditingController
  _detailController; // แก้ไขจาก _detail控制器 เป็น _detailController
  late TextEditingController _unitController;
  late int _selectedColor;

  final List<Map<String, dynamic>> _priorityColors = [
    {'name': 'High (Red)', 'color': Colors.red.value},
    {'name': 'Medium (Yellow)', 'color': Colors.yellow.value},
    {'name': 'Low (Green)', 'color': Colors.green.value},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _goalController = TextEditingController();
    _detailController = TextEditingController(); // ใช้ชื่อที่ถูกต้อง
    _unitController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Habit habit = ModalRoute.of(context)!.settings.arguments as Habit;
    _nameController.text = habit.name;
    _goalController.text = habit.goal.toString();
    _detailController.text = habit.detail; // ใช้ชื่อที่ถูกต้อง
    _unitController.text = habit.unit;
    _selectedColor = habit.color;
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final Habit habit = ModalRoute.of(context)!.settings.arguments as Habit;

    return Scaffold(
      appBar: AppBar(title: Text('Edit Habit')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Habit Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _detailController, // ใช้ชื่อที่ถูกต้อง
              decoration: InputDecoration(
                labelText: 'Detail',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _goalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Goal',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _unitController,
              decoration: InputDecoration(
                labelText: 'Unit',
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
                if (_nameController.text.isNotEmpty &&
                    _goalController.text.isNotEmpty &&
                    _detailController.text.isNotEmpty &&
                    _unitController.text.isNotEmpty) {
                  final goal = double.parse(_goalController.text);
                  habitProvider.editHabit(
                    habit.id!,
                    _nameController.text,
                    _selectedColor,
                    goal,
                    _detailController.text,
                    _unitController.text,
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

  @override
  void dispose() {
    _nameController.dispose();
    _goalController.dispose();
    _detailController.dispose(); // ใช้ชื่อที่ถูกต้อง
    _unitController.dispose();
    super.dispose();
  }
}
