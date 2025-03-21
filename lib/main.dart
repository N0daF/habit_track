import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/habit_provider.dart';
import 'screens/home_screen.dart';
import 'screens/add_habit_screen.dart';
import 'screens/edit_habit_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HabitProvider(),
      child: MaterialApp(
        title: 'Habit Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/add-habit': (context) => AddHabitScreen(),
          '/edit-habit': (context) => EditHabitScreen(),
        },
      ),
    );
  }
}