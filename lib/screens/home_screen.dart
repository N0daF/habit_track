import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_tile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<HabitProvider>(context, listen: false).fetchHabits();
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Tracker'),
      ),
      body: habitProvider.habits.isEmpty
          ? Center(child: Text('No habits yet. Add one!'))
          : ListView.builder(
              itemCount: habitProvider.habits.length,
              itemBuilder: (context, index) {
                return HabitTile(habit: habitProvider.habits[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add-habit');
          habitProvider.fetchHabits();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}