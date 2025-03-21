import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/database_helper.dart';

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

  Future<void> addHabit(String name) async {
    final habit = Habit(name: name, progress: 0.0);
    await DatabaseHelper.instance.insertHabit(habit);
    await fetchHabits();
  }

  Future<void> updateProgress(int id, double progress) async {
    final habit = _habits.firstWhere((h) => h.id == id);
    final updatedHabit = Habit(id: habit.id, name: habit.name, progress: progress);
    await DatabaseHelper.instance.updateHabit(updatedHabit);
    await fetchHabits();
  }
}