import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../models/habit_history.dart';
import '../providers/habit_provider.dart';
import 'package:intl/intl.dart';

class HabitHistoryScreen extends StatefulWidget {
  @override
  _HabitHistoryScreenState createState() => _HabitHistoryScreenState();
}

class _HabitHistoryScreenState extends State<HabitHistoryScreen> {
  late Habit habit;
  List<HabitHistory> history = [];
  DateTime selectedMonth = DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    habit = ModalRoute.of(context)!.settings.arguments as Habit;
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final historyData = await habitProvider.getHabitHistory(habit.id!);
    setState(() {
      history = historyData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final lastDayOfMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstDayWeekday = firstDayOfMonth.weekday % 7;

    final streakDays = _calculateStreak();

    return Scaffold(
      appBar: AppBar(
        title: Text('${habit.name} History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${DateFormat('MMMM').format(selectedMonth)} - $streakDays days',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_left),
                      onPressed: () {
                        setState(() {
                          selectedMonth = DateTime(selectedMonth.year, selectedMonth.month - 1);
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_right),
                      onPressed: () {
                        setState(() {
                          selectedMonth = DateTime(selectedMonth.year, selectedMonth.month + 1);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                  .map((day) => Text(
                        day,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                  .toList(),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1,
                ),
                itemCount: daysInMonth + firstDayWeekday,
                itemBuilder: (context, index) {
                  if (index < firstDayWeekday) {
                    return SizedBox.shrink();
                  }
                  final day = index - firstDayWeekday + 1;
                  final date = DateTime(selectedMonth.year, selectedMonth.month, day);
                  final dateString = DateFormat('yyyy-MM-dd').format(date);

                  // ตรวจสอบว่าในวันนั้น Habit เสร็จ 100% หรือไม่
                  final dayHistory = history.where((h) => h.date == dateString).toList();
                  bool isCompleted = false;
                  if (dayHistory.isNotEmpty) {
                    // คำนวณ Progress รวมในวันนั้น
                    final totalProgressAdded = dayHistory.fold<double>(
                      0.0,
                      (sum, h) => sum + h.progressAdded,
                    );
                    // เปรียบเทียบกับ goal
                    isCompleted = totalProgressAdded >= habit.goal;
                  }

                  return Container(
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted ? Colors.green : Colors.grey.withOpacity(0.3),
                    ),
                    child: Center(
                      child: Text(
                        '$day',
                        style: TextStyle(
                          color: isCompleted ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 10),
                Text('All done'),
                SizedBox(width: 20),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
                SizedBox(width: 10),
                Text('Some done'),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Your achievements are great! Keep going!',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateStreak() {
    if (history.isEmpty) return 0;
    history.sort((a, b) => b.date.compareTo(a.date));
    int streak = 0;
    DateTime currentDate = DateTime.now();
    for (var h in history) {
      final historyDate = DateFormat('yyyy-MM-dd').parse(h.date);
      final dayHistory = history.where((h) => h.date == h.date).toList();
      final totalProgressAdded = dayHistory.fold<double>(
        0.0,
        (sum, h) => sum + h.progressAdded,
      );
      final isCompleted = totalProgressAdded >= habit.goal;

      if (currentDate.difference(historyDate).inDays <= 1 && isCompleted) {
        streak++;
        currentDate = historyDate;
      } else {
        break;
      }
    }
    return streak;
  }
}