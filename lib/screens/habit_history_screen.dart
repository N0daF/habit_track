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
  DateTime selectedMonth = DateTime.now();
  Map<int, List<HabitHistory>> allHistories = {};

  @override
  void initState() {
    super.initState();
    _loadAllHistories();
  }

  Future<void> _loadAllHistories() async {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final habits = habitProvider.habits;
    Map<int, List<HabitHistory>> histories = {};
    for (var habit in habits) {
      final history = await habitProvider.getHabitHistory(habit.id!);
      histories[habit.id!] = history;
    }
    setState(() {
      allHistories = histories;
    });
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final habits = habitProvider.habits;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: habits.isEmpty
          ? Center(child: Text('No habits yet.', style: TextStyle(color: Colors.white)))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${DateFormat('MMMM').format(selectedMonth)}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_left, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  selectedMonth = DateTime(selectedMonth.year, selectedMonth.month - 1);
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_right, color: Colors.white),
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
                      children: ['SUN', 'MON', 'TUE', 'WEN', 'TUS', 'FRI', 'SAT']
                          .map((day) => Text(
                                day,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 10),
                    ...habits.asMap().entries.map((entry) {
                      final index = entry.key;
                      final habit = entry.value;
                      final history = allHistories[habit.id] ?? [];
                      final streakDays = _calculateStreak(habit, history);

                      final firstDayOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
                      final lastDayOfMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);
                      final daysInMonth = lastDayOfMonth.day;
                      final firstDayWeekday = firstDayOfMonth.weekday % 7;

                      return Column(
                        children: [
                          Card(
                            color: Colors.grey[900],
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: Color(habit.color),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '${habit.name} - $streakDays days',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
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

                                      final dayHistory = history.where((h) => h.date == dateString).toList();
                                      bool isCompleted = false;
                                      if (dayHistory.isNotEmpty) {
                                        final totalProgressAdded = dayHistory.fold<double>(
                                          0.0,
                                          (sum, h) => sum + h.progressAdded,
                                        );
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
                                              color: isCompleted ? Colors.white : Colors.grey[400],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // เพิ่มเส้นแบ่งระหว่าง Habit (ยกเว้น Habit สุดท้าย)
                          if (index < habits.length - 1)
                            Divider(
                              color: Colors.grey[700],
                              thickness: 1,
                            ),
                        ],
                      );
                    }).toList(),
                    SizedBox(height: 20),
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
                        Text('All done', style: TextStyle(color: Colors.white)),
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
                        Text('Some done', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Your achievements are great! Keep going!',
                      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  int _calculateStreak(Habit habit, List<HabitHistory> history) {
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