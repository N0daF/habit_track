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
  late TextEditingController _detailController;
  late TextEditingController _unitController;
  late Color _selectedColor;
  late String _selectedIcon;
  late Habit habit; // เพิ่มตัวแปรเพื่อเก็บ Habit

  final List<Map<String, dynamic>> _colors = [
    {'color': Colors.orange},
    {'color': Colors.green},
    {'color': Colors.blue},
    {'color': Colors.purple},
    {'color': Colors.red},
    {'color': Colors.yellow},
  ];

  final List<Map<String, dynamic>> _icons = [
    {'name': 'check_circle', 'icon': Icons.check_circle},
    {'name': 'water_drop', 'icon': Icons.water_drop},
    {'name': 'book', 'icon': Icons.book},
    {'name': 'fitness_center', 'icon': Icons.fitness_center},
    {'name': 'bed', 'icon': Icons.bed},
    {'name': 'lightbulb', 'icon': Icons.lightbulb},
  ];

  @override
  void initState() {
    super.initState();
    // ไม่ดึงข้อมูลใน initState อีกต่อไป
    _nameController = TextEditingController();
    _goalController = TextEditingController();
    _detailController = TextEditingController();
    _unitController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ดึงข้อมูล Habit จาก ModalRoute ใน didChangeDependencies
    habit = ModalRoute.of(context)!.settings.arguments as Habit;
    // อัปเดตค่าใน TextEditingController และตัวแปรอื่น ๆ
    _nameController.text = habit.name;
    _goalController.text = habit.goal.toString();
    _detailController.text = habit.detail;
    _unitController.text = habit.unit;
    _selectedColor = Color(habit.color);
    _selectedIcon = habit.icon;
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Edit Habit'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Habit Name',
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
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _goalController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Goal',
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
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _unitController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Unit',
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
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Color', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),
            Row(
              children: _colors.map((colorOption) {
                final color = colorOption['color'] as Color;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColor == color ? Colors.white : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Icon', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),
            Row(
              children: _icons.map((iconOption) {
                final iconName = iconOption['name'] as String;
                final icon = iconOption['icon'] as IconData;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIcon = iconName;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _selectedIcon == iconName ? Colors.grey[700] : Colors.grey[900],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedIcon == iconName ? Colors.white : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _detailController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Description',
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
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  if (_nameController.text.isNotEmpty &&
                      _goalController.text.isNotEmpty &&
                      _detailController.text.isNotEmpty &&
                      _unitController.text.isNotEmpty) {
                    final goal = double.parse(_goalController.text);
                    await habitProvider.editHabit(
                      habit.id!,
                      _nameController.text,
                      _selectedColor.value,
                      goal,
                      _detailController.text,
                      _unitController.text,
                      _selectedIcon,
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all fields')),
                    );
                  }
                },
                child: Text('SAVE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
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
    _detailController.dispose();
    _unitController.dispose();
    super.dispose();
  }
}