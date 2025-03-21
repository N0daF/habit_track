import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../models/habit_history.dart';
import '../services/database_helper.dart';
import 'package:intl/intl.dart';

class HabitProvider with ChangeNotifier {
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  HabitProvider() {
    fetchHabits();
  }

  Future<void> fetchHabits() async {
    _habits = await DatabaseHelper.instance.getHabits();
    notifyListeners();
  }

  Future<void> addHabit(String name, int color, double goal, String detail, String unit, String icon) async {
    final habit = Habit(
      name: name,
      color: color,
      goal: goal,
      detail: detail,
      unit: unit,
      icon: icon,
    );
    await DatabaseHelper.instance.insertHabit(habit);
    await fetchHabits();
  }

  Future<void> updateProgress(int id, double increment, DateTime selectedDate) async {
    final history = HabitHistory(
      habitId: id,
      date: DateFormat('yyyy-MM-dd').format(selectedDate),
      progressAdded: increment,
    );
    await DatabaseHelper.instance.insertHabitHistory(history);
    notifyListeners();
  }

  Future<void> editHabit(int id, String newName, int newColor, double newGoal, String newDetail, String newUnit, String newIcon) async {
    final habit = _habits.firstWhere((h) => h.id == id);
    final updatedHabit = Habit(
      id: habit.id,
      name: newName,
      color: newColor,
      goal: newGoal,
      detail: newDetail,
      unit: newUnit,
      icon: newIcon,
    );
    await DatabaseHelper.instance.updateHabit(updatedHabit);
    await fetchHabits();
  }

  Future<void> deleteHabit(int id) async {
    await DatabaseHelper.instance.deleteHabit(id);
    await fetchHabits();
  }

  Future<List<HabitHistory>> getHabitHistory(int habitId) async {
    return await DatabaseHelper.instance.getHabitHistory(habitId);
  }

  Future<double> getProgressForDate(int habitId, DateTime date) async {
    final List<HabitHistory> history = await getHabitHistory(habitId);
    final dateString = DateFormat('yyyy-MM-dd').format(date);
    final List<HabitHistory> dayHistory = history.where((h) => h.date == dateString).toList();
    final double totalProgress = dayHistory.fold<double>(0.0, (double sum, HabitHistory h) => sum + h.progressAdded);
    return totalProgress;
  }
}