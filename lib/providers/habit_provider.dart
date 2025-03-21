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

  Future<void> addHabit(String name, int color, double goal, String detail, String unit) async {
    final habit = Habit(
      name: name,
      progress: 0.0,
      color: color,
      goal: goal,
      detail: detail,
      unit: unit,
    );
    await DatabaseHelper.instance.insertHabit(habit);
    await fetchHabits();
  }

  Future<void> updateProgress(int id, double increment) async {
    final habit = _habits.firstWhere((h) => h.id == id);
    double newProgress = habit.progress + increment;
    if (newProgress > habit.goal) newProgress = habit.goal;
    final updatedHabit = Habit(
      id: habit.id,
      name: habit.name,
      progress: newProgress,
      color: habit.color,
      goal: habit.goal,
      detail: habit.detail,
      unit: habit.unit,
    );
    await DatabaseHelper.instance.updateHabit(updatedHabit);

    final history = HabitHistory(
      habitId: id,
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      progressAdded: increment,
    );
    await DatabaseHelper.instance.insertHabitHistory(history);

    await fetchHabits();
  }

  Future<void> editHabit(int id, String newName, int newColor, double newGoal, String newDetail, String newUnit) async {
    final habit = _habits.firstWhere((h) => h.id == id);
    final updatedHabit = Habit(
      id: habit.id,
      name: newName,
      progress: habit.progress,
      color: newColor,
      goal: newGoal,
      detail: newDetail,
      unit: newUnit,
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
}